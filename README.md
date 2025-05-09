**Version:** v1.0.0 Beta 4 (Latest published release)

**Status:** Beta Release

**Format Name:** `YINI` (influenced by `INI`, `JSON`, `C`, `Python`...)

---

# YINI Specification

_Yet another INI — a lightweight configuration file format: clean, readable, structured._

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

- ✅ **Clean and minimalistic syntax** — easy to write and read.
- ✅ **Typing support** for: Strings, Numbers, Booleans, Lists (Arrays), and Nulls.
- ✅ **Combines structure and simplicity** — more expressive than INI, less verbose than JSON, YAML, or TOML.
- ✅ **True section nesting** using intuitive markers (`#`, `~`, or `>`).
- ✅ **Indentation-independent structure** — no indentation pitfalls.
- ✅ **Explicit document terminator** (`/END` or `###`) for clear file boundaries and parser certainty.
- ✅ **Human readability first**, yet machine-friendly.
- ✅ **Flexible Boolean literals**, including: `true`, `false`, `on`, `off`, `yes`, `no` (case-insensitive).
- ✅ **Strict and lenient parsing modes** — suitable for both tooling and hand-edited configs.
- ✅ `=` for standard assignment, with optional `:` syntax for list-style values (colon-based lists).

---

## Quick Example

### Before (Traditional INI or ad-hoc config)
```ini
[Server]                # Defines a section named Server.
host = localhost
port = 8080

[Features]              # Defines a section named Features.
login = true
notifications = false
```

### After (YINI)
```c
# Server                // Defines a section named Server.
host = "localhost"
port = 8080

# Features              // Defines a section named Features.
login = true
notifications = false

/END
```

Notice:
- In YINI, (`#`) is used to define sections.
- Line-comment can be added using (`//`).
- In YINI, all strings must be enclosed in quotes.
- Natural, readable keys and values separated by (`=`).
- Strong typing without heavy syntax.
- Explicit, clean termination (`/END`).

---

## YINI Syntax
### Quoted Strings
Strings in YINI must always be enclosed in quotes — either in double quotes (`"`) or in single quotes (`'`).

**Note:** If a string is not quoted, it's not a string — period.

### Lists
To declare a list, after the `=` character, square brackets `[ ]` is used. Each item is separated by a comma.

There is also an alternative list notation using `:`, which omits brackets. Items are comma-separated and may appear either inline or on separate lines.

### Section Nesting
Nesting sections can be done easily by adding one extra section marker (e.g. `##`) — for example, in the example below, the section `Advanced` is a sub-section of the section `Features`.

### Alternative Boolean Literals
Booleans uses flexible literals — for example, in the example below, `True`, `YES`, and `ON` (case-insensitive) all mean `true`.

## Example: List, Nesting & Alternative Booleans Literals

 Like here below, using single quotes:

```c
# AppInfo
name = 'MyApp'          // String.
version = 1.2           // Number (real).

# Features
features = ['login', 'sync', 'offline']     // List with 3 items.

## Advanced             // Defines a sub-section of Features.
timeout = 9000          // Number (integer).
caching = True          // Boolean.
isLogging = YES         // Boolean (alternative keyword).
debugging = ON          // Boolean (alternative keyword).

/END                    // The explicit doc. terminator.
```

---

## Example: Flexible String Literals
YINI has four types of string literals — raw, classic, hyper, and triple-quoted — each designed to help express text clearly and appropriately in different situations, whether for escape handling, whitespace normalization, or multi-line content.

```c
// Basic strings (R-Strings) are raw by default — no escape sequences are interpreted.
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

/END
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
| Light typing | Safer and more powerful than plain INI |
| Simple nesting | Clear structure without complex indentation |
| Human-first | Designed for configuration, not data exchange |
| Predictable parsing | Strict or lenient modes available |

---

## License

Licensed under the [Apache License 2.0](./LICENSE).

© 2025 Marko K. Seppänen.

---

## Contributions

Feedback, ideas, testing, and discussions are always welcome. 🚀

(Implementation libraries or parsers can follow once the specification stabilizes.)

Specification needs still more testing, especially in parts like in string concat. and array nesting (where fixes and a few more additions may follow in specification and grammar).

A TypeScript-based YINI parser is currently in development:
https://github.com/YINI-lang/yini-parser-typescript

---

> _YINI: Clean. Readable. Structured._
