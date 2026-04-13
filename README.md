# YINI Specification ≡  

**YINI is a human-readable configuration format designed for clarity, readability, explicit structure, and predictable parsing. It has a formal specification and a defined grammar.**

> YINI (by the YINI-lang project) is an INI-inspired format for representing structured information. It is intended for configuration files, application settings, and general data storage use cases.

---

[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](./LICENSE)
![Status: Release Candidate](https://img.shields.io/badge/status-rc-blueviolet)

**Package Version:** 1.0.0-RC.5 ([Version Mapping Table](./README.md#version-mapping-table))  
**Date:** 2026-04  
**Status:** Release Candidate  

- [YINI Downloads](https://github.com/YINI-lang/YINI-spec/wiki/Get-YINI-Tools)  
- [Latest updates/changes in this package](/CHANGELOG.md)  
- [YINI Homepage](https://yini-lang.org/?utm_source=github&utm_medium=referral&utm_campaign=yini_spec&utm_content=readme)  

---

## 🙋‍♀️ A Quick YINI Example
Here is a small example of YINI syntax:
```yini
^ App
name    = "Demo App"
version = "1.0.0"
list    = ["web", "api"]
isDebug = On  // true/yes works too

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

## 🚀 Quick Start

You can try YINI with the CLI (`yini-cli`) by parsing a small configuration file.

### Option 1: Run with `npx` (no global install)
1. **Create a YINI file**  
    Save the following to a file called `config.yini`:
    ```yini
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
1. **Install the CLI globally**  (requres Node.js)
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
- ✔️ YINI is designed to be simple, but not simplistic, with explicit structure and deterministic parsing.
- ✔️ **Explicit value syntax** for strings, numbers, booleans, null, lists (AKA arrays), and inline objects.
- ✔️ **Indentation-independent parsing** — without indentation pitfalls.
- ✔️ **Formal specification and grammar.**
- ✔️ **Strict and lenient parsing modes.**
- ✔️ **Multiple comment styles** — C-style commenting rules using `//` and `/* ... */`. Supports `#` and `;` commenting styles too. 
- ✔️ **Minimal syntax noise** — with explicit assignments and section-based nesting.
- ✔️ **Flexible booleans** with `true`/`false`, `on`/`off`, `yes`/`no` (all case-insensitive).
- ✔️ **Common number literals**  — supports decimal, base-prefixed, and exponent notation.
- ✔️ **Designed to prefer explicit and readable syntax** over compact or implicit forms.
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
    
    /END                            // Optional document terminator.
`);

console.log(config);
```

The resulting value o `config` is:
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

; Structure is expressed by section markers rather than indentation.
```

💡 Notes:
> - Indentation in YINI is purely for human readability.
> - In YINI, `^` defines section headers.
> - `//` is used for inline comments (`#` (followed by space or tab) works too for inline comments).
> - `;` can be used for full line comments (`//` and `#` can be used too).
> - All strings must be enclosed in quotes (`'` or `"`).
> - Keys and values are separated by (`=`).
> - Typed scalar and composite values with explicit syntax.
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
> - Section depth is expressed directly by repeated section markers.
> - Unlike TOML, YINI **does not** use dot `.` notation in sections.

---

## Section Nesting
Section nesting is expressed by repeating the section marker character. For example, `^` indicates a top-level section, `^^` indicates a nested section, and `^^^` indicates a deeper nested section.

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
YINI defines four string literal forms: Raw, Classic, Hyper, and Triple-quoted. These forms differ in how they handle escape sequences, whitespace normalization, and multi-line content.

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

YINI is a text-based configuration format inspired by INI, JSON, Python, and YAML. It is designed to emphasize clarity, readability, explicit structure, and predictable parsing.

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

For more details, see section D.2, _“Acknowledgments & Special Thanks”_, in the [Rationale](./RATIONALE.md) document.

---

## Version Mapping Table

| Date     | Package Version | Spec Version | ANTLR4 Lexer | ANTLR4 Parser |
|----------|-----------------|--------------|--------------|---------------|
| 2025 Jul | 1.0.0-RC.1      | 1.0.0-RC.1   | 1.0.0-RC.1   | 1.0.0-RC.1    |
| 2025 Aug | 1.0.0-RC.2      | 1.0.0-RC.2   | 1.0.0-RC.2   | 1.0.0-RC.2    |
| 2025 Sep | 1.0.0-RC.3      | 1.0.0-RC.3   | 1.1.0-RC.1   | 1.1.0-RC.1    |
| 2026 Mar | 1.0.0-RC.4      | 1.0.0-RC.4   | 1.2.0-RC.1   | 1.2.0-RC.1    |
| 2026 Apr | 1.0.0-RC.5      | 1.0.0-RC.5   | 1.2.0-RC.2   | 1.2.0-RC.2    |
| …        | …               | …            | …            | …             |

---

## 🧾 License

YINI is licensed under the [Apache License 2.0](./LICENSE).

---

**^YINI ≡**  
> YINI is a human-readable configuration format designed for clarity, readability, explicit structure, and predictable parsing.
> 
> It has a formal specification and a defined grammar.

[yini-lang.org](https://yini-lang.org/?utm_source=github&utm_medium=referral&utm_campaign=yini_spec&utm_content=readme_footer) · [YINI-lang on GitHub](https://github.com/YINI-lang)  
