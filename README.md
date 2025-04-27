**Version:** v1.0.0 Beta 4

**Status:** Beta Release

**Format Name:** `YINI` (influenced by `INI`, `JSON`, `C`, `Python`...)

---

# YINI Specification

_Yet Another INI — a lightweight configuration file format: clean, readable, structured._

---

## What is YINI?

YINI is a human-friendly configuration file format that blends the simplicity of INI files with the structural clarity of modern data formats.

**Purpose:**
- Make configuration files easy to **read**, **write**, and **understand**.
- Maintain **minimal syntax** without sacrificing **nesting**, **typing**, or **clarity**.
- Provide a format that is simple for **humans** and structured enough for **tools**.

---

## Key Features

- ✅ Clean and minimalistic syntax
- ✅ Typing support: strings, numbers, booleans, nulls, lists
- ✅ Section nesting using intuitive markers (`#`, `~`, `>`)
- ✅ `=` for assignment of values to keys (lists has optional `:` assignment styles)
- ✅ Document terminator (`/END` or `###`) for clear file boundaries
- ✅ Designed for **human readability first**, but machine-friendly
- ✅ Alternative syntax for booleans, including: `true`, `false`, `on`, `off`, `yes`, `no`
- ✅ Strict and lenient parsing modes

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

## Another Example: Lists and Nesting

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
caching = ON

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

---

> _YINI: Clean. Readable. Structured._
