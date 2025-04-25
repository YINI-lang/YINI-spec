# About the YINI Format

YINI is a configuration and settings file format (similar but not identical to INI-files) for computer software that consists of plain text with a very simple structure and notation, consisting of Key–Value pairs and Key-List pairs, grouped into sections.

`YINI` (also `yINI`, `Yini` or `yini`)
## So, what is special about YINI?
In YINI:
- Strings are enclosed by either single quotes `'` or double quotes `"`, depending on your preference.
- Triple-quoted strings (enclosed in `"""`) are supported. For example:
  ```yini
  description = """This is a multi-line
  string in YINI format."""
- Key-**Value** pairs are separated by an equals sign `=`.
  
--EXPAND--

## Links
* **Specification:**
The actual YINI Specification can be found here: **[YINI spec](<../YINI-Specification.md>)**.

* **Grammar:**
This repository includes a YINI grammar defined using ANTLR 4, which closely follows the YINI specification. You can find the lexer and parser here: **[Lexer](<../Grammar-ANTLR4/YiniLexer.g4>)** and **[Parser](<../Grammar-ANTLR4/YiniParser.g4>)**.

* **Contributing:**
Feedback, bug reports, suggestions, and code contributions are welcome! Head over to **[Docs/Contributing](https://github.com/YINI-lang/YINI-spec/blob/develop/Docs/Contributing.md)**

## Author 🤓
Mr. Seppänen has been programming since the mid-80s, working in languages like Basic, C, and Assembler. He studied Computer Science and Master's in Software Development with a focus on Programming Languages, at Chalmers University of Technology. Professionally, he has worked many years in software development across PHP, TypeScript, and full-stack web development.

## Trivia
### The Name
In the beginning, `YINI` was known by its working name `MINI`, which later evolved into `MINI-CONFIG` / `miniCONFIG` standing for Minimalistic INI Configuration Object Notation File. Initially, the "M" in `MINI` represented Marko (after the author), but this was later changed to represent **Minimalistic**. As the specification matured beyond the draft stage, it was renamed to simply `YINI`, which stands for **Yet another INI**.

---

## Versions / Releases

| Version                  | Date YYYY-MM-DD| Description |
|--------------------------|----------------|-------------|
| YINI-spec v1.0.0 Beta 3  | 2025-04-25     | Third Beta
| YINI-spec v1.0.0 Beta 2  | 2025-04-23     | Second Beta
| YINI-spec v1.0.0 Beta 1  | 2025 Apr       | First Beta
| YINI-spec v1.0.0 Alpha 2 | 2024 Oct       | Pre-Beta
| YINI-spec v1.0.0 Alpha   | 2024 Oct       | Initial release

---

## License
This project is licensed under the Apache-2.0 license.
