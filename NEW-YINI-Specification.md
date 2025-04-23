# Specification for YINI formal grammar
Version: v1.0.0 Beta 2 + Updates

> **Note:** This specification of the YINI format may introduce changes that are not backward-compatible (see section 9.2. Versioning).

## Table of Contents
### 1. Introduction
  - 1.1. What is YINI?
  - 1.2. Purpose and Design Goals
  - 1.3. Key Features
### 2. File Structure
  * 2.1. File Encoding
  * 2.2. File Extension
  * 2.3. Optional Shebang (#!)
  * 2.4. Reserved: Optional Header (@yini) (for Future Use)
### 3. Syntax Overview
  * 3.1. General Syntax Rules
  * 3.2. Whitespace and Indentation
  * 3.3. Comments
### 4. Keys and Values
  * 4.1. Key Naming Rules
  * 4.2. Value Types (String, Number, Boolean, Null)
  * 4.3. Quoting Rules
### 5. Section Headers
  * 5.1. Syntax
  * 5.2. Allowed Markers (§, €, >)
  * 5.3. Nesting or Flat Model (if applicable)
### 6. Data Types and Literals
  * 6.1. Strings
    - 6.1.1 Raw Strings (R-Strings)
    - 6.1.2 Hyper Strings (H-Strings)
    - 6.1.3 Classic Strings (C-Strings)
    - 6.1.4 Triple-Quoted Strings
    - 6.1.5 String Concatenation
    - 6.1.6 String Type Mixing
  * 6.2. Numbers
  * 6.3. Booleans and Null
  * 6.4. Lists
  * 6.5. Reserved: Multiline Support (Future or Conditional Implementation)
### 7. Special Syntax
  * 7.1 Reserved: Anchors, or Includes (for Future Use)
  * 7.2 Escape Characters
### 8. Validation Rules
  * 8.1 Well-formedness
  * 8.2 Reserved Characters or Keywords
### 9. Compatibility
  * 9.1. Fallback Rules
  * 9.2. Versioning
  * 9.3. Encoding Notes
### 10. Examples
  * 10.1. Minimal Example
  * 10.2. Realistic Config Use Cases
### 11. Appendices
  * 11.1. Reserved: Grammar
  * 11.2. Reserved: Changelog
  * 11.3. License
### 12. Implementation Notes

---

## 12. Implementation Notes

The following notes are intended to support developers building engines and parsers for YINI, ensuring consistent and unambiguous interpretation across different host systems.

### 12.1 Top-Level Sections and Implicit Root

* If a document contains multiple level-1 sections (i.e., multiple `§ Section` blocks), these should be **treated as children of an implicit root object**.
* This implicit root should not have a name (or may be named `root` or similar, as determined by the host system).
* Do not skip section levels when parsing nested sections * level-3 sections must follow level-2.

### 12.2 Line Handling and Whitespace

* Newlines (`<NL>`) may be either LF (`0x0A`) or CRLF (`0x0D 0x0A`). Normalize them internally.
* Ignore leading and trailing whitespace on section headers and keys.
* Allow comments (`//` or `/* */`) after members or values.
* Whitespace between values in lists is allowed, including newlines.
* **A line cannot begin with a comma**, even if it's inside a list.

### Value and NULL Handling

* If a member has **no value**, it must be treated as `NULL`.
```yini
key =          // NULL
key:           // NULL
```
* If a key appears **more than once in the same section**, this is an **error** (keys must be unique).

### 12.4 Boolean Canonicalization

* Boolean literals are **case-insensitive**.
* The following values must be interpreted as Booleans:
  * `true`, `yes`, `on` → `true`
  * `false`, `no`, `off` → `false`
* Do not allow Boolean values like `1` or `0` unless explicitly cast by the host software.

### 12.5 Lists

* Lists may be defined using either:
  * `=` with square brackets:
    ```yini
    items = ["a", "b", "c"]
    ```
  * `:` with comma-separated items:
    ```yini
    items1: "a", "b", "c"

    items2:
    "a",
    "b",
    "c"
    ```
* **Bracketed lists must not** have a newline between `=` and `[`.
    ```yini
    invalidList = // This is treated as NULL!
    [1, 2, 3]  // Not a list.
    ```
* A trailing comma is allowed within `[ ]`, but a line must not start with a comma.

### 12.6 Strings Concatenation

* Strings can be concatenated using the `+` operator:
    ```yini
    name = "Hello, " + "world"
    ```
* Whitespace between parts is optional, but the whole expression must be on a single line.
* Concatenating different types of strings (e.g., raw + classic) is **permitted** (for use in some special or advanced cases), but generally **discouraged**.
* Escape sequences (e.g., `\n`) are only interpreted in C-strings.

### 12.7 String Literal Types

* Default string type is **raw**: no escape sequences, backslash is literal.
* C-Strings (`c"..."`) should interpret escape sequences.
* H-Strings (`h"..."`) must:
  * Allow multi-line strings.
  * Collapse sequences of whitespace and newlines into a single space.
  * Trim leading/trailing whitespace.

### 12.8 Comments

* Support both:
  * `//` for single-line comments (rest of the line ignored).
  * `/* ... */` for multi-line comments (may span lines).
  * **Nested block comments are not supported.**

### 12.9 Error Handling Recommendations

If the parser encounters:
  * A missing section level (e.g., level 3 without level 2),
  * A duplicate key in the same section,
  * A malformed list or string,

It should:
* **Fail gracefully** and report an error, OR
* **Use host-defined fallback logic**, if robustness is preferred.

### 12.10 Bonus Tips for Implementation

* Add position info for each token/value in case of errors.
* Normalize all booleans and nulls internally.
* Consider strict and lenient modes in the parser (e.g. allow trailing commas or not).
* (?) Optionally log ignored lines (e.g., with --) for debugging.
