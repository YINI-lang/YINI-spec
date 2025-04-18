# YINI specification version 1.0.0 Alpha 3

## Table of Contents
1. Intro 
2. Terminology
3. Definitions
4. Section Headers
5. Top Section Header
6. Terminal Line
7. Values & Native Types
8.  Members
9.  String Literals
    * 9.1 Raw Strings
    * 9.2 Hyper or H-Strings
    * 9.3 Classic or C-Strings
    * 9.4 String Concatenation
10. Number Literals
11. Boolean Literals
12. Lists (arrays)
13. NULL Literal
14. Sections in Sections
15. Conclusion
16. Example
17. Implementation Notes
18. Creator

---

## 1. Intro
`YINI` is a configuration file format, it stands for **Y**et another **INI** markup language. It consists of plain text with a simple syntax and structure, consisting of Key–Value pairs and Key-List pairs, organized in sections.

Recommended filename extension for a YINI file is `.yini`.

A short YINI document looks like the following.
```
# MyPrefs

HomeDir = "C:\Users\John Smith\"
Buffers = 10
IsNight = OFF
KeyWords: "Orange", "Banana", "Pear", "Peach"

/END // End of YINI doc.
```

A `YINI` document file can look like this as well:
```
# window
title = 'Sample Window'
id = 'window_main'

# image
src = 'gfx/bg.png'
id = 'bg1'
isCentered = true

# text
content = 'Click here!'
id = 'text1'
isCentered = true
url = 'images/'
styles: ['font-weight', 'bold'], ['size', 36], ['font', 'arial']

/END // End of YINI doc.
```

## 2. Terminology
- **Engine**: Is the program/software that reads and writes `YINI` documents.
- **Host**: The host is the program/software (written by the user/developer/programmer) that runs the `YINI`-engine (decoder and/or encoder).

## 3. Definitions
### 3.1 Whitespaces
- Newlines `<NL>` can be either `<LF>` (0x0A) or `<CR><LF>` (0x0D 0x0A).
- All tabs `<TAB>` (0x09) and blank spaces `<SPACE>` (0x20) are ignored.

### 3.2 Comments
- Single line comments start with a double slash `//`. Everything after `//` to the end of the line `<NL>` is ignored.
- Multi line comments start with `/*` and ends with `*/`. Multi line comments can span over multiple lines.
### 3.3 Ignore / Disable Line
--This space is reserved--<br/>
--Ignore / Disable Line: This may or may not be implemented in the future.--
>- Ignore/disable line start with a double minus `--` as first characters in a line. Everything (including comments) after `--` to the end of the line `<NL>` shall be ignored (by the engine).

### 3.4 Identifiers
Naming identifiers must follow below rules:
- Can only contain letters (a-z or A-Z), digits (0-9) and underscores `_`.
- Must begin with a letter or an underscore `_`.
- Identifiers are case-sensitive, uppercase and lowercase letters are distinct.
- Must be unique, there cannot be multiple section headers with the same identifier.
- An identifier can have a max length of 2047 characters + null character (a total of 2048 bytes).
- Also identifiers must follow the engine's or host's (program/software that reads and writes `YINI` documents) naming conventions.

## 4. Section Headers
A section header consists with one or more hash-symbols `#` and then an identifier (must be a unique identifier (within the same section level)). The number of hash-symbols indicates the nesting level of the section, there shall not be any whitespaces between multiple hash-symbols. Sections serves as objects.

In addition, the section header must be on its own separate line, any tabs or spaces at the beginning and end of the identifier are ignored.

Nesting sections must be attached to a existing section. If doing a section with level three, then there must be a section level 2 before.

A special case is YINI documents with multiple level 1 sections, the client's library reading the document must attach these level 1 section into one implicit section automatically. The name of this "implicit section" is left for the library to decide.

```
# SectionLevel1 #
## SectionLevel2 ##
### SectionLevel3 ###
```

## 5. Top Section Header
A `YINI` document always starts with a Section Header of level 1. There may be multiple single level 1 sections, each document must have at least one section.

(Note: If there is only one (1) section with level 1, it may be called the so-called title header.)

```
# Title
```

After a section with level 1, comes section header with level 2.

*) The very first line **may start** with a shebang `#!`, then this line is ignored.

```
# Title
## Section
```

## 6. Terminal Line
A `YINI` document must always end with `/END` (NON CASE-SENSITIVE) or `###` (three hashes) on its own line. After this there may be only whitespaces or possible comments.

```
/END
```

## 7. Values & Native Types
A `YINI` value MUST be of one of the following 3 groups of native/built-in types:

- Simple types:
  - String
  - Number
  - Boolean

- Compound type:
  - List/array (a sequence consisting of strings, numbers, or booleans)

- Special type:
  - NULL

Note: Above are all types that are supported by `YINI`, any other types are left to the host software to cast or convert to after reading (or before saving) a `YINI` document.

## 8. Members
Each **member** must start on its own line. The name of the member is called the **key**. Keys must be **unique** (identifier) within the same section (i.e., at the same section level).

There are two forms of members:
1. **Single value** - A key-value pair that holds only one single value.
2. **List of values** - A key-values pair that holds zero or more values (or elements). Elements are separated by commas.

### Member with a Single Value
A member with a single value is written as a **key-value pair**, using the equals character `=`. The key is on the left, and the value is on the right.

```yini
key = "value"
lives = 3
```

### Member with a List
A member with a list uses the equals `=` character (as with other members), followed by zero or more values inside square brackets `[` `]`, separated by commas. An optional final/trailing comma `,` may be accepted for convenience.

```yini
list1 = ["value1", "value2", "value3"]

list2 = [100, 200, 300]

list3 = []  // An empty list.
```

## 9. String Literals
In YINI, string literals can be enclosed in either single quotes `'` or double quotes `"`. You may use whichever is preferred or most appropriate for the context.

YINI supports **three types of string literals**, distinguished by a prefix character placed before the opening quote.

By default, all string literals are treated as **raw string literals by default**, unless a specific prefix indicates otherwise.

### Rules and Behavior for Strings

- All string literals **must start and finish on the same line**, except for **H-Strings**, which can span multiple lines (see section 9.2).
- Multiple string literals can be **concatenated** to create longer strings (see section 9.4).

### Summary

| String Type | Enclosed In | Multi-Line | Escape Sequences | Trims White-Spaces | Special Features
|---|---|---|---|---|---|
| Raw Strings                | ```' '``` or ```" "```   | ❌ No | ❌ No | ❌ No | Ideal for file paths and literal text
| Hyper Strings (H-Strings)  | ```h' '``` or ```h" "``` | ✅ Yes | ❌ No | ✅ Yes | Trims extra whitespace
| Classic Strings (C-Strings)| ```c' '``` or ```c" "``` | ❌ No | ✅ Yes | ❌ No | Supports escape sequences

### 9.1 Raw Strings (Default)
In (raw) strings the backslash **`\` is "just a backslash"** character, hence different escape sequences like newline or tabs cannot be used. The default (raw) strings must be on the same line.

Raw strings are particularly suitable for representing file paths and other literal text.
>myPath = "C:\Users\John Smith\"
or
>myPath = '/home/Leila Häkkinen'
or
>myPath = '/Users/kim-lee'

### 9.2 Hyper or H-Strings
There is also another kind of strings, ("Hyper") string literals, called H-Strings for short. These strings are prefixed with either `c` or `C`.

Hyper Strings, as Raw Strings, treat the backslash exactly as seen (escape sequences are not supported).

- Hower, Hyper strings are special in that they can span over multiple lines with `<NL>`, and indentation with `<WS>` can be used to aid human readability in YINI documents.
- Moreover, one or more succeeding `<NL>` and/or `<WS>` are always converted to one single blank space ` `. 
- Also, leading and trailing `<NL>` and/or `<WS>` are trimmed away.

Hyper Strings behaves similar to plain text in HTML documents.

The following:

```yini
h"My name is
  John Doe,  
  and this is a test string."
```

Will result in:
```txt
My name is John Doe, and this is a test string.
```



### 9.3 Classic or C-Strings (Escaped)
Alternatively YINI support also normal ("Classic") string literals, called C-Strings for short. These strings are prefixed with either `c` or `C`. All the usual escape sequences that represents newlines, tabs, backspaces, form-feeds, and so on are supported.

>myText = c"This is a newline \n and this is a tab \t character."

Escape sequences in C-Strings (in lower or uppercase):
- `\n` for Newline
- `\r` for Carriage Return
- `\b` for Backspace
- `\f` for Form Feed
- `\t` for Tab
- `\'` for Single Quote
- `\"` for Double Quote
- `\\` for backslash
- `\/` for normal Slash
- `\u hex hex hex hex` for hex value

Where hex is 0-9, or a-f, or A-F.

### 9.4 String Concatenation
Strings can be concatenated using the plus `+` operator. It adds together strings, you can add as many strings as you want.
```
var = "Hi, " + "hello " + "there"
```

## 10. Number Literals
Numbers can be integers or real numbers with `.` similar as a number in JavaScript. It can include a sign - or +. Can be of exponent form, 'e' or 'E' sign digits, where:
-sign is either +, -, or blank
- digits is any number 0 or larger

### Number Formats

In addition to normal (10-base) decimal literals, YINI supports other number base literals as well.

Note, due to relatively high usage binary and hexadecimal numbers can be given in two different notation.

| Number format | Alt. number format | Description | Number base | Note
|----------|--|---|---|---|
| `3e4` |   | Exponent notation number | 10-base | Result: 3×4^10
| `0b1010` | `%1010` | Binary number | 2-base |
| `0o7477` |   | Octal number | 8-base |
| `0z2ex9` |   | Duodecimal (dozenal) number | 12-base | `x` is 10, `e` is 11
| `0xf390` | `#f390` | Hexadecimal number | 16-base | `a`, `b`, `c`, `d`, `e`, `f` are 10 to 15

## 11. Boolean Literals
Booleans in a `YINI` document can be following literals (NON CASE-SENSITIVE):
- true
- false
- yes
- no
- on
- off

The engine should convert the literal value to the corresponding Boolean value in the host language.
  
## 12. Lists (arrays) ##

Lists can be defined in two different notations:
- **Lists with Brackets** - Uses a single-line format with square brackets.
- **Lists without Brackets** - Second notation is an optional multi-line format for better readability.

### List Literal (with Brackets)
A member with a list uses the equals `=` character (as with other members), followed by zero or more values inside square brackets `[` `]`, separated by commas. An optional final/trailing comma `,` may be accepted for convenience.

```yini
list1 = ["value1", "value2", "value3"]

list2 = [100, 200, 300]

list3 = []  // An empty list.
```

NOTE: There must be no newline `<NL>` between the equals sign `=`  and the start of list itself `[`, otherwise the member will be interpreted as having a null value.

Lists can be nested, like:

```yini
linkItems: [
	["stylesheet", "css/general.css"],
	["stylesheet", "css/themes.css"]
]
```

#### Alternative List Notation (without Brackets)
An alternative way to define a list is by using the colon character `:` instead of an equals sign. In this form/notation, the key is on the left of the colon, and the values (zero or more values) appear to the right, separated by commas.

Each value may optionally be placed on its own line. A final/trailing comma `,` is accepted so parsing is not broken.

No brackets are used in this list notion.

```yini
// Alternative list notation (with :).

list1: "oranges", "bananas", "peaches"

list2:
  "oranges",
  "bananas",
  "peaches"
```

## 13. NULL Literal
Value/literal `NULL` (NON CASE-SENSITIVE). 

Also if value is missing in member, then that member is treated as NULL.

## 14. Sections in Sections
If you want to put a section under another section, nested sections, make a section header that is one level higher than the current level. This means that you add one more hash symbol than the number of hash symbols in the current section. It is not allowed to skip any level when going to higher/deeper levels, the levels must come in order when nesting to deeper levels.
```
## Section ##
### SubSection ###
```

## 15. Conclusion

The YINI (Yet another INI) specification aims to offer a flexible, human-readable configuration format that extends traditional INI syntax with enhanced features such as nested sections, list literals, multiple string types, and support for various number formats. Its design balances simplicity and expressiveness, making it well-suited for both small configuration files and more structured data representations.

By providing a clearly defined syntax, consistent parsing rules, and support for modern data types, YINI strives to be both easy to use and powerful for developers and configuration authors alike.

Future updates to the specification may expand functionality or improve clarity, based on community feedback and evolving needs.

---

## 16. Example

A full example of a `YINI` document:
```
# MyPrefs

# General
IsDarkMode = YES
Buffers = 10
Dirs: "C:\Users", "D:\Work\Temp", "E:\Data\Temp"

## Menu 
Id = "FILE"
Value = "File"

### MenuItem
Value = "New"
OnClick = "CreateDoc()"

### MenuItem
Value = "Open"
OnClick = "OpenDoc()"

### MenuItem
Value = "Save"
OnClick = "SaveDoc()"

/END // End of YINI doc.
```

---

## 17. Implementation Notes

The following notes are intended to support developers building engines and parsers for YINI, ensuring consistent and unambiguous interpretation across different host systems.

### 17.1 Top-Level Sections and Implicit Root

- If a document contains multiple level-1 sections (i.e., multiple `# Section` blocks), these should be **treated as children of an implicit root object**.
- This implicit root should not have a name (or may be named `root` or similar, as determined by the host system).
- Do not skip section levels when parsing nested sections - level-3 sections must follow level-2.

### 17.2 Line Handling and Whitespace

- Newlines (`<NL>`) may be either LF (`0x0A`) or CRLF (`0x0D 0x0A`). Normalize them internally.
- Ignore leading and trailing whitespace on section headers and keys.
- Allow comments (`//` or `/* */`) after members or values.
- Whitespace between values in lists is allowed, including newlines.
- **A line cannot begin with a comma**, even if it's inside a list.

### Value and NULL Handling

- If a member has **no value**, it must be treated as `NULL`.
```yini
key =          // NULL
key:           // NULL
```
- If a key appears **more than once in the same section**, this is an **error** (keys must be unique).

### 17.4 Boolean Canonicalization

- Boolean literals are **case-insensitive**.
- The following values must be interpreted as Booleans:
  - `true`, `yes`, `on` → `true`
  - `false`, `no`, `off` → `false`
- Do not allow Boolean values like `1` or `0` unless explicitly cast by the host software.

### 17.5 Lists

- Lists may be defined using either:
  - `=` with square brackets:
    ```yini
    items = ["a", "b", "c"]
    ```
  - `:` with comma-separated items:
    ```yini
    items1: "a", "b", "c"

    items2:
    "a",
    "b",
    "c"
    ```
- **Bracketed lists must not** have a newline between `=` and `[`.
    ```yini
    invalidList = // This is treated as NULL!
    [1, 2, 3]  // Not a list.
    ```
- A trailing comma is allowed, but a line must not start with a comma.

### 17.6 Strings Concatenation

- Strings can be concatenated using the `+` operator:
    ```yini
    name = "Hello, " + "world"
    ```
- Whitespace between parts is optional, but the whole expression must be on a single line.
- Concatenation of different string types (e.g., raw + classic) is allowed for ease of use.
- Escape sequences (e.g., `\n`) are only interpreted in C-strings.

### 17.7 String Literal Types

- Default string type is **raw**: no escape sequences, backslash is literal.
- C-Strings (`c"..."`) should interpret escape sequences.
- H-Strings (`h"..."`) must:
  - Allow multi-line strings.
  - Collapse sequences of whitespace and newlines into a single space.
  - Trim leading/trailing whitespace.

### 17.8 Comments

- Support both:
  - `//` for single-line comments (rest of the line ignored).
  - `/* ... */` for multi-line comments (may span lines).
  - **Nested block comments are not supported.**

### 17.9 Error Handling Recommendations

If the parser encounters:
  - A missing section level (e.g., level 3 without level 2),
  - A duplicate key in the same section,
  - A malformed list or string,

It should:
- **Fail gracefully** and report an error, OR
- **Use host-defined fallback logic**, if robustness is preferred.

### 17.10 Bonus Tips for Implementation

- Add position info for each token/value in case of errors.
- Normalize all booleans and nulls internally.
- Consider strict and lenient modes in the parser (e.g. allow trailing commas or not).
- (?) Optionally log ignored lines (e.g., with --) for debugging.

## 18. Creator
Creator: 2024 Gothenburg, Marko K. Seppänen (Sweden via Finland).
