#!/usr/bin/env python3
"""Check repository version records against versions.json using only the standard library."""

import json
from pathlib import Path
import re
import sys


class VersionCheckError(ValueError):
    """Report an unreadable or inconsistent version record."""


def read_text(root: Path, relative_path: str) -> str:
    """Read a repository file as UTF-8."""
    try:
        return (root / relative_path).read_text(encoding="utf-8")
    except (OSError, UnicodeError) as error:
        raise VersionCheckError(f"{relative_path}: Cannot read UTF-8 text: {error}.") from error


def read_json(root: Path, relative_path: str) -> dict:
    """Read a JSON object and report input errors with its file path."""
    text = read_text(root, relative_path)
    try:
        value = json.loads(text)
    except json.JSONDecodeError as error:
        raise VersionCheckError(
            f"{relative_path}:{error.lineno}:{error.colno}: Invalid JSON: {error.msg}."
        ) from error
    if not isinstance(value, dict):
        raise VersionCheckError(f"{relative_path}: Expected a JSON object.")
    return value


def version_pair(value: object, location: str) -> dict[str, str]:
    """Require specification and grammar versions without imposing a version scheme."""
    if not isinstance(value, dict):
        raise VersionCheckError(f"{location}: Expected an object with version fields.")
    pair = {}
    for key in ("specification", "grammar"):
        version = value.get(key)
        if not isinstance(version, str) or not version or any(c.isspace() for c in version):
            raise VersionCheckError(
                f"{location}: '{key}' must be a nonempty version string without whitespace."
            )
        pair[key] = version
    return pair


def check_mapping(pairs: list[dict[str, str]], expected: dict[str, str], location: str) -> None:
    """Require one mapping for the current specification with the intended grammar."""
    matches = [pair for pair in pairs if pair["specification"] == expected["specification"]]
    if len(matches) != 1:
        raise VersionCheckError(
            f"{location}: Expected exactly one mapping for specification "
            f"'{expected['specification']}', found {len(matches)}."
        )
    actual = matches[0]["grammar"]
    if actual != expected["grammar"]:
        raise VersionCheckError(
            f"{location}: Specification '{expected['specification']}' maps to grammar "
            f"'{actual}'; expected '{expected['grammar']}' from versions.json."
        )


def readme_pairs(text: str) -> list[dict[str, str]]:
    """Read version pairs only from the README's Version Mapping Table section."""
    headings = list(re.finditer(r"^## Version Mapping Table[ \t]*$", text, re.MULTILINE))
    if len(headings) != 1:
        raise VersionCheckError("README.md: Expected exactly one Version Mapping Table section.")
    section = re.split(r"^##[ \t]+", text[headings[0].end():], maxsplit=1, flags=re.MULTILINE)[0]
    pairs = []
    for line in section.splitlines():
        if line.lstrip().startswith("|"):
            cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
            if len(cells) == 3:
                pairs.append({"specification": cells[1], "grammar": cells[2]})
    return pairs


def check_versions(root: Path) -> list[str]:
    """Return validation errors without changing any repository files."""
    try:
        expected = version_pair(read_json(root, "versions.json"), "versions.json")
    except VersionCheckError as error:
        return [str(error)]

    checks = (
        ("YINI-Specification.md", r"^\*\*Version:\*\*[ \t]+(\S+)", "specification"),
        ("Grammar-ANTLR4/YiniLexer.g4", r"^[ \t]*Grammar version:[ \t]*\n[ \t]*(\S+)", "grammar"),
        ("Grammar-ANTLR4/YiniParser.g4", r"^[ \t]*Grammar version:[ \t]*\n[ \t]*(\S+)", "grammar"),
        ("README.md", r"^\*\*Specification Package Version:\*\*[ \t]+(\S+)", "specification"),
    )
    errors = []
    documents = {}
    for relative_path, pattern, component in checks:
        try:
            text = read_text(root, relative_path)
            documents[relative_path] = text
            # Read the version identifier separately from display notes such as WIP.
            matches = re.findall(pattern, text, re.MULTILINE)
            if len(matches) != 1:
                raise VersionCheckError(
                    f"{relative_path}: Expected exactly one version declaration, found {len(matches)}."
                )
            if matches[0] != expected[component]:
                raise VersionCheckError(
                    f"{relative_path}: Found version '{matches[0]}'; expected "
                    f"'{expected[component]}' from versions.json ({component})."
                )
        except VersionCheckError as error:
            errors.append(str(error))

    try:
        location = "Docs/compatibility.json"
        releases = read_json(root, location).get("releases")
        if not isinstance(releases, list):
            raise VersionCheckError(f"{location}: 'releases' must be an array.")
        pairs = [version_pair(release, f"{location}: releases[{i}]") for i, release in enumerate(releases)]
        check_mapping(pairs, expected, location)
    except VersionCheckError as error:
        errors.append(str(error))

    if "README.md" in documents:
        try:
            check_mapping(readme_pairs(documents["README.md"]), expected, "README.md: Version Mapping Table")
        except VersionCheckError as error:
            errors.append(str(error))
    return errors


def main() -> int:
    """Print results and return an exit status suitable for continuous integration."""
    root = Path(__file__).resolve().parent.parent
    errors = check_versions(root)
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        print(f"Version check failed with {len(errors)} error(s).", file=sys.stderr)
        return 1
    print("Version check passed: Specification, grammars, README, and release mappings agree.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
