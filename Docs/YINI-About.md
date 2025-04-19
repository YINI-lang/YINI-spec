# YINI Specification v1.0.0 Beta 1

YINI is a configuration and settings file format (similar but not identical to INI-files) for computer software that consists of plain text with a very simple structure and notation, consisting of Key–Value pairs and Key-List pairs, grouped into sections.

`YINI` (also `yINI`, `Yini` or `yini`)
## So, what is special about YINI?
In YINI:
- Strings are enclosed by either single quotes `'` or double quotes `"`, depending on your preference.
- Key-**Value** pairs are separated by an equals sign `=`.
- While, Key-**List** pairs are separated by a colon `:`.
  
--EXPAND--

## Links
* **Specification:**
The actual YINI Specification can be found here: **[YINI spec](<../YINI-Specification.md>)**.

* **Grammar:**
This repo also includes a YINI grammar (in ANTLR 4). It aims to follow the specification as closely as possible. You can find it here: **[Lexer](<../Grammar-ANTLR4/YiniLexer.g4>)** and **[Parser](<../Grammar-ANTLR4/YiniParser.g4>)**.

* **Contributing:**
Feedback, bug reports, suggestions, and code contributions are welcome! Head over to **[Docs/Contributing](https://github.com/YINI-lang/YINI-spec/blob/develop/Docs/Contributing.md)**

## Author 🤓
Marko has been programming and developing software in his spare time since the mid 80s in several different programming languages, from Basic to C and Assembler. He studied Computer Science's Engineering and a Master's degree in Software Development with a specialization in Programming Languages. He has been working professionally for many years in software development from PHP to TypeScript and fullstack web development.

## Trivia
### The Name
In the beginning, `YINI` started with the working name `MINI`, and then `MINI-CONFIG` / `miniCONFIG` which stood for Minimalistic INI Configuration Object Notation File. Also M stood for Marko's (after the author) at the start but was changed to stand for minimalistic. Finally, as the specification matured beyond the draft stage, it was renamed to just `YINI`.

---

## Versions / Releases

| Version                  | Date     | Description |
|--------------------------|----------|-------------|
| YINI-spec v1.0.0 Beta 1  | 2025 Apr | First Beta
| YINI-spec v1.0.0 Alpha 2 | 2024 Oct | 
| YINI-spec v1.0.0 Alpha   | 2024 Oct | Initial release.

## Changes
--TODO--

---

## License
This project is licensed under the Apache-2.0 license.
