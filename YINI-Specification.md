# YINI specification version 1.0.0 Alpha 3

## Table of Contents
1. Intro 
2. Terminoly
3. Definitions
4. Section Headers
5. Section Header
6. Terminal Line
7. Values & Native Types
8.  Members
9.  String Literals
    * 9.1 Pure Strings
    * 9.2 Hyper or H-Strings
    * 9.3 Classic or C-Strings
10. Number Literals
11. Boolean Literals
12. Lists (arrays)
13. NULL Literal
14. Sections in Sections
15. Example

---

## 1. Intro
`YINI` is a configuration file format, it stands for **Y**et another **INI** markup language. It consists of plain text with a simple syntax and structure, comprising of Key–Value pairs and Key-List pairs, organized in sections.

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

## 2. Terminoly
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
- Must be unique, there cannot be multiple section header with the same identifier.
- An identifier can have a max length of 2047 characters + null character (a total of 2048 bytes).
- Also identifiers must follow the engine's or host's (program/software that reads and writes `YINI` documents) naming conventions.

## 4. Section Headers
A section header consists with one or more hash-symbols `#` and then an identifier (must be a unique identifier (within the same section level)). The number of hash-symbols indicates the nesting level of the section, there shall not be any whitespaces between multiple hash-symbols. Sections serves as objects.

In addition, the section header must be on its own separate line, any tabs or spaces at the beginning and end of the identifier are ignored.

Nesting sections must be attached to a existing section. If doing a section with level three, then there must be a section level 2 before.

A special case is YINI documents with multiple level 1 sections, the the client's library reading the document must attach these level 1 section into one implicit section automatically. The name of this "implicit section" is left for the library to decide.

```
# SectionLevel1 #
## SectionLevel2 ##
### SectionLevel3 ###
```

## 5. Section Header
A `YINI` document always starts with a Section Header of level 1. There may be multiple single level 1 sections, each document must have at least one section.

(Note: If there is only one (1) section with level 1, it may be called the so-called title header.)

```
# Title
```

After the a section with level 1, comes section header with level 2.

*) The very first line **may start** with a shebang `#!`, then this line is ignored.

```
# Title
## Section
```

## 6. Terminal Line
A `YINI` document must always end with `/END` (NON CASE-SENSITIVE)on its own line. After this there may be only whitespaces or possible comments.

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
Each member must start on its own line, the name is called key in members, must be a unique identifier within the section (on the same section level).
They come in two forms:
1. **A single value**: a key-value pair that holds only one single value.
2. **A list of values**: a key-values pair that holds zero or more values (or elements). Elements are separated by commas.

### Member with a Value
A member with one value is a Key-Value pair using the an equals character `=`. The key is on the left of a equals character and the value is on the right.
> key = "value"
or
> lives = 3

### Member with a List
#### List Literal
A member with a list, is a Key-List pair using the equals `=` character. After that follows zero or more values separated by a comma, and all values enclosed in brackets `[` `]`. (A final comma `,` may be accepted so parsing is not broken.)

> list1 = ["value1", "value2", "value3"]
>
> list2 = []  // An empty list.

NOTE: There may not be a <NL> after the equals `=` character and the list itself. Due to in that case the member notes a value with null.

#### List without Brackets
An alternative list notation for Key-List is using the colon character `:`. The key is on the left of the colon and the values (zero or more values) are on the right, each value separated by a comma. (A final comma `,` may be accepted so parsing is not broken.)

When using a colon `:` then `[` `]` are left out.

> // Alternative list notation (with :).
> list: "oranges", "bananas", "peaches"

## 9. String Literals
Strings in YINI can either be enclosed in single quotes `'` or double quotes `"`, use whichever you prefer or whatever is appropriate for the situation.

There are also different types of strings, these can be made by prefixing a string (before the first quote) with a specific letter. YINI support three kinds of strings.

By default all strings are **pure string literals by defalt**

All string literals must end and start on the same line, meaning they cannot span over multiple lines, except H-Strings (8.2). Multiple strings on can be concatenated together to archive longer string literals (8.4).

### 9.1 Pure Strings (Default)
In (pure) strings the backslash **`\` is "just a backslash"** character, hence different escape sequences like newline or tabs cannot be used. The default (pure) strings must be on same line.

YINI strings are ideal for file directory paths and the like.
>myPath = "C:\Users\John Smith\"
or
>myPath = '/home/Leila Häkkinen'
or
>myPath = '/Users/kim-lee'

### 9.2 Hyper or H-Strings
There is also another kind of strings, ("Hyper") string literals, called H-Strings for short. These strings are prefixed with either `c` or `C`.

Hyper Strings, as Pure Strings, treat the backslash exactly as seen (escape sequences are not supported).

- Hower, Hyper strings are special in that they can span over multiple lines with `<NL>`, and indentation with `<WS>` can be used to aid human readability in YINI documents.
- Moreover, one or more succeeding `<NL>` and/or `<WS>` are always converted to one single blank space ` `. 
- Also, leading and trailing `<NL>` and/or `<WS>` are trimmed away.

Hyper Strings behaves similar to plain text in HTML documents.

### 9.3 Classic or C-Strings (Escaped)
Alternatively YINI support also normal ("Classic") string literals, called C-Strings for short. These strings are prefixed with either `c` or `C`. All the usual escape sequences that represents newlines, tabs, backspaces, form-feeds, and so on are supported.

>myText = c"This is a newline \n and this is a tab \t character."

Escape codes in C-strings (in lower or uppercase):
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
Number can be an integer or a real number with `.` similar as a number in JavaScript. It can include a sign - or +. Can be of exponent form, 'e' or 'E' sign digits, where:
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
A list with zero or more values, each value separated by a comma, whitespaces between values/commas are OK, as well as there can be a comma after the last value. However, a line cannot start with a comma `,`.

Optionally a list can be enclosed in [ ], but it is not mandatory.

A list can also be nested with other lists.

NOTE: Key-List pairs are separated by a colon `:`, as opposed to key-Value pairs.

```
linkItems: [
	["stylesheet", "css/general.css"],
	["stylesheet", "css/themes.css"]
]
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

---

## 15. Example

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

Author: 2024 Gothenburg, Marko K. S. (Sweden via Finland).
