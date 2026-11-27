# YINI Specification Change History

This file records changes to earlier versions of the YINI specification. Entries describe the specification at the time of each version. The current [YINI specification](../YINI-Specification.md) defines the language rules.

For the three most recent version groups, see [§16.4, Spec Changes](../YINI-Specification.md#164-spec-changes).

## v1.0.0 RC 5, 2026-04-09
- **Changed:** The document terminator (`/END`) is now required in strict mode and remains optional in lenient mode.
- **Clarified:** Updated the specification text, validation rules, and strict/lenient mode table to reflect that strict mode requires `/END` at the end of the document.
- **Clarified:** Clarified whitespace rules for section headers: repeated/basic section headers do not require a space before the section name, while numeric shorthand headers (such as `^7`) do.
- **Clarified:** Defined top-level structure rules for lenient and strict mode. In RC5, lenient-mode orphan members could be exposed at the root or under an implicit base section; strict mode required exactly one explicit top-level section. The implementation-dependent lenient mapping was superseded by the standardized document-root mapping in RC6.
- **Updated:** Added a third large real-world configuration example (C) for parsing in strict mode.
  - See Section **15.7**.
  - The full YINI and JSON versions of these examples are also included under\
    [Large-Scale Real-World Configuration Examples](../Examples/Large-Scale%20Real-World%20Configuration%20Examples).

## v1.0.0 RC 4, 2026-03-29
- **Removed:** Support for colon-based list syntax (`key: value1, value2` and multi-line `key:` list form).
- **Clarified:** Lists in YINI are defined only with `=` and square brackets `[ ... ]`.
- **Rationale:** The colon-list syntax added convenience but did not add core expressive power, and its removal improves clarity, predictability, and grammar simplicity.
- **Changed:** Removed support for the additional alternative section marker `€`, due to no clear practical benefit compared to the existing markers.
- **Clarified:** The supported section markers are now explicitly `^` (primary), `§`, and `<`.
- **Fixed:** Corrected an error in Example 15.1.
- **Updated:** Added two large real-world configuration examples (A and B), featuring nested inline objects, lists, and complex structures.
  - See Sections **15.5** and **15.6**.
  - The full YINI and JSON versions of these examples are also included under\
    [Large-Scale Real-World Configuration Examples](../Examples/Large-Scale%20Real-World%20Configuration%20Examples).
- **Clarified:** Added clarifying bullets to Sections 1.2 and 1.4.
- **Fixed:** Fixed a few typos and made various minor wording and consistency improvements.
