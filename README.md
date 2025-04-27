# YINI Specification

**Version:** v1.0.0 Beta 3 + Updates

**Status:** Beta Release

**Format Name:** `YINI` (influenced by `INI`, `JSON`, `C`, `Python`...)

## 🧾 Overview
**Y**et another **INI** markup language - `YINI` **(Yet Another INI)** is a lightweight and human-readable configuration file format designed for both software and developers. It provides a **simple structure and notation** for storing settings, preferences, and configurations using **Key-Value** and **Key-List pairs** grouped into sections. **[More about YINI](<./Docs/YINI-About.md>)**

YINI is designed to be **easy to write**, **easy to parse**, and **clear to read**, especially for power users and devs working with nested preferences or UI components.

This project and repository deals with the specification for the YINI markup language.

---

## Why Use YINI?
- ✅ **Simple & Minimal** – Clean, readable, structured. Built for humans.
- ✅ **Flexible Syntax** – You can use strings enclosed in single or double quotes. Supports **raw strings** (for paths) **, escaped strings (C-Strings), and multi-line Hyper Strings**, and even Triple-Quoted Strings. 🥳
- ✅ **Structured Organization** – Need another section or nested section for data grouping? Sure no problem, no need to fuss with brackets or dots or whatever! Just add an extra hash character ```#```, ala Markdown header, and be done with it. 🚀
- ✅ **Easy & Lightweight Alternative** – Less verbose and more human-readable than XML, YAML, and JSON. 🙈

---

## ✨ Core Features
- **Sections** – Hierarchical structure with section depth defined via hash prefixes (`#`, `##`, `###`, etc.).
- **Key-Value Pairs** – `key = value`.
- **Lists (Arrays)** – List support using comma-separated values `[ ]`, or colon ```:``` for short hand notation.
- **Supports Booleans & Null Values** – `true`, `false`, `on`, `off`, `yes`, `no`, `null`.
- **Number Formats** – Numbers can be written in decimal (10), binary (2), octal (8), hexadecimal (16), and duodecimal (12) formats. You can also use exponent notation (e.g., `3e4` for 30000) to represent very large or small numbers easily.
- **Clear File End** - YINI document files are clearly terminated using the `/END` marker.

---

## 🔧 Syntax Overview
A short example of how a `YINI` document file looks like:

```yini
# MyPrefs

HomeDir = "C:\Users\John Smith\"
Buffers = 10
IsNight = OFF  // Boolean false, YINI understands also OFF, YES, ON etc.

// This is a list of fruits as strings. Items are comma-separated.
KeyWords = [ "Orange", "Banana", "Pear", "Peach" ]

/END  // All YINI document files must end with this line.
```

A `YINI` document file can look like this as well:
```yini
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

## 📦 More Examples
More examples can be found here: **[Examples](<./Examples>)** and there are some YINI document files here: **[More-samples](<./Grammar-ANTLR4/Test-samples/Valid>)**

---
## General Objective
Compared with other markup languages:
- YINI should have simpler structure and more lightweight than YAML and TOML.
- YINI should be more human-readable than (nested) JSON and YAML.
- YINI should be less verbose than JSON and XML.
- YINI's syntax shall be more high level than JSON.

## Motivation
`YINI` aims to be a simple and (relatively) lightweight text-based markup language format for storing configurations, settings, and preferences in software. It should be language-independent and platform-independent as far as possible.

YINI should have built-in types of the most general data types (to keep the format more simple and more lightweight, same types as JSON). Custom types, advanced typechecking and type specialization are left to the user/client and host/language ​​to handle/process if further specialization is desired by the user/client using a YINI document file.

YINI format should be very simple and minimal to express the structure, notation and grouping of data to be stored on a medium for later use. But still simple and legible enough to be read by humans.

Although there does not exist any YINI readers yet, a sister project **[YINI-Reader-TS](https://github.com/YINI-lang/YINI-Reader-TS)** is planned when this spec matures more (when YINI goes into beta?).

## Design Goals
1. YINI document files should be platform agnostic, portable between platforms and programming languages as far as possible.
2. YINI should have a simple structure and notation, be easy to group data, yet be unambiguous. 
3. YINI should be easily readable by humans.
4. YINI should be non-verbose, avoiding excessive or unnecessary words or characters. And at the same time be (relatively) light-weight, yet be (relatively) high-level.
5. YINI document files should be easy to create, use, read, write, and support one-pass processing.
6. Have clean document endings.

## 📚 Specification
The actual YINI Specification can be found here: **[YINI spec](<./YINI-Specification.md>)**.

## Grammar
This repository includes the YINI grammar defined using ANTLR4. The lexer and parser specifications follow the YINI syntax as closely as possible.
You find it here: **[Lexer](<./Grammar-ANTLR4/YiniLexer.g4>)** and **[Parser](<./Grammar-ANTLR4/YiniParser.g4>)**.

## 📄 License
This project is licensed under the Apache-2.0 license - see the [LICENSE](<./LICENSE>) file for details.

## 💬 Feedback

Have ideas, questions, or feedback? Open an **[issue](<./issues>)**.

### Contributing 🤝
Feedback, bug reports, suggestions, and code contributions are welcome!

Head over to **[Docs/Contributing.md](<./Docs/Contributing.md>)**

## 🤓 Author
This project and repository is created and maintained by Marko K. Seppänen.

### Creator
First created in 2024 Gothenburg, by Marko K. Seppänen (Sweden via Finland).

Mr. Seppänen has been programming since the mid-80s, working in languages like Basic, C, and Assembler. He studied Computer Science and Master's in Software Development with a focus on Programming Languages, at Chalmers University of Technology. Professionally, he has worked many years in software development across PHP, TypeScript, and full-stack web development.
