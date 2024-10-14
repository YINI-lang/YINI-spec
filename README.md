# YINI Specification

- INI-file the right way, both for software and humans 🙈
- Strings enclosed in single or double quotes. Pure, Classic or Hyper strings, use whatever you like and need 😉
- Need another section or nested section? Sure no problem, no need to hazzle with brackets or dots or whatnot! Just add an extra hash sign, ala Markdown header, and be done with it 😁

---
**Y**et another **INI** markup language - `YINI` is a config and settings file format (similar (but not same) to INI-files) for computer software that consists of plain text with a very simple structure and notation, comprising of Key–Value pairs and Key-List pairs, grouped in sections. YINI uses conventions that are familiar to programmers of the C-family of languages.

This project and repository deals with the specification for the YINI markup language.

## Short Examples
A short example of how a `YINI` document file looks like:

```ts
# MyPrefs

HomeDir = "C:\Users\John Smith\"
Buffers = 10
IsNight = OFF  // Boolean false, YINI understands also OFF, YES, ON etc.

// Following is a list (array) with strings as elements.
KeyWords = [ "Orange", "Banana", "Pear", "Peach" ]

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
styles = [
    ['font-weight', 'bold'], ['size', 36], ['font', 'arial']
]

/END  // End of YINI doc.
```

## More Examples
More examples can be found here: **[Examples](<./Examples>)** and there are some YINI document files here: **[More-samples](<./Source/Grammar-ANTLR4/Samples>)**

---
## General Objective
Compared with other markup languages:
- YINI should have simpler structure and more lightweight than YAML and TOML.
- YINI should be more human-readable than (nested) JSON and YAML.
- YINI should be less verbose (verbal) than XML.
- YINI's syntax shall be more high level than JSON.

## Motivation
`YINI` aims to be a simple and (relatively) lightweight text-based markup language format, for storing configurations, settings and preferences in software. It should be language-independent and platform-independent as far as possible.

YINI should have built-in types of the most general data types (to keep the format more simple and more lightweight). Custom types, advanced typechecking and type specialization are left to the user/client and host/language ​​to handle/process if further specialization is desired by the user/client using a YINI file/document.

YINI format should be very simple and minimal to express the structure, notation and grouping of data to be stored on a medium for later use. But still simple and legible enough to be read by humans.

Although there does not exists any YINI readers yet, a sister project **[YINI-Reader-TS](https://github.com/YINI-lang/YINI-Reader-TS)** is planned when this spec matures more (when YINI goes into beta?).

## Design Goals
1. YINI files/documents should be platform agnostic, portable between platforms and programming languages as far as possible.
2. YINI should have a simple structure and notation, be easy to group data, yet be unambiguous. 
3. YINI should be easily readable (to some extent) by humans.
4. YINI should be non-verbose, avoid to use excessive or unnecessary words or characters. And at the same time be (relatively) light-weight, yet be (relatively) high-level.
5. YINI files/documents should be easy to create, use, read, write, and support one-pass processing.

## Specification
The actual YINI Specification can be found here: **[YINI spec](<./Source/YINI-Specification.md>)**.

## Grammar
This repo also includes a YINI grammar (in ANTLR 4 ). It aims to follow the specification as closely as possible. You find it here: **[YINI grammar](<./Source/Grammar-ANTLR4/yini.g4>)**.

## Contributing
Feedback, bug reports, suggestions, and code contributions are welcome!

Head over to **[Docs/Contributing.md](<./Docs/Contributing.md>)**

## License
This project is licensed under the Apache-2.0 license - see the [LICENSE](<./LICENSE>) file for details.

## Author 🤓
This project and repository is created and maintaned by Marko K. S.

Marko has been programming and developing software during spare time since the 80s in multiple programming languages. In education he read Computer Science's Engineering and a Master's degree in Software Development with a specialization in Programming Languages. He has been working professionally for many years in software development from PHP to TypeScript and fullstack web development.
