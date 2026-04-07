# YINI Specification ≡  

**YINI is a human-readable configuration format designed for clarity, structure, and predictable parsing, with simple syntax and a formal specification and grammar.**

> YINI (by the YINI-lang project) is an INI-inspired format for representing structured information. It is suitable for configuration files, application settings, and general data storage use cases.

---

[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](./LICENSE)
![Status: Release Candidate](https://img.shields.io/badge/status-rc-blueviolet)

**Package Version:** 1.0.0-RC.4 + UPDATES (Latest published release) => [Version Table](./README.md#version-mapping-table)
**Date:** 2026-04
**Status:** Release Candidate

- [YINI Downloads](https://github.com/YINI-lang/YINI-spec/wiki/Get-YINI-Tools)  
- [Latest updates/changes in this package](/CHANGELOG.md)  
- [YINI Homepage](https://yini-lang.org/?utm_source=github&utm_medium=referral&utm_campaign=yini_spec&utm_content=readme)  

---

## 🙋‍♀️ A Quick YINI Example
Below is what YINI syntax looks like:
```yini
^ App
name = "Demo App"
version = "1.0.0"
tags = ["web", "api"]

    ^^ Server
    host = "localhost"
    port = 8080
    settings = { logging: true, mode: "debug" }
```

---

## ℹ️ Why YINI?
Why another format? – Consider the following points:
- **INI** is simple, but too limited for structured configuration.
- **JSON** is predictable, but can be verbose and is comment-free.
- **YAML** is flexible, but can be fragile and indentation-sensitive.
  
- YINI aims to be **clear, structured, and predictable,** while remaining practical and still offering some flexibility.

---

## 🚀 Quick Start
**Try parsing with the CLI (`yini-cli`)**

1. **Install globally (requires Node.js)**  
    Open your terminal and run:
    ```
    npm install -g yini-cli
    ```

2. **Create a YINI file**  
    Save the following to a file called `config.yini`:
    ```yini
    ^ App
      name = "My App Title"
      version = "1.2.3"
      pageSize = 25
      darkTheme = off
    ```

3. **Parse it with the CLI**  
    Run:
    ```bash
    yini parse config.yini
    ```

    You should see a parsed JS object printed to the console, similar to:
    ```js
    {
        App: {
            name: 'My App Title',
            version: '1.2.3',
            pageSize: 25,
            darkTheme: false
        }
    }    
    ```

### Use the Node.js parser in your project

1. **Install the package**  
    ```sh
    npm install yini-parser
    ```

2. **Parse an inline config**  
    ```js
    import YINI from 'yini-parser';

    const config = YINI.parse(`
      ^ Server
        host = 'localhost'
        port = 8080
        useTLS = OFF
    `);

    console.log(config);
    // { Server: { host: 'localhost', port: 8080, useTLS: false } }
    ```

3. **Or parse directly from a file**
    ```js
    import YINI from 'yini-parser';

    const fileConfig = YINI.parseFile('config.yini');
    console.log(fileConfig);
    ```

---

## Why YINI?
There are already many configuration formats — INI, JSON, YAML, TOML, XML — each with its strengths and trade-offs. YINI was designed to provide a balanced alternative that combines structure, readability, and simplicity.

> Too often, config formats come with their own trade-offs — INI can be limiting, JSON or TOML more verbose, and YAML has quirks related to whitespace and parsing.

YINI exists because:
- JSON is structured and predictable, but can be verbose (with all keys required to be quoted), strict in structure, and lacks support for comments.
- YAML is powerful but can be too permissive, error-prone, and sensitive to whitespace.
- TOML is fine, but sometimes gets too verbose too quickly.
- INI is simple and friendly, but too limited and lacks specification.

YINI was created out of practical necessity: during the development of another project, none of the existing formats felt right. YINI reflects the same spirit as the project that inspired it — structured, flexible, and predictable — yet simple, human-friendly, and clear.

**TL;DR:**
- ✅ **Combines structure and simplicity** — aims to be more expressive than INI, less verbose than JSON, YAML, or TOML. 
- ✅ **Minimal syntax, maximal readability** — strives to prioritize readability and straightforward syntax.

---

## ✨ Key Features
YINI aims to prioritize **human readability, clarity, and clean syntax**.

- ✔️ **Simple section-based structure** with clear visual nesting.
- ✔️ **Explicit value syntax** for strings, numbers, booleans, null, lists (AKA arrays), and inline objects.
- ✔️ **Indentation-independent parsing** — without indentation pitfalls.
- ✔️ **Formal grammar and specification.**
- ✔️ **Strict and lenient parsing modes.**
- ✔️ **Multiple comment styles** — C-style commenting rules using `//` and `/* ... */`. Supports `#` and `;` commenting styles too. 
- ✔️ **Minimal syntax noise** — avoids visual noise, easy to write and read.
- ✔️ **Flexible booleans** with `true`/`false`, `on`/`off`, `yes`/`no` (all case-insensitive).
- ✔️ **Common number literals**  — supports decimal, base-prefixed, and exponent notation.
- ✔️ **Human readability first** — Prioritizes clarity over cleverness — yet machine-friendly.
- ✔️ **Flexible strings** using single or double quotes.
- ✔️ **Supports the `null` value type.**

---

## A Bigger Example
In TypeScript/JavaScript:
```ts
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
    
    /END // (only optional)
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
> - In YINI, `:` is not an assignment operator; use `=` for both single values and lists.

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
```yini
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
> - Multiple `^` characters indicate section nesting depth (similar in principle to Markdown-style heading levels).
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
- **Inline comments:** `//` or `#`
- **Block comments:**  `/* multi-line */`
- **Full-line comments:** `;`  
- A line may also contain only an inline comment.

Note: `#` must be followed by a space or tab to be recognized as a comment (to avoid clashes with hex values like `#FF0033`).

## Strings

### Quoted Strings
Strings in YINI must always be enclosed in quotes — either in double quotes (`"`) or in single quotes (`'`) — even in lenient mode.

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

## 🔍 Summary: How YINI Compares to Other Formats

YINI is a minimal, human-friendly **text-based configuration format** inspired by INI, YAML, JSON, and TOML, with a strong focus on clarity, structure, and predictability.

### Feature Comparison

| Feature                          | YINI | INI | JSON | YAML | TOML |
|----------------------------------|:---:|:---:|:----:|:----:|:----:|
| Human-friendly by default        | ✅ | ➖ | ❌ | ✅ | ➖ |
| Readability at scale             | ✅ | ❌ | ❌ | ➖ | ➖ |
| Predictable parsing              | ✅ | ❌ | ✅ | ❌ | ✅ |
| Formal grammar / spec            | ✅ | ❌ | ✅ | ❌ | ✅ |
| Nested sections / hierarchy      | ✅ | ➖ | ✅ | ✅ | ✅ |
| Comments                         | ✅ | ✅ | ❌ | ✅ | ✅ |
| Minimal syntax noise             | ✅ | ✅ | ❌ | ➖ | ➖ |
| Aims to provide clear error reporting | ✅ | ❌ | ✅ | ❌ | ✅ |
| Designed to remain readable as files grow| ✅ | ❌ | ➖ | ❌ | ➖ |
| Designed to work well with tooling and schemas| ✅ | ❌ | ✅ | ➖ | ✅ |
| Supports mixed data & config     | ✅ | ➖ | ✅ | ✅ | ✅ |

> YINI is for people who want clean and predictable configuration files that are easy to work with.

---

## ⬇️ YINI Downloads
- [⬇️ YINI Downloads](https://github.com/YINI-lang/YINI-spec/wiki/Get-YINI-Tools)  
  *This page lists available YINI parsers, tools, and related implementations across different languages and platforms.*

---

## 💬 Feedback
We welcome feedback — feel free to open an Issue or start a Discussion.

### Acknowledgments
YINI has grown and improved thanks to the insights, questions, and thoughtful feedback from the community. Much of the specification — and this repository — reflects that shared input.

For more details, see section D.2, _“Acknowledgments & Special Thanks”_, in the [Rationale](./RATIONALE.md) document.

---

## Version Mapping Table

| Date     | Package Version | Spec Version | ANTLR4 Lexer | ANTLR4 Parser |
|----------|-----------------|--------------|--------------|---------------|
| 2025 Jul | 1.0.0-RC.1      | 1.0.0-RC.1   | 1.0.0-RC.1   | 1.0.0-RC.1    |
| 2025 Aug | 1.0.0-RC.2      | 1.0.0-RC.2   | 1.0.0-RC.2   | 1.0.0-RC.2    |
| 2025 Sep | 1.0.0-RC.3      | 1.0.0-RC.3   | 1.1.0-RC.1   | 1.1.0-RC.1    |
| 2026 Mar | 1.0.0-RC.4      | 1.0.0-RC.4   | 1.2.0-RC.1   | 1.2.0-RC.1    |
| …        | …               | …            | …            | …             |

---

## 🧾 License

YINI is licensed under the [Apache License 2.0](./LICENSE).

---

**^YINI ≡**  
> Designed to be simple, structured, and human-friendly.  
> 
> Readable like INI. Structured like JSON. No indentation surprises.  

[yini-lang.org](https://yini-lang.org/?utm_source=github&utm_medium=referral&utm_campaign=yini_spec&utm_content=readme_footer) · [YINI-lang on GitHub](https://github.com/YINI-lang)  
