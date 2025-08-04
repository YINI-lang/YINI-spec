# CHANGELOG
Edits and updates **in this repository**. (Very minor changes are not listed.)

### Feedback Acknowledgments
More details of feedback, see section D.2, _“Acknowledgments & Special Thanks”_, in the [Rationale](./RATIONALE.md) document.

## --dev/upcoming--
- Added new doc "Intro to YINI Config Format" in docs, moved from yini-parser-typescript.

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

**~ YINI ≡**  
> Aims to be a Clean, Readable, and Human-friendly configuration format.  

[github.com/YINI-lang](https://github.com/YINI-lang)
