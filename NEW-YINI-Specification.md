# Specification for YINI Formal Grammar  
**Version:** v1.0.0 Beta 2 + Updates

> **Note:** This specification of the YINI format may introduce changes that are not backward-compatible (see section 13.2. Versioning Strategy).

---

## Table of Contents

---

### **Part I – Introduction and Fundamentals**

**1. Introduction**  
&nbsp;&nbsp;&nbsp;&nbsp;1.1. What is YINI?  
&nbsp;&nbsp;&nbsp;&nbsp;1.2. Purpose and Design Goals  
&nbsp;&nbsp;&nbsp;&nbsp;1.3. Key Features

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
&nbsp;&nbsp;&nbsp;&nbsp;3.5. Reserved: Ignore / Disable Line *(for future use)*

---

### **Part II – Grammar and Literals**

**4. Keys and Values**  
&nbsp;&nbsp;&nbsp;&nbsp;4.1. Key Naming Rules  
&nbsp;&nbsp;&nbsp;&nbsp;4.2. Value Types (Simple, Compound, Special)

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
&nbsp;&nbsp;&nbsp;&nbsp;10.1. Reserved: Anchors, Includes, Multiline *(for future use)*

---

### **Part III – Validation and Compatibility**

**11. Validation Rules**  
&nbsp;&nbsp;&nbsp;&nbsp;11.1. Reserved Characters and Keywords  
&nbsp;&nbsp;&nbsp;&nbsp;11.2. Well-Formedness

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

---

### **Part IV – Examples and Appendices**

**14. Examples**  
&nbsp;&nbsp;&nbsp;&nbsp;14.1. Minimal Example  
&nbsp;&nbsp;&nbsp;&nbsp;14.2. Realistic Config Use Cases

**15. Appendices and Reserved Areas**  
&nbsp;&nbsp;&nbsp;&nbsp;15.1. License  
&nbsp;&nbsp;&nbsp;&nbsp;15.2. Reserved: Changelog  
&nbsp;&nbsp;&nbsp;&nbsp;15.3. Reserved: Grammar (Formal)

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

**Whitespace:** Whitespace (spaces and newlines) is used to separate elements in the file. Tabs does not contribute to the logical structure in any way, except a tab or space in important in section headers. Other than this tabs are totally ignored, though tabs or multiple spaces may be used to make it clearer for humans to read.

**Sections:** YINI files support sections, which group related members. A section begins with a section header, marked by one of the allowed characters (commonly `#`, `~`, or `>`), and then at least one space or tab, followed by the section name. Before a section headers there may exist indentation and spacing for human readability.

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

### 3.5. Reserved: Ignore / Disable Line *(for future use)*
--This space is reserved--<br/>
--Ignore / Disable Line: This may or may not be implemented in the future.--
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
A `YINI` _**value**_ can be of one of the following 3 groups of native/built-in types:

- **Value of Simple-type:**
  - String
  - Number
  - Boolean

- **Value of Compound-type:**
  - List (array) (a sequence consisting of other values, separated by comma)

- **Value of Special-type:**
  - NULL

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
- The section name must be a valid identifier, either a simple or phrased identifier (text encosed in backticks).
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
  - `~` (alternative marker)
  - `>` (for legacy or alternative support)
  - Reserved: `§` (maybe in future, for enhanced readability)
  - Reserved: `€` (maybe in future, for enhanced readability)contexts)
 
### 5.3. Sections in Sections (Nested Sections)
If you want to put a section under another section, nested sections, make a section header that is one level higher than the current level. This means that you add one more hash symbol than the number of hash symbols in the current section. It is not allowed to skip any level when going to higher/deeper levels, the levels must come in order when nesting to deeper levels.
```yini
# Prefs
## Section
### SubSection
```

## 6. String Literals
In YINI, string literals can be enclosed in either single quotes `'` or double quotes `"`, or optionally in triple double quotes `"""`. You may use whichever is preferred or most appropriate for the context.

YINI supports **four types of string literals**, distinguished by an optional **prefix character** placed before the opening quote (`'` or `"`).

If no prefix is used, the string is treated as a **raw string literal** by default.

Triple-quoted strings (`"""`) do not support any prefix character. Therefore, the prefix is only applicable to single-line Hyper-strings (`h`), Classic-strings (`c`), and optionally Raw-strings (`r`).

**Rules and Behavior for Strings:**
- All string literals **must start and finish on the same line**, except for **H-Strings** (see section 6.1.2.) and **Triple-Quoted Strings** (see section 6.1.4.), which can span multiple lines.
- Multiple string literals can be **concatenated** to create longer strings (see section 9.5).

**Summary**

| String Type | Enclosed In | Multi-Line | Escape Sequences | Trims Whitespace | Notes
|---|---|---|---|---|---|
| Raw Strings (default)         | `' '` or `" "`   | ❌ No | ❌ No | ❌ No | Ideal for file paths and literal text
| Hyper Strings (H-Strings)  | `""" """` | ✅ Yes | ❌ No | ✅ Yes | Whitespace is normalized and trimmed
| Classic Strings (C-Strings)| `c' '` or `c" "` | ❌ No | ✅ Yes | ❌ No | Supports standard escape sequences
| Triple-Quoted Strings | `' '` or `" "`   | ✅ Yes | ❌ No | ❌ No | Large multi-line blocks of literal text

### 6.1. Raw Strings (R-Strings)
In (raw) strings the backslash **`\` is "just a backslash"** character, hence different escape sequences like newline or tabs cannot be used. The default (raw) strings must be on the same line.

Raw strings are particularly suitable for representing file paths and other literal text.
>myPath = "C:\Users\John Smith\"
or
>myPath = '/home/Leila Häkkinen'
or
>myPath = '/Users/kim-lee'

### 6.2. Hyper Strings (H-Strings)
There is also another kind of strings, ("Hyper") string literals, called H-Strings for short. These strings are prefixed with either `c` or `C`.

Hyper Strings, as Raw Strings, treat the backslash exactly as seen (escape sequences are not supported).

- Hower, Hyper strings are special in that they **can span over multiple lines** with `<NL>`, and indentation with `<WS>` can be used to aid human readability in YINI documents.
- Moreover, one or more succeeding `<NL>` and/or `<WS>` are always converted to one single blank space ` `. 
- Also, leading and trailing `<NL>` and/or `<WS>` are trimmed away.

Hyper Strings behaves similar to plain text in HTML documents.

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
Alternatively YINI support also normal ("Classic") string literals, called C-Strings for short. These strings are prefixed with either `c` or `C`. All the usual escape sequences that represents newlines, tabs, backspaces, form-feeds, and so on are supported.

Classic strings must start and end on the same line.

>myText = c"This is a newline \n and this is a tab \t character."

#### 6.3.1. Escape Characters
Escape sequences are only supported in Classic Strings (C-Strings), strings enclosed in single quotes or double quotes, prefixed with the letter C. 

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
// A list with THREE elements.
list1 = ["a", "b", "c", ]  // Trailing comma is valid.

// A list with FOUR elements.
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
list1: "oranges", "bananas", "peaches"  // List with three elements.

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
  "peaches",  // Trailing comma is valid here.
```
> **Note:** Commas are required between values. A trailing comma is allowed at last line.

Each item can optionally be placed on its own line for readability. Commas are required between values. A trailing comma is allowed.

**Termination Rule**

A multi-line list (using `:`) ends when **any of the following** is encountered:
- a new key assignment (`key = ...` or `key: ...`)
- a new section header (simple or phrased)
- a terminal marker (`/END`)

**Nested Lists with `:` Notation**

Nested lists are supported and may include inner bracketed Lists:
```yini
linkItems:
	["stylesheet", "css/general.css"],
	["stylesheet", "css/themes.css"]
```

## 10. Advanced Constructs
### 10.1. Reserved: Anchors, Includes, Multiline *(for future use)*
Note: These features are reserved for potential future versions and are currently part of this version of YINI.

- Future version may support:
  - **Anchors (`&`) and `use`:** YINI may support a mechanism similar to YAML for defining anchors and aliases to reuse values or structures. An anchor assigns a name to a key or section, and keyword `use` reference it.
  - **Includes (`@include`):** To modularize configurations, YINI may support a directive to include external files. The @include keyword followed by a file path string is a proposed mechanism.

## 11. Validation Rules
### 11.1. Reserved Characters and Keywords
### 11.2. Well-Formedness

## 12. Implementation Notes

The following notes are intended to support developers building engines and parsers for YINI, ensuring consistent and unambiguous interpretation across different host systems.

See also **11.2. Well-formedness**.

### 12.1. Top-Level Sections and Implicit Root

* If a document contains multiple level-1 sections (i.e., multiple `§ Section` blocks), these should be **treated as children of an implicit root object**.
* This implicit root should not have a name (or may be named `root` or similar, as determined by the host system).
* Do not skip section levels when parsing nested sections * level-3 sections must follow level-2.

### 12.2. Line Handling and Whitespace

* Newlines (`<NL>`) may be either LF (`0x0A`) or CRLF (`0x0D 0x0A`). Normalize them internally.
* Ignore leading and trailing whitespace on section headers and keys.
* Allow comments (`//` or `/* */`) after members or values.
* Whitespace between values in lists is allowed, including newlines.
* **A line cannot begin with a comma**, even if it's inside a list.

### 12.3. Value and NULL Handling

* If a member has **no value**, it must be treated as `NULL`.
```yini
key =          // NULL
key:           // NULL
```
* If a key appears **more than once in the same section**, this is an **error** (keys must be unique).

### 12.4. Boolean Canonicalization

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
* Consider strict and lazy/lenient modes in the parser (e.g. allow trailing commas or not).
* (?) Optionally log ignored lines (e.g., with --) for debugging.
