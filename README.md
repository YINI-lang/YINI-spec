# YINI-spec v1.0.0 Alpha 2
**Y**et another **INI** markup language - `YINI` is a config and settings file format (similar to INI-files) for computer software that consists of plain text with a simple structure, comprising of Key–Value pairs and Key-List pairs, grouped in sections.

## Short Examples
A short example of how a `YINI` document file looks like:

```ts
# MyPrefs

HomeDir = "C:\Users\John Smith\"
Buffers = 10
IsNight = OFF  // Boolean false, YINI understands also OFF, YES, ON etc.

// Following is a list (array) with strings as elements.
KeyWords: [ "Orange", "Banana", "Pear", "Peach" ]

/END  // All YINI files must end with this line.
```

A `YINI` document file can look like this as well:
```ts
# window
title = 'Sample Window'  // Strings can be enclosed in either ' or ".
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

// Following is a list with other lists as elements.
styles: [
    ['font-weight', 'bold'], ['size', 36], ['font', 'arial']
]

/END  // End of YINI doc.
```

---
## General Objective
Compared with other markup languages:
- YINI should have simpler structure and more lightweight than YAML and TOML.
- YINI should be more human-readable than (nested) JSON and YAML.
- YINI should be less verbose (verbal) than XML.
- YINI's syntax shall be more high level than JSON (but also less than YAML's).

## Motivation
`YINI` aims to be a simple and (relatively) lightweight text-based markup language format, for storing configurations, settings and preferences in software. It should be language-independent and platform-independent as far as possible.

YINI should have built-in types of the most general data types (to keep the format more simple and more lightweight). Custom types, advanced typechecking and type specialization are left to the user/client and host/language ​​to handle/process if further specialization is desired by the user/client using a YINI file/document.

Yet, the YINI format should be easy and simple enough to express structure, notation and groupings of data to be stored on a medium for later use.

## Design Goals
1. YINI files/documents should be platform agnostic, portable between platforms and programming languages as far as possible.
2. YINI should have a simple structure and notation, and easy to group data. 
3. YINI should be easily readable (to some extent) by humans.
4. YINI should be non-verbose, avoid to use excessive or unnecessary words or characters. And at the same time be (relatively) light-weight, yet be (relatively) high-level.
5. YINI files/documents should be easy to create, use, read, write, and support one-pass processing.

## Latest Release
The latest (and most stable) release can be found here: **[YINI spec](<https://github.com/YINI-lang/YINI-spec/tree/staging>)**.

## Current Spec
The current specification in this branch can be found here: **[YINI spec](<./YINI spec.md>)**.

## Grammar
There exists a YINI grammar (in ANTLR 4 ) in this branch here: **[YINI grammar](<./grammar-antlr4/yini.g4>)**.

## Published Specs
Published YINI specifications can be found here: **[YINI spec](<https://github.com/YINI-lang/YINI-spec/tree/published-specs>)**.

## So, what is special about YINI?
In YINI:
- Strings are enclosed by either single quotes `'` or double quotes `"`, use what you prefer.
- Key-**Value** pairs are separated by an equals sign `=`.
- While, Key-**List** pairs are separated by a colon `:`.
  
--EXPAND--

## More Examples
### Bigger Example 1
```
# MyPrefs

## General
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

### Bigger Example 2
```
# package
name = "SomeName"
description = "Some description of something."
version = "1.8.4"
authors: [
    "skljsdalf",
    "Sss sdfsdf <sdfsf@jlewr.com>",
    "sdfalf",
]
exclude: [
    "build",
    "docs",
    "examples",
    "packages",
]

# dev-dependencies
tester = "bin/tester@1.1.4"

/END // End of doc.
```

## Trivia
### The Name
In the beginning, `YINI` started with the working name `MINI`, and then `MINI-CONFIG` / `miniCONFIG` which stood for Minimalistic INI Configuration Object Notation File. Also M stood for Marko's (after the author) at the start but was changed to stand for minimalistic. Finally, as the specification began to mature away from the draft stage, the name was renamed to just `YINI`.

## Versions / Releases

| Version                  | Date     | Description |
|--------------------------|----------|-------------|
| YINI-spec v1.0.0 Alpha 2 | 2024 Oct | 
| YINI-spec v1.0.0 Alpha   | 2024 Oct | Initial release.

## Changes
--TODO--
