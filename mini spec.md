# MINI specification

A MINI file is a configuration file for computer software that consists of plain text with a simple syntax and structure comprising of key–value, and/or key–values, pairs organized in sections.

## Definitions
- **Host**: The host is the program/software (written by the client user/programmer) that runs the (MINI) decoder or encoder.
- **Decoder**: A MINI-Decoder converts or reads a MINI document into a meaningful object or data structure for a host to be used.
- **Encoder**: A MINI-Encoder takes an object or data structure on the host and converts/saves it to a MINI document.

## Whitespaces
Newlines are LF (0x0A) or CRLF (0x0D 0x0A). Tabs and blank spaces are ignored.

## Section Headers
A Section header consists of an identifier (unique word/name, phrase without any spaces) surrounded by one or more hash-symbols `#` on each side. There must be an equal number of `#` characters on both sides. The number of hash-symbols indicates the level of the section.

In addition, the section heading must be on its own separate line, any tabs or spaces at the beginning or end of the identifier are ignored.

```
# SectionLevel1 #
## SectionLevel2 ##
### SectionLevel3 ###
```

Naming identifiers must follow below rules:
- Can only contain letters (a-z or A-Z), digits (0-9) and underscores `_`.
- Must begin with a letter or an underscore `_`.
- Identifiers are case-sensitive, uppercase and lowercase letters are distinct.
- Must be unique, there cannot be multiple section headings with the same identifier.

## Title Section
A MINI document always starts with the Title section, it is a Section header with level 1. There can only be one single Title section in a document.

```
# Title #
```

After the Title section comes section header with level 2.

```
# Title #
## Section ##
```

## Values & Native Types
A MINI value MUST be of one of the following 3 groups of native types:

- Simple types:
  - String
  - Number
  - Boolean

- Compound type:
  - List/array (a sequence consisting of strings, numbers, or booleans)

- Special type:
  - NULL or blank

That are all types that are supported by MINI, the host software may cast or convert a value if the host needs another "special" type.

## Key/Value Pairs
Comes in two forms:
1. A single value: a key-value pair that holds only one single value.
2. A list of values: a key-values pair that holds zero or more values (or elements). Elements are separated by commas.

### A Key/Value Pair
The key is on the left of a equals sign `=` and the value is on the right.
> key = "value"
or
> lives = 3

### A Key/Value-list Pair
The key is on the left of a colon sign `:` and the values are on the right, each value separated by comma. (A final comma `,` may be accepted so parsing is not broken.)
> key: "value1", "value2", "value3"

or

> fruits: "pear", "orange", "banana"

## String ##
--todo--

## Number ##
--todo--
  
## Boolean ##
--todo--
  
## List (array) ##
--todo--
  
## NULL ##
--todo--

## Sections in Sections
To nest a section under another section, make a section header that is one level higher, add one extra hash symbol on each side than the number of enclosed hash signs that is wanted to be nested.
```
## Section ##
### SubSection ###
```

---

```
# menu #
id = "file"
value = "File"

### menuItem ###
value = "New"
onclick = "CreateDoc()"

### menuItem ###
value = "Open"
onclick = "OpenDoc()"

### menuItem ###
value = "Save"
onclick = "SaveDoc()"

```


---

By Marko K. Seppänen.

