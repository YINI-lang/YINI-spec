# MINI specification

MINI is a configuration markup language, is another YINI (Yet another INI) format. It consists of plain text with a simple syntax and structure comprising of key–value(s) pairs organized in sections.

A short MINI document looks like the following.
```
# Prefs

HomeDir = "C:\Users\John Smith"
Buffers = 10

###
```

## Terminoly
- **Host**: The host is the program/software (written by the client user/programmer) that runs the (MINI) decoder or encoder.
- **Decoder**: A MINI-Decoder converts or reads a MINI document into a meaningful object or data structure for a host to be used.
- **Encoder**: A MINI-Encoder takes an object or data structure on the host and converts/saves it to a MINI document.

## Definitions
### Whitespaces
- Newlines <NL> can be either <LF> (0x0A) or <CR><LF> (0x0D 0x0A).
- All tabs <TAB> (0x09) and blank spaces <SPACE> (0x20) are ignored.

### Identifiers
Naming identifiers must follow below rules:
- Can only contain letters (a-z or A-Z), digits (0-9) and underscores `_`.
- Must begin with a letter or an underscore `_`.
- Identifiers are case-sensitive, uppercase and lowercase letters are distinct.
- Must be unique, there cannot be multiple section header with the same identifier.
- An identifier can have a max length of 2047 characters + null character (a total of 2048 bytes).

## Section Headers
A section header consists with one or more hash-symbols `#` and then an identifier (unique word/name, phrase without any spaces). The number of hash-symbols indicates the level of the section.

In addition, the section header must be on its own separate line, any tabs or spaces at the beginning or end of the identifier are ignored.

```
# SectionLevel1 #
## SectionLevel2 ##
### SectionLevel3 ###
```

## Title Section
A MINI document always starts with a Section header of level 1, the so-called title section header. There can only be one single level 1 section.

```
# Title #
```

After the Title section comes section header with level 2.

```
# Title #
## Section ##
```

## Terminal token
A MINI document must always end with three hash-symbols on its own line, after this there may be only whitespaces or possible comments.

```
###
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
  - NULL

Note: That are all types that are supported by MINI, any other types are left to the host software to cast or convert to after reading (or before saving) a MINI document.

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

A full example:
```mini
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

