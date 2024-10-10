# YINI-spec v1.0.0 Alpha 2
**Y**et another **INI** markup language - `YINI` is a configuration file format (similar to INI-files) for computer software that consists of plain text with a simple structure, comprising of Key–Value pairs and Key-List pairs, organized in sections.

## Short Examples
A short example of how a `YINI` document file looks like:

```
# MyPrefs

HomeDir = "C:\Users\John Smith\"
Buffers = 10
IsNight = OFF
KeyWords: "Orange", "Banana", "Pear", "Peach"

/END // End of YINI doc.
```


A `YINI` document file can look like this too:
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

---
## General Objective
Compared with other markup languages:
- YINI should be simpler and more lightweight than YAML and TOML.
- YINI should be more human-readable than (nested) JSON and YAML.
- YINI should be less verbose (verbal) than XML.
- YINI's syntax shall be more high level than JSON (but also less than YAML's).

## Motivation
`YINI` aims to be a simple and (relatively) lightweight text-based markup language format, for storing configurations, settings and preferences in software. It should be language-independent and platform-independent as far as possible.

It aims to be even more simple and lightweight than similar formats (no specific names mentioned). No unnecessary extra niceties (due to keeping the format simple and lightweight) with regards to types (this can be taken care of by the host language if desired or needed). Yet expressive enough to store the most important data types like strings, numbers, booleans and lists in sections or nested sections.

## Design Goals
1. YINI should be simple and (relatively) lightweight.
2. YINI should be easily readable (to some extent) by humans.
3. YINI should be non-verbose, not use excessive or unnecessary words.
4. YINI data/document should be portable between platforms and programming languages.
5. YINI should be easy to use, implement and support one-pass processing.

## Specification
Specification can be found here: **[YINI spec](<./YINI spec.md>)**.

## Grammar
There exists a YINI grammar in ANTLR 4 here: **[YINI grammar](<./Grammar-YINI.antlr4>)**.

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

| Version                | Date     | Description |
|------------------------|----------|-------------|
| YINI-spec v1.0.0 Alpha | 2024 Oct | Initial release.

## Changes
--TODO--
