_YINI: A lightweight configuration file format — clean, readable, structured._

> \# YINI ≡
---
# Specification for the YINI Format
**Version:** v1.0.0 Beta 4

> **Note:** This specification of the YINI format may introduce changes that are not backward-compatible (see Section 13.2, "Versioning Strategy").

```yini
# YINI
Yet_another = 'INI'
###
```
© 2025 Marko K. Seppänen. Licensed under the Apache License, Version 2.0.
See the full license text at the end of this document.

---

## Preface
YINI was designed with a simple idea in mind: configuration files should be easy for humans to write, read, and understand — without sacrificing structure or future flexibility.

While inspired by established formats such as INI, JSON, Python, Markdown, and YAML, YINI introduces a clean, minimalistic design focused on human readability, structural clarity, and extensibility for the future.  
One of YINI's key strengths is its intuitive approach to **nesting sections**, allowing complex structures to be expressed in a simple, natural, and visually clear way — without the heavy indentation rules or syntax overhead found in other formats.

YINI embraces simplicity as a strength, offering just enough rules to stay consistent, while staying forgiving enough for real-world use.

This specification defines the YINI format with care and clarity, aiming to serve both casual users and implementers seeking a robust, reliable configuration format.  
Above all, YINI remains true to its founding goal: **make configuration effortless**.

---

## Table of Contents

---

### **Part I – Introduction and Fundamentals**

**1. Introduction**  
&nbsp;&nbsp;&nbsp;&nbsp;1.1. What is YINI?  
&nbsp;&nbsp;&nbsp;&nbsp;1.2. Purpose and Design Goals  
&nbsp;&nbsp;&nbsp;&nbsp;1.3. Key Features  
&nbsp;&nbsp;&nbsp;&nbsp;1.4. Terminology

**2. File Structure**  
&nbsp;&nbsp;&nbsp;&nbsp;2.1. File Encoding  
&nbsp;&nbsp;&nbsp;&nbsp;2.2. File Extension  
&nbsp;&nbsp;&nbsp;&nbsp;2.3. Optional Shebang (`#!`)  
&nbsp;&nbsp;&nbsp;&nbsp;2.4. Reserved: Optional Header (`@yini`) *(for future use)*

**3. Syntax Overview**  
&nbsp;&nbsp;&nbsp;&nbsp;3.1. General Syntax Rules  
&nbsp;&nbsp;&nbsp;&nbsp;3.2. Whitespace and Indentation  
&nbsp;&nbsp;&nbsp;&nbsp;3.3. Comments  
&nbsp;&nbsp;&nbsp;&nbsp;3.4. Identifiers  
&nbsp;&nbsp;&nbsp;&nbsp;3.5. Document Terminator  
&nbsp;&nbsp;&nbsp;&nbsp;3.6. Reserved: Ignore / Disable Line *(for future use)*

---

### **Part II – Grammar and Literals**

**4. Keys and Values**  
&nbsp;&nbsp;&nbsp;&nbsp;4.1. Key Naming Rules  
&nbsp;&nbsp;&nbsp;&nbsp;4.2. Value Types (Simple, Compound, Special)  
&nbsp;&nbsp;&nbsp;&nbsp;4.3. Type Rules

**5. Section Headers**  
&nbsp;&nbsp;&nbsp;&nbsp;5.1. Syntax  
&nbsp;&nbsp;&nbsp;&nbsp;5.2. Allowed Markers (`#`, `~`, `>`)  
&nbsp;&nbsp;&nbsp;&nbsp;5.3. Sections in Sections (Nested Sections)

**6. String Literals**  
&nbsp;&nbsp;&nbsp;&nbsp;6.1. Raw Strings (R-Strings)  
&nbsp;&nbsp;&nbsp;&nbsp;6.2. Hyper Strings (H-Strings)  
&nbsp;&nbsp;&nbsp;&nbsp;6.3. Classic Strings (C-Strings)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6.3.1. Escape Characters  
&nbsp;&nbsp;&nbsp;&nbsp;6.4. Triple-Quoted Strings  
&nbsp;&nbsp;&nbsp;&nbsp;6.5. String Concatenation  
&nbsp;&nbsp;&nbsp;&nbsp;6.6. String Type Mixing

**7. Number Literals**  
&nbsp;&nbsp;&nbsp;&nbsp;7.1. Numbers  
&nbsp;&nbsp;&nbsp;&nbsp;7.2. Exponent Format  
&nbsp;&nbsp;&nbsp;&nbsp;7.3. Number Formats

**8. Boolean and Null Literals**  
&nbsp;&nbsp;&nbsp;&nbsp;8.1. Booleans  
&nbsp;&nbsp;&nbsp;&nbsp;8.2. Null Literal

**9. List Literals**  
&nbsp;&nbsp;&nbsp;&nbsp;9.1. Bracketed Notation with `=`  
&nbsp;&nbsp;&nbsp;&nbsp;9.2. Colon-Based Notation without Brackets (`:`)

**10. Advanced Constructs**  
&nbsp;&nbsp;&nbsp;&nbsp;10.1. Reserved Features _(For Future Use)_  

---

### **Part III – Validation, Implementation & Compatibility**

**11. Validation Rules**  
&nbsp;&nbsp;&nbsp;&nbsp;11.1. Reserved Syntax  
&nbsp;&nbsp;&nbsp;&nbsp;11.2. Well-Formedness Requirements  
&nbsp;&nbsp;&nbsp;&nbsp;11.3. Strict vs. Lenient Modes _(Optional Feature)_

**12. Implementation Notes**  
&nbsp;&nbsp;&nbsp;&nbsp;12.1. Top-Level Sections and Implicit Root  
&nbsp;&nbsp;&nbsp;&nbsp;12.2. Line Handling and Whitespace  
&nbsp;&nbsp;&nbsp;&nbsp;12.3. Value and NULL Handling  
&nbsp;&nbsp;&nbsp;&nbsp;12.4. Boolean Canonicalization  
&nbsp;&nbsp;&nbsp;&nbsp;12.5 Lists  
&nbsp;&nbsp;&nbsp;&nbsp;12.6 Strings Concatenation  
&nbsp;&nbsp;&nbsp;&nbsp;12.7 String Literal Types  
&nbsp;&nbsp;&nbsp;&nbsp;12.8 Comments  
&nbsp;&nbsp;&nbsp;&nbsp;12.9 Error Handling Recommendations  
&nbsp;&nbsp;&nbsp;&nbsp;12.10 Bonus Tips for Implementation

**13. Compatibility and Versioning**  
&nbsp;&nbsp;&nbsp;&nbsp;13.1. Fallback Rules  
&nbsp;&nbsp;&nbsp;&nbsp;13.2. Versioning Strategy  
&nbsp;&nbsp;&nbsp;&nbsp;13.3. Encoding Notes  
&nbsp;&nbsp;&nbsp;&nbsp;13.4. JSON Compatibility

---

### **Part IV – Examples and Appendices**

**14. Examples**  
&nbsp;&nbsp;&nbsp;&nbsp;14.1. Minimal Example  
&nbsp;&nbsp;&nbsp;&nbsp;14.2. Realistic Config Use Cases  
&nbsp;&nbsp;&nbsp;&nbsp;14.3. Examples of YINI → JSON Mapping  
&nbsp;&nbsp;&nbsp;&nbsp;14.4. Examples of JSON → YINI Mapping  

**15. Appendices and Reserved Areas**  
&nbsp;&nbsp;&nbsp;&nbsp;15.1. License  
&nbsp;&nbsp;&nbsp;&nbsp;15.2. Author(s)  
&nbsp;&nbsp;&nbsp;&nbsp;15.3. Spec Changes  
&nbsp;&nbsp;&nbsp;&nbsp;15.4. Reserved: Grammar (Formal)

---

## 1. Introduction
### 1.1. What is YINI?
**YINI (Yet another INI)** is a lightweight, human-readable configuration file format—defined by a formal grammar—designed to provide simplicity, flexibility, and clear separation of concerns in configuration data. Its syntax is inspired by widely-used configuration file formats like INI and YAML, but also by JSON, C, and Python. YINI aims to offer a more consistent and intuitive structure, allowing for easy parsing and editing by both humans and machines.

YINI is particularly targeted at users who need a straightforward format for storing and organizing configuration data, where human readability and ease of use are paramount. YINI is flexible enough to handle a wide range of use cases—from simple key-value pairs to nested and structured data—making it an effective choice for everything from application preferences and program settings to complex system configuration files.

### 1.2. Purpose and Design Goals
The YINI format was created with the following key design goals in mind:

- **Simplicity:** YINI is designed to be as simple and intuitive as possible. The syntax is minimalistic yet expressive, with clear conventions for defining sections, keys, and values.

- **Human Readability:** A core principle of YINI is that it should feel natural and intuitive for humans to work with. Its structure is designed to be clear and predictable, minimizing unnecessary complexity so that configuration files are easy to read, understand, write, and maintain—even for non-programmers.

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

## 1.4. Terminology
The following key terms are used consistently throughout this specification. Understanding these terms will help interpret YINI’s grammar, structure, and semantics.

| Term                     | Definition |
|---------------------------|------------|
| Classic String (C-String) | A string prefixed with `C` that supports escape sequences like `\n`, `\t`, etc. |
| Configuration             | A structured set of members and sections that defines settings or data in a YINI document or file. |
| Document Terminator       | A special line (`/END` or `###`) that explicitly marks the end of a YINI document. |
| Hyper String (H-String)    | A multi-line string prefixed with `H` that normalizes whitespace and trims edges. |
| Identifier                | The name of a key or section. Can be a simple word (e.g., `title`) or a **phrased identifier** (wrapped in backticks). |
| Key                       | An identifier on the left side of an assignment (`=` or `:`). Keys must be unique within their section (and depth/level). |
| Lazy/Lenient Mode         | A relaxed parsing mode allowing fallback behavior and partial tolerance for malformed input. |
| List                      | A compound value type consisting of zero or more comma-separated items, defined with either `=` and `[]` (or `:` and line-separated values). |
| Member                    | A key-value pair, such as `key = value`, representing a single entry within a section or root. |
| Raw String (R-String)      | A string literal that does not interpret escape sequences **(default type)**. |
| Section                   | A logical grouping of members, introduced by a header using a section marker like `#`, `~`, or `>`. |
| Section Marker            | A special character (`#`, `~`, or `>`) that denotes a new section header. |
| Strict Mode               | A parsing mode where all structural and validation rules are enforced. |
| Triple-Quoted String      | A string enclosed in `""" ... """`, allowing multi-line raw content without escapes. |
| Value                     | The data assigned to a key. Can be of type string, number, boolean, null, or list. |
| YINI document             | A complete YINI configuration. In this specification, "document" and "file" mean the same thing. |
| YINI file                 | A complete YINI configuration. In this specification, "file" and "document" mean the same thing. |
| YINI                      | Short for "Yet another INI", a human-readable configuration format blending INI-style sections with modern typing and structure. |

## 2. File Structure
The structure of a YINI file is designed to be simple, clear, and highly readable. The file structure determines how data is organized, encoded, and presented. Below are the key elements of the file structure.

### 2.1. File Encoding
YINI files must be encoded in **UTF-8**. This encoding ensures compatibility with most systems and applications, providing a consistent method for interpreting characters.

- **Mandatory Encoding:** All YINI files should be encoded using UTF-8 without a Byte Order Mark (BOM). This guarantees that the file content is universally readable across different platforms.

- **Character Set:** Only Unicode characters are allowed. Special or non-printable characters, such as control characters (except spaces, tabs, and newlines are allowed), should not be used unless specifically required for escape sequences.

### 2.2. File Extension
YINI files should use the `.yini` file extension. This extension helps clearly identify the file type and ensures proper handling by tools and parsers designed for the YINI format.

### 2.3. Optional Shebang (`#!`)
For Unix-based systems, a shebang (#!) is commonly used in script files to specify the interpreter. This feature is supported in YINI files, making it possible to use YINI documents as configuration files for scripts or command-line applications.

**How to Use the Shebang:**
- The **very first line** of the document may optionally begin with a Unix-style **shebang** (`#!`), which specifies the interpreter for the script.
- If present, the shebang line will be ignored by the YINI parser.

Here’s an example of a YINI document with a shebang that could be used in a Unix-based scripting environment:
```yini
#!/usr/bin/env yini

# Config
key = value
```

## 3. Syntax Overview
The syntax of YINI is designed to be minimalistic and human-readable while offering enough flexibility for structured data representation. This section provides an overview of the key syntax rules for YINI files.

### 3.1. General Syntax Rules
YINI files consist of a series of **sections, members** (key-value pairs), and optional **comments**. The following rules define the basic structure of a valid YINI file:

**Whitespace:** Whitespace (spaces and newlines) is used to separate elements in the file. Tabs do not contribute to the logical structure in any way, except a tab or space in important in section headers. Other than this tabs are totally ignored, though tabs or multiple spaces may be used to make it clearer for humans to read.

**Sections:** YINI files support sections, which group related members. A section begins with a section header, marked by one of the allowed characters (commonly `#`, `~`, or `>`), and then at least one space or tab, followed by the section name. Before a section header there may exist indentation and spacing for human readability.

**Example of a section:**
```yini
# SectionName
key = value
```

**Keys and Values (Members):** The basic unit of YINI is a key-value pair, called a Member. A key and its associated value are separated by an equal sign (=), Before or after the =, any number of spaces or tabs can be used.

**Example:**
```yini
key = value
```

**Comments:** YINI supports both single-line and multi-line comments, which are ignored by parsers and serve only for human readability. Note that `#` is not used for comments in YINI—it is reserved for section headers.

**Example:**
```c
// This is a single-line comment.

/*
  This is a multi-line comment.
  It spans several lines.
*/
```

### 3.2. Whitespace and Indentation
While YINI is not indentation-sensitive, the following whitespace behaviors are defined:

- Newlines (`<NL>`) may be either Unix-style (`LF`, U+000A) or Windows-style (`CRLF`, U+000D U+000A).
- Tabs (`<TAB>`, U+0009) and blank spaces (`<SPACE>`, U+0020) are ignored outside of quoted values and section headers.
- Indentation is not syntactically required but may be used to visually structure content for clarity.

### 3.3. Comments
YINI supports two types of comments:

- **Single-line Comments:**
  
  Begin with `//` and continue to the end of the line.
  ```c
  // This is a single-line comment.
  ```
- **Multi-line (Block) Comments:**
  
  Begin with `/*` and end with `*/`. These comments may span multiple lines.
  ```c
  /*
    This is a multi-line comment.
    It can span multiple lines.
  */
  ```

Note: Comments may generally appear anywhere in the file, except within quoted strings.

### 3.4. Identifiers
Identifiers are names used for keys (in members) and sections (section headers). 

An _**identifier**_ can be one of two forms below:
- **Form 1: Identifier of Simple Form:**
  - Keys must be non-empty.
  - Keys are case-sensitive (`Title` and `title` are different).
  - Can only contain letters (a-z or A-Z), digits (0-9) and underscores `_`.
  - Must begin with a letter or an underscore `_`.
  - Note: Cannot contain hyphens (`-`) or periods (`.`).
  
  Example:
  ```yini
  name
  ```

- **Form 2: Identifier Enclosed in Backticks:**
  - A phrase is a name wrapped in backticks  ``` ` ```.
  - It can include spaces, special (printable) characters, and quotes (single `'` or double `"`).
  - It must be on a single line and **cannot contain** newlines or another backtick.
  
  Example:
  ```yini
  `Description of Project`
  `Amanda's Project`
  ```
### 3.5 Document Terminator
A YINI document must always end with a **terminator line**. The document terminator in a YINI file denotes the definitive end of the document content. The **default and recommended** terminator is:

```yini
/END
```

This line is **not case-sensitive** (`/end`, `/End`, etc. are also valid).
Only **whitespace or comments** may appear after the terminator.

It is recommended that there are no leading spaces or tabs, on the same line as the terminator. If there are comment after the marker, these should be ignored.

Alternatively, a shorter form may be used:
```
###
```

While `###` is valid, `/END` is the standard and should be preferred for clarity in most cases.

### 3.6. Reserved: Ignore / Disable Line *(for future use)*
--This space is reserved--<br/>
--Ignore / Disable Line: This is a reserved feature for future versions.--
>- Ignore/Disable Line:
A line that begins with a double minus -- will be completely ignored by the engine. Everything after -- until the end of the line (<NL>) shall be disregarded, including any comments.

**Example:**
```yini
-- this entire line is ignored, including trailing // comments
```

## 4. Keys and Values
YINI represents configuration and structured data through a series of _**members**_, each of which is a key-value pair. This section defines the syntax and rules for keys and values, including allowed characters, data types, quoting, and related behaviors.

### 4.1. Key Naming Rules
A key is an identifier used to reference a specific value within a specific YINI file.

- Keys must be valid identifier, either of a simple form, or a phrased identifier (backticked string)  (see 3.4. Identifiers).
- Keys must be unique within the same section (in the same level). 

**Examples:**
```yini
username = "admin"
user_id = 12345
```

### 4.2. Value Types (Simple, Compound, Special)
> YINI infers the type of each value automatically based on its syntax.
There is no need to declare types explicitly — the parser determines the value type by how it is written (e.g., quotes, brackets, keywords).

A YINI _**value**_ can be of one of the following three groups of native/built-in types:

- **Simple types:**
  - String
  - Number
  - Boolean

- **Compound types:**
  - List (array) — a sequence of values, separated by commas

- **Special type:**
  - NULL

**Note:** YINI types map 1-to-1 to native JSON types.

### 4.3. Type Rules
This section describes how values (on the right-hand side of `=`) are interpreted based on their syntax.

#### Strings
If the value is meant to be a string, it must be quoted — either with single quotes (``` ' ```), double quotes (`"`), or triple quotes (`"""`).

**ONLY when quoted**, the value is considered to be of type **String**.

#### Numbers
- A sequence of digits **without a period** (`.`) is treated as a **Number** (integer).
- A sequence of digits **with a period** (`.`) is treated as a **Number** (floating-point / float).

#### Booleans
If the value matches any of the following keywords `true`, `false`, `on`, `off`, `yes`, or `no` (case-insensitive) — it is interpreted as a **Boolean**. 

#### Lists
If the value is a **bracketed sequence** (`[ ... ]`) of values (of any supported type), separated by commas — the entire value is treated as a **List**.

#### Null
If the value is the keyword `null` (case-insensitive), or if the value is missing (e.g., blank after `=`, or a blank item within a bracketed sequence) — it is treated as **Null**.

**Summary:**

| Value form examples | Meaning |
|------------|---------|
| `'something'`, `"something"`, or `"""something"""` | **String** |
| `123` | **Number** (integer) |
| `3.1415` | **Number** (float) |
| `true`, `FALSE`, `On`, `off`, `YES`, `No` _(any casing)_| **Boolean** |
| `null` _(any casing)_, ` ` _(blank)_ | **Null** |
| _(Unquoted non-number as a value)_ | **ERROR** |

## 5. Section Headers
Sections in YINI are used to organize related members (key-value pairs) into logical groups. This allows for improved readability, structure, and modularity within configuration files.

### 5.1. Syntax
A _**section header**_ starts a new logical grouping of members. Section headers appear ALWAYS on their own line.
```yini
// A section header with a simple identifier.
~ SectionName

// A section header with a phrased identifier.
~ `Section Name`
```

- A section header begins with a **section marker**, immediately followed by **one or more whitespace (space or tab) characters**, then the section name.
- The section name must be a valid identifier, either a simple or phrased identifier (text enclosed in backticks).
- The section header ends at the newline. There may follow a comment, but this will get ignored by the parser.
```yini
# UserSettings
username = "alice"
theme = "dark"
```

### 5.2. Allowed Markers (`#`, `~`, `>`)
YINI allows a limited set of _**section markers**_ to identify section headers. These markers help visually and semantically distinguish section starts from key-value members or comments.

Supported markers:
  - `#` (preferred marker, for now)
  - `~` (alternative marker, in case of confusion of using `#`)
  - `>` (for legacy or alternative support)
  - Reserved: `§` (experimental, maybe in future, for enhanced readability)
  - Reserved: `€` (experimental, maybe in future, for enhanced readability)
  - Reserved: `;`
 
### 5.3. Sections in Sections (Nested Sections)
If you want to put a section under another section, nested sections, make a section header that is one level higher than the current level. This means that you add one more hash symbol than the number of hash symbols in the current section. It is not allowed to skip any level when going to higher/deeper levels, the levels must come in order when nesting to deeper levels.
```yini
# Prefs
## Section
### SubSection
```

## 6. String Literals
In YINI, string literals can be enclosed in either single quotes `'` or double quotes `"`, or optionally in triple double quotes `"""`. You may use whichever is preferred or most appropriate for the context.

YINI supports **four types of string literals**, distinguished by an optional **prefix character** placed before the opening quote (`'` or `"`), triple double quotes `"""` does not support any prefix character.

If no prefix is used, the string is treated as a **raw string literal** by default.

Triple-quoted strings (`"""`) do not support any prefix character. Therefore, the prefix is only applicable to single-line Hyper-strings (`H`), Classic-strings (`C`), and optionally Raw-strings (`R`).

**Rules and Behavior for Strings:**
- All string literals **must start and finish on the same line**, except for **H-Strings** (see section 6.2.) and **Triple-Quoted Strings** (see section 6.4.), which can span multiple lines.
- Multiple string literals can be **concatenated** to create longer strings (see section 6.5).

**Summary**

| String Type | Enclosed In | Multi-Line | Escape Sequences | Trims Whitespace | Notes
|---|---|---|---|---|---|
| Raw Strings (default)         | `' '` or `" "`   | ❌ No | ❌ No | ❌ No | Ideal for file paths and literal text
| Hyper Strings (H-Strings)  | `H' '` or `h" "` | ✅ Yes | ❌ No | ✅ Yes | Whitespace is normalized and trimmed
| Classic Strings (C-Strings)| `C' '` or `c" "` | ❌ No | ✅ Yes | ❌ No | Supports standard escape sequences
| Triple-Quoted Strings | `""" """`   | ✅ Yes | ❌ No | ❌ No | Large multi-line blocks of literal text

### 6.1. Raw Strings (R-Strings)
In (raw) strings the backslash **`\` is "just a backslash"** character, hence different escape sequences like newline or tabs cannot be used. The default (raw) strings must be on the same line.

Raw strings are particularly suitable for representing file paths and other literal text.
>myPath = "C:\Users\John Smith\"
or
>myPath = '/home/Leila Häkkinen'
or
>myPath = '/Users/kim-lee'

#### Raw String Prefix
Any string enclosed in quotes (single `'` or double `"` ) can be prefixed with either `R` or `r` explicitly to denote it as a Raw-String, but Prefixing raw strings is not required as strings are Raw as standard.

### 6.2. Hyper Strings (H-Strings)
There is also another kind of strings, ("Hyper") string literals, called H-Strings for short. These strings are prefixed with either `H` or `h`.

Hyper Strings, as Raw Strings, treat the backslash exactly as seen (escape sequences are not supported).

- However, Hyper strings are special in that they **can span over multiple lines** with `<NL>`, and indentation with `<WS>` can be used to aid human readability in YINI documents.
- Moreover, one or more succeeding `<NL>` and/or `<WS>` are always converted to one single blank space ` `. 
- Also, leading and trailing `<NL>` and/or `<WS>` are trimmed away.

Hyper Strings behave similarly to plain text in HTML documents.

The following:

```yini
H"My name is
  John Doe,  
  and this is a test string."
```

Will result in:
```txt
My name is John Doe, and this is a test string.
```

### 6.3. Classic Strings (C-Strings)
Alternatively, YINI also supports standard ("Classic") string literals, called C-Strings for short. These strings are prefixed with either `C` or `c`. All the usual escape sequences that represents newlines, tabs, backspaces, form-feeds, and so on are supported.

Classic strings must start and end on the same line.

>myText = c"This is a newline \n and this is a tab \t character."

#### 6.3.1. Escape Characters
Escape sequences are only supported in Classic Strings (C-Strings), strings enclosed in single quotes or double quotes, prefixed with the letter `C` (or `c`). 

**Full List**

**Escape Sequences (lower or uppercase, only in C-Strings):**
- `\n` for Newline
- `\r` for Carriage Return
- `\t` for Tab
- `\b` for Backspace
- `\f` for Form Feed
- `\"` for Double Quote
- `\'` for Single Quote
- `\\` for backslash
- `\/` for normal Slash
- `\0` for null byte control character
- `\u hex hex hex hex` Unicode character (4-digit hex)
- `\x hex hex` Hex byte (2-digit)

Where hex is 0-9, or a-f, or A-F.

**Invalid Escapes**

Invalid escape sequences (e.g. `\z`) must result in a parse error unless explicitly allowed by a custom extension or parser configuration.

### 6.4. Triple-Quoted Strings
A **Triple-Quoted String** is a string literal that:
- **Begins and ends** with three double-quote characters: `"""`.
- **May span multiple lines** (i.e., includes newline characters).
- **May contain any characters**, including regular quotes (`"`) and double quotes (`""`), **except** for an unescaped sequence of three double quotes (`"""`) that would terminate the string.
- The first unescaped `"""` after the start is interpreted as the **end** of the string.
- Does not support any prefix character, triple quoted strings are by design raw.

Example of Triple-Quoted strings:
```yini
"""This is a multiline
string that spans
three lines."""

"""He said, "hello" and left."""

"""You can use "" double quotes inside."""
```

Note: All content between the opening and closing triple quotes is preserved as-is, including whitespace and line breaks.

### 6.5. String Concatenation
Strings in YINI can be **concatenated** using the plus sign `+`. This operator joins two or more string literals into a single combined string. Any number of strings can be chained together using this method.

**Example:**
```yini
greeting = "Hi, " + "hello " + "there"
```
The result of the above will be equivalent to:
```yini
greeting = "Hi, hello there"
```

Concatenation supports all string types (Raw, Classic, Hyper), though mixing types is generally discouraged (except for special cases (see more in next section)).

### 6.6. String Type Mixing
Concatenation of string literals of different types (e.g., raw + classic, classic + hyper) is **permitted**, but generally **discouraged**. This flexibility exists to support **rare or advanced use cases** where such combinations may be helpful or necessary.

Engines should handle mixed-type concatenations correctly, but authors are encouraged to use consistent string types within concatenations to ensure clarity and predictable behavior.

## 7. Number Literals
### 7.1. Numbers
YINI supports both integer and floating-point literals. Numbers may be signed and written in decimal notation.

- **Integers:** A sequence of digits, optionally prefixed with + or -.
- **Floats:** Must include a decimal point (`.`) and optional exponent (`e` or `E`).

**Examples:**
```yini
age = 42
pi = 3.14159
negative = -12
scientific = 1.23e4
```

### 7.2. Exponent Format
Exponent notation uses the format:
```
<base>e<sign><exponent>
```

Where:
- `<base>` is any integer number.
- `<sign>` can be `+`, `-`, or blank (positive).
- `<exponent>` is any non-negative number.

Example:
```
3e4 // Is same as 3 × 10⁴ = 30000
```

### 7.3. Number Formats
In addition to standard decimal numbers (base-10), YINI supports other number base literals as well.

Note, binary and hexadecimal values also allow **alternative notations** for convenience and readability.

| Number Format | Alternative Format | Description | Base | Notes
|----------|--|---|---|---|
| `3e4` |   | Exponent notation number | 10-base | Result: `3 × 10⁴`
| `0b1010` | `%1010` | Binary number | 2-base | `0` and `1` only
| `0o7477` |   | Octal number | 8-base | Digits from `0` to `7`
| `0z2ex9` |   | Duodecimal (dozenal) | 12-base | `x` is 10, `e` is 11
| `0xf390` | `#f390` | Hexadecimal number | 16-base | `a–f`, `A-F` represent `10–15`

## 8. Boolean and Null Literals

### 8.1. Booleans
Booleans in a `YINI` document can be following literals (NON CASE-SENSITIVE):
- Treated as **TRUE** (by the engine):
  - `true`
  - `yes`
  - `on`
- Treated as **FALSE** (by the engine):
  - `false`
  - `no`
  - `off`

The engine should convert the literal value to the corresponding Boolean value in the host language.

### 8.2. Null Literal
Value/literal `NULL` (NON CASE-SENSITIVE). 

Also if value is missing in member, then that member is treated as NULL.

## 9. List Literals
YINI supports two ways to define lists:
- **Bracketed List Notation** - A single-line style using `=` and square brackets `[ ]`, similar as in JSON.
- **Colon-Based List Notation** - A more human-friendly, optionally multi-line style using `:` and no brackets.

Note: Only lists has the alternative notation using `:`.

### 9.1. Bracketed Notation with `=`
A list can be assigned to a key using the equals sign `=`, followed by square brackets `[ ]` containing zero or more comma-separated values.

Whitespace (spaces, tabs, and newlines) is allowed within the brackets.

```yini
list1 = ["value1", "value2", "value3"]
list2 = [100, 200, 300]
list3 = []  // An empty list.
```

For convenience, a trailing comma (`,`) may be optionally be included.

```yini
// A list with THREE items.
list1 = ["a", "b", "c", ]  // Trailing comma here is ignored.

// A list with FOUR items.
list2 = ["a", "b", "c", NULL]
```

> **Note: ** A parser may optionally support strict and lenient modes, where trailing commas are either disallowed or accepted.

**Syntax Rule**

There must be **no newline** between the `=` and the opening bracket `[`, otherwise the value will be interpreted as `null`.

❌ Invalid:
```yini
list =
["item1", "item2"]  // Not a valid list!
```

✅ Valid:
```yini
list = ["item1", "item2"]
```

**Nested Lists**

Lists may contain other lists:
```yini
linkItems = [
	["stylesheet", "css/general.css"],
	["stylesheet", "css/themes.css"]
]
```

### 9.2. Colon-Based Notation without Brackets (`:`)
This notation offers a more readable syntax using a colon `:` instead of `=`, and omits square brackets entirely.

```yini
list1: "oranges", "bananas", "peaches"  // List with three items.

list2:  // An empty list.
```

**Multi-line List Syntax:**

Each item (and its comma) may optionally appear on its own line for better readability.

```yini
list1:
  "oranges",
  "bananas",
  "peaches"

list2:
  "oranges",
  "bananas",
  "peaches",  // Trailing comma is valid here, and is ignored.
```
> **Note:** Commas are required between values. A trailing comma is allowed at last line.

Each item can optionally be placed on its own line for readability. Commas are required between values. A trailing comma is allowed.

**Termination Rule**

A multi-line list (using `:`) ends when **any of the following** is encountered:
- a new key assignment (`key = ...` or `key: ...`)
- a new section header (simple or phrased)
- a document terminator marker (`/END`)

**Nested Lists with `:` Notation**

Nested lists are supported and may include inner bracketed Lists:
```yini
linkItems:
	["stylesheet", "css/general.css"],
	["stylesheet", "css/themes.css"]
```

## 10. Advanced Constructs
### 10.1. Reserved Features _(For Future Use)_
The following features are reserved for potential support in future versions of the YINI specification. They are **not currently active** in this version, but their syntax and keywords **are reserved**.

#### 10.1.1. Anchors and Aliases
YINI may introduce a mechanism similar to YAML’s anchors and aliases. These constructs would allow users to define reusable fragments within a configuration.

  - **Anchors (`@`):** Or some other token, to assign a name to a key, section, or structure.
  - **Aliases (`use`):** Reference a previously defined anchor using the use keyword.

#### 10.1.2. Includes
YINI may support modular configuration files via external file inclusion.
  - **Directive:** `@include "<path/to/file>"`
  - **Description:** Imports the contents of another YINI file into the current one.
  - **Usage:** Proposed as a preprocessor-style directive.

These features, while not implemented in this version, are reserved and must not be repurposed by user-defined syntax.

## 11. Validation Rules
YINI enforces a set of validation rules to ensure the structure and content of files are consistent, unambiguous, and semantically correct. These rules fall into two main categories: **reserved syntax protections** and **well-formedness**. Validation ensures compatibility across implementations and minimizes user errors.

### 11.1. Reserved Syntax
Certain characters and keywords are **reserved** by the YINI specification for internal syntax or future use. Using them incorrectly may lead to a parse error or undefined behavior.

#### 11.1.1. Reserved Characters
The following characters are reserved by the YINI syntax and must not be used improperly outside of their defined contexts. They may appear inside quoted strings or phrase identifiers but are otherwise restricted:

| Character	| Usage Context	| Description |
|-----------|---------------|-------------|
| `=` | Assignment  | Separates key from value |
| `~`, `>` | Section headers | Used to denote section start |
| `#` | Header prefix / hex values | Begins section or hex number |
| `%` | Binary prefix | Begins binary number |
| `//` | Comment | Starts single-line comment |
| `/* */` | Comment | Marks multi-line comment block |
| `@` | Directive prefix | Reserved for future syntax |
| `--` | Line disabling | Experimental use (see Section 3.6) |

#### 11.1.2. Reserved Keywords
The following keywords are restricted and must not be used as bare identifiers (e.g., for keys, values, or section names) unless enclosed in quotes or backticks:
- `/END` _(case-insensitive)_
- `###` _(alone on its own line)_
- `@yini`
- `@ver`, `@version`
- `@include`, `@anchor`, `@alias`

Use of these keywords outside their defined roles may result in a parse error.

### 11.2. Well-Formedness Requirements
A YINI file is considered **well-formed** if it adheres to the core syntactic and structural rules defined in this specification.

#### 11.2.1. Structural Requirements
- A file may consist of zero or more **sections**.
- A file may consist of zero or more valid key-value pairs (members).
- Section headers must begin with a valid marker (`#`, `~`, `>`).
- At least one space or tab is required between a section marker and the section name.
- Duplicate keys **within the same section and depth level** are not allowed.
  - Keys are case-sensitive, and no spaces nor quotes allowed unless enclosed in backticks (phrase identifiers).
- Lines that do not match any syntactic role (member, comment, section, terminator) are considered malformed.
- A YINI file must end with only one single terminator (`/END` or `###`).

#### 11.2.2. Character Encoding
Files **must** be encoded as **UTF-8 without BOM**.

#### 11.2.3. Line Endings
- Acceptable: Unix-style `<LF>` or Windows-style `<CR><LF>` line endings.
- Mixed line endings are discouraged but tolerated in lenient mode.
  
#### 11.2.4. Valid Value Types
- Values must be one of the supported data types: **String**, **Number**, **Boolean**, **Null**, or **List**.
- Boolean values are **case-insensitive**: `True`, `On`, `Yes`, etc.
- Null values: `null`, `NULL`, `Null` are all interpreted as `null`.

#### 11.2.5. Document Terminator
- See Section 3.5, "Document Terminator" for terminator syntax.
- A valid YINI file must end with a terminator (`/END`, `###`).
- Only one terminator is permitted per file.
- Missing terminators:
  - **In strict mode:** Treated as an error.
  - **In lazy/lenient mode:** Treated as a warning.
- After the terminator, only whitespaces and comments are allowed.

##### Table: Terminator Requirement by Mode
| Mode | Terminator Requirement |
|---|---|
| Strict | Yes (mandatory) |
| Lazy/Lenient | Optional (*) |

(*) In systems that value deterministic parsing, even lazy/lenient mode should favor explicit termination.

##### Rationale
The document terminator ensures robust parsing boundaries, improves multi-file safety, and aids debugging.

#### 11.2.6. Escaping and String Literals
- Escape sequences are **ONLY allowed** in classic strings (quoted with `'` or `"`, **and prefixed** with `C` or `c`).
- Triple-quoted strings must use `"""` for both opening and closing (`'''` is not supported).

#### 11.2.7. Shortest Valid YINI Documents
- **Valid short documents:**
  - ✅ The following is the shortest valid YINI document **with a member**:
    ```yini
    K=
    ###
    ```
    **Note:** A key named `K`, whose value will be interpreted as `null`.

  - ✅ The following is the shortest valid YINI document **with a section header**:
    ```yini
    # S
    ###
    ```
    **Note:** A section header named `S`, containing no members.

  - ✅ Thus, the following **is also a valid** YINI document by this specification:
    ```yini
    ###
    ```
    **Note:** A YINI document may only contain the document terminator, meaning there are no members or sections in the file.
- **Invalid short documents:**
  - ❌ However, the following file is invalid:
    ```yini
    // A dangling key is invalid, either = or : is missing.
    key
    ###
    ```
    **Note:** This is not a proper member, it contains only a key, either `=` or `:` is missing to make it a proper member.

  - ❌ The following empty file (with only a comment) is also invalid:
    ```yini
    // Invalid empty YINI document, the required document terminator (`/END` or `###`) is missing.
    ```
    **Note:** The document terminator is required in a valid YINI document.

### 11.3. Strict vs. Lenient Modes _(Optional Feature)_
Some YINI parsers may support multiple **validation modes**:

- **Strict Mode:**
  - Enforces full well-formedness.
  - Disallows trailing commas.
  - For production and tool-chain use.
- **Lazy/Lenient Mode:** 
  - Permissive with minor errors (e.g., trailing commas, mixed line endings).
  - May allow unescaped bare values or relaxed typing.
  - Useful for hand-edited configuration files.

**Note:** Implementations must clearly document the validation mode in use and detail which rules are relaxed under lenient parsing.
 
## 12. Implementation Notes

The following guidance is intended to assist developers implementing YINI parsers, engines, or tools. These notes aim to promote consistent interpretation of YINI syntax across different platforms and environments.

See also [Section 11.2: Well-Formedness Requirements] for formal validation criteria.

### 12.1. Top-Level Sections and Implicit Root

* If a document contains **multiple top-level sections** (i.e., multiple level-1 sections), they must be considered **children of an implicit root**.
* The implicit root section:
  - **Has no name**, or may be labeled "`root`" or similar (implementation-defined).
* Section hierarchy must be respected:
  - A level-3 section **must follow** a level-2 section.
  - Skipping levels (e.g., directly from level-1 to level-3) is invalid.

### 12.2. Line Handling and Whitespace

* Newline normalization is required:
  * Support both LF (`0x0A`) and CRLF (`0x0D 0x0A`).
* Leading/trailing whitespaces (tabs or spaces):
  * Trim from section headers and keys.
* Hyper Strings (H-Strings):
  * Leading/trailing whitespaces (tabs or spaces) and newlines are trimmed.
  * Inside a H-string, whitespaces (tabs or spaces) and newlines are normalized to one single space character.
* Comments may follow key-value members or appear on separate lines.
* Whitespace is permitted within lists, including across lines.

### 12.3. Value and NULL Handling

* If a key is assigned without a value::
  ```yini
  key =          // NULL
  key:           // NULL
  ```
  it must be interpreted as having a value of `null`.
* Key uniqueness:
  - Keys must be **unique within the same section and section level**.
  - Duplicates in the same section are a **parse error**.

### 12.4. Boolean Canonicalization

* Boolean literals are **case-insensitive**.
* The following values must be interpreted as Booleans:
  * `true`, `yes`, `on` → `true`
  * `false`, `no`, `off` → `false`
* Do not allow Boolean values like `1` or `0` unless explicitly cast by the host software.

### 12.5 Lists

* Two syntaxes are valid for lists:
  - **(a) Bracketed form (preferred):**
    ```yini
    items = ["a", "b", "c"]
    ```
      * A bracketed list line must not begin with a comma.
      * A trailing comma in `[ ]` is treated as a `null` value.
  - **(b) Unbracketed multiline:**
    ```yini
    items1: "a", "b", "c"

    items2:
    "a",
    "b",
    "c"
    ```
    * Trailing commas are allowed in unbracketed lists (form b).

**Bracketed lists must not** have a newline between `=` and the opening bracket `[`:
  ```yini
  invalidList = // NULL!
  [1, 2, 3]     // Not parsed as a list!
  ```

### 12.6 Strings Concatenation

* Strings can be concatenated using the `+` operator:
    ```yini
    name = "Hello, " + "world"
    ```
* Concatenation must occur **on a single line**.
* Concatenating different types of strings (e.g., r"..." + c'...') is **permitted** (for use in some special or advanced cases), but generally **discouraged**.
* Only Hyper strings (C-Strings) interpret escape sequences (`\n`, `\t`, etc).

### 12.7 String Literal Types

| Type           | Prefix           | Example    | Behavior |
|----------------|------------------|------------|----------|
| (Raw) String   | None, `R`, or `r`| "Some text"| Text is as-is, no escaping; backslash is literal|
| Classic-String | `C` or `c`       | `C"..."`   | Escape sequences are interpreted|
| Hyper-String   | `H` or `h`       | `H"..."`   | (*) Multi-line, whitespace-collapsing, trimmed |

(*) Hyper string behavior:
  * Allow multi-line strings.
  * Collapse sequences of whitespace and newlines into a single space.
  * Trim leading/trailing whitespace.

### 12.8 Comments

* YINI supports:
  - `//` for single-line comments (rest of the line is ignored).
  - `/* ... */` for multi-line comments (may span lines).
  - **Nested block comments are not supported.**

### 12.9 Error Handling Recommendations

If the parser encounters:
  * A **missing intermediate section level** (e.g., level 3 without level 2),
  * A **duplicate key in the same section and section level**,
  * A **malformed list or string**

It should:
* **Fail gracefully** and report an error, OR
* **Use host-defined fallback logic**, if robustness is preferred.

### 12.10 Bonus Tips for Implementation
Developers are encouraged to implement the following features to improve parser robustness and developer experience:

* Attach **position metadata** (line/column) to tokens for better diagnostics.
* Normalize internal representations of:
  - `true` / `false`
  - `null`
* Support both `strict` and `lazy`/`lenient` parsing modes.
* (?) Optionally log ignored lines (e.g., with --) for debugging.
* Optionally, **log ignored or unknown lines** (e.g., those starting with `--`) to assist debugging or migration.

## 13. Compatibility and Versioning
This section covers YINI's compatibility and interoperability principles.

### 13.1. Fallback Rules
#### 13.1.1. Invalid Sections or Keys
- Invalid key names or section headers should be retained as-is but ignored if in lenient mode, or issue a warning or error if in strict mode.
  
#### 13.1.2. Graceful Degradation
- Parsers may issue warnings instead of errors when encountering unrecognized features (e.g., unknown directives, anchors, or section markers).
- Implementations should strive to process known-valid content even if advanced features are not supported.

### 13.2. Versioning Strategy
**Version Format**

- In the future, the YINI Specification will adopt _Semantic Versioning_ (`MAJOR.MINOR.PATCH STAGE`) to signal format evolution.
- **`STAGE`:** For the time being, the specification version remains `v1.0.0` until all primary features are implemented, tested, and the specification exits in the `Beta` stage. The next stage after `Beta` will be denoted `RC` (Release Candidate). Each stage may be appended with an incremental number, such as `Beta 2`, `Beta 3`, `Beta 4`, etc.

Semantic Versioning:
- **MAJOR:** Incompatible changes.
- **MINOR:** Backward-compatible additions.
- **PATCH:** Backward-compatible fixes.

### 13.3. Encoding Notes
#### 13.3.1 Required Encoding
- **UTF-8 without BOM** is the required and default encoding for YINI files.
- Parsers must support UTF-8 fully.
- Use of other encodings (e.g., UTF-16, Latin-1) is discouraged and not guaranteed to be portable.

#### 13.3.2 Byte Order Mark (BOM)
- A UTF-8 BOM (`0xEF 0xBB 0xBF`) is **not required** and **should be avoided**.
- If present, parsers must detect and ignore the BOM without failing.

#### 13.3.3 Shebang Line (Optional)
A shebang line may be used at the very top of the file:
```
#!/usr/bin/env yini
```
This line is ignored by YINI parsers but may affect script execution in Unix environments. It must be ignored by the YINI parser as a comment or metadata line.

### 13.4. JSON Compatibility

A valid YINI file can be converted into a valid JSON file (and vice versa) while preserving **data structure, types, and identifier names exactly**.

Although YINI and JSON are distinct formats with different goals, their core data models are closely aligned.
Strings, numbers, booleans, nulls, and lists in YINI map naturally to their JSON equivalents, and key names (identifiers) maintain structural correspondence when properly quoted.

You can convert a YINI file into JSON (and vice versa) and preserve all real data — structure, types, and names — correctly,  
but you must ignore or remove YINI-only features like section markers, comments, and terminators when expressing it as JSON.

#### Converting YINI to JSON
- **Keys (Identifiers):** As long as keys are quoted properly in JSON, and identifiers follow JSON string rules.
- **Value types (String, Number, Boolean, Null, List):** Direct mapping is possible between YINI and JSON native types.
- **Lists (Arrays):** Lists `[]` map 1-to-1.
- **Sections:** YINI sections correspond to nested objects `{}` in JSON.
- **String types:** ⚠️ All strings become plain JSON strings once parsed, escaping is normalized when serialized.

#### Metadata Limitations
- 🚫 Metadata (such as comments and the document terminator) will not be carried over to JSON.

#### Summary
When converted carefully, a well-formed YINI document can be faithfully represented as a valid JSON object, preserving all structure, data types, and identifier names.  
Conversely, a valid JSON object can be mapped into a YINI document, provided that JSON-specific constructs (such as deeply nested objects) are expressed as sections and that YINI syntax rules are respected.

**Table: Correspondence Between YINI and JSON**

| Entity             | → JSON                         | → YINI                          | Notes |
|--------------------|---------------------------------|----------------------------------|-------|
| Structure Mapping  | ✅ Yes (sections become objects) | ✅ Yes (objects become sections)|   |
| Types Mapping      | ✅ Yes (direct type mapping)     | ✅ Yes (direct type mapping)    |   |
| Identifiers (Keys) | ✅ Yes (must always be quoted)    | ✅ Yes (backticks if needed)   |   |
| Comments           | 🚫 No (discarded)                | -                               | Comments are dropped during JSON conversion.|
| Terminator         | 🚫 No (ignored)                  | -                               | Terminator must be appended when converting to YINI.|

### See also:
See Sections 14.3 and 14.4 for examples of YINI ⇆ JSON mappings.

## 14. Examples

### 14.1. Minimal Example
```yini
# Prefs

name = "Kim"
entries = 10
enabled = true

/END
```

**Explanation:**
  - Begins with a single section `# Prefs`.
  - Contains three keys (`name`, `entries`, `enabled`) with string, number, and boolean values, respectively.
  - Ends with the document terminator `/END`.

### 14.2. Realistic Config Use Cases
#### 14.2.1. User Preferences Configuration
```yini
# Preferences

theme = "dark"
language = "en"
notifications = true
volume = 85
recent_files = [
  "report.yini",
  "draft_0423.yini",
  "budget2025.yini"
]

/END
```

#### 14.2.2. Application Settings with Sections
```yini
# Database
host = "localhost"
port = 5432
username = "appuser"
password = "s3cret"

# Logging
level = "debug"
file = "/var/log/myapp.log"
rotate = true

# Features
enable_experimental = false
api_version = "v2.1"

/END
```

**Notes:**
- The `#` marker cleanly divides logical domains into sections.

#### 14.2.3. Script Metadata
```yini
# Metadata
name = "Data Fetch Script"
version = "1.3.0"
author = "Jane Doe"
schedule = "daily"
active = true

/END
```

#### 14.2.4. Feature Flags
```yini
# FeatureFlags
debug = true
experimental_ui = false
use_cache = true
cache_expiry = 86400  		// In seconds
last_purge_date = "2025-05-25"	// YYYY-MM-DD

/END
```

#### 14.2.5. Feature Toggles with Alternative Syntax
```yini
/*
  Feature Toggles with Alternative Syntax
*/

~ `Feature Toggles`
`Debug` = ON
`Experimental UI` = OFF
`Night Mode` = OFF
`Use Cache` = ON

~~ `Cache Config`
`Cache Expiry` = 86400  		// In seconds
`Last Purge Date (YYYY-MM-DD)` = "2025-05-25"

###
```

**Notes:**
- Uses the alternative section marker `~`.
- Demonstrates alternative boolean literals: `ON` and `OFF`.
- \`Cache Config\` is a nested subsection of \`Feature Toggles\`.
- All keys and section header identifiers are enclosed in backticks, allowing the use of spaces and special characters.
- Ends with the alternative document terminator `###`.

### 14.3. Examples of YINI → JSON Mapping

#### 14.3.1. Simple Flat Structure to JSON
**YINI:**
```yini
# User
name = "Alice"
age = 28
active = true

/END
```

**JSON Equivalent:**
```json
{
  "User": {
    "name": "Alice",
    "age": 28,
    "active": true
  }
}
```

#### 14.3.2. Nested Sections (multiple levels) to JSON
**YINI:**
```yini
# Settings
theme = "dark"
language = "en"

## Display
resolution = "1920x1080"
fullscreen = true

/END
```

**JSON Equivalent:**
```json
{
  "Settings": {
    "theme": "dark",
    "language": "en",
    "Display": {
      "resolution": "1920x1080",
      "fullscreen": true
    }
  }
}
```

#### 14.3.3. Lists (Arrays) to JSON
**YINI:**
```yini
# Server
hosts = ['server1.example.com', 'server2.example.com']

/END
```

**JSON Equivalent:**
```json
{
  "Server": {
    "hosts": [
      "server1.example.com",
      "server2.example.com"
    ]
  }
}
```

#### 14.3.4. Nulls and Booleans to JSON
**YINI:**
```yini
# Flags
enabled = On
archived = Off
description = Null

/END
```

**JSON Equivalent:**
```json
{
  "Flags": {
    "enabled": true,
    "archived": false,
    "description": null
  }
}
```

### 14.4. Examples of JSON → YINI Mapping

#### 14.4.1. Simple JSON Object to YINI
**JSON:**
```json
{
  "Profile": {
    "username": "bob",
    "age": 35,
    "verified": true
  }
}
```

**YINI Equivalent:**
```yini
# Profile
username = "bob"
age = 35
verified = true

/END
```

#### 14.4.2. Nested JSON Objects to YINI
**JSON:**
```json
{
  "App": {
    "version": "2.5",
    "settings": {
      "theme": "light",
      "notifications": true
    }
  }
}
```

**YINI Equivalent:**
```yini
# App
version = "2.5"

## settings
theme = "light"
notifications = true

/END
```

#### 14.4.3. JSON Array to YINI
**JSON:**
```json
{
  "Servers": {
    "hosts": ["alpha.local", "beta.local", "gamma.local"]
  }
}
```

**YINI Equivalent:**
```yini
# Servers
hosts = ["alpha.local", "beta.local", "gamma.local"]

/END
```

## 15. Appendices and Reserved Areas
### 15.1. License
Apache License, Version 2.0, January 2004,
http://www.apache.org/licenses/
Copyright 2024-2025 Gothenburg, Marko K. Seppänen. (Sweden via
Finland).

### 15.2. Author(s)
This specification is created and maintained by Marko K. Seppänen.

#### Creator
First authored in 2024, Gothenburg, by Marko K. Seppänen (Sweden via Finland).

Mr. Seppänen has been programming since the mid-80s, working in languages like BASIC, C, Java, and Assembler. He studied Computer Science and Master's in Software Development with a focus on Programming Languages at Chalmers University of Technology (Gothenburg, Sweden). Professionally, he has many years of experience in software development, particularly in TypeScript, JavaScript, PHP, and full-stack web development.

### 15.3. Spec Changes
A running log of changes and updates **to the YINI specification**.

v1.0.0 Beta 4
- Fixed an issue with very short YINI files in the grammar: both members and sections are now explicitly optional. 

v1.0.0 Beta 3, 2025-04-25

v1.0.0 Beta 2, 2025-04-23
- Added (new) support for triple-quoted strings (`"""`).
- Added support for alternative hexadecimal literals using `#`.
- Added support for binary literals using `%`.
- Reintroduced support for the alternative terminator marker `###`.

---
/END
