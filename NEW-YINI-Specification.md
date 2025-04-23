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
  * 2.3. Optional Shebang (`#!`)
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

## 1. Introduction
### 1.1. What is YINI?
**YINI (Yet another INI)** is a lightweight, human-readable configuration file format designed to provide simplicity, flexibility, and clear separation of concerns in configuration data. Its syntax is inspired by widely-used configuration file formats like INI and YAML, but also by JSON, C, and Python. It aims to offer a more consistent and intuitive structure, allowing for easy parsing and editing by both humans and machines.

YINI is primarily targeted at users who require a straightforward format for storing and organizing configuration information, where human readability and ease of use are paramount. YINI is flexible enough to handle various use cases, from simple key-value pairs to more complex data structures, making it a suitable choice for a variety of applications ranging from web development to system configuration.

### 1.2. Purpose and Design Goals
The YINI format was created with the following key design goals in mind:

- **Simplicity:** YINI is designed to be as simple and intuitive as possible. The syntax is minimalistic yet expressive, with clear conventions for defining sections, keys, and values.

- **Human Readability:** One of the core principles of YINI is its focus on human readability. The format prioritizes clarity in its structure and aims to minimize complexity, ensuring that configuration files remain easy to read, write, and modify.

- **Flexibility:** While simple, YINI is designed to accommodate a variety of data structures, including primitive values (strings, numbers, booleans, nulls) and more complex ones like lists and nested sections.
 
- **Compatibility:** YINI is meant to be compatible with a variety of tools and libraries, ensuring that it can be easily integrated into different programming languages and ecosystems.
     
The following is WIP:
> It also allows for optional extensions, enabling future enhancements without breaking backward compatibility.

- **Extensibility:** The format is designed to be extendable, allowing for future features and syntax to be incorporated as needed, such as support for anchors, includes, or custom validation rules.

### 1.3. Key Features
- **Clear Sectioning:** Sections are clearly delineated, allowing for organized groupings of related configuration data. Section headers can be marked with a variety of symbols (e.g., `#`, `~`, `>`), depending on user preference.

- **Clear End of Document:** YINI supports clear document terminator markers (`/END` or `###`).

- **Flexible Data Types:** YINI supports a variety of data types, including strings, numbers, booleans, nulls, and lists. This flexibility makes it suitable for both simple and complex configuration needs.

- **Commenting and Documentation:** YINI allows for inline comments, enabling users to document their configuration files directly. This enhances the human-readable nature of the format and makes it easier for teams to collaborate on configuration management.

- **Multi-line and Nested Data:** The format supports multi-line strings and nested sections, providing the ability to express more complex configurations while maintaining readability.

## 2. File Structure
The structure of a YINI file is designed to be simple, clear, and highly readable. The file structure determines how data is organized, encoded, and presented. Below are the key elements of the file structure.

### 2.1. File Encoding
YINI files must be encoded in **UTF-8**. This encoding ensures compatibility with most systems and applications, providing a consistent method for interpreting characters.

- **Mandatory Encoding:** All YINI files should be encoded using UTF-8 without a Byte Order Mark (BOM). This guarantees that the file content is universally readable across different platforms.

- **Character Set:** Only Unicode characters are allowed. Special or non-printable characters, such as control characters (except spaces, tabs, and newlines are allowed), should not be used unless specifically required for escape sequences.

### 2.2. File Extension
YINI files should use the `.yini` file extension. This extension helps clearly identify the file type and ensures proper handling by tools and parsers designed for the YINI format.

### 2.3. Optional Shebang (`#!`)
YINI files may optionally begin with a **shebang** (`#!`) line, particularly when the file is used in a script or executable context. This line tells the system what interpreter or application should process the YINI file.

- **Shebang Format:** The shebang line should appear as the very first line in the file, with no leading whitespace. For example:

```txt
#!/usr/bin/env yini-parser
```

- **Optional Usage:** Including a shebang is entirely optional.

## 3. Syntax Overview
The syntax of YINI is designed to be minimalistic and human-readable while offering enough flexibility for structured data representation. This section provides an overview of the key syntax rules for YINI files.

### 3.1. General Syntax Rules
YINI files consist of a series of sections and members (key-value pairs), and optional comments. The following general rules govern the structure of a YINI file:

**Whitespace:** Whitespace (spaces and newlines) is used to separate elements in the file. Tabs does not contribute to the logical structure in any way, except a tab or space in important in section headers. Other than this tabs are totally ignored, though tabs or multiple spaces may be used to make it clearer for humans to read.

**Keys and Values (members):** The basic unit of YINI is a key-value pair, called a Member. A key and its associated value are separated by an equal sign (=), Before or after the =, any number of spaces or tabs can be used.

**Example:**
```yini
key = value
```

**Sections:** YINI files support sections, which group related key-value pairs (members). Sections are denoted by a header, which typically starts with one of the allowed markers (`#` or `>`).

**Example of a section:**
```yini
# SectionName
key = value
```

**Comments:** YINI allows signle line comments, which start with the `//` symbol (note: `#` does denote sections). And multi line comments `/* */`. These comments are ignored by parsers and are purely for human readability.

**Example:**
```yini
// This is a comment
key = value
```

### 3.2. Whitespace and Indentation
YINI files do not require strict indentation, but consistent use of whitespace helps ensure readability. However, the following considerations must be kept in mind:

- Newlines `<NL>` can be either `<LF>` (0x0A) or `<CR><LF>` (0x0D 0x0A).
- All tabs `<TAB>` (0x09) and blank spaces `<SPACE>` (0x20) are ignored.

### 3.3. Comments
YINI supports comments, they may be generally placed anywhere in the file. They are ignored during parsing and serve only to provide context or explanations for human readers.

- **Single Line Comments:** Line comments start with a double slash `//`. Everything after `//` to the end of the line `<NL>` is ignored.
- **Multi Line (Block Comments):** Multi line comments start with `/*` and ends with `*/`. Multi line comments can span over multiple lines.

### 3.4 Ignore / Disable Line
--This space is reserved--<br/>
--Ignore / Disable Line: This may or may not be implemented in the future.--
>- Ignore/disable line start with a double minus `--` as first characters in a line. Everything (including comments) after `--` to the end of the line `<NL>` shall be ignored (by the engine).

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
