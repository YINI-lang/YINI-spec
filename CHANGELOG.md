# CHANGELOG
Edits and updates **in this repository**.

2025-05-10
- Updated spec and grammar with new escape characters.
- In spec, reserved `{ }` for future use.
- In spec renamed section to "Future / Reserved Features" from "Reserved Features".
- Added examples using escape characters.
- Updated readme about the Example about Flexible Strings

2025-05-03
- Reworded readme as including "alternative to INI".
- Fixes in specs:
  * Made it more clear that Lists are also known as arrays.
  * Clarified, that multi-line strings can be done with Hyper Strings and triple-quotes.
  * Fixed minor typos, wordings, and tweaks.

2025-05-02
- Extensively clarified types and colon usage (colon usage is only alloed in combination with lists).

2025-04-28
- In spec, renamed section to "Spec Changes" from "Spec Changelog" (to distinguish it more from the CHANGELOG file).

2025-04-27 (spec: v1.0.0 Beta 4)
- Distinguished between changes to specification and in the repository itself: Changelog section in the spec doc now is exclusive only to the YINI specification itself, and the repository has its own file `CHANGELOG.md` (this file) now.
- In the spec doc, renamed section 15.3, "Changelog" to "Spec Changelog" to make it more clear in the future.
- Created new environment named "release" (in addition to "staging", "develop") for the latest published release of the specification and repository. When the env "staging" is updated and patched with final correct version strings, staging should be merged over into "release". So the repo release should always have final version strings (no `+ Updates` etc in version strings). - The idea is to be able to point a web link to the latest published `YINI-Specification.md` and it will always have the final correct version string already in this env.
- Wrote new and replaced README.md in the repo.

2025-04-26 (spec: v1.0.0 Beta 3 + Updates)
- Clarified valid very short YINI files with new examples in the specification.

2025-04-25 (spec: v1.0.0 Beta 3)
- Reworked and reordered large sections in spec doc, with an updated Table of Contents.
- Reworded many sections in spec doc for clarity.
- Included the Changelog section (moved from About document) in spec doc.
- In spec doc added new sections "Advanced Constructs", "Validation Rules", "Compatibility and Versioning", "Appendices and Reserved Areas"  to enhance specification completeness.
- Readded "Terminology" section in spec doc.
- In spec doc, added a handful of examples into section "Realistic Config Use Cases".

2025-04-23 (spec: v1.0.0 Beta 2)
- Clarified list handling in the "Values & Native Types" section.
- Added a syntax summary section to improve clarity.
- Added a section detailing items and items in lists.
