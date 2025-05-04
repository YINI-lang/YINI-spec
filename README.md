**Version:** v1.0.0 Beta 4 (Latest published release)

**Status:** Beta Release

**Format Name:** `YINI` (influenced by `INI`, `JSON`, `C`, `Python`...)

---

# YINI Specification

_Yet another INI — a lightweight configuration file format: clean, readable, structured._

---

## What is YINI?

YINI is a human-friendly configuration file format — designed as an alternative to INI — blending its simplicity with the structural clarity of modern data formats.

> YINI aims to hit the sweet spot between human-friendly simplicity and reliable structure — without the noise of JSON or the quirks of YAML.

**Purpose:**
- Make configuration files easy to **read**, **write**, and **understand**.
- Maintain **minimal syntax** without sacrificing **nesting**, **typing**, or **clarity**.
- Provide a format that is simple for **humans** and structured enough for **tools**.

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
[server]
host=localhost
port=8080

[features]
login=true
notifications=false
```

### After (YINI)
```yini
# Server
host = "localhost"
port = 8080

# Features
login = true
notifications = false

/END
```

Notice:
- Natural, readable keys and values.
- Strong typing without heavy syntax.
- Sections are intuitive with simple markers.
- Explicit, clean termination.

---

## Example: Lists, Nesting, and Booleans

```yini
# AppInfo
name = "MyApp"
version = 1.2

# Features
features = ["login", "sync", "offline"]

# Server
host = "localhost"
port = 8080

## Advanced
caching = true

/END
```

---

## Example: Using Different String Types

```yini
String = "D:\folder\file"  // No escapes needed.

ClassicString = C"Hello\nWorld"  // Supports escape sequences.

HyperString = H"
  This is a hyper string spanning multiple lines,
  trims edges and normalizes whitespaces.
"

TripleQuotedString = """
This is a literal,
triple-quoted string
without escapes.
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

Feedback, ideas, and discussions are always welcome. 🚀

(Implementation libraries or parsers can follow once the specification stabilizes.)

A TypeScript-based YINI parser is currently in development:
here https://github.com/YINI-lang/yini-parser-typescript

---

> _YINI: Clean. Readable. Structured._
