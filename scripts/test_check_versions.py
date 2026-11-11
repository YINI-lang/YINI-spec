"""Exercise the version checker's command-line behavior in isolated repositories."""

import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


class CheckVersionsTests(unittest.TestCase):
    """Check successful validation and actionable failures for invalid input."""

    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / "repository"
        self.root.mkdir()
        self.expected = {"specification": "1.0.0-RC.6x", "grammar": "1.4.0-RC.1"}
        self.files = {
            "versions.json": json.dumps(self.expected),
            "YINI-Specification.md": "# Specification\n**Version:** 1.0.0-RC.6x WIP\n",
            "Grammar-ANTLR4/YiniLexer.g4": (
                "/* Apache License, Version 2.0. */\n"
                "/*\n  Grammar version:\n  1.4.0-RC.1 - 2026 Nov (v1.0.0-rc.6x Spec).\n*/\n"
            ),
            "Grammar-ANTLR4/YiniParser.g4": (
                "/*\n  Grammar version:\n  1.4.0-RC.1 - 2026 Nov (v1.0.0-rc.6x Spec).\n*/\n"
            ),
            "README.md": (
                "**Specification Package Version:** 1.0.0-RC.6x ([Table](#version-mapping-table))\n"
                "\n## Version Mapping Table\n\n"
                "| Date | Specification v. | Grammar v. |\n|---|---|---|\n"
                "| 2026 May | 1.0.0-RC.6 | 1.3.0-RC.1 |\n"
                "| 2026 Nov | 1.0.0-RC.6x | 1.4.0-RC.1 |\n| … | … | … |\n"
                "\n## Other Section\n\n| Other | 1.0.0-RC.6x | Unrelated |\n"
            ),
            "Docs/compatibility.json": json.dumps({"releases": [
                {"specification": "1.0.0-RC.6", "grammar": "1.3.0-RC.1"},
                self.expected,
            ]}),
        }
        for name, content in self.files.items():
            self.write(name, content)
        self.script = self.root / "scripts/check-versions.py"
        self.script.parent.mkdir()
        shutil.copyfile(Path(__file__).with_name("check-versions.py"), self.script)

    def write(self, name, content):
        """Write a fixture file without touching the working repository."""
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")

    def run_check(self):
        """Run from outside the repository to check working-directory independence."""
        return subprocess.run(
            [sys.executable, str(self.script)], cwd=self.temp.name,
            capture_output=True, text=True, encoding="utf-8", check=False,
        )

    def assert_failure(self, result, *messages):
        """Require a clean failure with relevant diagnostics and no traceback."""
        self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
        self.assertNotIn("Traceback", result.stderr)
        self.assertEqual(result.stdout, "")
        for message in messages:
            self.assertIn(message, result.stderr)

    def test_matching_versions_pass(self):
        # 1. Arrange.
        expected_message = "Version check passed"

        # 2. Act.
        result = self.run_check()

        # 3. Assert.
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(expected_message, result.stdout)
        self.assertEqual(result.stderr, "")

    def test_specification_without_wip_passes(self):
        # 1. Arrange.
        self.write("YINI-Specification.md", "**Version:** 1.0.0-RC.6x\n")

        # 2. Act.
        result = self.run_check()

        # 3. Assert.
        self.assertEqual(result.returncode, 0)

    def test_each_component_version_mismatch_fails(self):
        for name in ("YINI-Specification.md", "Grammar-ANTLR4/YiniLexer.g4",
                     "Grammar-ANTLR4/YiniParser.g4", "README.md"):
            with self.subTest(file=name):
                # 1. Arrange.
                version = self.expected["grammar" if name.endswith(".g4") else "specification"]
                self.write(name, self.files[name].replace(version, version + "-wrong", 1))

                # 2. Act.
                result = self.run_check()

                # 3. Assert.
                self.assert_failure(result, name, "expected", version)
                self.write(name, self.files[name])

    def test_missing_and_duplicate_version_declarations_fail(self):
        for name in ("YINI-Specification.md", "Grammar-ANTLR4/YiniLexer.g4",
                     "Grammar-ANTLR4/YiniParser.g4", "README.md"):
            for count in (0, 2):
                with self.subTest(file=name, count=count):
                    # 1. Arrange.
                    self.write(name, self.files[name] * count)

                    # 2. Act.
                    result = self.run_check()

                    # 3. Assert.
                    self.assert_failure(result, name, f"version declaration, found {count}")
                    self.write(name, self.files[name])

    def test_missing_files_fail(self):
        for name, content in self.files.items():
            with self.subTest(file=name):
                # 1. Arrange.
                (self.root / name).unlink()

                # 2. Act.
                result = self.run_check()

                # 3. Assert.
                self.assert_failure(result, name, "Cannot read")
                self.write(name, content)

    def test_invalid_utf8_fails(self):
        # 1. Arrange.
        (self.root / "YINI-Specification.md").write_bytes(b"\xff")

        # 2. Act.
        result = self.run_check()

        # 3. Assert.
        self.assert_failure(result, "YINI-Specification.md", "Cannot read UTF-8")

    def test_invalid_json_fails(self):
        for name in ("versions.json", "Docs/compatibility.json"):
            with self.subTest(file=name):
                # 1. Arrange.
                self.write(name, "{not JSON}")

                # 2. Act.
                result = self.run_check()

                # 3. Assert.
                self.assert_failure(result, name, "Invalid JSON")
                self.write(name, self.files[name])

    def test_invalid_manifest_shape_fails(self):
        for value in ([], None, {}, {"specification": "1.0.0"},
                      {**self.expected, "grammar": 14},
                      {**self.expected, "specification": ""},
                      {**self.expected, "grammar": "1.4.0 RC.1"}):
            with self.subTest(value=value):
                # 1. Arrange.
                self.write("versions.json", json.dumps(value))

                # 2. Act.
                result = self.run_check()

                # 3. Assert.
                self.assert_failure(result, "versions.json")

    def test_invalid_release_mapping_shape_fails(self):
        for value in ([], {}, {"releases": {}}, {"releases": [None]},
                      {"releases": [{"specification": "1.0.0"}]},
                      {"releases": [{**self.expected, "grammar": ""}]}):
            with self.subTest(value=value):
                # 1. Arrange.
                self.write("Docs/compatibility.json", json.dumps(value))

                # 2. Act.
                result = self.run_check()

                # 3. Assert.
                self.assert_failure(result, "Docs/compatibility.json")

    def test_missing_current_release_mapping_fails(self):
        # 1. Arrange.
        self.write("Docs/compatibility.json", json.dumps({"releases": [
            {"specification": "1.0.0-RC.6", "grammar": "1.3.0-RC.1"},
        ]}))

        # 2. Act.
        result = self.run_check()

        # 3. Assert.
        self.assert_failure(result, "Docs/compatibility.json", "found 0")

    def test_wrong_current_release_mapping_fails(self):
        # 1. Arrange.
        self.write("Docs/compatibility.json", json.dumps({"releases": [
            {**self.expected, "grammar": "1.3.0-RC.1"},
        ]}))

        # 2. Act.
        result = self.run_check()

        # 3. Assert.
        self.assert_failure(result, "Docs/compatibility.json", "maps to grammar", "1.4.0-RC.1")

    def test_duplicate_current_release_mapping_fails(self):
        # 1. Arrange.
        self.write("Docs/compatibility.json", json.dumps({"releases": [
            self.expected, {**self.expected, "grammar": "1.3.0-RC.1"},
        ]}))

        # 2. Act.
        result = self.run_check()

        # 3. Assert.
        self.assert_failure(result, "Docs/compatibility.json", "found 2")

    def test_missing_readme_mapping_section_fails(self):
        # 1. Arrange.
        self.write("README.md", self.files["README.md"].replace(
            "## Version Mapping Table", "## Old Version Mapping Table"))

        # 2. Act.
        result = self.run_check()

        # 3. Assert.
        self.assert_failure(result, "README.md", "Expected exactly one Version Mapping Table section")

    def test_missing_wrong_and_duplicate_current_readme_mapping_fail(self):
        row = "| 2026 Nov | 1.0.0-RC.6x | 1.4.0-RC.1 |"
        for replacement, diagnostic in (("", "found 0"),
                                         (row.replace("1.4.0-RC.1", "1.3.0-RC.1"), "maps to grammar"),
                                         (row + "\n" + row, "found 2")):
            with self.subTest(replacement=replacement):
                # 1. Arrange.
                self.write("README.md", self.files["README.md"].replace(row, replacement))

                # 2. Act.
                result = self.run_check()

                # 3. Assert.
                self.assert_failure(result, "README.md: Version Mapping Table", diagnostic)

    def test_independent_failures_are_reported_together(self):
        # 1. Arrange.
        for name in ("YINI-Specification.md", "Grammar-ANTLR4/YiniLexer.g4"):
            self.write(name, "No version declaration here.\n")

        # 2. Act.
        result = self.run_check()

        # 3. Assert.
        self.assert_failure(result, "YINI-Specification.md", "Grammar-ANTLR4/YiniLexer.g4", "2 error(s)")


if __name__ == "__main__":
    unittest.main()
