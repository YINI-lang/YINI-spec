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

## More Examples
* All examples can be found here: **[Examples](<./Examples>)**.
* Also more samples can be found here: **[More-samples](<./More-samples>)**

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

## Links
### Latest Release
The latest (and most stable) release can be found here (in staging): **[Latest YINI Release](<https://github.com/YINI-lang/YINI-spec/tree/staging>)**.

### Current Spec
The current specification in this branch can be found here: **[YINI spec](<./YINI spec.md>)**.

### Grammar
There exists a YINI grammar (in ANTLR 4 ) in this branch here: **[YINI grammar](<./Grammar-antlr4/yini.g4>)**.

### Published Specs
Published YINI specifications can be found here: **[Published YINI Specs](<https://github.com/YINI-lang/YINI-spec/tree/published-specs>)**.

## Contributing
See the file [CONTRIBUTING.md](<./CONTRIBUTING.md>)

## License
This project is licensed under the Apache-2.0 license - see the [LICENSE.md](<./LICENSE.md>) file for details.