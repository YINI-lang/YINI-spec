# Intro to YINI Config Format

## 1. Sections
Group settings under a named header. A section header name starts with `^`.

Start a section with `^`, e.g.:
```yini
^ App
title = "AppName"
```

> Alternative section markers to `^` are also supported: `<`, `§`, `€` (e.g. `< Section`).

> See section 9 for more advanced marker and naming options.

## 2. Key = Value
Each line inside a section is a **key** (name) and **value**, separated by `=`.

Write settings as `key = value`:
```yini
maxConnections = 100
enableLogging  = true
```

> See section 9 for more advanced marker and naming options.

### 💡Tip
Use backticks (\`) to quote section or key names that contain spaces or special characters.

Key names with spaces/special characters can be backticked:

```yini
 user id  = 1            # Invalid ❌
`user id` = 1            # Valid ✅
```

## 3. Values
Values can be:
- **Strings** (always quoted): `'hello'` or `"world"` (either single or double quoted)
- **Numbers:** `42`, `3.14` or `-10`
- **Booleans:** `true`, `false`, `on`, `off`, `yes`, `no` (all case-insensitive)
- **Nulls:** Use `null` or leave the value blank after `=` (in lenient mode)
- **Lists:**
  * JSON‑style: `["red", "green", "blue"]`
  * Colon‑style: *(Planned – not yet implemented in parser)* 

## 4. Comments
Various commenting styles are supported:
```yini
// This is a line comment
timeout = 30  // inline comment
# This is also a line comment (must have a space after #)
interval = 30  # inline comment (must have a space after #)
/* Block comment spanning
   multiple lines */
; Full line comment (must be whole line).
```

> **Tip:** You can add comments anywhere—above, beside, or below any setting or section.
> 
👆 **Caveat 1:** If you use `#` for comments, always put a space after the `#`.
(Otherwise, the parser might misinterpret it as part of a value.)

👆 **Caveat 2:** `;` is used only for full-line comments. The `;` must be the first non-whitespace character on a line (only spaces or tabs are allowed before it).
(If `;` appears later in the line, the parser may treat it as part of a value or as a line delimiter, not as a comment.)

💡**Tip:** You can use any comment style in your file.
For best readability, try to stick to one style per file.

## 5. Nested Sections
Use extra carets `^` for sub‑sections:
```yini
^ Parent
^^ Child

// Add another caret `^` and you get a sub-section
// of the previous section, and so...
^^^ SubChild
```

If you prefer, you can indent the nested section for visibility:
```yini
^ Main
    ^^ Sub
    host = "db.example.com"
```

One can nest multiple sections:
```yini
^ Root
^^ Sub
^^^ SubSub
^ BackToRoot
```

Example with indented sections:
```yini
^ Root
value = 'At level 1'
    ^^ Sub
    value = 'At level 2'
        ^^^ SubSub
        value = 'At level 3'
        
^ BackToRoot
value = 'Back at level 1'
```

The above Yini code will produce the following JavaScript object:
```js
// JS object
{
  Root: {
    value: 'At level 1',
    Sub: { value: 'At level 2', SubSub: { value: 'At level 3' } }
  },
  BackToRoot: { value: 'Back at level 1' }
}
```

> See section 9 for more advanced marker and naming options.

## 6. Lists
```yini
// JSON‑style lists
colors = ["red", "green", "blue"]

numberList = [
    10,
    20,
    30
]


// Colon‑style list
// 👆 Colon‑style list support is planned for an upcoming release.
fruits:
  "Pear",
  "Cherry",
  "Banana"
```

> You can use either single or double quotes for string values in YINI.

## 7. Document Terminator (strict mode)
The `/END` marker is optional in both lenient (default) and in strict mode.

End a file explicitly with:
```yini
^ App
title = "MyTitle"

/END    // Is only optional.
```

## 8. Disabled Lines
Prefix any valid line with `--` to skip it entirely:
```yini
--maxRetries = 5
```

## 9. Advanced: Alternative Section Markers & Naming
In addition to the standard syntax, YINI supports several advanced options:

- (a.) **Alternative section markers:**  
  Besides `^`, you can use `<`, `§`, or `€` as section header markers.  
  
  ```yini
  < MySection
  § Settings
  € MyApp
  ```

- (b.) **Backticked section names and key names:**  
  Use backticks (`) to allow spaces or special characters in section or key names:

  ```yini
    ^ `Section name with spaces`
    `user id` = 42
  ```

- (c.) **Numeric shorthand section markers:**  
  To create deeply nested sections (beyond 6 levels), use numeric shorthand:

  ```yini
  ^7 DeepSection    # Equivalent to 7 carets: ^^^^^^^ DeepSection
  <10 VeryDeep      # Equivalent to <<<<<<<<<<< VeryDeep
  ```

  👆 Though, can not mix standard/classic and numeric shorthand markers in the same section header.

- (d.) **More features:**  
  The YINI format supports even more features than listed here, such as additional number notations, string types, and advanced escaping. For full details, see the [latest release of the YINI specification](https://github.com/YINI-lang/YINI-spec/blob/release/YINI-Specification.md).

## 10. Complete Example

```yini
@yini       # Optional marker to identify YINI format.

^ App
name    = "MyApp"
version = "1.0.0"
debug   = off  // Turn on for debugging.

^^ Database
host     = "db.local"
port     = 5432
--user   = "secret"  # This line is disabled due to --.
userList = ["alice", "bob", "carol"]

/END // (optional)
```

---

## Learn More

- ➡️ [YINI Parser on npm](https://www.npmjs.com/package/yini-parser)  
  *Install and view package details.*

- ➡️ [Read the YINI Specification](https://github.com/YINI-lang/YINI-spec/blob/release/YINI-Specification.md#table-of-contents)  
  *Full formal spec for the YINI format, including syntax and features.*

- ➡️ [YINI Parser on GitHub](https://github.com/YINI-lang/yini-parser-typescript)  
  *TypeScript source code, issue tracker, and contributing guide.*

- ➡️ [YINI vs Other Formats](https://github.com/YINI-lang/YINI-spec/tree/release#-summary-difference-with-other-formats)  
  *How does YINI differ: comparison with INI, YAML, and JSON.*
  
- ➡️ [Why YINI? (Project Rationale)](https://github.com/YINI-lang/YINI-spec/blob/release/RATIONALE.md)  
  *Learn about the motivations and design decisions behind YINI.*

---

**~ YINI ≡**  
> Aims to be a Clean, Readable, and Human-friendly configuration format.  

[github.com/YINI-lang](https://github.com/YINI-lang)
