# YINI Specification ≡  

**YINI is a text-based configuration format with clear section nesting and predictable parsing. It has a formal specification and grammar.**

> Inspired by INI, YINI groups related settings into sections and supports strings, numbers, booleans, lists, and objects. Use it for configuration files, application settings, and other structured data.

---

[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](./LICENSE)
![Status: Release Candidate](https://img.shields.io/badge/status-rc-blueviolet)

**Specification Package Version:** 1.0.0-RC.7x/RC.8-WIP ([Version Mapping Table](./README.md#version-mapping-table))  
**Date:** 2026-11-14  
**Status:** Release Candidate  

- [YINI Downloads](https://github.com/YINI-lang/YINI-spec/wiki/Get-YINI-Tools)  
- [Latest updates/changes in this package](/CHANGELOG.md)  
- [YINI Homepage](https://yini-lang.org/?utm_source=github&utm_campaign=yini_spec&utm_content=readme&utm_medium=referral)  

---

## Specification and Repository Guide

- [YINI Specification](./YINI-Specification.md) — syntax, data model, and validation rules.
- [ANTLR4 Grammar](./Grammar-ANTLR4/) — lexer and parser grammars for implementers.
- [Example configuration](./config-example.yini) — a commented application configuration to copy and adapt.
- [YINI Examples](./Examples/README.md) — lenient and strict examples, with selected expected JSON outputs.

If the specification and grammar disagree, follow the specification. A parser must also check the specification's validation rules; matching the grammar alone is not enough.

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

For a complete application configuration, copy [config-example.yini](./config-example.yini) to `config.yini` and adapt the settings to your application.

---

## ℹ️ Why YINI?

There are already many established configuration formats, each with different trade-offs.

- **[INI](https://en.wikipedia.org/wiki/INI_file)** is simple, but limited for structured configuration and lacks a single widely adopted formal specification.
- **[JSON](https://en.wikipedia.org/wiki/JSON)** is predictable, but can be verbose and does not support comments.
- **[YAML](https://en.wikipedia.org/wiki/YAML)** supports several ways to write data, including block structures where indentation determines nesting.
- **TOML** is well-defined, but may become verbose in larger nested files.
- **XML** is expressive and strongly structured, but often introduces more syntax overhead than needed for human-edited configuration.

YINI uses section markers to show nesting and explicit syntax for each value type. The aim is to keep both small and large configuration files easy to read and edit.

**Summary:**
- YINI is intended to provide more structure than traditional INI-style files.
- YINI is designed to prioritize clarity, readability, and predictable parsing.

---

## Design Goals

YINI is designed around a small set of core goals:

1. **Clarity over cleverness** — prefer syntax that is easy to understand correctly.
2. **Readable structure** — make related settings and nested groups easy to follow.
3. **Simple, useful syntax** — keep the rules small while supporting practical configuration needs.
4. **Predictable rules** — make the same input have the same meaning across parsers.
5. **Visible meaning** — show structure and value types directly in the file.
6. **Clear nesting** — use section markers to show which sections belong inside others.
7. **Easy to edit and parse** — support both people editing files and tools reading them.

---

## 🚀 Quick Start

You can try YINI with the command-line tool (`yini-cli`) by reading a small configuration file and printing its contents as JSON.

You will need Node.js and npm for the commands below.

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
1. **Install the CLI globally**
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

2. **Parse configuration text**
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

- ✔️ **Sections** group related settings and show nesting with markers.
- ✔️ **Predictable rules** give the same input the same meaning.
- ✔️ **Explicit value syntax** for strings, numbers, booleans, null, lists (arrays), and inline objects.
- ✔️ **Section nesting does not depend on indentation.** Whitespace inside strings still follows the rules for that string form.
- ✔️ **Formal specification and grammar.**
- ✔️ **Lenient and strict parsing modes** — lenient mode is the default, strict mode enables stronger validation.
- ✔️ **Multiple comment styles** — C-style commenting rules using `//` and `/* ... */`. Supports `#` and `;` commenting styles too. 
- ✔️ **Direct syntax** — use `=` for section assignments and markers for section nesting.
- ✔️ **Flexible booleans** with `true`/`false`, `on`/`off`, `yes`/`no` (all case-insensitive).
- ✔️ **Number formats** include decimal, binary, octal, duodecimal (base 12), hexadecimal, and exponent notation.
- ✔️ **Visible value types** — strings are quoted, lists use `[]`, and inline objects use `{}`.
- ✔️ **String forms** include Raw Strings, Escaped Strings (`E`/`e`), Triple-Quoted Strings, and Block Strings (`b`, `B`, or `block` in any capitalization).
- ✔️ **Supports null values**, written as `null` or `None` in any casing.
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

    // Section markers determine nesting. Indent the sections to make them
    // easier to read.

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
      useTLS = OFF                  // false and NO work too.

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

# In this YAML block mapping, indentation determines nesting.
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
> - Section markers determine nesting; you can indent sections for readability.
> - In YINI, `^` defines section headers.
> - `//` and `#` start line comments outside strings and backticked identifiers (names enclosed in backticks). No whitespace is required around `#`.
> - `;` can be used for full-line comments (`//` and `#` can be used too).
> - All strings must be enclosed in quotes (`'` or `"`).
> - Use `=` between a key and its value at the root or inside a section.
> - Values can be strings, numbers, booleans, null, lists, or inline objects.
> - Inside inline objects, use `:` between a key and its value, as in `{ port: 8080 }`. Lenient mode also accepts `=` there.

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

💡 Changing section indentation does not change section nesting. Indentation within strings follows the rules for that string form.

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

    ^^ Cache                // Defines Cache, a sub-section of Service.
    Type = "redis"
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
> - **Two** `^^` = a child of the current top-level section.
> - **Three** `^^^` = a child of the current depth-2 section.
> - Section depth is expressed directly by repeated section markers.
> - Unlike TOML, YINI **does not** use dot `.` notation in sections.

---

## Section Nesting
Section nesting is expressed by repeating the section marker character. For example, `^` indicates a top-level section, `^^` indicates a nested section, and `^^^` indicates a deeper nested section.

Repeated markers are allowed through depth 9. For deeper sections, use numeric shorthand such as `^10 SectionName`. Define each parent level before adding a child; shorthand does not allow skipped levels. See [Nested Sections](./YINI-Specification.md#53-nested-sections).

## Comments
YINI supports several comment styles:
- **Inline comments:** `//` or `#`
- **Block comments:**  `/* multi-line */`
- **Full-line comments:** `;`  
- A line may also contain only an inline comment.

Note: Outside strings and backticked identifiers, `#` always begins a comment. Hexadecimal values use `0x...` or `hex:...`; `#FF0033` starts a comment.

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

An unquoted value is not a string. For example, `on` is a boolean; `"on"` is a string.

### String Literals in YINI
YINI defines five main string literal forms: Raw Strings, Escaped Strings, Raw Triple-Quoted Strings, Escaped Triple-Quoted Strings, and Block Strings.

These forms differ in how they handle escape sequences and multi-line content.

Block Strings accept `b` or `B`, or the word `block` in any capitalization: `block`, `BLOCK`, `Block`, and `bLoCk` all work. Changing the prefix's capitalization does not change the case of the content.

Source line endings (LF, CRLF, or CR) become LF (`\n`) in all multiline string values. Block Strings also remove structural indentation. See the [string rules](./YINI-Specification.md#6-string-literals).

```ini
# Raw strings are the default. No prefix is needed, but an optional R prefix
# may be used for clarity. Escape sequences are not interpreted.
String = "D:\folder\file"

// Escaped strings use E or e and support escape sequences.
EscapedString = e"Hello\nWorld\n"
ClassicString = C"Hello\nWorld\n" // deprecated prefix; same value

/* Raw Triple-Quoted Strings can span multiple lines. They keep spaces,
   tabs, and literal backslashes; source line endings become LF.
 */
TripleQuotedString = """
This is a triple-quoted
string literal — backslashes
stay literal, without escapes.
"""

// Block Strings remove structural indentation while keeping line breaks.
// Use b or B, or block in any capitalization, for scripts, SQL queries, or similar text.
BlockString = block"""
    npm install
    npm run build
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

YINI uses explicit section markers for nesting and supports common data types. The table below compares a few syntax features.

### Feature Comparison

| Feature                          | YINI | INI | [JSON](https://www.rfc-editor.org/rfc/rfc8259) | [YAML](https://yaml.org/spec/1.2.2/) | [TOML](https://toml.io/en/v1.1.0) |
|----------------------------------|:---:|:---:|:----:|:----:|:----:|
| Formal language specification    | ✅ | Varies | ✅ | ✅ | ✅ |
| Nested objects and lists         | ✅ | Varies | ✅ | ✅ | ✅ |
| Comments                         | ✅ | Varies | ❌ | ✅ | ✅ |
| Built-in null value              | ✅ | Varies | ✅ | ✅ | ❌ |
| Strings spanning source lines    | ✅ | Varies | ❌ | ✅ | ✅ |

INI has several variants, so its supported features depend on the parser. For the other formats, the table follows the linked language specifications.

---

## ⬇️ YINI Downloads
- [⬇️ YINI Downloads](https://github.com/YINI-lang/YINI-spec/wiki/Get-YINI-Tools)  
  *This page lists available YINI parsers, tools, and related implementations across different languages and platforms.*

---

## 💬 Feedback
We welcome feedback — feel free to open an Issue or start a Discussion.

### Acknowledgments
Community questions, testing, and feedback have helped improve YINI and its specification.

See [Acknowledgments in the Rationale](./RATIONALE.md#acknowledgments) for the contributors and feedback behind these changes.

---

## Version Mapping Table

| Date     |Specification v. |Grammar ANTLR4 lexer/parser  v.|
|----------|-----------------|-------------------------------|
| 2025 Jul | 1.0.0-RC.1      | 1.0.0-RC.1   |
| 2025 Aug | 1.0.0-RC.2      | 1.0.0-RC.2   |
| 2025 Sep | 1.0.0-RC.3      | 1.1.0-RC.1   |
| 2026 Mar | 1.0.0-RC.4      | 1.2.0-RC.1   |
| 2026 Apr | 1.0.0-RC.5      | 1.2.0-RC.2   |
| 2026 May | 1.0.0-RC.6      | 1.3.0-RC.1   |
| 2026 Nov | 1.0.0-RC.7      | 1.4.0-RC.1   |
| …        | …               | …            |

---

## License

This project is licensed under the Apache License 2.0 — see the [LICENSE](./LICENSE) file for details.

---

**^YINI ≡**  
> YINI is a text-based configuration format inspired by INI, with explicit section nesting and predictable parsing.
> 
> It has a formal specification and a defined grammar.

[yini-lang.org](https://yini-lang.org/?utm_source=github&utm_campaign=yini_spec&utm_content=readme_footer&utm_medium=referral) · [YINI-lang on GitHub](https://github.com/YINI-lang)  
