**YINI is a lightweight, human-friendly configuration format — simpler than YAML, and more expressive than INI.**

---

**Version:** v1.0.0 Beta 5 (Latest published release)

**Status:** Beta Release

**Format Name:** `YINI` (influenced by `INI`, `JSON`, `C`, `Python`...)

---
> \~ YINI ≡
---

# YINI Specification
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](./LICENSE)
![Status: Beta](https://img.shields.io/badge/status-beta-yellow)

_Yet another INI — a lightweight configuration file format that is clean, readable, structured._

---

## What is YINI?

YINI is a human-friendly configuration file format — designed as an alternative to INI — blending its simplicity with the structural clarity of modern data formats.

**Purpose:**
- Make configuration files easy to **read**, **write**, and **understand**.
- Maintain **minimal syntax** without sacrificing **nesting**, **typing**, or **clarity**.
- Provide a format that is simple for **humans** and structured enough for **tools**.

> YINI aims to hit the sweet spot between human-friendly simplicity and reliable structure — without the noise of JSON or the quirks of YAML.

---

## Key Features
Ten key features below:

- ✅ **Clean and minimalistic syntax** — avoids visual noise, easy to write and read.
- ✅ **Typing support** for: Strings, Numbers, Booleans, Lists (Arrays), and Nulls.
- ✅ **Combines structure and simplicity** — more expressive than INI, less verbose than JSON, YAML, or TOML. 
- ✅ **True section nesting** using intuitive markers (`^` or `~`).
- ✅ **Indentation-independent structure** — no indentation pitfalls.
- ✅ **Human readability first** — prioritizes clarity over cleverness — yet machine-friendly.
- ✅ **Flexible Boolean literals**, including: `true`, `false`, `on`, `off`, `yes`, `no` (case-insensitive).
- ✅ **Strict and lenient parsing modes** — suitable for both tooling and hand-edited configs.
- ✅ `=` for standard assignment, with optional `:` syntax for list-style values (colon-based lists).
- ✅ **Optional document terminator** `/END` for clear file boundaries and parser certainty in **strict-mode**.

💡 **Note:** YINI supports both `//` and `#` for comments. When using `#`, it must be followed by a space or tab character. This ensures that hex-like values like `#FF9900` are not misinterpreted as comments.

---

## Quick Example

### Before (Traditional INI or ad-hoc config)
```ini
[Server]                # Defines a section named Server.
host=localhost
port=8080

[Features]              # Defines a section named Features.
login=true
notifications=false
```

### After (YINI)
```ini
^ Server                # Defines a section named Server.
host = "localhost"
port = 8080

^ Features              # Defines a section named Features.
login = true
notifications = false
```

Notice:
- In YINI, `^` defines section headers.
- `#` (followed by space or tab) is used for line comments (`//`for comments works too).
- All strings must be enclosed in quotes (`"` or `'`).
- Natural, readable keys and values separated by (`=`).
- Strong typing without heavy syntax.

---

### Alternative Style (YINI with `~`, `//`, and `'`)
```c
~ Server                // Defines a section named Server.
host = 'localhost'      // Strings in single quotes works too.
port = 8080

~ Features              // Defines a section named Features.
login = true
notifications = false
```

Notice:
- Using alternative section marker `~`.
- Using `//` for line comments works too.

---

## YINI Syntax
### Quoted Strings
Strings in YINI must always be enclosed in quotes — either in double quotes (`"`) or in single quotes (`'`).

**Note:** If a string is not quoted, it's not a string — period.

### Lists
To declare a list, after the `=` character, square brackets `[ ]` are used. Each item is separated by a comma.

There is also an alternative list notation using `:`, which omits brackets. Items are comma-separated and may appear either inline or on separate lines.

### Section Nesting
Nesting sections can be done easily by adding one extra section marker (e.g. `^^`) — for example, in the example below, the section `Advanced` is a sub-section of the section `Features`.

### Alternative Boolean Literals
Booleans support flexible, case-insensitive literals, in the example below, `True`, `YES`, and `ON` (case-insensitive) all mean `true`.

## Example: List, Nesting & Alternative Booleans Literals

 Here's an example using single-quoted strings:

```ini
^ AppInfo
name = 'MyApp'          # String.
version = 1.2           # Number (real).

^ Features
features = ['login', 'sync', 'offline']     # List with 3 items.

^^ Advanced             # Defines a sub-section of Features.
timeout = 9000          # Number (integer).
caching = True          # Boolean.
isLogging = YES         # Boolean (alternative keyword).
debugging = ON          # Boolean (alternative keyword).
```

---

## Example: Flexible String Literals
YINI has four types of string literals — Raw, Classic, Hyper, and Triple-quoted — each designed to help express text clearly and appropriately in different situations, whether for escape handling, whitespace normalization, or multi-line content.

```yini
// Raw strings are the default. No prefix is needed, but an optional R prefix
// may be used for clarity. Escape sequences are not interpreted.
String = "D:\folder\file"

// Classic strings (C-Strings) are prefixed with C or c — they support escape sequences.
ClassicString = C"Hello\nWorld\n"

// Hyper strings (H-Strings) are prefixed with H or h — they behave
// similarly to HTML text: whitespace is normalized and edges are trimmed.
HyperString = H"
  This is a hyper string spanning multiple lines,
  with trimmed edges and normalized whitespace.
"

// Triple-quoted strings can span multiple lines and
// preserve all characters as-is, including tabs and newlines.
TripleQuotedString = """
This is a triple-quoted
string literal — characters
are preserved exactly, without escapes.
"""
```

---

## Specification Document

Full detailed specification available here:

➡️ [Read the YINI Specification](./YINI-Specification.md)

It covers syntax, grammar, validation rules, examples, versioning, JSON compatibility, and more.

---

## Why YINI?

| Feature | Benefit |
|:---|:---|
| Minimal syntax | Easy to read and edit by hand |
| Lightweight, yet type-safe | Safer and more expressive than plain INI |
| Simple nesting | Clear structure without complex indentation rules |
| Human-first | Designed for configuration, not data exchange |
| No guesswork in parsing | Optional strict mode available |

## 📊 Comparison: YINI vs Other Formats
| Feature                      | INI | JSON | YAML | TOML | **YINI** |
|-----------------------------|:---:|:----:|:----:|:----:|:--------:|
| Typing (bool, list, null)   | ❌  | ✅   | ✅   | ✅   | ✅       |
| Section nesting             | ❌  | ❌   | ✅   | ✅   | ✅       |
| Human-friendly syntax       | ✅  | ❌   | ➖[1]   | ➖[2]  | ✅       |
| Readable multi-line strings | ❌  | ❌   | ✅   | ✅   | ✅       |
| Flexible boolean literals   | ❌  | ❌   | ➖[3]  | ✅   | ✅       |
| Comment support             | ✅  | ❌   | ✅   | ✅   | ✅       |
| Escape sequence support     | ❌  | ✅   | ✅   | ✅   | ✅       |
| Clean, minimal syntax       | ✅  | ❌   | ❌   | ➖[2]   | ✅       |
| Strict vs lenient modes     | ❌  | ❌   | ❌   | ❌   | ✅       |

[1] YAML's syntax can be seen as complex or inconsistent for some users, especially around indentation and implicit typing.  
[2] Some users find TOML's use of `[`, `]`, and `.` visually noisy in deeply nested files.  
[3] YAML's flexible boolean handling can result in unintended type coercion, as behavior varies between parsers.

**Legend:**
- ✅ = Yes / Fully supported
- ❌ = Not supported
- ➖ = Disputed, or partially or inconsistently supported

---

## License

Licensed under the [Apache License 2.0](./LICENSE).

© 2025 Marko K. Seppänen.

---

## Contributions

Feedback, ideas, testing, and discussions are always welcome. 🚀

(Implementation libraries or parsers can follow once the specification stabilizes.)

The specification still needs more testing — especially regarding string concatenation and deeply nested arrays. Further adjustments and refinements may follow in both the spec and grammar.

A TypeScript-based YINI parser is currently in development:
https://github.com/YINI-lang/yini-parser-typescript

### Acknowledgments
Some parts of the YINI specification have benefited from valuable community feedback. See section 15.2, "Acknowledgments", for more details.

---

> _YINI: Clean. Readable. Structured._
