# \~ YINI Specification ≡

**YINI is a simple, minimal, structured, and human-readable configuration format — less verbose than JSON, less complex than YAML, and more expressive than INI.**

---

[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](./LICENSE)
![Status: Release Candidate](https://img.shields.io/badge/status-rc-blueviolet)

**Package Version:** 1.0.0-RC.2 (Latest published release) => [Version Table](./README.md#version-mapping-table)

**Status:** Release Candidate

---

- ➡️ [Getting Started: Intro to YINI Config Format](https://github.com/YINI-lang/YINI-spec/blob/develop/Docs/Intro-to-YINI-Config-Format.md)  
  *Beginner-friendly walkthrough and basic usage examples.*

- ➡️ [YINI Parser on npm](https://www.npmjs.com/package/yini-parser)  
  *Install and view package details.*

- ➡️ [Read the YINI Specification](https://github.com/YINI-lang/YINI-spec/blob/release/YINI-Specification.md#table-of-contents)  
  *Full formal spec for the YINI format, including syntax and features.*

- ➡️ [YINI Parser on GitHub](https://github.com/YINI-lang/yini-parser-typescript)  
  *TypeScript source code, issue tracker, and contributing guide.*

- ➡️ [YINI vs Other Formats](https://github.com/YINI-lang/YINI-spec/tree/release#-summary-difference-with-other-formats)  
  *How does YINI differ: comparison with INI, YAML, and JSON.* (illustrative examples)
  
- ➡️ [Why YINI? (Project Rationale)](https://github.com/YINI-lang/YINI-spec/blob/release/RATIONALE.md)  
  *Learn about the motivations and design decisions behind YINI.*

- ➡️ [YINI Project](https://github.com/YINI-lang)  
  *YINI home.*

---

## 🙋‍♀️ Why YINI?
- **YINI is an alternative** to other great config formats like INI, JSON, YAML, XML, and TOML — designed for clarity, simplicity, minimalism, and straightforward section nesting.
- **Started as a personal project and a research challenge:** Provides structure similar to INI, with features inspired by JSON and YAML.
- **Built for clarity:**
    * Uses minimal, concise syntax, especially for nested sections.
    * Supports commonly used configuration data structures.
    * Flexible commenting styles, and the spec supports both lenient and strict modes (though, enforced by the parser).
- Created out of a practical need for configuration that is **clear, simple, minimal, and flexible**.

---

## 🚀 What is YINI?

**YINI (Yet another INI)** is a minimal and human-readable configuration file format with a formally defined grammar and a specification. It was designed for straightforward configuration, with improvements over classic INI and a simpler structure than YAML, JSON, or TOML.

YINI aims to be clean, consistent, and structured — Intended for both manual and programmatic editing.

> YINI aims to hit a fine balance between human-friendly simplicity and reliable structure — without the noise of JSON or the quirks of YAML.

Inspired by including INI, JSON, Python, and Markdown. YINI keeps things minimal and consistent — with **structured sections**, **multiple comment styles**, and a **formal grammar**.

---

## ✨ YINI CLI and Parser Now Available!

Open-source **YINI parser for Node.js & TypeScript** is available:

- **GitHub:** [yini-parser-typescript](https://github.com/YINI-lang/yini-parser-typescript)
- **npm:** [yini-parser](https://www.npmjs.com/package/yini-parser)
- **npm:** [yini-cli](https://www.npmjs.com/package/yini-cli) (run from CLI/terminal)

You can use this package to parse YINI files in your own projects!

```sh
npm install yini-parser
```

### Quick Code Example
Example in JavaScript/TypeScript:
```js
import YINI from 'yini-parser';

const config = YINI.parse(`
    // This is a comment in YINI
    // YINI is a simple, human-readable configuration file format.

    // Note: In YINI, spaces and tabs don't change meaning - indentation is just
    // for readability.

    /*  This is a block comment

        In YINI, section headers use repeated characters "^" at the start to
        show their level: (Section header names are case-sensitive.)

        ^ SectionLevel1
        ^^ SectionLevel2
        ^^^ SectionLevel3
    */

    ^ Server                        // Definition of section (group) "Server"
      host = 'localhost'
      port = 8080
      useTLS = OFF                  // "false" and "NO" works too

        // Sub-section of "Server"
        ^^ Login
          username = 'user_name'
          password = 'your_password_here'
    
    /END
`);

console.log(config);
```

The above variable `config` now outputs:
```js
// JS object
{
    Server: {
        host: 'localhost',
        port: 8080,
        useTLS: false,
        Login: { 
            username: 'user_name', 
            password: 'your_password_here'
        }
    }
}
```

- ➡️ [Parser usage & documentation](https://github.com/YINI-lang/yini-parser-typescript#usage)

---

## Why YINI?
There are already many configuration formats — INI, JSON, YAML, TOML, XML — each with its strengths and trade-offs. YINI was designed to provide a balanced alternative that combines structure, readability, and simplicity.

> Too often, config formats come with their own trade-offs — INI can be limiting, JSON or TOML more verbose, and YAML has quirks related to whitespace and parsing.

YINI exists because:
- JSON is structured and predictable, but can be verbose (with all keys required to be quoted), strict in structure, and lacks support for comments.
- YAML is powerful but too permissive, error-prone, and has significant whitespace.
- TOML is fine, but sometimes gets too verbose too quickly.
- INI is simple and friendly, but too limited and lacks specification.

YINI was created out of practical necessity: during the development of another project, none of the existing formats felt right. YINI reflects the same spirit as the project that inspired it — structured, flexible, and predictable — yet simple, human-friendly, and clear.

**TL;DR:**
- ✅ **Combines structure and simplicity** — aims to be more expressive than INI, less verbose than JSON, YAML, or TOML. 
- ✅ **Minimal syntax, maximal readability** — strives to prioritize readability and straightforward syntax.

---

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

## Version Mapping Table

| Date     | Package Version | Spec Version | ANTLR4 Lexer | ANTLR4 Parser |
|----------|-----------------|--------------|--------------|---------------|
| 2025 Jul | 1.0.0-RC.1      | 1.0.0-RC.1   | 1.0.0-RC.1   | 1.0.0-RC.1    |
| 2025 Aug | 1.0.0-RC.2      | 1.0.0-RC.1   | 1.0.0-RC.2   | 1.0.0-RC.2    |
| …        | …               | …            | …            | …             |

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

### With Alternative Indentation (YINI)
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

; If preferred, YAML indentation style can be used as well
; — structure is still defined by section markers.
```

💡 In YINI, indentation is only for human readability.

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
^ Service                   // Defines a section named Server.
Enabled = true

    ^^ Cache
    Type = "redis"          // Defines Cache, a sub-section of Server.
    TTL = 3600

        ^^^ Options         // Defines Options, a sub-section of Cache.
        Host = "127.0.0.1"
        Port = 6379

^ Env                       // Defines a section named Env.
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
- **Full-line comments:** Starting with `;`, `//` or `#`

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

YINI seeks to provide a minimal configuration format, inspired by INI, YAML, JSON, and TOML, with a focus on straightforward structure and readability.

### Illustrative Examples

| Feature                  | INI  | JSON | YAML | TOML | YINI |
|--------------------------|:----:|:----:|:----:|:----:|:----:|
| Comments                 | ✔️   | ❌   | ✔️   | ✔️   | ✔️ |
| Nested Sections          | ➖   | ✔️   | ✔️   | ✔️   | ✔️ |
| Formal Grammar           | ❌   | ✔️   | ➖   | ✔️   | ✔️ |
| Minimal Syntax Noise     | ✔️   | ❌   | ➖   | ➖   | ✔️ |
| Human-Focused by Default | ➖   | ❌   | ✔️   | ➖   | ✔️ |

> YINI is for people who want clean, minimal, predictable config files that are easy to work with.

## 📘 Read the Spec

The format is defined by a formal grammar. See [Specification](./YINI-Specification.md) for:
- Syntax and types
- Section nesting
- Escape rules
- Comment behavior
- Strict vs lenient mode
- Validation rules
- And more

But WHY another format, exactly?? [Read the Rationale](./RATIONALE.md) - it covers background, design motivations, and format comparisons.

---

## 📦 Status and Support

- The spec is currently in ***Release Candidate*** stage.
- (Implementation libraries or parsers can follow once the specification stabilizes a bit more.)

### Parsers/Readers
- A TypeScript-based YINI parser:  
https://github.com/YINI-lang/yini-parser-typescript
- YINI parser released on NPM: https://www.npmjs.com/package/yini-parser

| Language | Repo | Notes |
|----------|------|-------|
| C++      | https://github.com/zKiwiko/yini-cpp | Header only YINI parser for C++ |
| Rust     | https://github.com/zKiwiko/yini-rs | YINI parser and writer in Rust, [yini-rs on crates.io](https://crates.io/crates/yini-rs) |

### 🚀 Future
The specification still needs more testing — especially regarding string concatenation and deeply nested arrays. Further adjustments and refinements may follow in both the spec and grammar.

### Acknowledgments
YINI has grown and improved thanks to the insights, questions, and thoughtful feedback from the community. Much of the specification — and this repository — reflects that shared input.

For more details, see section D.2, _“Acknowledgments & Special Thanks”_, in the [Rationale](./RATIONALE.md) document.

## 💬 Feedback
Feedback is welcome — open an Issue or a Discussion.

## 🧾 License

YINI is licensed under the [Apache License 2.0](./LICENSE).

---

> ~ **YINI ≡** - _Aims to be a Clean, Readable, and Structured configuration format_  
> [github.com/YINI-lang](https://github.com/YINI-lang)