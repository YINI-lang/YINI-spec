# CHANGELOG

Edits and updates **in this repository and package**. (Very minor changes are not listed.)

### Feedback Acknowledgments

More details of feedback, see section D.2, _“Acknowledgments & Special Thanks”_, in the [Rationale](./RATIONALE.md) document.

## Package 2026-xx-xx + UPDATES (spec: v1.0.0-RC.5 + UPDATES)
- Revised `#` character handling and updated hexadecimal notation rules in the specification and ANTLR4 grammar:
  * **Changed:** In the specification, `#` now always begins a comment outside string literals. No whitespace is required before or after `#`.
  * **Added:** Added the explicit hexadecimal notation `hex:` as an alternative to `0x...`. The `hex:` prefix is case-insensitive and MUST be followed immediately by hexadecimal digits or an allowed digit separator.
  * **Removed:** Removed support for `#` as a hexadecimal number prefix. Hexadecimal numbers MUST now be written using `0x...` or the explicit `hex:` form.
- **Changed:** Increased the maximum repeated section marker depth from 6 to 9. Section marker separators (`_`) may now be used to make deeper repeated marker headers easier to read. Repeated marker headers may express levels 1–9 directly, while numeric shorthand remains required for levels 10 and deeper.
- **Removed:** Removed Hyper Strings (H-Strings) from the specification and ANTLR4 grammar. While useful for readable long-form text, they served a narrow use case and overlapped with existing string forms. Their removal keeps the core language smaller, clearer, and more predictable.
- **Improved:** Made the lexer grammar target-independent by removing TypeScript-specific members and semantic predicates, enabling cross-language parser generation.
- **Changed:** In `Grammar-ANTLR4`, replaced Windows-specific `.bat` helper scripts with a language-agnostic `Taskfile.yaml`.
- **Improved:** Revised `Contributing.md` for clarity and consistency.
- **Changed:** Restructured the `Examples` directory into **Lenient** and **Strict** subdirectories.
- **Added:** Added GitHub Actions workflows to validate example files with `yini-cli`.
  **Note:** Validation in CI depends on the currently published `yini-cli` release, so some files may fail there even when they are valid according to the latest specification or grammar in this repository. Even in such cases, the validation output remains useful for manual review and for identifying where CLI support has not yet caught up.
- **Added:** In lenient mode, inline object members MAY use `=` as an alternative to `:`. The canonical form remains `key: value`.
- **Clarified:** In strict mode, inline object members MUST use `:`. Using `=` inside inline objects is invalid, whether mixed with `:` or used consistently.
- **Clarified:** Tools and formatters SHOULD normalize inline object members to `:`.
- **Changed:** Updated string concatenation rules. In both modes, a concatenation expression MUST begin with a string literal. In strict mode, all concatenation operands MUST be string literals. In lenient mode, additional operands MAY be string literals, number literals, boolean literals, or null literals. Numeric addition is not defined. Non-string scalar operands are converted to their parsed canonical string representation before concatenation. A concatenation expression MAY span multiple source lines only when the line break occurs after the `+` operator; a line break before `+` is invalid. Lists and inline objects MUST NOT be used as concatenation operands.
  * In strict mode, all concatenation operands MUST be string literals.
  * In lenient mode, a `+` expression MAY be treated as string concatenation if at least one operand is a string literal. Other permitted scalar operands are number literals, boolean literals, and null literals.
  * If a lenient-mode `+` expression contains no string literal, it MUST be rejected because YINI does not define numeric addition.
  * Lists and inline objects MUST NOT be used as concatenation operands.
- **Clarified:** Defined empty-document handling by mode. In lenient mode, a document containing only whitespace, comments, and/or disabled lines is permitted but SHOULD produce a warning. In strict mode, such a document is invalid and MUST result in an error.
- **Added:** For readability, an underscore character `_` may appear after a base prefix or between successive digits in number literals. For example:
  ```yini
  2_468
  0x_ab_cd_12_34_ef
  0b1111_0001
  ```
- **Added:** For readability, added support for section marker separators `_` in repeated section marker headers. For example:

  ```yini
  ^^_^^_^ Section      // depth 5
  ^^^_^^^ Section      // depth 6
  ^^^_^^^_^^^ Section  // depth 9
  ```
- **Added:** Added optional mode declarations to the YINI marker using `@yini strict` and `@yini lenient`. These declarations state the document's expected parser mode but MUST NOT automatically switch the active parser mode. If `@yini strict` is parsed in lenient mode, the parser MUST emit a mode-mismatch error. If `@yini lenient` is parsed in strict mode, the parser MUST emit a mode-mismatch warning.
- **Clarified:** Missing values versus trailing commas:
  * If the value is the keyword `null` (case-insensitive), or if a root-level or section-level member has no value after `=` in lenient mode, it is treated as **Null**.
  * Missing values inside lists or objects are not treated as `Null`.
  * A trailing comma inside a list or object is permitted only in lenient mode and is ignored; in strict mode it is an error.
- **Clarified:** Duplicate key and duplicate section handling:
  * In lenient mode, the first definition wins.
  * Later duplicate keys or duplicate sections at the same level MUST be ignored and MUST produce a warning diagnostic.
  * In strict mode, duplicate keys and duplicate sections at the same level MUST result in an error.
  * Implementations MUST NOT silently overwrite, merge, or extend earlier definitions.
- **Clarified:** UTF-8 encoding and BOM handling. YINI documents MUST be encoded as UTF-8. A UTF-8 BOM SHOULD NOT be used, but implementations MAY accept and ignore an initial UTF-8 BOM for compatibility.
- **Clarified:** Orphan member handling in lenient mode, including the preferred direct-root mounting strategy and the fallback implicit `base` section strategy.
- **Clarified:** Section nesting rules, including that descending into deeper nesting MUST NOT skip intermediate levels, while ascending to a shallower level may skip levels.
- **Clarified:** `/END` post-content behavior. After the document terminator, only whitespace and comments are permitted; any other content MUST result in an error.
- **Improved:** Revised wording throughout the specification to better align with the YINI design goals of clarity, readability, explicit structure, predictability, and deterministic parsing.
- **Fixed:** Various typos, formatting issues, and style inconsistencies.
- **Changed:** Re-added `>` as a supported ASCII section marker. It is documented as a quote-like fallback marker with a portability caveat for contexts such as Markdown, email, and forum renderers.

## Package 2026 Apr (spec: v1.0.0-rc.5)
- **Changed:** In the Spec, the document terminator (`/END`) is now required in strict mode and remains optional in lenient mode.
- **Clarified:** In the Spec, updated the specification text, validation rules, and strict/lenient mode table to reflect that strict mode requires `/END` at the end of the document.
- **Clarified:** In the Spec, repeated/basic section headers do not require a space before the section name, but numeric shorthand headers (such as `^7`) do.
- **Clarified:** In the Spec, clarified top-level section rules in lenient and strict mode. Lenient mode allows orphan members at the root (or under implicit `base`), while strict mode requires exactly one top-level section.
- **Updated:** In the Spec, added a third large real-world configuration example (C) for parsing in strict mode.
  - See Section **15.7**.
  - The full YINI and JSON versions of these examples are also included under  
    [Large-Scale Real-World Configuration Examples](./Examples/Large-Scale%20Real-World%20Configuration%20Examples).
- **Updated:** Removed all colon-based lists from samples and examples, replacing them with bracketed lists (`[ ... ]`), since colon-based lists are no longer supported.
- **Improved:** Cleaned up and reorganized the ANTLR4 lexer and parser grammar files (`.g4`) for better clarity, consistency, and maintainability.
  
## 2026 Mar (v1.0.0-rc.4)
- **Removed:** In the Spec, support for colon-based list syntax (`key: value1, value2` and multi-line `key:` list form).
- **Clarified:** In the Spec, lists in YINI are defined only with `=` and square brackets `[ ... ]`.
- **Rationale:** In the Spec, the colon-list syntax added convenience but did not add core expressive power, and - - **Changed:** In the Spec, removed support for the additional alternative section marker `€`, due to no clear practical benefit compared to the existing markers.
- **Clarified:** In the Spec, the supported section markers are now explicitly `^` (primary), `<`, and `§`.
- **Fixed:** In the Spec, corrected an error in Example 15.1.
- **Updated:** In the Spec, added two large real-world configuration examples (A and B), featuring nested inline objects, lists, and complex structures.
  - See Sections **15.5** and **15.6**.
  - The full YINI and JSON versions of these examples are also included under  
    [Large-Scale Real-World Configuration Examples](./Examples/Large-Scale%20Real-World%20Configuration%20Examples).
- **Updated:** Updated the footer snippet on most of the Markdown files.
- **Updated:** Updated the explanation of YINI's name origin, moved it from the introduction to the preface, and removed the old slogan.
- **Clarified:** In the Spec, added clarifying bullets to Sections 1.2 and 1.4.
- **Fixed:** In the Spec, fixed a few typos and made various minor wording and consistency improvements.

## 2025 Sep (v1.0.0-rc.3)
- Spec update: The `/END` document terminator is now optional everywhere, it's no longer required in strict mode.
- Updated the ANTLR4 lexer and parser to 1.1.0-RC.1: The parser has been completely refactored to use a flat structure, simplifying host parser integration and improving maintainability. The lexer has also been updated to support these changes.
- Implemented a utility (Node.js project) to generate a PDF file from the YINI specification file. 
- Updated lexer that fixes issues with negative values and edge cases for integers, floats, and exponential numbers.
- Added new doc "Intro to YINI Config Format" in docs, moved from yini-parser-typescript.
- Updated spec and lexer to support doz numbers with A and B too // x = A = 10, e = B = 11.


## 2025 Aug (v1.0.0-rc.2)
- Updated lexer and parser files with updated grammar rules to catch and handle invalid syntax
in YINI files, specifically related to bad syntax members.
- Updated readme with a "Version Mapping" section.

## 2025 Jul (v1.0.0-rc.1)
- In spec, clarified "Abort Sensitivity Levels" and added it can also be called (or be known as) "Bail Sensitivity Levels".
- In spec added section 2.4, "YINI Marker (`@yini`)" and support for it in the grammar (lexer and parser).
- In lexer, fixed bug that caused DISABLE_LINE to skip/consume every line after the (`--`).
- Refactored parser, so a new section is part of a "member" (instead of being a "nested section" part of a "section" directly). Due to it will be easier to implement the parser.
- In spec, updated section 3.4, backticked identifiers to clarify the rules, explicitly stating that empty backticked identifiers are permitted.
- In lexer, fixed issue that invalid identifiers are correctly identified. And being able to be forwarded to the parser.
- Updated lexer so it can identify invalid or erroneous section markers, so they can be forwarded to the parser for error reporting. E.g. 
```
^^2 SectionHead # Invalid marker, mixup between basic and numeric section marker.
```
- Updated spec, discontinued alternative marker character `~` (visually ambiguous) in favor of `<`.
- Lexer rule for IDENT updated to include the `.` character (even though it is invalid in YINI identifiers), enabling the parser to catch and throw an error if a dot is present.
- Fixed a grammar issue where empty lists `[]` and empty objects `{}`, with or without whitespace in between opening and closing characters, were not handled correctly.
- Object literals in YINI now always use `:` between keys and values (e.g., `{ foo: 123 }`). The use of `=` inside objects is no longer valid.

## 2025 Jun (spec: v1.0.0 Beta 7)
- Fixed backticked identifiers (phrases) (as per Spec) cannot include tabs, newlines, or other backticks.
- Moved _"Acknowledgments"_ from the specificaton file to the `RATIONALE.MD` under the section _"Acknowledgments & Special Thanks"_— to shorten the main spec and improve formal structure.
- Refactored the structure and order of sections in `RATIONALE.MD` for improved readability and flow.
- Updated most YINI code examples to use indented nested sections for improved human readability, based on community feedback.
- Clarified and updated in Spec and the `YiniLexer.g4` where special/control characters can be and are used.
- In Spec added support for `C` (or `c`) prefixed Triple-quoted strings (similar to Python triple quotes), though default Triple-quoted strings behaves similar to multi-line raw strings (can now optionally be prefixed with `R` to be explicit).
- Added another section in Spec with summary table for "String Types Summary".
- In Spec added supported control characters in <Unicode-WS>.
- Added internal links to all level 2 sections in the ToC of both in the Spec and `RATIONALE.MD`.
- Renamed the branch and enviroment, from `release` to `production`.
- Simplified string rules in lexer, illegal characters are deferred to the parser, which gives more control.

## 2025 May (spec: v1.0.0 Beta 6)
- Reworked the use of `#` for comments, and added `^` as new default marker for sections. Updated README and Branding to reflect this.
- Expanded README example with showing the use of the full line comment `;`.

## 2025 May (spec: v1.0.0 Beta 5)
- Updated Spec and grammar with new escape characters.
- In Spec, reserved `{ }` for future use.
- In Spec renamed section to "Future / Reserved Features" from "Reserved Features".
- Added examples using all escape characters.
- Updated README about the Example about Flexible Strings
- Deprecated the `>` as section marker.
- Added rationale in the Spec for the `#` marker as a design choice, and expanded on it in the preface.
- Included the YINI "logo" at the top of the README.
- Change the default mode to non-strict, updated Spec and examples to not having /END, added examples and test samples in strict mode.
- Included "Acknowledgments" in Spec.
- Reworded some parts of the README.
- Added in README another section "Comparison: YINI vs Other Formats".
- Added in README example of TOML to YINI, using nested sections.
- In README using C-style commenting as YINI follows this philosify primarly, though alternative commenting using `#` and `;` are supported too.
- Added `RATIONALE.md` (with "Background and Intent" and "Versus Other Formats") and small section mentioning it in the Spec.
- Fixed a handful erroneous examples and samples, that should now parse okey.

## 2025-05-03
- Reworded README as including "alternative to INI".
- Fixes in specs:
  * Made it more clear that Lists are also known as arrays.
  * Clarified, that multi-line strings can be done with Hyper Strings and triple-quotes.
  * Fixed minor typos, wordings, and tweaks.

## 2025-05-02
- Extensively clarified types and colon usage (colon usage is only alloed in combination with lists).

## 2025-04-28
- In spec, renamed section to "Spec Changes" from "Spec Changelog" (to distinguish it more from the CHANGELOG file).

## 2025-04-27 (spec: v1.0.0 Beta 4)
- Distinguished between changes to specification and in the repository itself: Changelog section in the spec doc now is exclusive only to the YINI specification itself, and the repository has its own file `CHANGELOG.md` (this file) now.
- In the spec doc, renamed section 15.3, "Changelog" to "Spec Changelog" to make it more clear in the future.
- Created new environment named "release" (in addition to "staging", "develop") for the latest published release of the specification and repository. When the env "staging" is updated and patched with final correct version strings, staging should be merged over into "release". So the repo release should always have final version strings (no `+ Updates` etc in version strings). - The idea is to be able to point a web link to the latest published `YINI-Specification.md` and it will always have the final correct version string already in this env.
- Wrote new and replaced README.md in the repo.

## 2025-04-26 (spec: v1.0.0 Beta 3 + Updates)
- Clarified valid very short YINI files with new examples in the specification.

## 2025-04-25 (spec: v1.0.0 Beta 3)
- Reworked and reordered large sections in spec doc, with an updated Table of Contents.
- Reworded many sections in spec doc for clarity.
- Included the Changelog section (moved from About document) in spec doc.
- In spec doc added new sections "Advanced Constructs", "Validation Rules", "Compatibility and Versioning", "Appendices and Reserved Areas"  to enhance specification completeness.
- Readded "Terminology" section in spec doc.
- In spec doc, added a handful of examples into section "Realistic Config Use Cases".

## 2025-04-23 (spec: v1.0.0 Beta 2)
- Clarified list handling in the "Values & Native Types" section.
- Added a syntax summary section to improve clarity.
- Added a section detailing items and items in lists.

---

**^YINI ≡**  
> YINI is a human-readable configuration format designed for clarity, explicit structure, and predictable parsing.  

[yini-lang.org](https://yini-lang.org) · [YINI-lang on GitHub](https://github.com/YINI-lang)  
