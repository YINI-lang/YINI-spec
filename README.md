# YINI Specification ≡  

**YINI is a human-readable configuration format designed for clarity, readability, explicit structure, and predictable parsing. It has a formal specification and a defined grammar.**

> YINI (by the YINI-lang project) is an INI-inspired format for representing structured information. It is intended for configuration files, application settings, and general data storage use cases.

---

[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](./LICENSE)
![Status: Release Candidate](https://img.shields.io/badge/status-rc-blueviolet)

**Specification Package Version:** 1.0.0-RC.6 ([Version Mapping Table](./README.md#version-mapping-table))  
**Date:** 2026-05-30  
**Status:** Release Candidate  

- [YINI Downloads](https://github.com/YINI-lang/YINI-spec/wiki/Get-YINI-Tools)  
- [Latest updates/changes in this package](/CHANGELOG.md)  
- [YINI Homepage](https://yini-lang.org/?utm_source=github&utm_medium=referral&utm_campaign=yini_spec&utm_content=readme)  

---

## 🙋‍♀️ A Quick YINI Example
Here is a small lenient-mode (default) example of YINI syntax:
```ini
^ App
name    = "Demo App"
version = "1.0.0"
list    = ["web", "api"]
isDebug = On  // true/yes also mean true.

    ^^ Server
    host   = "localhost"
    port   = 8080
    object = { logging: true, mode: "debug" }
```

---

## ℹ️ Why YINI?

There are already many established configuration formats, each with different trade-offs.

- **[INI](https://en.wikipedia.org/wiki/INI_file)** is simple, but limited for structured configuration and lacks a single widely adopted formal specification.
- **[JSON](https://en.wikipedia.org/wiki/JSON)** is predictable, but can be verbose and does not support comments.
- **[YAML](https://en.wikipedia.org/wiki/YAML)** is flexible, but can be indentation-sensitive and less predictable to parse.
- **TOML** is well-defined, but may become verbose in larger nested files.
- **XML** is expressive and strongly structured, but often introduces more syntax overhead than needed for human-edited configuration.

YINI is intended as a configuration format that emphasizes clarity, readability, explicit structure, and predictable parsing. It is designed to be simple, but not simplistic, and to remain usable in both small and larger configuration files.

**Summary:**
- YINI is intended to provide more structure than traditional INI-style files.
- YINI is designed to prioritize clarity, readability, and predictable parsing.

---

## Design Goals

YINI is designed around a small set of core goals:

1. **Clarity over cleverness** — prefer syntax that is easy to understand correctly.
2. **Readability without sacrificing structure** — remain easy to read while still supporting structured configuration.
3. **Simplicity with serious usability** — keep the format simple, but not simplistic.
4. **Predictability over magic** — favor explicit and stable interpretation rules.
5. **Explicitness over hidden behavior** — make structure and meaning visible in the file itself.
6. **Structure without visual clutter** — support hierarchy without relying on indentation semantics.
7. **Human-friendly, parser-friendly** — support direct editing by humans and consistent parsing by tools.

---

## 🚀 Quick Start

You can try YINI with the CLI (`yini-cli`) by parsing a small configuration file.

### Option 1: Run with `npx` (no global install)
1. **Create a YINI file**  
    Save the following to a file called `config.yini`:
    ```ini
    ^ App
    name = "My App Title"
    version = "1.2.3"
    pageSize = 25
    darkTheme = off
    ```
2. **Parse it with `npx`**
    Run:
    ```bash
    npx yini-cli parse config.yini
    ```

### Option 2: Install globally
1. **Install the CLI globally**  (requires Node.js)
    ```bash
    npm install -g yini-cli
    ```

2. **Parse the file**  
    ```bash
    yini parse config.yini
    ```

### Result
You should see JSON output printed to the console, similar to:
```json
{
    "App": {
        "name": "My App Title",
        "version": "1.2.3",
        "pageSize": 25,
        "darkTheme": false
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

    console.log(config.Server.host); // localhost
    console.log(config); // { Server: { host: 'localhost', port: 8080, useTLS: false } }
    ```

3. **Or parse directly from a file**
    ```js
    import YINI from 'yini-parser';

    const fileConfig = YINI.parseFile('config.yini');
    
    console.log(fileConfig);
    ```

---

## ✨ Key Features
YINI is designed to prioritize **readability, clarity, and explicit structure**.

- ✔️ **Simple section-based structure** with clear visual nesting.
- ✔️ YINI is designed to be simple, but not simplistic, with explicit structure and deterministic (predictable and consistent) parsing.
- ✔️ **Explicit value syntax** for strings, numbers, booleans, null, lists (AKA arrays), and inline objects.
- ✔️ **Indentation-independent parsing** — without indentation pitfalls.
- ✔️ **Formal specification and grammar.**
- ✔️ **Lenient and strict parsing modes** — lenient mode is the default, strict mode enables stronger validation.
- ✔️ **Multiple comment styles** — C-style commenting rules using `//` and `/* ... */`. Supports `#` and `;` commenting styles too. 
- ✔️ **Minimal syntax noise** — with explicit assignments and section-based nesting.
- ✔️ **Flexible booleans** with `true`/`false`, `on`/`off`, `yes`/`no` (all case-insensitive).
- ✔️ **Common number literals**  — supports decimal, base-prefixed, and exponent notation.
- ✔️ **Designed to prefer explicit and readable syntax** over compact or implicit forms.
- ✔️ **Flexible strings** using single quotes, double quotes, Classic escaped strings, and Triple-Quoted Strings.
- ✔️ **Supports the `null` value type.**
- ✔️ **Explicit string concatenation** using `+`; concatenation expressions must begin with a string literal.
- ✔️ **Optional mode declarations** — `@yini strict` and `@yini lenient` state which mode the file is intended for. They do not switch the parser mode by themselves; the parser or tool chooses the actual mode.

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
      useTLS = OFF                  // "false" and "NO" work too

        // Sub-section of "Server"
        ^^ Login
          username = 'user_name'
          password = 'your_password_here'
    
    /END  // Optional in lenient mode; required in strict mode.
`);

console.log(config);
```

The resulting value of `config` is:
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

- [Parser usage & documentation](https://github.com/YINI-lang/yini-parser-typescript#usage)

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
```ini
^ server

    ^^ connection
    host = 'localhost'
    port = 8080  // Dev port

    ^^ auth
    enabled = true

        ^^^ credentials
        username = 'admin'
        password = 'secret'  // Change me!

; Structure is expressed by section markers rather than indentation.
```

💡 Notes:
> - Indentation in YINI is purely for human readability.
> - In YINI, `^` defines section headers.
> - `//` and `#` are used for inline comments. Outside string literals, `#` always begins a comment; no whitespace is required.
> - `;` can be used for full-line comments (`//` and `#` can be used too).
> - All strings must be enclosed in quotes (`'` or `"`).
> - Keys and values are separated by `=`.
> - Typed scalar and compound values use explicit syntax.
> - In YINI, `:` is not an assignment operator; use `=` for root-level and section-level members.

### With Alternative Indentation (YINI)
```ini
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
[Service]               # Defines a section named Service.
Enabled = true

[Service.Cache]         # Defines Cache, a sub-section of Service.
Type = "redis"
TTL = 3600

[Service.Cache.Options] # Defines Options, a sub-section of Cache.
Host = "127.0.0.1"
Port = 6379

[Env]                   # Defines a section named Env.
code = "dev"
```

### After (YINI)
```ini
^ Service                   // Defines a section named Service.
Enabled = true

    ^^ Cache
    Type = "redis"          // Defines Cache, a sub-section of Service.
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
> - Section depth is expressed directly by repeated section markers.
> - Unlike TOML, YINI **does not** use dot `.` notation in sections.

---

## Section Nesting
Section nesting is expressed by repeating the section marker character. For example, `^` indicates a top-level section, `^^` indicates a nested section, and `^^^` indicates a deeper nested section.

## Comments
YINI supports several comment styles:
- **Inline comments:** `//` or `#`
- **Block comments:**  `/* multi-line */`
- **Full-line comments:** `;`  
- A line may also contain only an inline comment.

Note: Outside string literals, `#` always begins a comment. Hexadecimal values use `0x...` or `hex:...`; `#FF0033` is treated as a comment, not a hex value.

```ini
key1 = "value" // Inline comment.
key2 = "value" # Also an inline comment.
# Full-line hash comment.
; Full-line semicolon comment.

/*
  Block comment.
*/
```

## Strings

### Quoted Strings
Strings in YINI must always be enclosed in quotes — either in double quotes (`"`) or in single quotes (`'`) — even in lenient mode.

**Note:** If a value is not quoted, it is not treated as a string — no exceptions. (No ambiguity over strings or keywords.)

### String Literals in YINI
YINI defines four main string literal forms: Raw Strings, Classic Strings, Raw Triple-Quoted Strings, and C-Triple-Quoted Strings.  

These forms differ in how they handle escape sequences and multi-line content.

💡 **Note:** YINI primarily follows C-style commenting rules using `//` and `/* ... */`. However, alternative commenting styles `;` and `#` are also supported. 
```ini
# Raw strings are the default. No prefix is needed, but an optional R prefix
# may be used for clarity. Escape sequences are not interpreted.
String = "D:\folder\file"

// Classic strings (C-Strings) are prefixed with C or c — they support
// escape sequences.
ClassicString = C"Hello\nWorld\n"

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

### String Concatenation

YINI supports explicit string concatenation with `+`. A concatenation expression must begin with a string literal.

```ini
label = "port-" + 5432   // Valid in lenient mode: "port-5432"
bad   = 5432 + "-port"   // Invalid: must begin with a string literal.
```

In strict mode, all concatenation operands must be string literals.

---

## 🔍 Summary: How YINI Compares to Other Formats

YINI is a text-based configuration format inspired by INI, JSON, Python, and YAML. It is designed to emphasize clarity, readability, explicit structure, and predictable parsing.

### Feature Comparison

| Feature                          | YINI | INI | JSON | YAML | TOML |
|----------------------------------|:---:|:---:|:----:|:----:|:----:|
| Human-friendly by default        | ✅ | ➖ | ❌ | ✅ | ➖ |
| Readability at scale             | ✅ | ❌ | ❌ | ➖ | ➖ |
| Predictable parsing              | ✅ | ❌ | ✅ | ➖ | ✅ |
| Formal grammar / spec            | ✅ | ❌ | ✅ | ✅ | ✅ |
| Nested sections / hierarchy      | ✅ | ➖ | ✅ | ✅ | ✅ |
| Comments                         | ✅ | ✅ | ❌ | ✅ | ✅ |
| Minimal syntax noise             | ✅ | ✅ | ❌ | ➖ | ➖ |
| Aims to provide clear error reporting | ✅ | ❌ | ✅ | ❌ | ✅ |
| Designed to remain readable as files grow| ✅ | ❌ | ➖ | ❌ | ➖ |
| Designed to work well with tooling and schemas| ✅ | ❌ | ✅ | ➖ | ✅ |
| Supports mixed data & config     | ✅ | ➖ | ✅ | ✅ | ✅ |

> This table is a simplified comparison intended to highlight common characteristics. Exact behavior depends on the specific parser or implementation.
> YINI is intended for configuration files where readability, structure, and predictable parsing are important.

---

## ⬇️ YINI Downloads
- [⬇️ YINI Downloads](https://github.com/YINI-lang/YINI-spec/wiki/Get-YINI-Tools)  
  *This page lists available YINI parsers, tools, and related implementations across different languages and platforms.*

---

## 💬 Feedback
We welcome feedback — feel free to open an Issue or start a Discussion.

### Acknowledgments
YINI has grown and improved thanks to the insights, questions, and thoughtful feedback from the community. Much of the specification — and this repository — reflects that shared input.

For more details, see section D.2, _"Acknowledgments & Special Thanks"_, in the [Rationale](./RATIONALE.md) document.

---

## Version Mapping Table

| Date     | Specification Package Version | Spec Version | ANTLR4 Lexer | ANTLR4 Parser |
|----------|-----------------|--------------|--------------|---------------|
| 2025 Jul | 1.0.0-RC.1      | 1.0.0-RC.1   | 1.0.0-RC.1   | 1.0.0-RC.1    |
| 2025 Aug | 1.0.0-RC.2      | 1.0.0-RC.2   | 1.0.0-RC.2   | 1.0.0-RC.2    |
| 2025 Sep | 1.0.0-RC.3      | 1.0.0-RC.3   | 1.1.0-RC.1   | 1.1.0-RC.1    |
| 2026 Mar | 1.0.0-RC.4      | 1.0.0-RC.4   | 1.2.0-RC.1   | 1.2.0-RC.1    |
| 2026 Apr | 1.0.0-RC.5      | 1.0.0-RC.5   | 1.2.0-RC.2   | 1.2.0-RC.2    |
| 2026 May | 1.0.0-RC.6      | 1.0.0-RC.6   | 1.3.0-RC.1   | 1.3.0-RC.1    |
| …        | …               | …            | …            | …             |

---

## License

This project is licensed under the Apache License 2.0 — see the [LICENSE](./LICENSE) file for details.

---

**^YINI ≡**  
> YINI is a human-readable, INI-inspired, indentation-insensitive configuration format with clear nested sections, explicit structure, and predictable parsing.
> 
> It has a formal specification and a defined grammar.

[yini-lang.org](https://yini-lang.org/?utm_source=github&utm_medium=referral&utm_campaign=yini_spec&utm_content=readme_footer) · [YINI-lang on GitHub](https://github.com/YINI-lang)  
