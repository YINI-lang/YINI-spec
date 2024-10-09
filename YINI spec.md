# YINI specification version 1.0 Alpha
## Revision 1.0.0

`YINI` is a configuration file format, it stands for **Y**et another **INI** markup language. It consists of plain text with a simple syntax and structure, comprising of Key–Value pairs and Key-List pairs, organized in sections.

Recommended filename extension for a YINI file is `.yini`.

A short YINI document looks like the following.
```yini
# Prefs

HomeDir = "C:\Users\John Smith"
KeyWords: "oranges", "bananas", "peaches"
Buffers = 10

### // End of YINI doc.
```

## Table of Contents
--TODO--

## 1. Terminoly
- **Engine**: Is the program/software that reads and writes `YINI` documents.
- **Host**: The host is the program/software (written by the user/developer/programmer) that runs the `YINI`-engine (decoder and/or encoder).

## 2. Definitions
### 2.1 Whitespaces
- Newlines `<NL>` can be either `<LF>` (0x0A) or `<CR><LF>` (0x0D 0x0A).
- All tabs `<TAB>` (0x09) and blank spaces `<SPACE>` (0x20) are ignored.

### 2.2 Comments
- Single line comments start with a double slash `//`. Everything after `//` to the end of the line `<NL>` is ignored.
- Multi line comments start with `/*` and ends with `*/`. Multi line comments can span over multiple lines.
### 2.3 Ignore / Disable Line
--This space is reserved--<br/>
--Ignore / Disable Line: This may or may not be implemented in the future.--
>- Ignore/disable line start with a double minus `--` as first characters in a line. Everything (including comments) after `--` to the end of the line `<NL>` shall be ignored (by the engine).

### 2.4 Identifiers
Naming identifiers must follow below rules:
- Can only contain letters (a-z or A-Z), digits (0-9), dashes `-` (minus characters) and underscores `_`.
- Must begin with a letter or an underscore `_`.
- Identifiers are case-sensitive, uppercase and lowercase letters are distinct.
- Must be unique, there cannot be multiple section header with the same identifier.
- An identifier can have a max length of 2047 characters + null character (a total of 2048 bytes).

## 3. Section Headers
A section header consists with one or more hash-symbols `#` and then an identifier (must be a unique identifier (within the same section level)). The number of hash-symbols indicates the level of the section, there shall not be any whitespaces between multiple hash-symbols. Sections serves as objects.

In addition, the section header must be on its own separate line, any tabs or spaces at the beginning and end of the identifier are ignored.

```
# SectionLevel1 #
## SectionLevel2 ##
### SectionLevel3 ###
```

## 4. Section Header
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

## 5. Terminal Token
A `YINI` document must always end with three hash-symbols (without any whitespaces in between) on its own line, after this there may be only whitespaces or possible comments.

```
###
```

## 6. Values & Native Types
A `YINI` value MUST be of one of the following 3 groups of native/built-in types:

- Simple types:
  - String
  - Number
  - Boolean

- Compound type:
  - List/array (a sequence consisting of strings, numbers, or booleans)
  - Tuple (--NOT IMPLEMENTED YET--)

- Special type:
  - NULL

Note: Above are all types that are supported by `YINI`, any other types are left to the host software to cast or convert to after reading (or before saving) a `YINI` document.

## 7. Members
Each member must start on its own line, the name is called key in members, must be a unique identifier within the section (on the same section level).
They come in two forms:
1. **A single value**: a key-value pair that holds only one single value.
2. **A list of values**: a key-values pair that holds zero or more values (or elements). Elements are separated by commas.

### Member with a Value
A member with one value is a Key-Value pair using the an equals character `=`. The key is on the left of a equals character and the value is on the right.
> key = "value"
or
> lives = 3

NOTE: Key-Value pairs are separated by equals `=` character, as opposed to key-List pairs.

### Member with a List
A member with a list, is a Key-List pair using the colon character `:`. The key is on the left of the colon and the values (zero or more values) are on the right, each value separated by a comma. (A final comma `,` may be accepted so parsing is not broken.)

Optionally a list can be enclosed in `[` `]`, but it is not mandatory.
> key: ["value1", "value2", "value3"]

or just

> fruits: "oranges", "bananas", "peaches"

## 8. String Literals ##
### 8.1 Strings (Pure) ###
Strings can either be enclosed in single quotes `'` or double quotes `"`. In `YINI` strings are **pure string literals by defalt**, meaning that these strings cannot span over multiple lines, include any whitespaces except blank space <SPACE>, and backslash **`\` is "just a backslash"** character. Also they do not support different escape sequences like newline or tabs, except:
- String enclosed in single quotes `'`, support only `\'` for `'`
- String enclosed in double quotes `"`, support only `\"` for `"`

YINI strings are ideal for file directory paths and the like.
>myPath = "C:\Users\John Smith"

### 8.2 Escaped Strings ###
Alternatively YINI support also "normal" strings literals, called C-Strings. These strings are prefixed with either `c` or `C` (for classic string). All the usual escape sequences" that represents newlines, tabs, backspaces, form-feeds, and so on are supported.

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

## 9. Number Literals ##
Number can be an integer or a real number with `.` similar as a number in JavaScript. It can include a sign - or +. Can be of exponent form, 'e' or 'E' sign digits, where:
-sign is either +, -, or blank
- digits is any number 0 or larger

### Number Formats ###

In addition to normal (10-base) decimal literals, YINI supports other number base literals as well.

--MAYBE IN NEXT SPEC: Not sure about the alt. notation like `#`, `=`, `%` and so on--

| Number format | Alt. number format | Description | Number base | Note
|----------|--|---|---|---|
| `3e4` | - | Exponent notation number | 10-base | Result: 3×4^10
| `0d1209` | `=1209` | 10-base decimal number | 10-base |
| `0b1010` | `%1010` | Binary number | 2-base |
| `0o7477` | `&7477` | Octal number | 8-base |
| `0z2ex9` | `€2ex9` | Duodecimal (dozenal) number | 12-base | `x` is 10, `e` is 11
| `0xf390` | <strike>`#f390`</strike> | Hexadecimal number | 16-base | `a`, `b`, `c`, `d`, `e`, `f` are 10 to 15

## 10. Boolean Literals ##
Booleans in a `YINI` document can be following literals (NON CASE-SENSITIVE):
- true
- false
- yes
- no
- on
- off

The engine should convert the literal value to the corresponding Boolean value in the host language.
  
## 11. List (array) ##
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

## 12. Tuple ##
--This space is reserved--<br/>
--NOT IMPLEMENTED YET: MAYBE IN NEXT SPEC--

## 13. NULL ##
Value/literal `NULL` (NON CASE-SENSITIVE). 

Also if value/list is missing in member, then that member is treated as NULL.

## 14. Sections in Sections
If you want to put a section under another section, make a section header that is one level higher than the current level. This means that you add one more hash symbol than the number of hash symbols in the current section. It is not allowed to skip any level when going to higher/deeper levels, the levels must come in order when nesting to deeper levels.
```
## Section ##
### SubSection ###
```

---

## 15. Example

A full example of a `YINI` document:
```yini
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

### // End of YINI doc.
```

---

Author: 2024 Gothenburg, Marko K. Seppänen (Sweden via Finland).
