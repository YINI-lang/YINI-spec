# \~ YINI Specification ≡

**YINI is a lightweight, human-friendly configuration format — simpler than YAML, and more expressive than INI.**

---
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](./LICENSE)
![Status: Beta](https://img.shields.io/badge/status-beta-yellow)

**Version:** v1.0.0 Beta 6 (Latest published release)

**Status:** Beta Release

---

- ➡️ [Read the YINI Specification](./YINI-Specification.md)

---

## 🚀 What is YINI?

**YINI (Yet another INI)** is a minimal and human-readable configuration file format with a formally defined grammar and a specification. It was designed for clarity and simplicity, offering features that improve on classic INI while avoiding the complexity of formats like YAML - yet being less noisy than JSON and TOML.

YINI is clean, consistent, and structured — easy for humans to write and machines to parse.

> YINI aims to hit the sweet spot between human-friendly simplicity and reliable structure — without the noise of JSON or the quirks of YAML.

Inspired by including INI, JSON, Python, and Markdown. YINI keeps things minimal and consistent — with **structured sections**, **multiple comment styles**, and a **formal grammar**.

## 🔥 Why YINI
There are already many configuration formats — INI, JSON, YAML, TOML — but none hit the sweet spot of balance YINI was aiming for.

> Too often, config formats are either too limiting (like INI), too verbose (like JSON or TOML), or too quirky (like YAML).

YINI exists because:
- JSON is structured and predictable, but too verbose and strict (and lacks comments 😤).
- YAML is powerful but too permissive, error-prone, and has significant whitespace.
- TOML is fine, but sometimes gets too verbose too quickly.
- INI is simple and friendly, but too limited and lacks specification.

YINI was created out of practical necessity: during the development of another project, none of the existing formats felt right. YINI reflects the same spirit as the project that inspired it — structured, flexible, and predictable — yet simple, human-friendly, and clear.

**TL;DR:**
- ✅ **Combines structure and simplicity** — more expressive than INI, less verbose than JSON, YAML, or TOML. 
- ✅ **Minimal syntax, maximal readability** — aiming for clarity over cleverness.

## ✨ Key Features
YINI aims to prioritize **human readability, clarity, and clean syntax**.

- ✔️ **Clean and minimalistic syntax** — avoids visual noise, easy to write and read.
- ✔️ **Typing support** for: Strings, Numbers, Booleans, Lists (Arrays), and Nulls.
- ✔️ **Easy section nesting** Markdown-style section levels: `^`, `^^`, `^^^` ...
- ✔️ **Indentation-independent structure** — no indentation pitfalls.
- ✔️ **Flexible Commenting styles** — C-style commenting rules using `//` and `/* ... */`. Supports `#` and `;` commenting styles too. 
- ✔️ **Flexible Literals:**
  * Including booleans: `true`, `false`, `on`, `off`, `yes`, `no` (all case-insensitive).
  * Numeric notations with base and exponent support.
- ✔️ **Human readability first** — prioritizes clarity over cleverness — yet machine-friendly.

### Additional Features
Definitions for rules in strict-mode (lenient is default).
- Formal grammar for reliable parsing.
- **Strict and lenient parsing modes** — suitable for both tooling and hand-edited configs. Read more in 11.3.1 in the specification, "Table: Lenient vs. Strict Mode".
- Explicit string quoting — no ambiguity over strings.
- **Optional document terminator** `/END` for clear file boundaries and parser certainty in **strict-mode**.
- **Enhanced robustness** in strict-mode — if you cut a YINI file into two halves, both halves will be rendered invalid by the rules.

 ---

## 🧠 Quick Examples

### Before (YAML)
```
server:
    connection:
        host: "localhost"
        port: 8080  # Dev port
    auth:
        enabled: true
        credentials:
            username: "admin"
            password: "secret"  # Change me!

# Like Python, structure relies entirely on indentation — easy to misread or misplace.
```

### After (YINI)
```yini
^ server

    ^^ connection
    host = 'localhost'
    port = 8080  // Dev port

    ^^ auth
    enabled = true

        ^^^ credentials
        username = 'admin'
        password = 'secret'  // Change me!

; Clear structure with visual nesting — still easy to read and follow.
```

💡 Notes:
> - Indentation in YINI is purely for human readability.
> - In YINI, `^` defines section headers.
> - `//` is used for inline comments (`#` (followed by space or tab) works too for inline comments).
> - `;` can be used for full line comments (`//` and `#` can be used too).
> - All strings must be enclosed in quotes (`'` or `"`).
> - Natural, readable keys and values separated by (`=`).
> - Strong typing without heavy syntax.

---

### Before (TOML)
```toml
[Service]               # Defines a section named Server.
Enabled = true

[Service.Cache]         # Defines Cache, a sub-section of Server.
Type = "redis"
TTL = 3600

[Service.Cache.Options] # Defines Options, a sub-section of Cache.
Host = "127.0.0.1"
Port = 6379

[Env]                   # Defines a section named Env.
code = "dev"
```

### After (YINI)
```js
^ Service               // Defines a section named Server.
Enabled = true

    ^^ Cache
    Type = "redis"          // Defines Cache, a sub-section of Server.
    TTL = 3600

        ^^^ Options             // Defines Options, a sub-section of Cache.
        Host = "127.0.0.1"
        Port = 6379

^ Env                   // Defines a section named Env.
code = "dev"
```

💡 Notes:
> - Using multiple `^` to indicate section nesting depth (Markdown-style section levels).
> - **One** `^` = top-level section.
> - **Two** `^^` = nested section under previous.
> - **Three** `^^^` = sub-subsection.
> - This structure is visually clear and easy to parse — especially for both humans and machines.
> - Unlike TOML, YINI **does not** use dot `.` notation in sections.

---

## Section Nesting
Nesting sections can be done easily by adding one extra section marker (e.g. `^^`).

## Comments
YINI supports **three types of comments**:
- **Inline comments:** `//` (or commenting using `#`)
- **Block comments:**  `/* multi-line */`
- **Full-line comments:** Starting with `;`, `//` or `#`,

Note: `#` must be followed by a space or tab to be recognized as a comment (to avoid clashes with hex values like `#FF0033`).

## Strings

### Quoted Strings
Strings in YINI must always be enclosed in quotes — either in double quotes (`"`) or in single quotes (`'`).

**Note:** If a value is not quoted, it is not treated as a string — no exceptions. (No ambiguity over strings or keywords.)

### String Literals in YINI
YINI has four types of string literals — Raw, Classic, Hyper, and Triple-quoted — each designed to help express text clearly and appropriately in different situations, whether for escape handling, whitespace normalization, or multi-line content.

💡 **Note:** YINI primarily follows C-style commenting rules using `//` and `/* ... */`. However, alternative commenting styles `;` and `#` are also supported. 
```yini
# Raw strings are the default. No prefix is needed, but an optional R prefix
# may be used for clarity. Escape sequences are not interpreted.
String = "D:\folder\file"

// Classic strings (C-Strings) are prefixed with C or c — they support
// escape sequences.
ClassicString = C"Hello\nWorld\n"

; Hyper strings (H-Strings) are prefixed with H or h — they behave
; similarly to HTML text: whitespace is normalized and edges are trimmed.
HyperString = H"
  This is a hyper string spanning multiple lines,
  with trimmed edges and normalized whitespace.
"

/* Triple-quoted strings can span multiple lines and
   preserve all characters as-is, including tabs and newlines.
 */
TripleQuotedString = """
This is a triple-quoted
string literal — characters
are preserved exactly, without escapes.
"""
```

---

## 🔍 Summary: Difference with Other Formats

YINI aims to be minimal like INI, cleaner than YAML, and less noisy than JSON — while offering more clarity than TOML.

| Feature                  | INI  | JSON | YAML | TOML | YINI |
|--------------------------|:----:|:----:|:----:|:----:|:----:|
| Comments                 | ✔️   | ❌   | ✔️   | ✔️   | ✔️ |
| Nested Sections          | ➖   | ✔️   | ✔️   | ✔️   | ✔️ |
| Formal Grammar           | ❌   | ✔️   | ➖   | ✔️   | ✔️ |
| Minimal Syntax Noise     | ✔️   | ❌   | ➖   | ➖   | ✔️ |
| Human-Focused by Default | ➖   | ❌   | ✔️   | ➖   | ✔️ |

> YINI is for people who want clean, minimal, predictable config files that don’t fight back.

## 📘 Read the Spec

The format is defined by a formal grammar. See [Specification](./YINI-Specification.md) for:
- syntax and types
- section nesting
- escape rules
- comment behavior
- strict vs lenient mode
- validation rules
- and more

But WHY another format, exactly?? [Read the Rationale](./RATIONALE.md) - it covers background, design motivations, and format comparisons.

---

## 📦 Status and Roadmap

- Currently in ***Beta stage***.
- (Implementation libraries or parsers can follow once the specification stabilizes a bit more.)
- A TypeScript-based YINI parser is about to start development:
https://github.com/YINI-lang/yini-parser-typescript
- Feedback welcome 💬 — open a Discussion or an Issue.

### 🚀 Future
The specification still needs more testing — especially regarding string concatenation and deeply nested arrays. Further adjustments and refinements may follow in both the spec and grammar.

### Acknowledgments
YINI has grown and improved thanks to the insights, questions, and thoughtful feedback from the community. Much of the specification — and this repository — reflects that shared input.

For more details, see section D.2, _“Acknowledgments & Special Thanks”_, in the [Rationale](./Docs/RATIONALE.md) document.

## 🧾 License

YINI is licensed under the [Apache License 2.0](./LICENSE).

---

> ~ **YINI ≡** - _A Clean, Readable, and Structured configuration format_  
> [https://yini-lang.org](https://yini-lang.org)