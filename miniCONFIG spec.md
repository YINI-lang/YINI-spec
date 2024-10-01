# MINI-CONFIG specification

`MINI-CONFIG` or `miniCONFIG` is a configuration markup language, is another YINI (Yet another INI) format. It consists of plain text with a simple syntax and structure comprising of key–value(s) pairs organized in sections.

A short MINI document looks like the following.
```
# Prefs

HomeDir = "C:\Users\John Smith"
KeyWords: "oranges", "bananas", "peaches"
Buffers = 10

###
```

## Terminoly
- **Engine**: Is the program/software that reads and writes `miniCONFIG` documents.
- **Host**: The host is the program/software (written by the user/developer/programmer) that runs the `miniCONFIG`-engine (decoder or encoder).
- **Decoder**: A `miniCONFIG` converts or reads a MINI document into a meaningful object or data structure for a host to be used.
- **Encoder**: A `miniCONFIG` takes an object or data structure on the host and converts/saves it to a `miniCONFIG` document.

## Definitions
### Whitespaces
- Newlines `<NL>` can be either `<LF>` (0x0A) or `<CR><LF>` (0x0D 0x0A).
- All tabs `<TAB>` (0x09) and blank spaces `<SPACE>` (0x20) are ignored.

### Identifiers
Naming identifiers must follow below rules:
- Can only contain letters (a-z or A-Z), digits (0-9) and underscores `_`.
- Must begin with a letter or an underscore `_`.
- Identifiers are case-sensitive, uppercase and lowercase letters are distinct.
- Must be unique, there cannot be multiple section header with the same identifier.
- An identifier can have a max length of 2047 characters + null character (a total of 2048 bytes).

## Section Headers
A section header consists with one or more hash-symbols `#` and then an identifier (unique word/name, phrase without any spaces). The number of hash-symbols indicates the level of the section, there shall not be any whitespaces between multiple hash-symbols. Sections serves as objects.

In addition, the section header must be on its own separate line, any tabs or spaces at the beginning and end of the identifier are ignored.

```
# SectionLevel1 #
## SectionLevel2 ##
### SectionLevel3 ###
```

## Title Section
A `miniCONFIG` document always starts * with a Section header of level 1, the so-called title section header. There can only be one single level 1 section.

```
# Title #
```

After the Title section comes section header with level 2.

*) The very first line may start with a shebang `#!`, then this line is ignored.

```
# Title #
## Section ##
```

## Terminal Token
A `miniCONFIG` document must always end with three hash-symbols (without any whitespaces in between) on its own line, after this there may be only whitespaces or possible comments.

```
###
```

## Values & Native Types
A `miniCONFIG` value MUST be of one of the following 3 groups of native/built-in types:

- Simple types:
  - String
  - Number
  - Boolean

- Compound type:
  - List/array (a sequence consisting of strings, numbers, or booleans)

- Special type:
  - NULL

Note: Above are all types that are supported by `miniCONFIG`, any other types are left to the host software to cast or convert to after reading (or before saving) a `miniCONFIG` document.

## Members
Each member must start on its own line, they come in two forms:
1. A single value: a key-value pair that holds only one single value.
2. A list of values: a key-values pair that holds zero or more values (or elements). Elements are separated by commas.

### Member with a Value
A member with one value is a Key/Value pair using the a equals sign `=`. The key is on the left of a equals sign and the value is on the right.
> key = "value"
or
> lives = 3

### Member with a List
A member with a list, is a Key/List pair using the colon sign `:`. The key is on the left of the colon and the values (zero or more values) are on the right, each value separated by a comma. (A final comma `,` may be accepted so parsing is not broken.)
> key: "value1", "value2", "value3"

or

> fruits: "oranges", "bananas", "peaches"

## String ##
A string in `miniCONFIG` can be of two forms:

### Double quoted strings
Surrounded by double quotation `"` marks: All escape codes are ignored except `\"`, the text becomes how it looks. Any `<NL>` will be converted into `<SPACE>`.
Double quoted strings are ideal for file directory paths and the like.
>"C:\Users\John Smith"

### Single quoted strings
Surrounded by single quotation `'` marks, are similarat to strings in C, JSON and the like. Any special characters are done with backslash `\` followed by a character that is wanted:

Either in lower or uppercase.
```
    '"'
    '\'
    '/'
    'b'
    'f'
    'n'
    'r'
    't'
    'u' hex hex hex hex
```

Where hex is 0-9, or a-f, or A-F.

## Number ##
Number can be an integer or a real number with `.` similar as a number in JavaScript. It can include a sign - or +. Can be of exponent form, 'e' or 'E' sign digits, where:
-sign is either +, -, or blank
- digits is a number 0 or larger
  
## Boolean ##
Booleans in a `miniCONFIG` document can be following literals (NON CASE-SENSITIVE):
- true
- false
- yes
- no
- on
- off

The engine should convert the literal value to the corresponding Boolean value in the host language.
  
## List (array) ##
A list with zero or more values, each value separated by a comma, whitespaces between values/commas are OK.
  
## NULL ##
Value/literal `NULL` (NON CASE-SENSITIVE). Also if value/list is missing in member, then that member is treated as NULL.

## Sections in Sections
To nest a section under another section, make a section header that is one level higher, add one extra hash symbol on each side than the number of enclosed hash signs that is wanted to be nested.
```
## Section ##
### SubSection ###
```

---

A full example:
```miniconfig
# menu #
id = "file"
value = "File"

### menuItem ###
value = "New"
onClick = "CreateDoc()"

### menuItem ###
value = "Open"
onClick = "OpenDoc()"

### menuItem ###
value = "Save"
onClick = "SaveDoc()"

### // End of file.
```


---

By Marko K. Seppänen.

