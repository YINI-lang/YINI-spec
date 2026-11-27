_YINI: A clear configuration file format — clean, readable, structured._

---

# Specification for the YINI Format
**Version:** --Upcoming-- - 1.0.0-RC.7x/RC.8-WIP
**Date:** 2026-11-14 + FUTURE

> **Status:** This is a release-candidate version. Minor clarifications and corrections may still be made before YINI 1.0.0.

© 2024-2026 Marko K. Seppänen. Licensed under the Apache License, Version 2.0.
See the full license text at the end of this document.

---

[⇨ Table of Contents](./YINI-Specification.md#table-of-contents)

## Preface
**YINI (by the YINI-lang project) was designed with a simple idea in mind:** configuration files should be clear to read, straightforward to edit, and predictable to interpret.  
Its design emphasizes explicit structure and human-readable syntax, while remaining formal enough to support consistent parsing and reliable tooling.  
The name *YINI* originates from "Yet another INI", reflecting its inspiration from the traditional INI format.

YINI grew from a concrete question: Could a configuration format be more structured than INI, more readable than JSON, and less fragile than indentation-sensitive formats like YAML? From that starting point, YINI gradually developed around a small set of core design goals:

- Clarity over cleverness.
- Readability without sacrificing structure.
- Simplicity with serious usability.
- Predictability over magic.
- Explicitness over hidden behavior.
- Structure without visual clutter.
- Human-friendly editing with deterministic parsing.

YINI is therefore intended to be simple, but not simplistic: explicit where structure matters, readable at a glance, and defined clearly enough to support robust implementations.

See [A.1. Why was YINI created?](./RATIONALE.md) for background.

While inspired by well-known formats such as INI, JSON, Python, Markdown, and YAML, YINI defines its own approach through explicit structure, clear typing rules, and predictable interpretation.  
A central part of this approach is its handling of nested sections, which makes hierarchy visible without requiring indentation to define structure.

This specification defines YINI with the goal of serving both human authors and implementers by describing the format in a clear, precise, and consistent way.

Some parts of the YINI specification have benefited from valuable feedback and insights shared by users in the broader community.

For more feedback details, see section D.2, _“Acknowledgments & Special Thanks”_, in the [Rationale](./RATIONALE.md) document.

---

## Table of Contents

---

([⇨ Preface](./YINI-Specification.md#preface))  

### **Part I – Introduction and Fundamentals**

**1. Introduction** ([Link ⇨](./YINI-Specification.md#1-introduction))  
&nbsp;&nbsp;&nbsp;&nbsp;1.1. What is YINI?  
&nbsp;&nbsp;&nbsp;&nbsp;1.2. Purpose and Design Goals  
&nbsp;&nbsp;&nbsp;&nbsp;1.3. Background and Intent  
&nbsp;&nbsp;&nbsp;&nbsp;1.4. Key Features  
&nbsp;&nbsp;&nbsp;&nbsp;1.5. Terminology

**2. File Structure** ([Link ⇨](./YINI-Specification.md#2-file-structure))  
&nbsp;&nbsp;&nbsp;&nbsp;2.1. File Encoding  
&nbsp;&nbsp;&nbsp;&nbsp;2.2. File Extension  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2.1. Strict-Mode Filename Suffix  
&nbsp;&nbsp;&nbsp;&nbsp;2.3. Optional Shebang (`#!`)  
&nbsp;&nbsp;&nbsp;&nbsp;2.4. YINI Marker (`@yini`)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.4.1. Optional Mode Declaration  

**3. Syntax Overview** ([Link ⇨](./YINI-Specification.md#3-syntax-overview))  
&nbsp;&nbsp;&nbsp;&nbsp;3.1. General Syntax Rules  
&nbsp;&nbsp;&nbsp;&nbsp;3.2. Whitespace and Indentation  
&nbsp;&nbsp;&nbsp;&nbsp;3.3. Comments  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.3.1. Inline Comments  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.3.2. Multi-line Block Comments  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.3.3. Full-line Comments  
&nbsp;&nbsp;&nbsp;&nbsp;3.4. Identifiers  
&nbsp;&nbsp;&nbsp;&nbsp;3.5. Document Terminator  
&nbsp;&nbsp;&nbsp;&nbsp;3.6. Disable Line

---

### **Part II – Grammar and Literals**

**4. Keys and Values** ([Link ⇨](./YINI-Specification.md#4-keys-and-values))  
&nbsp;&nbsp;&nbsp;&nbsp;4.1. Key Naming Rules  
&nbsp;&nbsp;&nbsp;&nbsp;4.2. Value Types (Simple, Compound, Special)  
&nbsp;&nbsp;&nbsp;&nbsp;4.3. Type Rules

**5. Section Headers** ([Link ⇨](./YINI-Specification.md#5-section-headers))  
&nbsp;&nbsp;&nbsp;&nbsp;5.1. Syntax  
&nbsp;&nbsp;&nbsp;&nbsp;5.2. Section Markers (`^`, `§`, `>`, or `<`)  
&nbsp;&nbsp;&nbsp;&nbsp;5.3. Nested Sections  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.3.1. Section Marker Separators  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.3.2. Shorthand Section Heading  

**6. String Literals** ([Link ⇨](./YINI-Specification.md#6-string-literals))  
&nbsp;&nbsp;&nbsp;&nbsp;6.1. Raw Strings (R-Strings)  
&nbsp;&nbsp;&nbsp;&nbsp;6.2. Escaped Strings (E-Strings)\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6.2.1. Escape Sequences  
&nbsp;&nbsp;&nbsp;&nbsp;6.3. Triple-Quoted Strings  
&nbsp;&nbsp;&nbsp;&nbsp;6.4. Block Strings\
&nbsp;&nbsp;&nbsp;&nbsp;6.5. String Types Summary\
&nbsp;&nbsp;&nbsp;&nbsp;6.6. String Concatenation\
&nbsp;&nbsp;&nbsp;&nbsp;6.7. Scalar Conversion in Lenient Concatenation

**7. Number Literals** ([Link ⇨](./YINI-Specification.md#7-number-literals))  
&nbsp;&nbsp;&nbsp;&nbsp;7.1. Numbers  
&nbsp;&nbsp;&nbsp;&nbsp;7.2. Digit Separators  
&nbsp;&nbsp;&nbsp;&nbsp;7.3. Exponent Format  
&nbsp;&nbsp;&nbsp;&nbsp;7.4. Number Formats

**8. Boolean and Null Literals** ([Link ⇨](./YINI-Specification.md#8-boolean-and-null-literals))  
&nbsp;&nbsp;&nbsp;&nbsp;8.1. Booleans  
&nbsp;&nbsp;&nbsp;&nbsp;8.2. Null Literal

**9. Object Literals** ([Link ⇨](./YINI-Specification.md#9-object-literals))  
&nbsp;&nbsp;&nbsp;&nbsp;9.1. Objects (using `{` and `}`)  
&nbsp;&nbsp;&nbsp;&nbsp;9.2. Object Member Separators  

**10. List Literals** ([Link ⇨](./YINI-Specification.md#10-list-literals))  
&nbsp;&nbsp;&nbsp;&nbsp;10.1. Bracketed Lists (`[...]`)  

**11. Reserved and Future Constructs** ([Link ⇨](./YINI-Specification.md#11-reserved-and-future-constructs))\
&nbsp;&nbsp;&nbsp;&nbsp;11.1. Future / Reserved Features _(For Future Use)_  

---

### **Part III – Validation, Implementation & Compatibility**

**12. Validation Rules** ([Link ⇨](./YINI-Specification.md#12-validation-rules))  
&nbsp;&nbsp;&nbsp;&nbsp;12.1. Reserved Syntax  
&nbsp;&nbsp;&nbsp;&nbsp;12.2. Well-Formedness Requirements  
&nbsp;&nbsp;&nbsp;&nbsp;12.3. Lenient vs. Strict Modes  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;12.3.1. Table: Lenient vs. Strict Mode

**13. Implementation Rules** ([Link ⇨](./YINI-Specification.md#13-implementation-rules))\
&nbsp;&nbsp;&nbsp;&nbsp;13.1. Top-Level Sections and Document Root  
&nbsp;&nbsp;&nbsp;&nbsp;13.2. Line Handling and Whitespace  
&nbsp;&nbsp;&nbsp;&nbsp;13.3. Value and Null Handling  
&nbsp;&nbsp;&nbsp;&nbsp;13.4. Boolean Canonicalization  
&nbsp;&nbsp;&nbsp;&nbsp;13.5. Objects  
&nbsp;&nbsp;&nbsp;&nbsp;13.6. Lists  
&nbsp;&nbsp;&nbsp;&nbsp;13.7. String Concatenation  
&nbsp;&nbsp;&nbsp;&nbsp;13.8. String Literal Types  
&nbsp;&nbsp;&nbsp;&nbsp;13.9. Comments  
&nbsp;&nbsp;&nbsp;&nbsp;13.10. Additional Implementation Guidance

**14. Compatibility and Versioning** ([Link ⇨](./YINI-Specification.md#14-compatibility-and-versioning))  
&nbsp;&nbsp;&nbsp;&nbsp;14.1. Fallback Rules  
&nbsp;&nbsp;&nbsp;&nbsp;14.2. Versioning Strategy  
&nbsp;&nbsp;&nbsp;&nbsp;14.3. Encoding Notes  
&nbsp;&nbsp;&nbsp;&nbsp;14.4. JSON Compatibility

---

### **Part IV – Examples and Appendices**

**15. Examples** ([Link ⇨](./YINI-Specification.md#15-examples))  
&nbsp;&nbsp;&nbsp;&nbsp;15.1. Minimal Example  
&nbsp;&nbsp;&nbsp;&nbsp;15.2. Realistic Config Use Cases  
&nbsp;&nbsp;&nbsp;&nbsp;15.3. Examples of YINI → JSON Mapping  
&nbsp;&nbsp;&nbsp;&nbsp;15.4. Examples of JSON → YINI Mapping  
&nbsp;&nbsp;&nbsp;&nbsp;15.5. Large-Scale Real-World Configuration Example A: Corporate SaaS Platform  
&nbsp;&nbsp;&nbsp;&nbsp;15.6. Large-Scale Real-World Configuration Example B: High-Security Distributed Control System  
&nbsp;&nbsp;&nbsp;&nbsp;15.7. Large-Scale Real-World Configuration Example C: Industrial Monitoring & Automation Platform  

**16. Appendices and Reserved Areas** ([Link ⇨](./YINI-Specification.md#16-appendices-and-reserved-areas))  
&nbsp;&nbsp;&nbsp;&nbsp;16.1. License  
&nbsp;&nbsp;&nbsp;&nbsp;16.2. Acknowledgments  
&nbsp;&nbsp;&nbsp;&nbsp;16.3. Author(s)  
&nbsp;&nbsp;&nbsp;&nbsp;16.4. Spec Changes  
&nbsp;&nbsp;&nbsp;&nbsp;16.5. Formal Grammar  
&nbsp;&nbsp;&nbsp;&nbsp;16.6. Common Mistakes and Pitfalls  
&nbsp;&nbsp;&nbsp;&nbsp;16.7. 🧾 Unicode Whitespace Characters  

---

## 1. Introduction
### 1.1. What is YINI?
**YINI** is a human-readable text format for representing structured information.  
It is designed to be clear, predictable, and easy for humans to read and write, and is defined by this specification together with its accompanying ANTLR4 grammar.  

Its syntax is inspired by widely used configuration formats such as INI and YAML, as well as general-purpose languages and data notations including JSON, C, and Python.  
YINI aims to offer a consistent and intuitive structure that is easy to parse and edit by both humans and machines.  

YINI is targeted at users who require a straightforward format for storing and organizing data—such as configuration files, application settings, and other general data storage—where human readability and ease of use are of primary importance.

YINI supports scalar values, lists, inline objects, members, and nested sections. These constructs allow documents to represent both flat and hierarchical configuration data.

### 1.2. Purpose and Design Goals

The YINI format was designed with the following philosophy and key goals in mind:

1. **Clarity over cleverness**  
YINI is designed to favor clear and understandable syntax over compact, implicit, or surprising constructs. The format aims to reduce ambiguity and make both documents and rules easier to interpret correctly.

2. **Readability without sacrificing structure**  
YINI is intended to remain easy for humans to read and follow, while still providing real structure for nested and non-trivial configuration data. Readability is treated as a primary requirement, not as an afterthought.

3. **Simplicity with serious usability**  
YINI aims to keep the core syntax simple, consistent, and approachable, while still supporting practical configuration needs such as lists, objects, comments, and nested sections. The goal is to remain simple, but not simplistic.

4. **Predictability over hidden behavior**  
YINI is designed so that the meaning of a document follows explicit and stable rules. It avoids relying on invisible or context-sensitive behavior whenever possible, so that users can more easily understand how a document will be interpreted.

5. **Explicit structure without visual clutter**  
YINI is designed to represent hierarchy and grouping explicitly, without depending on indentation to define structure. The goal is to make structure visible and reliable while keeping the overall notation compact and readable.

6. **Human-friendly editing**  
YINI is intended to be comfortable for humans to write, review, and maintain. Its syntax is designed to support direct editing of configuration files without requiring excessive punctuation, ceremony, or visual noise.

7. **Deterministic parsing**  
YINI is designed to support deterministic (predictable and consistent) parsing by implementations, especially in strict mode. This helps reduce ambiguity and improves robustness for validation, tooling, and long-term maintainability.
  
### 1.3. Background and Intent

YINI was created as a configuration format for cases where human readability, explicit structure, and predictable interpretation are more important than compactness or maximum syntactic flexibility.

Its design aligns with several established software-design principles, including **KISS** (_"Keep It Simple, Stupid"_), the **principle of least surprise** / **least astonishment** (POLA), **explicit is better than implicit**, and the contract-oriented idea behind the **Liskov Substitution Principle (LSP)**. These principles are reflected in YINI's visible section structure, quoted strings, and deterministic parsing rules.

YINI also makes deliberate trade-offs. It does not try to infer structure from indentation, minimize every character of syntax, or behave like a general expression language. Instead, it favors explicit structure and stable interpretation rules, because configuration files are often read, reviewed, edited, and validated over time.

For a deeper discussion of the motivation and design philosophy, see [Why YINI?](./RATIONALE.md).

### 1.4. Key Features
Unless explicitly stated otherwise, YINI parsers are expected to operate in lenient (non-strict) mode by default. Strict mode is optional and intended for environments where stricter validation is needed.

YINI prioritizes **clarity, structure, and predictability**. The features below show how those properties take shape in the format.

- **Explicit Section Structure:** Sections are defined by explicit header markers, not indentation. The primary marker is `^`, with `§`, `>`, and `<` accepted as alternatives. This keeps document structure visible and unambiguous.

- **Indentation-insensitive Syntax:** YINI does not use indentation to determine structure. Indentation may be used for readability, but it does not affect parsing.

- **Typed Values Without Type Annotations:** YINI supports strings, numbers, booleans, nulls, lists, and inline objects. The type of a value is inferred from how it is written, so no separate type annotation is needed.

- **Inline Collections:** Lists use `[]`, and inline objects use `{}` with `:` as the canonical member separator. Inline collections are not indentation-sensitive.

- **Commenting and Documentation:** Users can comment/annotate values and sections with comments. Comments are ignored by the parser and have no effect on the parsed output.

- **Nested Sections:** YINI supports hierarchically nested sections, allowing complex configurations to be expressed with explicit structure.

- **Multiple String Forms:** YINI supports several string forms for different needs, including single-quoted strings, double-quoted strings, raw strings, escaped strings, and triple-quoted multi-line strings.

- **Multi-line Strings:** YINI supports multi-line string literals for longer text values, without requiring unrelated document structure to be affected.

- **Dual Parsing Modes:** YINI defines both lenient and strict parsing modes. Lenient mode is more permissive and is the default. Strict mode applies stronger validation rules for environments that require more predictable and constrained input.

- **`@yini` Document Marker:** A YINI document supports a `@yini` marker near the top of the document. It identifies the document as YINI and MAY optionally declare the expected parsing mode.

- **Document Terminator:** YINI supports an optional document terminator (`/END`); see Section 3.5 for mode-specific requirements. When present, it provides an unambiguous signal of document completion, which is especially helpful for streaming parsers and documents embedded within larger payloads.

### 1.5. Terminology
Uppercase requirement keywords—including MUST, MUST NOT, SHOULD, SHOULD NOT, and MAY—carry the meanings defined by BCP 14 ([RFC 2119](https://www.rfc-editor.org/rfc/rfc2119.html) and [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174.html)). These special meanings apply only when the keywords are written entirely in uppercase.

These terms are used throughout this specification to describe YINI's grammar, structure, and semantics. The list also includes a few general English terms used with specific meaning in this document.

| Term                      | Definition |
|---------------------------|------------|
| Array                 | In JSON, and in some markup and many programming languages a list is called an *array*. In YINI, the preferred term is *list*. For more details, see: List. |
| Backticked identifier | An identifier enclosed in backticks, such as `` `display name` ``, allowing names that cannot be written as simple identifiers. |
| Boolean literal | A case-insensitive literal representing `true` or `false`, such as `true`, `false`, `yes`, `no`, `on`, or `off`. |
| Canonical form | The preferred syntax form for a construct, used by documentation and recommended for formatters. |
| Classic string | Deprecated name for an Escaped String; the `C` and `c` prefixes remain valid but are deprecated. |
| Comment | Text ignored by the parser and not represented in the parsed data model. |
| Compound value | A value that contains one or more nested values. In YINI, lists and inline objects are compound values. |
| Configuration | A structured set of sections and members representing settings or data. |
| Delimiter | A character (or sequence of characters) used to show where something starts, ends, or is separated from something else. |
| Diagnostic | A warning or error reported by a parser or implementation. |
| Disabled line | A line whose first non-whitespace characters are `--`; the entire line is ignored by the parser. |
| Document terminator | The `/END` marker that explicitly marks the end of a YINI document. It is optional in lenient mode and required in strict mode. |
| Escaped string | A string literal prefixed with `E` or `e`, where supported escape sequences are interpreted. The deprecated `C` and `c` prefixes have the same behavior. |
| Explicit | Written or stated directly in the source text, code, or specification. |
| Identifier | A name used for a key, object member key, or section name. |
| Implementation | A parser, validator, formatter, syntax highlighter, tool, library, or host integration that supports YINI. |
| Implicit | Inferred from surrounding syntax, context, or defined rules rather than written directly. |
| Inline object | A compound value enclosed in `{` and `}`, containing zero or more object members. |
| Key | The identifier on the left side of a member assignment. The identifier can either be _simple_ or _backticked_. |
| Lenient mode | The default parsing mode. It is more permissive than strict mode, while still preserving predictable parsing behavior. |
| List | An ordered compound value enclosed in `[` and `]`, containing zero or more comma-separated values. In JSON and many programming languages, this structure is commonly called an *array*. |
| Logical line | A line of YINI source terminated by a supported line ending (`LF`, `CRLF`, or `CR`) or, for the final line, by end-of-file (`EOF`). Some constructs require tokens to appear on the same logical line. |
| Member | A **key-value** (pair) entry at root or section level, canonically written as `key = <value>`. For example: `num = 100` or `str = "Hello"`. See Section 4.3 for separator rules. |
| Mode declaration | An optional declaration in the YINI marker, such as `@yini strict` or `@yini lenient`, that states the document's expected parsing mode. |
| Nested section | A section contained under another section, represented by a greater section depth. |
| Null literal | The case-insensitive literals `null` and `None`, representing the null value. |
| Number literal | A numeric value written using decimal notation or one of the supported base-prefixed forms. |
| Object member | A key-value entry **inside an inline object**, normally written as `key: <value>`. For example: `num: 100` or `str: "Hello"`. In lenient mode only, it may also be written as `key = <value>`; conforming lenient-mode parsers MUST accept both separators. |
| Orphan member | A root-level member not contained in an explicit section. |
| Parser | Software that reads a YINI document and produces a parsed data representation, or reports diagnostics. |
| Raw string | A string literal that does not interpret escape sequences. Raw string behavior is the default. |
| Root-level member | A member written outside any explicit section. Root-level members are allowed only in lenient mode. |
| Scalar value | A non-compound value: string, number, boolean, or null. |
| Section | A named grouping of members and/or nested sections. |
| Section depth | The nesting level of a section. A top-level section has depth 1. |
| Section header | A line that introduces a section, using a section marker such as `^`, `§`, `>`, or `<`. |
| Section marker | A character used to introduce a section header. The primary section marker is `^`. |
| Simple identifier | An identifier written without backticks, using only letters, digits, and underscores, and not beginning with a digit. |
| Strict mode | An optional parsing mode that enforces stricter structural validation, including exactly one explicit top-level section, no top-level orphan members, and a required document terminator (`/END`). It is not the default mode. |
| String literal | A quoted text value. YINI strings MUST be quoted. |
| Top-level section | A section at depth 1. Strict mode requires exactly one explicit top-level section. |
| Triple-Quoted String | A string literal enclosed in `""" ... """` that may span multiple lines. |
| Value | The data assigned to a key. The value can be a string, number, boolean, null, list, or inline object. |
| YINI document | A complete, self-contained YINI configuration input. The term "file" is used informally when a YINI document is stored on disk. |
| YINI file                 | Informal term for a YINI document. See: YINI document. |
| YINI marker | The optional `@yini` marker near the top of a document, used to identify the document as YINI and optionally declare the expected parsing mode. |

## 2. File Structure
A YINI file consists of an explicit document structure based on sections, members, and values. It may also contain comments, but indentation does not determine structure. The file structure determines how data is organized, encoded, and presented. Below are the key elements of the file structure.

### 2.1. File Encoding
YINI documents MUST be encoded in UTF-8. Files in other encodings, such as UTF-16 or Latin-1, are outside this specification and may not be portable.

- **BOM Policy:** The canonical encoding is UTF-8 without a byte order mark (BOM). A UTF-8 BOM (`0xEF 0xBB 0xBF`) SHOULD NOT be used. Implementations MAY accept and ignore an initial UTF-8 BOM for compatibility.

- **Character Set:** YINI documents use Unicode. Authors SHOULD avoid non-printable characters except where the syntax permits them. The [literal control character table](#literal-control-characters) defines which controls may appear in string content and backticked identifiers.

See §3.2 for the whitespace that separates tokens.

### 2.2. File Extension
YINI files SHOULD use the `.yini` file extension. This extension makes it easier to identify the file type and ensures proper handling by tools and parsers designed for the YINI format.

#### 2.2.1. Strict-Mode Filename Suffix

YINI files meant to be parsed and validated in strict mode MAY use the filename suffix `.strict.yini`.

This suffix is a naming convention only. It does not automatically switch the parser into strict mode. The parser, tool, API, command-line option, or host application configuration remains responsible for selecting the active parsing mode.

Implementations MAY use the `.strict.yini` suffix to provide helpful diagnostics. For example, if a file named `config.strict.yini` is parsed in lenient mode, an implementation SHOULD report a warning or mode-mismatch diagnostic.

The `.strict.yini` suffix does not replace `@yini strict`, and it does not replace strict-mode validation. A file using this suffix MUST still satisfy all strict-mode requirements when parsed in strict mode.

### 2.3. Optional Shebang (`#!`)

A shebang line MAY appear only as the first line of a YINI document.

If a shebang is present, the shebang marker `#!` MUST be the first two non-BOM characters of the document. An initial UTF-8 BOM may precede the marker if the implementation accepts it under [§2.1](#21-file-encoding).

The YINI parser MUST ignore a correctly placed shebang line.

A `#!` sequence that appears after leading whitespace, after a blank line, or anywhere other than the first line MUST NOT be treated as a shebang.

If such a misplaced shebang-like sequence appears where `#` would otherwise begin a comment, it MUST be treated as a comment.

- In lenient mode, a misplaced shebang-like sequence remains valid as a comment and SHOULD be reported as a warning.
- In strict mode, a document containing any misplaced shebang-like sequence is invalid. An implementation MUST report an error for at least the first such sequence.
- To avoid repeated diagnostics and unnecessarily complex implementation logic, an implementation SHOULD report only the first misplaced shebang-like sequence per document.

Example:

```yini
#!/usr/bin/env yini

^ Config
key = "value"
```

This is not a valid shebang: ` #!/usr/bin/env yini`, because it has leading whitespace. It is treated as a comment in both modes. It SHOULD produce a warning in lenient mode; in strict mode, it MUST produce an error and make the document invalid.

### 2.4. YINI Marker (`@yini`)
The optional YINI marker (`@yini`) MAY be used and is RECOMMENDED for clarity and identification. If present, the YINI marker MUST appear before any meaningful YINI content. It MAY be preceded only by a shebang line, comments, or whitespace. (If both a shebang and a YINI marker are present, the shebang MUST appear first.)

The marker is case-insensitive: `@yini`, `@YINI`, and `@Yini` are all valid.

Its main purpose is to clearly indicate — both to humans and to programs — what format the file is in.

Although YINI files typically have the `.yini` extension, the filename is not always visible (for example, when files are embedded, or copied as snippets, etc.). The marker line provides immediate identification regardless of context.

- It also helps clarify the file format when files are opened in editors or included in bug reports.

Example:
```yini
@YINI

^ Config
key = "value"
```

Example (with shebang):
```yini
#!/usr/bin/env yini

@yini

^ Config
key = "value"
```

#### 2.4.1. Optional Mode Declaration

The YINI marker MAY include an optional mode declaration.

Supported mode declarations are:

```yini
@yini strict
@yini lenient
```

The marker and mode declaration are case-insensitive. Therefore, `@yini strict`, `@YINI STRICT`, and `@Yini Strict` are equivalent.

A mode declaration states which parsing mode the document expects. It forms part of the document contract, but it does not automatically switch the parser into that mode. This is intentional: the parser, tool, API, command-line option, or host application configuration remains responsible for selecting the active parsing mode.

Mode declarations guard against missing required validation and make differences between the expected and active parsing modes visible. The diagnostic depends on the direction of the mismatch:

- If a document declares `@yini strict` and the parser is operating in lenient mode, the parser MUST report a **mode-mismatch error diagnostic** and MUST reject the document.
- If a document declares `@yini lenient` and the parser is operating in strict mode, the parser MUST report a **mode-mismatch warning diagnostic** and MUST continue strict-mode validation. The declaration mismatch alone MUST NOT cause rejection; the document MUST still satisfy all strict-mode content and structural requirements.

| Declaration | Parsed in lenient mode | Parsed in strict mode |
|---|---:|---:|
| `@yini strict` | ❌ Error; reject | ✅ Mode matches |
| `@yini lenient` | ✅ Mode matches | ⚠️ Warning; accepted if all strict checks pass |
| `@yini` | ✅ Allowed | ✅ Allowed |
| No marker | ✅ Allowed | ✅ Allowed |

A matching declaration produces no mode-mismatch diagnostic. These entries describe the declaration check only, not whether the document as a whole is valid.

An error prevents acceptance without the required strict checks. A warning reports that stricter checks are being applied without rejecting otherwise valid content solely because of its declaration.

Implementations SHOULD present the mode-mismatch warning before any strict-mode content errors, so users can understand why lenient-only constructs are being rejected.

The parser MUST already be operating in the selected active mode. It MUST NOT silently switch modes because of the declaration.

A mode declaration does not by itself make a document valid. A document MUST satisfy all requirements of the active mode before it can be accepted.

Important: The parsing mode is always determined by external configuration — the parser, tool, API, CLI option, or host application — regardless of whether a mode declaration is present.

## 3. Syntax Overview
The syntax of YINI is designed to emphasize clarity, readability, predictability, and explicit structure in configuration files. This section provides a high-level overview of the principal syntax rules defined by the format.

### 3.1. General Syntax Rules
YINI files consist of a series of **sections, members** (key-value pairs), and optional **comments**. The following rules define the basic structure of a valid YINI file:

#### Whitespace

Whitespace (spaces and newlines) is used to separate elements in the file. Tabs do not contribute to the logical structure. In section headers, whitespace between the marker and the section name is optional in repeated/basic form, but required in numeric shorthand form (to make it clear where the marker ends and where the name starts). Outside strings and backticked identifiers, spaces and tabs are generally insignificant except where this specification explicitly requires or forbids whitespace, such as in numeric shorthand section headers or between tokens. Tabs and multiple spaces MAY be used for visual alignment and readability where whitespace is otherwise insignificant.

For definitions of whitespace and control characters, see Section 3.2, "Whitespace and Indentation".

#### Sections

YINI files support sections, which group related members. A section begins with a section header, marked by one of the allowed section markers (commonly `^`) or by a numeric shorthand form. In the repeated/basic form, whitespace between the marker and the section name is optional. In the numeric shorthand form, at least one space or tab is required after the number.

**Example of a section:**
```yini
^ SectionName
key = "value"
```

#### Keys and Values (Members)

The basic unit of YINI is a key-value pair, called a **member**. At root and section level, its canonical form uses an equal sign (`=`).

**Example:**
```yini
key = "value"
```

Inside inline objects (`{ ... }`), the canonical form uses a colon (`:`).

```yini
config = { enabled: true, retries: 3 }
```

Sections [4.3](#43-type-rules) and [9.2](#92-object-member-separators) define the lenient alternatives and strict-mode requirements.

#### Comments

YINI primarily follows C-style commenting rules using `//` and `/* ... */`. Alternative inline `#` comments, and full-line `;` comments are supported too. These are ignored by parsers and exist solely for human readability.

**Example:**
```ini
; Full-line comment.
key1 = "Banana"

key2 = "Mango"  // This is an inline comment.
key3 = "Peach"  # This is also an inline comment.

/*
  This is a block comment.
  It spans several lines.
*/
```

### 3.2. Whitespace and Indentation
A numeric shorthand section marker such as `^7` requires at least one space or tab before the section name, as in `^7 Section`.

The following whitespace `<WS>` behaviors are defined:
- Newlines (`<NL>`) may be either Unix/Linux-style (`LF`, U+000A), Windows-style (`CRLF`, U+000D U+000A), or (`CR`, U+000D).
- End-of-file (`EOF`) MAY terminate the final logical line without an `LF`, `CRLF`, or `CR`. A trailing line ending is not required in either lenient or strict mode, provided that the final line is otherwise complete and valid.
- Tabs (`<TAB>`, U+0009) and spaces (`<SPACE>`, U+0020) are generally insignificant outside string literals and backticked identifiers, except where this specification explicitly requires or forbids them, such as in numeric shorthand section headers and between distinct lexical tokens.
- You can indent section headers and members for readability. Section markers determine nesting. Inside a Block String, leading ASCII spaces set the margin described in [§6.4, Block Strings](#64-block-strings).

#### Literal control characters

In both modes, parsers MUST accept or reject literal control characters in source text as shown below. “Other C0” covers the rest of U+0000–U+001F after tab (U+0009), LF (U+000A), and CR (U+000D).

NUL is the Unicode control character U+0000, whose numeric value is zero. The Escaped String `e"\0"` produces a string containing one NUL character. In that spelling, `\0` consists of a backslash and a digit zero in the source. A literal NUL is a U+0000 character embedded directly in the source file.

| Source context | Tab | Line ending (LF, CRLF, CR) | Other C0 | DEL and C1 (U+007F–U+009F) |
| --- | --- | --- | --- | --- |
| Single-line Raw or Escaped String | Accept | Reject | Reject | Accept |
| Raw or Escaped Triple-Quoted String | Accept | Accept | Reject | Accept |
| Block String content | Accept | Accept | Reject | Accept |
| Backticked identifier | Reject | Reject | Reject | Reject |

Accepted tabs, DEL, and C1 characters retain their code points in string values. Each source line ending kept in multiline content becomes one LF, including in Raw strings. Escaped Strings can represent any of these controls with the escapes in §6.2.1. Parsers MUST normalize source line endings before decoding those escapes. For example, the two escapes in `E"\r\n"` produce CR followed by LF. See §6.4 for the placement of Block String delimiters and the treatment of structural indentation and line breaks.

### 3.3. Comments
YINI supports the following comment forms. On a Block String delimiter line, the opening quotes may be followed only by ASCII spaces or tabs before the line break. The closing quotes may be followed by a `//` or `#` line comment. Section 6.4 gives examples.

| Syntax | Type | Valid position |
|--------|------|----------------|
| `//` | Line comment | **Anywhere whitespace is allowed**; ignores the rest of the line |
| `#` | Line comment | **Anywhere whitespace is allowed**; ignores the rest of the line |
| `/* ... */` | Block comment | Where whitespace is allowed, except directly after either Block String delimiter (§6.4). May span multiple lines. |
| `;` | Full-line comment | Only at the beginning of a logical line, after optional spaces or tabs |

These rules apply:
- Comments are ignored by the parser and have no effect on the parsed data model.
- Comment markers are recognized only outside string literals and outside backticked identifiers. A comment marker appearing inside a quoted string, triple-quoted string, Escaped string, or backticked identifier is treated as ordinary content.
- Line comments begin at `//` or `#` and continue until the next line ending or `EOF`.
- Block comments begin at `/*` and end at the next `*/`. Nested block comments are not supported.
- Comments may appear only where whitespace is allowed. A comment MUST NOT split an identifier, keyword, number literal, string prefix, string literal delimiter, section marker, or other token.
- A line ending inside a block comment remains a logical-line boundary. Ignoring the comment MUST NOT make tokens on opposite sides of that line ending count as being on the same logical line.
- Where a line comment is allowed, it may begin immediately after a complete token. No whitespace is required before `//` or `#`.

While both `//` and `#` are valid for inline comments, it is recommended to use **only one style per file** to maintain clarity and consistency for human readers.

See also Section 3.6, "Disable Line", for a related mechanism used to deactivate valid lines of configuration.

#### 3.3.1. Inline Comments
YINI supports two syntaxes for inline comments.
- **Double slash** `//` comments are the default — outside string literals and backticked identifiers, everything from `//` to the end of the line is treated as a comment:
    ```yini
    key = "value" // This is an inline comment.
    key = true//This is also an inline comment.
    ```
- **Hash `#` comments** are supported too — outside string literals and backticked identifiers, everything from `#` to the end of the line is treated as a comment:
    ```yini
    key = "value" # This is an inline comment.
    key = true#This is also an inline comment.
    ```

Outside string literals and backticked identifiers, the `#` character begins a comment. Where the comment is allowed, the parser ignores the rest of that line. No whitespace is required before or after `#`.

✅ **Valid `#` comments:**
  - `# This is a comment`
  - `# Also valid`
  - `#\tTabbed too`
  - `#Comment too` — Valid with or without horizontal whitespace.
  - `#FF9900` — Interpreted as a comment.
  - `##` — Also a comment.

Because `#` begins a comment outside string literals and backticked identifiers, it cannot appear inside simple identifiers, prefixes, or other tokens.

```txt
^ MySection # comment      // Valid: comment after a section header.
0xFF#comment               // Valid: comment after a complete value.

na#commentme = "Kim"       // Invalid: `#` begins a comment after `na`, leaving an incomplete/invalid member.
hex:#FF                    // Invalid: `#` begins a comment before any hexadecimal digits.
E#comment"hello"           // Invalid: `#` begins a comment after `E`, splitting the string prefix from its literal.
```

### 3.3.2. Multi-line Block Comments
YINI supports multi-line block comments.
  
Block comments begin with `/*` and end with `*/`. They may span multiple lines.

```yini
/*
  This is a multi-line comment.
  It can span multiple lines.
*/
```

### 3.3.3. Full-line Comments
A semicolon (`;`) begins a full-line comment only when it is the first non-whitespace character on a line. Spaces and tabs may appear before it. A semicolon after meaningful content does not begin an inline comment.

```yini
; Valid full-line comment
   ; Valid full-line comment with leading whitespace

key = "value" ; INVALID: Semicolon is not an inline comment marker.
```

If `;` appears after meaningful content outside a string literal, it is not treated as a comment marker and MUST result in an error unless otherwise permitted by a future extension.

Block comments may appear between any two members, or on their own lines. They cannot appear inside a quoted string or within an identifier. Comments are ignored by parsers and exist solely for human readability.

### 3.4. Identifiers
Identifiers are names used for keys (in member assignments) and for section names (in section headers).

An _**identifier**_ can be written in one of the following forms:

- **Form 1: Simple identifier**
  - A simple identifier MUST be non-empty.
  - A simple identifier is case-sensitive (`Title` and `title` are different).
  - A simple identifier can contain only letters (`a-z`, `A-Z`), digits (`0-9`), and underscores (`_`).
  - A simple identifier MUST begin with a letter or an underscore (`_`).
  - A simple identifier MUST NOT contain hyphens (`-`) or periods (`.`). To use such characters, the identifier MUST be written as a backtick-quoted identifier (form 2).
  
  Example:
  ```yini
  name
  ```

- **Form 2: Backticked Identifier:**
  - The identifier MUST start and end with a backtick <code>`</code>.
  - A backticked identifier MUST follow the [literal control character table](#literal-control-characters). YINI defines no control-character escapes for identifiers.
  - Ordinary spaces are allowed.
  - A backtick-quoted identifier MAY be empty (<code>``</code>).
    This permits representing an identifier equivalent to the JSON empty key <code>""</code>.
    Although permitted, empty identifiers are discouraged because they reduce readability.
  - Spaces inside a backticked identifier are significant and MUST be preserved.  
  These are distinct:
  ```yini
  `name`
  ` name`
  `name `
  ```
- `` \` `` produces a backtick and `\\` produces a backslash *inside a backticked identifier*.
  Example:
  ```yini
  `a\`b` = 1
  ```

Example:
```yini
`Description of Project`
`Amanda's Project`
```

### 3.5. Document Terminator
**Mode requirement:** The document terminator is optional in lenient mode and required in strict mode.

| Mode | `/END` requirement |
|---|---|
| Lenient mode | Optional |
| Strict mode | Required |

A YINI document MAY end with a terminator line in lenient mode.  
A YINI document MUST end with a terminator line in strict mode.

The terminator line MAY end directly at `EOF`; no trailing `LF`, `CRLF`, or `CR` is required in either mode. In strict mode, a valid `/END` followed immediately by `EOF` satisfies the document-terminator requirement.

The document terminator explicitly marks the end of the configuration content
and reduces ambiguity about whether the complete trailing portion of a document
was received.

In strict mode, a missing terminator allows implementations to detect documents
whose trailing content has been truncated, omitted, or incompletely copied.
The terminator does not guarantee detection of every possible truncation,
split, or partial-copy scenario.

The default and recommended terminator is:
```yini
/END
```

This line is **not case-sensitive** (`/end`, `/End`, etc. are also valid).
Only **whitespace or comments** may appear after the terminator.

The terminator MAY be preceded by spaces or tabs, but the canonical form has no leading whitespace.

After the document terminator, only whitespace and comments are permitted.  
Any other content appearing after the terminator MUST result in an error.

### 3.6. Disable Line
A disabled line begins with optional SPACE (U+0020) or TAB (U+0009) characters
followed by `--`, provided that the marker occurs outside any string literal,
backticked identifier, or comment.

The marker and the remainder of that logical line MUST be ignored as
configuration content. The line ending remains a logical line boundary.

Inside a string literal, including Raw Strings, Escaped Strings, and both forms
of Triple-Quoted Strings, `--` MUST be treated as ordinary string content and
MUST NOT disable the line. The same sequence inside a backticked identifier or
comment has no line-disabling effect.

Disabled lines are non-meaningful content. They do not contribute to empty-document detection.

Non-normative note: Disabled lines are intended for temporarily excluding configuration lines without deleting them. Syntax highlighters MAY style disabled lines differently from comments.

**Example 1:**
```yini
// The next line is ignored — even though it's valid syntax.
--key = "Apples"
```

**Example 2:**
```yini
^ Server
host = 'localhost'
port = 8080

--^ Features
--login = true
--notifications = false
```

**Example 3: Preserved string content:**

```yini
text = """
--This line is part of the string.
"""
```

The `--` characters and the surrounding line breaks remain in `text`. Each source line ending becomes LF in the value; see Section 6.3.

## 4. Keys and Values
YINI represents configuration and structured data through a series of _**members**_, each of which is a key-value pair. This section defines the syntax and rules for keys and values, including allowed characters, data types, quoting, and related behaviors.

### 4.1. Key Naming Rules
A **key** is an identifier used to reference a specific value in a member (a `key = "value"` pair) within a YINI file.

- Keys MUST be valid identifiers — either a **simple form** or a **backticked identifier** (a backticked string). (See Section 3.4: Identifiers.)
- Keys MUST be **unique** within the same section and nesting level. 
- Assignment separator rules are defined in Section 4.3.
  
**Examples:**
```yini
username = "admin"
user_id = 12345
```

### 4.2. Value Types (Simple, Compound, Special)
> YINI infers the type of each value automatically based on its syntax.
There is no need to declare types explicitly — the parser determines the value type by how it is written (e.g., quotes, brackets, keywords).

A YINI _**value**_ can be of one of the following three groups of native/built-in types:

- **Simple/scalar types:**
  - String
  - Number
  - Boolean

- **Compound types:**
  - Object (similar to a map) — a sequence of key-value pairs (members), separated by commas
  - List (also known as Arrays) — a sequence of values, separated by commas

- **Special type:**
  - Null

Currently, YINI value types map 1-to-1 to native JSON types. Constructs such as date-time values **SHOULD currently be expressed as strings**. See more in 11.1.3, "Date-time Type".

### 4.3. Type Rules
This section defines assignment separators and how a value's syntax determines its type.

The canonical separator for root-level and section-level members is `=`. In lenient mode, authors MAY also use `:`, and conforming lenient-mode parsers MUST accept it. Both separators assign the same value and follow the same rules. They MAY be mixed across members of a document or section. In strict mode, section members MUST use `=`. Root-level orphan members are forbidden in strict mode (Section 12.2.1).

Any number of spaces or tabs may appear before or after an assignment separator. The value MUST begin on the same logical line as the separator. For a list or object, this means that the opening `[` or `{` MUST appear on that line. A line ending before the value begins is a missing-value error, including a line ending inside a block comment.

Inside inline objects, the canonical separator is `:`. Section [9.2](#92-object-member-separators) defines their separator rules.

Documentation and examples SHOULD teach and use the canonical spelling for each context, unless their purpose requires showing an alternative. Tools and formatters SHOULD normalize root-level and section-level separators to `=` and inline object separators to `:`.

```yini
// Canonical spelling.
name = "Kim"
items = [1, 2]
config = { enabled: true }
```

```yini
// Equivalent lenient-only spelling.
name: "Kim"
items: [1, 2]
config: { enabled: true }
```

A list value always requires brackets. The lenient alternative does not allow `items: 1, 2` or a bare `items:` followed by values on later lines.

For example, this document is invalid in both modes:

```yini
^ Config
x = /*
*/ [1]
/END
```

The line ending inside the comment leaves `x` without an explicit value, which is a missing-value error in both modes. The `[1]` on the next logical line is not a valid standalone statement, so the document is invalid in both modes.

#### Strings
If the value is meant to be a string, it MUST be quoted — either with single quotes (``` ' ```), double quotes (`"`), or triple quotes (`"""`) — even in lenient mode.

Unquoted text MUST NOT be interpreted as a string literal, even in lenient mode.

#### Numbers
- A sequence of digits **without a period** (`.`) is treated as a **Number** (integer).
- A sequence of digits **with a period** (`.`) is treated as a **Number** (floating-point / float).
- YINI also supports explicit base-prefixed number formats such as binary, octal, duodecimal, and hexadecimal literals. See Section 7.4, "Number Formats".

#### Booleans
If the value matches any of the following keywords `true`, `false`, `on`, `off`, `yes`, or `no` (case-insensitive) — it is interpreted as a **Boolean**. 

#### Lists
If the value is a bracketed sequence (`[ ... ]`) of values, separated by commas, the entire value is treated as a List. List items MAY be any supported YINI value type: string, number, boolean, null, list, or inline object.

#### Null
The keywords `null` and `None` (case-insensitive) represent **Null**. Missing values are errors in both modes. See Section 8.2.

Missing values inside lists or objects are not treated as `Null`. A trailing comma inside a list or object is permitted only in lenient mode and is ignored; in strict mode it is an error.

**Summary:**

| Value form examples | Meaning |
|------------|---------|
| `'something'`, `"something"`, or `"""something"""` | **String** |
| `123` | **Number** (integer) |
| `3.1415` | **Number** (float) |
| `true`, `FALSE`, `On`, `off`, `YES`, `No` _(any casing)_| **Boolean** |
| `null` or `None` _(any casing)_ | **Null** |
| _(missing value)_ | **ERROR in both modes** |
| _(Any value such as unquoted words that are not booleans, numbers, or null literals)_ | **ERROR** |

**Example:**
```txt
name = 'Sarosh'                // String
BTW = "BTW means By The Way."  // String
age = 42                       // Number
e = 2.718                      // Number
isActive = True                // Boolean
nightMode = OFF                // Boolean
nothing = Null                 // Null
alsoNothing = None             // Null
missing =                      // Error in both modes: Missing value.
scores = [1, 2, 3]             // List
mixed = ["Arial", 12, true]    // List (mixed types)
```

## 5. Section Headers
Sections in YINI are used to organize related members (key-value pairs) into logical groups. This allows for improved readability, structure, and modularity within configuration files.

An **empty section** contains neither members nor subsections. Whitespace, comments, and disabled lines do not count as content. Empty sections are valid in both modes, but implementations SHOULD report a warning diagnostic for each empty section. A section containing subsections is not empty.

An explicit section header counts as meaningful document content, even when the section is empty. See Section 12.2.1 for empty-document rules.

### 5.1. Syntax
A section header is a line that:

- Starts with one or more section marker characters (`^`, `§`, `>`, or `<`), or with a numeric shorthand such as `^7`.
- Is followed by a section name, which may be either a simple identifier or a backticked identifier.
- Ends at the newline.

**Spacing rules:**
- In the repeated/basic form, no space is required between the marker and the section name.
- In the numeric shorthand form, at least one horizontal space is required after the number before the section name.

**Examples:**
```yini
^ SectionName
^SectionName2
^^ Database
^^Database2

^7 DeepSection
§100 `Very Deep Section`
<12 Title
```

### 5.2. Section Markers (`^`, `§`, `>`, or `<`)
YINI allows a limited set of **section markers** to identify section headers. These markers help visually and semantically distinguish section starts from key-value members or comments.

Supported markers:

- `^` — Primary and recommended section marker. It is within the 7-bit ASCII range and is the most portable option.
- `§` — Supported Unicode aesthetic option for authors who prefer it and know their toolchain handles it correctly. It may be less portable because it lies outside the 7-bit ASCII range.
- `>` — (Not recommended) Quote-like ASCII fallback marker. It is portable, but authors should **be aware** that some email clients, forum renderers, and Markdown-like environments may treat it as a quote prefix.
- `<` — (Not recommended) Explicit ASCII fallback marker. It provides a quote-safe counterpart to `>` for plain-text environments where `§` is unsuitable and `>` may be treated as a quote prefix.

Recommended preference order is: **`^` first, then `§` when Unicode aesthetics are desired** and supported, then `>` or `<` only when an ASCII fallback is needed.

**When using a repeated marker to indicate nesting, a maximum of nine (`9`) repeated markers is allowed.**  

That is, the following denote nesting levels 1–9 when using the primary marker:
```yini
^          ← level 1
^^         ← level 2
^^^        ← level 3
^^^^       ← level 4
^^^^^      ← level 5
^^^^^^     ← level 6
^^^^^^^    ← level 7
^^^^^^^^   ← level 8
^^^^^^^^^  ← level 9
```

The same repeated-marker depth rule applies to all supported section markers.

**Using ten or more section marker characters in a repeated marker header is invalid.**  
For example, `^^^^^^^^^^ Section` is invalid and MUST be written using numeric shorthand instead, such as `^10 Section`. 

For nesting levels deeper than 9, the **numeric shorthand section header** syntax MUST be used (see Section 5.3.2).

### 5.3. Nested Sections
To place a section under another (i.e., to nest sections), repeat the section marker character (this technique with repeating characters is inspired by Markdown) without skipping any intermediate levels. Each additional repetition indicates one more nesting level. However, when moving to a less-nested level, the document may return directly to any previously established shallower level.

- Repeated section marker (`^`, `§`, `>`, or `<`) headers may only be repeated up to nine times — to level 9 (maximum).
- Beyond level 9, the numeric shorthand section MUST be used (see section 5.3.2).
- **Going deeper (increase nesting):** Must increment exactly one level at a time. E.g.: `^^` → `^^^` but not `^^` → `^^^^`.  
  This rule applies equally to **repeated marker** form and **numeric shorthand** form. Numeric shorthand does not permit skipping intermediate levels.
- **Going shallower (decrease nesting):** May drop directly to any previous level. E.g.: `^9` → `^^` or `^9` → `^`.
- Numeric shorthand MAY be used for any level. For levels 10 and deeper, numeric shorthand MUST be used.
- The maximum supported section depth is 255 levels.

```yini
^ Prefs
    ^^ Section
        ^^^ SubSection
```

Optionally, indentation may be omitted:
```yini
^ Prefs
^^ Section
^^^ SubSection
```

```txt
^ Level1
^^^ Level3  // ❌ Invalid: cannot skip Level2
```

Although indentation has no semantic meaning, authors SHOULD visually indent nested section headers for readability.

✅ **Example of valid section nesting:**
```yini
^ `Section 1`         // Main section 1 (depth 1)
^^ `Section 1.1`      // Sub-section of 1 (depth 2)
^^^ `Section 1.1.1`   // Sub-section of 1.1 (depth 3)

^^ `Section 1.2`      // Sub-section of 1 (depth 2)

^ `Section 2`         // Main section 2 (depth 1)
^^ `Section 2.1`      // Sub-section of 2 (depth 2)
^^^ `Section 2.1.1`   // Sub-section of 2.1 (depth 3)

^ `Section 3`         // Main section 3 (depth 1)
```

#### 5.3.1. Section Marker Separators

For readability, underscores (`_`) MAY be placed between repeated section markers.

Rules for separator underscores:

- An underscore MAY appear only between two repeated occurrences of the same section marker character.
- An underscore MUST NOT appear at the beginning or end of the section marker sequence.
- An underscore MUST NOT appear adjacent to another `_`.
- Section marker separators are supported only in repeated section marker form, not in numeric shorthand form.
- Section marker separators do not count toward the section depth. Only actual section marker characters are counted.

These rules do not restrict underscores in section names. A section name MAY begin with `_`, even without whitespace after the marker sequence. That underscore is part of the name.

For example:
```yini
^_name          // Depth 1, name "_name".
^ _name         // The same header with a space for readability.
^^_^_name       // Depth 3, name "_name"; marker sequence "^^_^".
^_              // Depth 1, name "_".
```

For example, the following are equivalent:
```yini
^^^^^ Section    // depth 5
^^_^^_^ Section  // depth 5

^^^^^^ Section   // depth 6
^^^_^^^ Section  // depth 6

^^^^^^^^^ Section   // depth 9
^^^_^^^_^^^ Section // depth 9
```

These following examples are all invalid:
```yini
^^_ Section      // ❌ Invalid: extra text after the section name "_".
^__^ Section     // ❌ Invalid adjacent underscores.

_^ Section       // ❌ Invalid leading underscore.
^_ Section       // ❌ Invalid: extra text after the section name "_".

^_< Section      // ❌ Invalid: section marker characters must not be mixed.
^1_0 Section      // ❌ Invalid: separators are not allowed in numeric shorthand section headers.
```

#### 5.3.2. Shorthand Section Heading

Numeric shorthand uses `<marker><n> <name>`, where `<marker>` is one of the allowed section marker characters (`^`, `§`, `>`, `<`) and `<n>` is a decimal section depth from 1 to 255. The first digit of `<n>` MUST be `1`–`9`; leading zeros are invalid. At least one space or tab MUST separate `<n>` from the section name. Numeric shorthand MAY be used at any depth and MUST be used for depths greater than 9. For levels 1–9, repeated markers such as `^`, `^^`, and `^^^` are RECOMMENDED. The nesting rules in Section 5.3 still apply.

For example:
- To go from depth 9 to depth 10: write `^10 SectionName`.  
- To go from depth 10 to depth 11: write `^11 SectionName`.  
- To go from depth 11 to depth 12: write `^12 SectionName`.  
- And so on...

This prevents arbitrarily long runs of the same marker beyond level 9.  

**✅ Valid examples:**

Repeated marker form for levels 1–9:

```yini
^         Level1      // depth 1
^^        Level2      // depth 2
^^^       Level3      // depth 3
^^^^      Level4      // depth 4
^^^^^     Level5      // depth 5
^^^^^^    Level6      // depth 6
^^^^^^^   Level7      // depth 7
^^^^^^^^  Level8      // depth 8
^^^^^^^^^ Level9      // depth 9
```

For deeper repeated marker headers, `_` separators may make the section depth easier to read:

For example:
```yini
^^^_^       Level4      // depth 4
^^^_^^      Level5      // depth 5
^^^_^^^     Level6      // depth 6
^^^_^^^_^   Level7      // depth 7
^^^_^^^_^^  Level8      // depth 8
^^^_^^^_^^^ Level9      // depth 9
```

Numeric shorthand form for levels deeper than 9:

```yini
^         Level1      // depth 1
^^        Level2      // depth 2
^^^       Level3      // depth 3
^^^^      Level4      // depth 4
^^^^^     Level5      // depth 5
^^^^^^    Level6      // depth 6
^^^^^^^   Level7      // depth 7
^^^^^^^^  Level8      // depth 8
^^^^^^^^^ Level9      // depth 9
^10       Level10     // depth 10
^11       Level11     // depth 11
```

Numeric shorthand may also be used for levels 1–9:

```yini
^1     Level1      // depth 1
^2     Level2      // depth 2
^3     Level3      // depth 3
```

Going back to a shallower level is allowed:

```yini
^      Level1
^^     Level2
^^^    Level3
^      BackTo1     // allowed: returns to depth 1
^^     BackTo2     // allowed: descends from depth 1 to depth 2
```

**❌ Invalid examples:**

Skipping an intermediate level is invalid:

```yini
^      Level1
^^^    Level3      // ❌ Invalid: depth 2 was not established
```

The same rule applies to numeric shorthand:

```yini
^1     Level1
^2     Level2
^9     Level9      // ❌ Invalid: depths 3 through 8 were not established
```

A numeric shorthand section header requires whitespace after the number:

```yini
^7Level7           // ❌ Invalid: shorthand requires at least one space or tab after the number
```

A numeric shorthand section depth MUST NOT have a leading zero:

```yini
^01 Name           // ❌ Invalid: leading zero; use ^1 Name
```

Using ten or more repeated section markers is invalid:

```yini
^^^^^^^^^^ Level10 // ❌ Invalid: use numeric shorthand instead
```

Numeric shorthand does not permit skipping intermediate nesting levels. It is only an alternative notation for expressing a section depth and a notation for going deeper than level 9. Therefore, a shorthand section at level `n` is valid ONLY if level `n - 1` has already been explicitly established in the current nesting chain.

## 6. String Literals

**Prefix Glossary Table:**

String prefixes are **case-insensitive**, e.g. lowercase `r` behaves identically to `R`, and `block`, `BLOCK`, and `Block` behave identically. The short Block String prefix may be `b` or `B`.

|Prefix| Type Name      | Behavior Summary|
|------|----------------|---|
|_none_| Raw String     | Raw (default) if no prefix is used |
| R _(optional and has no functional effect)_   | Raw String     | No escapes; backslashes are literal (default) |
| E or e; C or c (deprecated aliases) | Escaped String | Supports escape sequences like `\n`, `\t` |
| b, B, or block in any capitalization | Block String | Multiline literal content with structural indentation removed |

Prefix R is optional and has no functional effect — raw strings are the default.

YINI defines two ordinary string behaviors and two delimiter forms:
- Behavior:
  * Raw behavior: escape sequences are not interpreted.
  * Escaped behavior: escape sequences are interpreted.
- Delimiter form:  
  * Single-line quoted form: `'...'` or `"..."`.
  * Triple-quoted form: `"""..."""`.

Combining these gives Raw Strings, Escaped Strings, Raw Triple-Quoted Strings, and Escaped Triple-Quoted Strings. The `C` and `c` prefixes remain supported as deprecated aliases for `E` and `e`; see Section 6.2.

Block Strings are a separate triple-quoted form that removes structural indentation and keeps content line breaks as LF. See Section 6.4.

The [literal control character table](#literal-control-characters) applies to each string form below.

String literals in YINI **MUST be enclosed** in either single quotes `'` or double quotes `"`, or optionally in triple double quotes `"""` — even in lenient mode. You MAY use whichever is preferred or most appropriate for the context.

**Quote character note:** In this specification, the quote characters used to delimit strings are the plain ASCII quote characters:

- Single quote: `'` U+0027 APOSTROPHE
- Double quote: `"` U+0022 QUOTATION MARK

Typographic or curly quotation marks such as `‘`, `’`, `“`, and `”` are ordinary Unicode text characters. They do not begin or end YINI string literals.

**Note:** Text MUST be enclosed in quotation marks to be parsed as a string literal.

**YINI supports a number of string literal forms:** single-line quoted strings, Escaped strings, Triple-Quoted strings, and Block Strings. Ordinary string behavior is determined by the optional prefix before the opening quote sequence.

The `R` prefix is optional and has no semantic effect because Raw strings are the default. The `E`/`e` prefixes enable escape-sequence interpretation; the deprecated `C`/`c` aliases have the same behavior.

Triple-Quoted Strings may also use the `R`/`r` or `E`/`e` prefixes, including the deprecated `C`/`c` aliases for `E`/`e`. Without a prefix, a Triple-Quoted String is Raw by default. YINI supports multi-line strings via Triple-Quoted Strings.

String behavior is controlled by an optional prefix before the opening quote sequence:

- No prefix: Raw string behavior.
- `R` or `r`: Raw string behavior; allowed for explicitness only.
- `E` or `e`: Escaped string behavior; escape sequences are interpreted. The deprecated `C`/`c` aliases have the same behavior.

This applies to both single-line quoted strings and ordinary Triple-Quoted Strings. Triple-Quoted Strings without a prefix are Raw by default. The `b` or `B` prefix, or `block` in any capitalization, selects the separate Block String form.

**Rules and Behavior for Strings:**
- All string literals **MUST start and finish on the same line**, except for **Triple-Quoted Strings** (see Section 6.3), which can span multiple lines, and **Block Strings** (see Section 6.4), which must span multiple lines.
- Multiple string literals can be **concatenated** to create longer strings (see [Section 6.6, "String Concatenation"](#66-string-concatenation)).

**String Overview**

| Type                   | Quotes Used              | Multi-Line | Escapes | Trims Whitespace | Description                          | Similar To            |
|------------------------|--------------------------|------------|---------|------------------|--------------------------------------|------------------------|
| Raw String             | `'...'` or `"..."`       | ❌ No      | ❌ No   | ❌ No             | Simple 1-line literal                | Raw literal strings    |
| Escaped String         | `E'...'` or `e"..."`      | ❌ No      | ✅ Yes  | ❌ No             | 1-line with escapes                  | C / JSON strings       |
| Triple-Quoted (Raw)    | `"""..."""`              | ✅ Yes     | ❌ No   | ❌ No             | Multi-line raw text                  | Python raw triple-quote |
| Escaped Triple-Quoted  | `E"""..."""` or `e"""..."""` | ✅ Yes | ✅ Yes  | ❌ No             | Multi-line with escapes              | Python triple-quote     |
| Block String           | `b"""`, `B"""`, or `block"""` (any capitalization), then optional ASCII spaces or tabs and a line break | ✅ Required | ❌ No | ✅ Structural indentation only | Literal multiline text, such as scripts or SQL queries | YAML literal block scalar |

### 6.1. Raw Strings (R-Strings)
A raw string is enclosed in either single quotes (`'...'`) or double quotes (`"..."`).

Raw strings do not interpret escape sequences, backslashes (`\`) are treated as ordinary characters.

To include a single quote, use double quotes as the delimiter. To include a double quote, use single quotes as the delimiter.

Raw strings MUST NOT contain line breaks. For multi-line raw text, use a Triple-Quoted String.

Raw strings are particularly suitable for representing file paths and other literal text.

Examples:
```yini
single_quote = "Amanda's file"
double_quote = 'He said "hello"'

path_raw1 = "C:\Users\Kim\Documents"  // Raw string
path_raw2 = "D:\Users\John Smith\"    // The final backslash is part of the string content.
path_raw3 = '/home/Leila Häkkinen'
path_raw4 = '/Users/kim-lee'
```

The value of `path_raw2` is:
```txt
D:\Users\John Smith\
```

Important: In Raw strings, a backslash before the closing quote does not escape the quote.

Curly quotation marks may appear inside quoted strings as ordinary text:

```yini
meaning = "It comes from Greek akmḗ (ἀκμή), meaning “the highest point” or “best”."
```

In the above example, the outer `"` characters are plain ASCII double quotes and delimit the string. The inner `“` and `”` characters are typographic quotation marks and are part of the string value.

#### Raw String Prefix
Any string enclosed in single quotes (`'`) or double quotes (`"`) MAY be prefixed with `R` or `r` to explicitly mark it as a Raw String. This prefix is optional because strings are raw by default.

<a id="62-classic-strings-c-strings"></a>

### 6.2. Escaped Strings (E-Strings)
An Escaped String is a string literal prefixed with `E` or `e`. Escaped Strings interpret escape sequences before the final string value is produced. The prefix is not preserved in the resulting data model.

**Deprecated aliases:** *Classic String* is the deprecated name for an Escaped String. The `C`/`c` prefixes remain supported as deprecated aliases for `E`/`e`, with identical escape rules and resulting string values in both parsing modes, including Triple-Quoted forms. New documents SHOULD use `E`/`e`, and documentation SHOULD use the name *Escaped String*.

For a control character forbidden in the source, use an escape from §6.2.1.

Single-line quoted Escaped Strings MUST begin and end on the same logical line.

Examples:
```yini
text1 = E"hello\nworld"

text2 = e"This is a newline \n and this is a tab \t character."

text3 = e"hello\nworld"
```

`text1`, `text2`, and `text3` parse to strings containing an actual newline, not the two characters `\` and `n`. The `\t` in `text2` produces a tab.

#### 6.2.1. Escape Sequences

Escape sequences are supported only in Escaped Strings and their Triple-Quoted forms.

Unicode escape sequences MUST represent valid Unicode scalar values.  
Surrogate code points in the range U+D800 to U+DFFF are invalid.  

**Full list of escape sequences**  

The following escape sequences are case-sensitive:
- `\\` — Backslash.
- `\'` — Single quotation mark.
- `\"` — Double quotation mark.
- `` \` `` — Backtick.
- `\/` — Normal/forward slash (yields a plain `/`).
- `\0` — NUL (U+0000), null byte (0x00) in UTF-8. An ASCII digit (`0`–`9`) immediately after this escape MUST cause a parse error.
- `\?` — Literal question mark, provided for C/C++ compatibility.
- `\a` — Alert/bell (ASCII 7).
- `\b` — Backspace (ASCII 8).
- `\f` — Form feed (ASCII 12).
- `\n` — Newline (ASCII 10).
- `\r` — Carriage return (ASCII 13).
- `\t` — Tab (ASCII 9).
- `\v` — Vertical tab (ASCII 11).
- `\xhh` — Short Unicode escape, using exactly 2 hexadecimal digits. Denotes the Unicode code point U+00hh; never a raw byte, since YINI has no byte-string literal type.
- `\uhhhh` — Unicode code point in the range U+0000 to U+FFFF, using exactly 4 hexadecimal digits.
- `\Uhhhhhhhh` — Unicode code point in the range U+00000000 to U+10FFFF, using exactly 8 hexadecimal digits.
- `\oOOO` — Octal Unicode character escape. Read the entire run of consecutive ASCII digits (`0`–`9`) immediately after `\o`. It MUST contain one to three digits, all in `0`–`7`, and its value MUST be at most octal `377` (U+00FF). An empty run or a run that fails any of these checks MUST cause a parse error in both modes.

Where:
- `h` = Hexadecimal digit: `0-9`, `a-f`, or `A-F`.
- `O` = Octal digit: `0-7`.

**Invalid escapes**

Invalid escape sequences MUST produce an error diagnostic in both modes. Examples include the following errors:
- `E"\o378"` contains a non-octal digit, `E"\o400"` exceeds the maximum value, and `E"\o3770"` has four digits. To append a digit, write `E"\o377" + "0"`.
- `E"\012"` is invalid. Use `E"\o12"` for LF or `E"\x0012"` for NUL followed by the characters `1` and `2`.

**Additional recommendation:** Implementations SHOULD explain unsupported
escape forms and suggest the valid YINI spelling. For example, C/C++-style octal
escapes such as `\1` through `\377` are invalid in both modes; use `\o1`
through `\o377` instead. A parser MAY continue after the error to report other
problems, but it MUST still mark the document as invalid. See Section 14.1.2,
"Graceful Degradation".

### 6.3. Triple-Quoted Strings
A **Triple-Quoted String** is a string literal that:
- **Begins** with `"""` and **ends** at the next `"""` sequence that is recognized as the closing delimiter.
- **May span multiple lines**, including embedded newline characters.
- In a Raw Triple-Quoted String, the sequence `"""` cannot appear as content because it terminates the string. In an Escaped Triple-Quoted String, quote characters may be escaped using `\"`.
- Without a prefix, a Triple-Quoted String is Raw: escape sequences are not interpreted.
- With an `E` or `e` prefix, escape sequences are interpreted using the same rules as Escaped Strings. The deprecated `C`/`c` aliases have the same behavior.
- With an `R` or `r` prefix, behavior is identical to the unprefixed Raw form. The `R` prefix is allowed only for explicitness.

By default, Triple-Quoted Strings are treated as **Raw** — escape sequences are not interpreted. To explicitly indicate that a Triple-Quoted String is raw, a prefix `R` (or `r`) MAY be used. This prefix is purely **syntactic sugar** and does not affect its default behavior.

If **prefixed with `E` or `e`**, the string supports escape sequences, just like single-line quoted Escaped Strings. The deprecated `C`/`c` aliases have the same behavior. This includes support for: `\n`, `\t`, `\\`, `\"`, `\xhh`, `\u1234`, `\o123`, etc.

#### Examples

Raw (default) Triple-Quoted Strings:
```yini
"""This is a multiline
string that spans
three lines."""

"""He said, "hello" and left."""

"""You can use double quotes (") inside."""
```

Escaped Triple-Quoted Strings (with `E` or `e` prefix and escapes enabled):
```yini
E"""This spans multiple lines with a tab\tand newline\n"""

e"""Quotes inside: "double" and 'single'"""

E"""This also interprets \n as a newline."""
```

Triple-Quoted Strings keep spaces, tabs, blank lines, and the positions of line breaks. In both lenient and strict mode, each source line ending (`LF`, `CRLF`, or `CR`) in the content MUST become one LF (`U+000A`) in the parsed value. This applies with or without a prefix.

Raw Triple-Quoted Strings keep backslashes literal. In Escaped Triple-Quoted Strings, source line endings MUST be normalized before escape sequences are interpreted. Characters produced by escapes MUST NOT be normalized. For example, `\r` produces CR, and `\r\n` produces CRLF. Use Escaped Strings when exact CR or CRLF characters are needed.

### 6.4. Block Strings

A Block String holds multiline, line-oriented text, such as a script or SQL query, as an ordinary YINI string value. Its content is not executed.

A Block String starts with `b`, `B`, or the word `block` in any capitalization, immediately followed by `"""`. The opening line MUST end with a line break. For `block`, uppercase and lowercase ASCII letters can be mixed: `block`, `BLOCK`, `Block`, and `bLoCk` all work. All these spellings have identical behavior in both parsing modes. Changing the prefix's capitalization does not change the case of the string content.

The closing `"""` MUST start a new line. Only ASCII spaces may precede it on that line.

In both modes, the parser MUST ignore any ASCII spaces (`U+0020`) and tabs (`U+0009`) immediately after either delimiter. After those spaces and tabs, the opening line MUST end. The closing line may end with a line break or at end-of-file. The following forms are also allowed after the closing quotes, with or without a space or tab before them.

- `//` or `#` starts a line comment. The parser ignores the rest of the line. The comment adds nothing to the string value.
- `+` joins the Block String to the next operand under the concatenation rules in [§6.6](#66-string-concatenation).
- `,` may follow a Block String wherever a list or inline object permits a comma. A comma after the last item is valid only in lenient mode.

Any other character in that position is an error. For example, `""" /* note */` is invalid. After a valid `+` or `,`, the usual comment rules apply, including `/* ... */` comments that span lines. Inside the block, comment markers are literal text. On content lines, trailing spaces and tabs are part of the value after the indentation rules below are applied.

**Valid in both modes.** Both values are `Hello`.

```yini
greeting = b"""
  Hello
""" // A comment

message = b"""
  Hello
""" # A comment
```

**Valid in both modes.** The first value is `Hello!`. The list contains the strings `one` and `two`.

```yini
message = b"""
  Hello
""" + /* Add punctuation. */ "!"

items = [
  b"""
    one
  """, /* The next item
          is on the following line. */
  "two"
]
```

```yini
build = block"""
    npm install
    npm run build
      --verbose
    npm test
"""
```

The value has four lines: `npm install`, `npm run build`, `  --verbose`, and `npm test`. It has no line break after `npm test`.

The short prefix can also introduce a SQL query:

```yini
query = B"""
    SELECT id, name
    FROM users
    WHERE active = TRUE;
"""
```

The line break ending the opening line and the line break immediately before the closing line are structural and are excluded from the value. Each remaining source line ending (`LF`, `CRLF`, or `CR`) MUST become one LF (`U+000A`) in the parsed value, in both parsing modes.

The [literal control character table](#literal-control-characters) applies to Block String content.

To include a final LF in the value, leave an empty content line immediately before the closing delimiter:

```yini
cmd = b"""
  npm i

"""
```

The parsed value is `"npm i\n"`. Without the empty content line, it is `"npm i"`.

The first content line containing anything other than ASCII spaces (`U+0020`) sets the margin, also called the structural indentation. Count the ASCII spaces at the start of that line. Every such line MUST start with at least that many spaces. Remove exactly that many from each such line and keep any extra spaces. Tabs and Unicode spaces are content and MUST be preserved.

**Invalid example.** The six spaces before `first` set the margin. The four spaces before `second` fall short of it.

```yini
fragment = b"""
      first
    second
"""
```

If those leading spaces are part of the text you want to keep, use an ordinary raw triple-quoted string (`"""` without a prefix). It preserves the leading spaces on every line, even when the first line starts farther to the right than the next. See [§6.3, Triple-Quoted Strings](#63-triple-quoted-strings).

A line containing a tab or a Unicode space character is not an empty or space-only line, even if it looks blank. It MUST satisfy the same structural indentation rule as any other line containing a non-space character. If it is the first such line, it sets the structural indentation. For example, when the structural indentation is two ASCII spaces, a line containing two ASCII spaces followed by a tab is valid and keeps the tab in the value. A line starting directly with a tab is invalid in that case.

On a space-only content line, remove up to the structural indentation and preserve any extra spaces. A space-only line before the first nonempty line is invalid if it has more spaces than the structural indentation. If there are no nonempty content lines, use the greatest number of spaces on any content line as the structural indentation; all such lines become empty. Blank content lines and their intervening line breaks remain in the value.

A `"""` sequence at the start of a line or after only ASCII spaces begins the closing delimiter. A `"""` sequence anywhere else on a content line is literal. There is no escape for a closing delimiter.

**Invalid in both modes.** The quotes before `Docstring` close the block. The word that follows them is an error on that line.

```yini
text = b"""
  """Docstring"""
"""
```

**Valid in both modes.** To store that one line, enclose it in single quotes. All six double quotes are part of the value.

```yini
text = '"""Docstring"""'
```

Backslashes and quotes are literal; YINI escape sequences are not interpreted. Only `b`, `B`, and `block` in any capitalization select this form. `e"""..."""` and `E"""..."""` remain Escaped Triple-Quoted Strings. The Block String prefixes MUST NOT be used with single-line quoted strings: `block"..."`, `block'...'`, `b"..."`, and `b'...'` are invalid in any capitalization. The former `command` prefix is no longer supported and MUST be rejected in both parsing modes.

**Application note:** Block Strings contain text. The application decides how to use that text, such as submitting a SQL query or running a script, and converts LF to another line-ending form if needed. For scripts, the application chooses the shell or terminal interface; YINI does not guarantee that commands work across operating systems or shells.

### 6.5. String Types Summary

Ordinary YINI string behavior is determined by two independent choices:

1. The optional string prefix:
   - No prefix, `R`, or `r` means Raw string behavior.
   - `E` or `e` means Escaped string behavior, where escape sequences are interpreted. The deprecated `C`/`c` aliases have the same behavior.

2. The delimiter form:
   - Single-line quoted strings use `'...'` or `"..."`.
   - Triple-Quoted Strings use `"""..."""` and may span multiple lines.

Raw strings are the default. The `R` prefix is allowed for explicitness only and has no semantic effect. The `E`/`e` prefixes enable escape-sequence interpretation; the deprecated `C`/`c` aliases have the same behavior.

Block Strings use `b"""`, `B"""`, or `block"""` in any capitalization, with the distinct multiline and indentation rules in Section 6.4.

For the full table of supported string forms, see the overview table at the beginning of Section 6.

### 6.6. String Concatenation

String **concatenation** joins two or more operands with the plus sign (`+`) and produces a single string value. Implementations SHOULD treat concatenation as a value-level expression.

**Example:**
```yini
greeting = "Hi, " + "hello " + "there"
```

The result is equivalent to:
```yini
greeting = "Hi, hello there"
```

#### Concatenation Operands

Implementations MUST NOT evaluate `+` between operands as numeric addition. For readability, whitespace around `+` is recommended, but not required.

Between concatenation operands, `+` MUST be interpreted as the operator, even without surrounding whitespace. A numeric operand MAY have its own leading `+` or `-` sign. Thus, `"a"+42` joins `"a"` and `42`, while `"a"++42` joins `"a"` and `+42`.

**In strict mode**, all concatenation operands MUST be string literals. This includes Raw/R-prefixed strings, Escaped/E-prefixed strings (including deprecated `C`/`c` aliases), ordinary Triple-Quoted Strings, and Block Strings.

**In lenient mode**, a concatenation expression MUST begin with a string literal. Additional operands MAY be string literals, number literals, boolean literals, or null literals. Non-string scalar operands MUST be converted to strings as defined in [§6.7](#67-scalar-conversion-in-lenient-concatenation) before concatenation.

Lists and inline objects MUST NOT be operands in concatenation expressions.

Each string literal is interpreted according to its own string type before concatenation. For example, Escaped Strings interpret escape sequences before being joined, while Raw Strings preserve backslashes literally.

To join another operand after a Block String, put `+` on the same line as the closing quotes, as shown in §6.4. Starting the next line with `+` is invalid.

**Valid in both lenient and strict mode:**
```yini
escaped = E"Line 1\n" + "Line 2"

longText = "This is a long string that is split " +
           "across multiple source lines."
```

**Valid in lenient mode only:**
```yini
str1 = "Port: " + 8080
// "Port: 8080"

str2 = "1" + 2 + 3
// "123"

str3 = "a" + +42
// "a42"

str4 = "a"+42
// "a42"

str5 = "a"++42
// "a42"

str6 = "a"+-42
// "a-42"
```

**Invalid in both modes:**
```yini
invalid1 = 1 + 2 + 3          // Invalid: YINI does not define numeric addition.
invalid2 = 8080 + " is port"  // Invalid: concatenation must begin with a string literal.
invalid3 = 1 + 2 + "3"        // Invalid: concatenation must begin with a string literal.
```

**Rationale:** Requiring concatenation to begin with a string literal avoids ambiguity between numeric-looking expressions and string concatenation. For example, `1 + 2 + "3"` could otherwise be misread as either `"123"` or `"33"`. YINI rejects such expressions instead, because `+` is not a numeric addition operator.

#### Multi-line Concatenation

A line break MAY occur after the `+` operator. This allows long string values to be split across multiple source lines without using a Triple-Quoted String.

A line break MUST NOT occur before the `+` operator. The `+` operator MUST appear on the same logical line as the preceding operand.

Valid:
```yini
longText = "This is a long string that is split " +
           "across multiple source lines, but " +
           "the resulting value is still one string."
```

Also valid:
```yini
title = "YINI: " + "A human-friendly configuration format"
```

Invalid:
```yini
message = "hello "
        + "world"  // ❌ Invalid: newline before +
```

For longer human-authored text where line breaks should be kept, authors SHOULD use Triple-Quoted Strings instead. Source line endings become LF; see Section 6.3. Triple-Quoted String literals MAY still be used as operands in a concatenation expression.

### 6.7. Scalar Conversion in Lenient Concatenation

Scalar conversion to strings is allowed only in lenient-mode concatenation expressions.

Conversion is deterministic for each scalar type. Strings, booleans, and null
are converted from their parsed scalar values. Numbers are converted using the
normalized lexical representation defined below.

In lenient mode, scalar operands are **converted to strings before concatenation** as follows:
- Strings use their interpreted string value.
- Numbers are converted using a normalized representation of their source literal. Implementations MUST perform this normalization without first
  converting the literal through a potentially lossy host-language
  floating-point type.

  **This means 1e3 remains 1e3, rather than becoming 1000.**

  Numeric normalization applies these rules:
  * Digit separators (`_`) are removed.
  * A leading plus sign (`+`) is removed.
  * An uppercase exponent marker (`E`) is normalized to lowercase `e`.
  * A plus sign immediately following an exponent marker is removed.
  * Non-decimal integer literals are converted exactly to base-10 notation.
  * Other digits, decimal points, minus signs, and exponent digits are
    preserved.
  * Negative zero remains negative zero.

  Examples:
  * `42` becomes `42`.
  * `1_000` becomes `1000`.
  * `+100` becomes `100`.
  * `1.50` remains `1.50`.
  * `3E+04` becomes `3e04`.
  * `-0` remains `-0`.
  * `0xFF` becomes `255`.
- Booleans are converted to `true` or `false`.
- Null is converted to `null`, whether written as `null` or `None` in any casing.
- Base prefixes such as `0x`, `0b`, `%`, `0o`, `0z`, and `hex:` are not preserved during scalar-to-string conversion. The `%` prefix is deprecated; see [Section 7.4](#74-number-formats).
- Lists and inline objects MUST NOT be converted to strings. See [§6.6](#66-string-concatenation) for the permitted operands.

Example:
```yini
a = "a: " + 9999
b = "n: " + 1_000_000
c = "hex: " + 0xFF

d = "bool: " + YES
e = "null: " + NULL
```

This produces:
```txt
a: 9999
n: 1000000
hex: 255

bool: true
null: null
```

Multi-line concatenation does not change scalar conversion rules:
```yini
label = "port-" +
        5432
```

In lenient mode, this produces:
```txt
port-5432
```

In strict mode, this is invalid because `5432` is not a string literal (it's a number literal).

## 7. Number Literals
### 7.1. Numbers
YINI supports both integer and floating-point literals. Numbers may be signed and written in decimal notation.

A leading `+` or `-` sign MUST immediately precede the number, without whitespace or comments between them. Signs within exponents follow the same adjacency rule.

- **Integers:** A sequence of digits, optionally prefixed with + or -.

A decimal integer part MUST NOT contain unnecessary leading zeros. The literal
`0` is valid, but `00`, `01`, and `007` are invalid. This rule also applies
when the integer part is followed by a decimal fraction or exponent.

Examples:

- Valid: `0`, `0.5`, `0e3`
- Invalid: `00`, `01`, `00.5`, `01e3`

A grammar or lexer MAY recognize a leading-zero form for diagnostic recovery,
but semantic validation MUST reject it as an invalid YINI number literal.

- **Floats:** A number is considered floating-point if it includes a decimal point, an exponent (`e` or `E`), or both. A decimal point is not required when using exponent notation, so `3e4` is also a valid floating-point number.

Valid decimal number forms include:

- Integer: `42`, `-12`, `+100`
- Decimal fraction: `3.14`, `-0.5`, `.5`
- Exponent notation: `3e4`, `1.5e10`, `2E-3`, `+4E+8`

A decimal point MUST be followed by at least one digit. Therefore, `1.` is
invalid. The exponent marker MUST be followed by an optional sign and at
least one decimal digit.

**Numeric interpretation (both modes):**

The following rules define the numeric value of each literal. They apply in
both lenient and strict mode.

- **Integers:** Decimal literals without a decimal point or exponent, and all
  supported non-decimal integer literals, MUST be interpreted exactly within
  the signed 64-bit range: **-9223372036854775808 through 9223372036854775807**
  (-2^63 through 2^63 - 1). Integers outside this range MUST produce an error
  diagnostic. Integer `-0` has the same numeric value as `0`.
- **Floating-point values:** Decimal literals containing a decimal point or
  exponent MUST be converted to IEEE 754 binary64 (double precision), using
  **round-to-nearest, ties-to-even**. This selects the nearest representable
  value; if two values are equally close, the one with an even least-significant
  significand bit is selected. Ordinary rounding, such as the binary64
  approximation of `0.1`, is valid and does not require a warning.
- **Overflow:** A floating-point literal that rounds to positive or negative
  infinity MUST produce an error diagnostic. NaN and infinity are not YINI
  numeric values.
- **Underflow to zero:** A floating-point literal with a nonzero mathematical
  value that rounds to zero MUST produce an error diagnostic. Small values that
  round to a nonzero binary64 subnormal value are permitted. Subnormal values
  are the smallest nonzero values binary64 can represent.
- **Negative zero:** The sign of floating-point negative zero MUST be preserved,
  for example in `-0.0` or `-0e3`.

A conforming parser MUST support the integer range and floating-point values
defined above. If its ordinary host-language type cannot hold an integer
exactly, it MUST use another lossless numeric representation, such as an
arbitrary-precision integer or a numeric wrapper. It MUST NOT silently round
the integer or expose it as a string instead of a number.

If a caller requests a later conversion to a host type that cannot preserve the
parsed numeric value, that conversion MUST report an error rather than silently
change the value.

These numeric checks also apply to operands in lenient-mode concatenation.
After validation, number-to-string conversion MUST use the source-literal
normalization in Section 6.7, rather than formatting the rounded numeric value.
For example, `"value: " + 1.50` produces `"value: 1.50"`. The source spelling
of integer `-0` also remains `-0` during that normalization.

**Valid numeric values in both modes:**

```yini
^ Numbers
large_id = 9007199254740993       // Exact integer; must not be rounded.
minimum_integer = -9223372036854775808
maximum_integer = 9223372036854775807
ratio = 0.1                     // The defined binary64 approximation.
small = 5e-324                  // Rounds to the smallest positive subnormal.
negative_zero = -0.0            // Preserves the floating-point sign.
/END
```

**Invalid numeric values in both modes:**

```yini
^ InvalidNumbers
too_large = 9223372036854775808  // Error: outside the signed 64-bit range.
too_small = -9223372036854775809 // Error: outside the signed 64-bit range.
overflow = 1e400                // Error: would round to infinity.
underflow = 1e-400              // Error: nonzero value would round to zero.
/END
```

### 7.2. Digit Separators

For readability, an underscore (`_`) MAY be used as a digit separator inside number literals. It MAY appear either immediately after a supported base prefix or between successive digits. Digit separators do not change the numeric value.

Underscores are permitted:
- Between two digits.
- Immediately after a supported base prefix: `0b`, `0o`, `0x`, `0z`, `hex:`, or the deprecated `%` prefix (see [Section 7.4](#74-number-formats)).
- Between digit groups in base-prefixed number literals, such as `0xFF_AA`, `0b1010_1100`, or `0o755_644`.
- Underscores MAY appear between digits in the integer part, fractional part, or exponent part of a decimal number.

Underscores are not permitted:
- At the beginning or end of a number literal.
- Adjacent to another underscore.
- Inside or between the characters of a base prefix.
- Underscores MUST NOT appear adjacent to a sign character (`+` or `-`), decimal point (`.`), exponent marker (`e` or `E`), or at the beginning or end of the literal.

Examples:
```yini
decimal = 2_468
binary = 0b_1101
octal = 0o_640
hex1 = 0x_A3
hex2 = 0xCafe_Babe
hex3 = 0x_ab_cd_12_34_ef
hex4 = hex:_FF_AA_00
binary_grouped = 0b1111_0001
binary_alt = %_1010  // Deprecated: use 0b_1010 instead.
octal_grouped = 0o6_4_0
duodecimal = 0z_2EX9
```

Invalid examples:
```yini
bad1 = 73_        // ❌ INVALID: Trailing underscore.
bad2 = 5__9       // ❌ INVALID: Adjacent underscores.

bad3 = 0_b1101    // ❌ INVALID: Underscore breaks the base prefix.
bad4 = _73        // ❌ INVALID: Leading underscore.

bad_hex1 = 0x_    // ❌ INVALID: Separator without any digits.
bad_hex2 = hex:_  // ❌ INVALID: Separator without any digits.
```

### 7.3. Exponent Format
Exponent notation uses the format:
```
<significand>e<sign><exponent>
```

Where:
- `<significand>` is an integer or decimal number.
- `e` may be written as `e` or `E`.
- `<sign>` may be `+`, `-`, or omitted.
- `<exponent>` is a sequence of decimal digits, optionally using permitted digit separators.

Example:
```
3e4 // Is same as 3 × 10⁴ = 30000
```

```yini
valid_float = 1_000.5_25
valid_exp = 1.5e1_0

bad_float1 = 1_.5     // ❌ Invalid: underscore before decimal point.
bad_float2 = 1._5     // ❌ Invalid: underscore after decimal point.
bad_exp1 = 1_e10      // ❌ Invalid: underscore before exponent marker.
bad_exp2 = 1e_10      // ❌ Invalid: underscore after exponent marker.
```

### 7.4. Number Formats
In addition to standard decimal numbers (base-10), YINI supports other number base literals as well.

Hexadecimal values also allow **alternative notations** for convenience and readability. Binary values retain the deprecated `%` alternative described below.

All integer forms below MUST follow the signed 64-bit range in [Section 7.1](#71-numbers), in both parsing modes. A base prefix does not change the numeric type or range.

For example, `0x7FFFFFFFFFFFFFFF` is valid. `0x8000000000000000` and `0xFFFFFFFFFFFFFFFF` exceed the maximum and MUST produce an error diagnostic.

| Number Format (case-insensitive) | Alternative Format | Description | Base | Notes |
|----------|--|---|---|---|
| `3e4`    | - | Exponent notation number | 10-base | Result: `3 × 10⁴`
| `0b1010` | `%1010` (deprecated) | Binary number prefix | 2-base | Digits: `0` and `1` only
| `0o7477` | - | Octal number | 8-base prefix | Digits: `0`–`7`
| `0z2EX9` | `0z2BA9` | Duodecimal (AKA dozenal) prefix | 12-base | `X` = `A` = 10, `E` = `B` = 11 (case-insensitive)
| `0xF390` | `hex:F390`, `HEX:f390` | Hexadecimal number prefix | 16-base | `0`–`9`, `a`–`f` (or `A`–`F`) = 10–15 

**Deprecated:** The `%` binary prefix is deprecated. New documents SHOULD use the `0b` prefix. The `%` form remains valid in both parsing modes and has the same numeric value, range, and digit-separator rules as the `0b` form. In both parsing modes, implementations SHOULD issue a deprecation warning when encountering a `%`-prefixed binary literal, recommending the `0b` prefix instead. For example: "The `%` binary prefix is deprecated. Use `0b` instead."

**Note:** All prefix-based number formats in YINI are case-insensitive. For example, `0xF390`, `0XF390`, `0xf390`, and `0Xf390` are all valid hexadecimal literals.

```yini
color1 = hex:fa90
color2 = Hex:Fa90
color3 = HEX:FA90
```

The `#` character is not a hexadecimal prefix in YINI. Outside string literals and backticked identifiers, `#` always begins a comment.

In the `hex:` form, the value after `hex:` MUST contain hexadecimal digits and permitted digit separators only. The `0x` prefix is not used inside the `hex:` form.

The `hex:` prefix applies only in a value position. Where a member key is expected and `:` is permitted as its separator, `hex:10` MUST be read as the key `hex` assigned decimal `10`. This includes root-level and section-level members in lenient mode and inline object members in both modes.

```yini
hex:10              // Lenient assignment to key hex, with decimal value 10.
color = hex:10      // Hexadecimal value 10, equal to decimal 16.
object = { hex:10 } // Object key hex, with decimal value 10.
```

```
color1 = hex:FFAA00     // ✅ valid
color2 = 0xFFAA00       // ✅ valid
color3 = hex:_FF_AA_00  // ✅ valid
color4 = hex:0xFFAA00   // ❌ invalid
color5 = hex: FFAA00    // ❌ invalid
```

## 8. Boolean and Null Literals

### 8.1. Booleans
Boolean literals in a YINI document **are case-insensitive** and may be written as follows:
- Treated as **TRUE** (by the parser or implementation):
  - `true`
  - `yes`
  - `on`
- Treated as **FALSE**:
  - `false`
  - `no`
  - `off`

The engine MUST convert the literal value to the corresponding Boolean value in the host language.

### 8.2. Null Literal
The keywords `null` and `None` are case-insensitive spellings of the same null value. Both are valid wherever a null literal is allowed, in either mode. The recommended canonical spelling is `null`.

```yini
^ Settings
first = null
second = None
third = nOnE
items = [null, NONE]
object = { value: None }
```

Quoted forms such as `"None"` are strings. In identifier positions, these spellings are ordinary case-sensitive names. For example, `None = NONE` defines a key named `None` with a null value, and `none` is a different key.

Every assignment MUST have an explicit value. If the logical line ends or reaches EOF before a value begins, the assignment MUST produce an error in both modes. This includes assignments followed only by whitespace or comments. Missing list items and missing inline object values are also errors. Recovery MUST NOT accept the document by inserting null or dropping the incomplete member.

```yini
^ Settings
missing =              // Error in both modes: Missing value.
color = #FF9900         // Error in both modes: The intended value is a comment.
object = { value: }     // Error in both modes: Missing object value.
items = [1, , 2]        // Error in both modes: Missing list item.
```

An explicit empty string (`""` or `''`), list (`[]`), or object (`{}`) is a value and is valid in both modes.

Trailing commas do not create null values. A trailing comma is ignored in lenient mode and MUST produce an error in strict mode:

```yini
items = [1, 2, ]        // Lenient mode: [1, 2]. Strict mode: Error.
object = { value: 1, }  // Lenient mode: { value: 1 }. Strict mode: Error.
```

## 9. Object Literals

### 9.1. Objects (using `{` and `}`)

YINI supports inline objects as a compound value type. An inline object contains zero or more object members enclosed in braces `{` and `}`.

An inline object behaves like a map or dictionary. Each object member has a key and a value, and members are separated by commas. Objects may be nested; an object value may itself contain another inline object.

An empty object `{ }` is valid in both lenient and strict mode.

An object has the following canonical form:

```txt
<identifier> = { <key1>: <value1>, <key2>: <value2>, ... }
```

```yini
settings = { enabled: true, retries: 3 }
empty = { }
```

#### Syntax rules

For the placement of the opening brace `{` in an assignment, see [§4.3](#43-type-rules).

```yini
object1 =
{ a: 1, b: 2 }  // Invalid: `{` does not appear on the same line as `=`.
```

Each object member's value MUST begin on the same logical line as its separator. The object itself may span several lines.

✅ Valid:
```yini
object1 = { a: 1, b: 2 }

object2 = {
    a: 1,
    b: 2
}
```

❌ Invalid:
```yini
obj = {
    a:
        1  // Invalid: the value begins on the line after the separator.
}
```

The **key** in each object member follows the same identifier rules as any YINI key.

The **value** in each object member may be any supported YINI value type:
- String
- Number
- Boolean
- Null
- List
- Inline object

The following structural rules apply to inline objects:
- An inline object begins with `{` and ends with `}`.
- Between { and }, zero or more object members may appear.
- Object members are separated by commas.
- Leading commas are not allowed.
- Empty member slots are not allowed.
- In lenient mode only, a trailing comma after the last member is permitted and ignored.
- In strict mode, trailing commas are invalid.
- Whitespace is ignored except inside quoted strings and backticked identifiers.
- Where §3.3 allows a line comment, it may begin after a complete token, even without preceding whitespace. A comment marker MUST NOT split a token.
- Object member keys MUST be unique within the same inline object.
  * In lenient mode, the first object member definition wins: the first member MUST be kept, later duplicate object members MUST be ignored, and the implementation MUST report the duplicate as a warning diagnostic.
  * In strict mode, any duplicate object member key MUST result in an error.
  * Implementations MUST NOT silently overwrite an earlier object member with a later one.

The **canonical object member separator is `:`.** See Section 9.2, "Object Member Separators", for the exact separator rules in lenient and strict mode.

Examples:
```yini
// Valid in both lenient and strict mode.
obj1_a = { a: 1, b: 2 }
obj1_b = {
    a: 1,
    b: 2
}

// ✅ Valid in both lenient and strict mode.
obj2 = { }

// ✅ Lenient mode only: trailing comma is ignored.
obj3_a = { a: 1, b: 2, }
obj3_b = {
    a: 1,
    b: 2,  // Trailing comma here.
}

// ❌ Invalid in both modes: leading comma.
obj4_a = { , a: 1 }
obj4_b = {
    ,
    a: 1
}

// ❌ Invalid in both modes: empty member slot.
obj5_a = { a: 1,, b: 2 }
obj5_b = {
    a: 1,,
    b: 2
}
obj5_c = {
    a: 1,
    , 
    b: 2
}
```

A complete nested object example:
```yini
^ System

config = {
    name: "production",
    services: {
        web: {
            ports: [80, 443],
            routes: [
                { path: "/", secure: true },
                { path: "/api", secure: false }
            ]
        },
        database: {
            replicas: [
                { host: "db1", role: "primary" },
                { host: "db2", role: "secondary" }
            ]
        }
    }
}
```

### 9.2. Object Member Separators

Inside inline objects, `:` is the canonical member separator. For the placement of the value, see [§9.1, Syntax rules](#syntax-rules).

```yini
obj = { a: 1, b: 2 }
```

The canonical root-level and section-level spelling is defined in Section 4.3.
```yini
name = "Kim"
```

The following rules apply:
- In lenient mode, authors MAY use either `:` or `=`, and conforming lenient-mode parsers MUST accept both separators.
- In strict mode, inline object members MUST use `:`. Using `=` MUST produce an error, whether mixed with `:` or used consistently.
- Within a single inline object, mixing `:` and `=` is valid but discouraged in lenient mode. Conforming lenient-mode parsers MUST accept mixed separators.
- In lenient mode, both separators MUST produce the same parsed member and value.

```yini
// Canonical form, valid in lenient and strict mode.
obj1 = { a: 1, b: 2 }

// Lenient mode only.
obj2 = { a = 1, b = 2 }

// Discouraged in lenient mode; invalid in strict mode.
obj3 = { a: 1, b = 2 }
```


Conceptual grammar:

```
COLON =  ':';
EQUALS = '=';

// Lenient mode:
objectMember
  : KEY hspace* (COLON | EQUALS) hspace* value
  ;

// Strict mode:
objectMember
  : KEY hspace* COLON hspace* value
  ;
```

Where `hspace` means spaces/tabs only, no newlines.

## 10. List Literals
Lists in YINI correspond to *arrays* in JSON and many programming languages (e.g., in JavaScript).

YINI defines lists using square brackets `[ ]`, similar to JSON.

### 10.1. Bracketed Lists (`[...]`)
A list contains zero or more comma-separated values. A root-level or section-level member canonically assigns it with `=`, as in `items = [1, 2]`. Section 4.3 defines the lenient `:` alternative and the same-logical-line requirement for the opening `[`.

Whitespace (spaces, tabs, and newlines) is allowed within the brackets.

```yini
list1 = ["value1", "value2", "value3"]
list2 = [100, 200, 300]
list3 = []  // An empty list.
```

For convenience, a trailing comma (`,`) may optionally be included (only in lenient mode).

```yini
// A list with THREE items.
list1 = [
  "a",
  "b",
  "c",  // Trailing comma here is ignored (parse error in strict mode).
]

// A list with THREE items.
list2 = ["a", "b", "c", ]  // Trailing comma here is ignored.

// A list with FOUR items.
list3 = ["a", "b", "c", NULL]
```


```yini
// ❌ Invalid list literal.
items1 =
[
    "a",
    "b"
]

// ✅ Valid
items2 = [
    "a",
    "b"
]

```

❌ Invalid:
```yini
list =
["item1", "item2"]  // Invalid: Due to the newline in previous line.
```

✅ Valid:
```yini
list = ["item1", "item2"]
```

**Nested Lists**

Lists may contain other lists:
```yini
linkItems = [
	["stylesheet", "css/general.css"],
	["stylesheet", "css/themes.css"]
]
```

## 11. Reserved and Future Constructs
### 11.1. Future / Reserved Features _(For Future Use)_
The following features are reserved for potential support in future versions of the YINI specification. They are **not currently active** in this version, but their syntax and keywords **are reserved**.

#### 11.1.1. Anchors and Aliases
The syntax space for anchors and aliases is reserved for possible future use. These constructs would allow users to define reusable fragments within a configuration.

The exact anchor and alias syntax is not defined in this version.

Implementations of this specification MUST NOT assign normative meaning to these reserved constructs unless operating under an explicitly documented extension.

#### 11.1.2. Includes
The `@include` directive name is reserved for possible future file inclusion support.

These features are not implemented in this version. They are reserved for future use and MUST NOT be used for user-defined syntax.

#### 11.1.3. Date-time Type

Currently, the YINI **value types** in the specification map 1-to-1 to native JSON types. With that said, YINI does not currently support native date, time, or date-time types. All date and time values **SHOULD currently** be represented as strings.

Support for standardized date-time literals may be considered in a future version, once the core specification is stable.

## 12. Validation Rules
YINI enforces a set of validation rules to ensure the structure and content of files are consistent, unambiguous, and semantically correct. These rules fall into two main categories: **reserved syntax protections** and **well-formedness**. Validation ensures compatibility across implementations and minimizes user errors.

### 12.1. Reserved Syntax
Certain characters and keywords are **reserved** by the YINI specification for
internal syntax or future use. Using them outside their permitted contexts MUST
produce an error diagnostic in both lenient and strict mode.

#### 12.1.1. Reserved Characters
The following characters and character sequences are reserved by the YINI syntax and MUST NOT be used improperly outside of their defined contexts. They may appear inside quoted strings or backticked identifiers but are otherwise restricted:

| Character	| Usage Context	| Description |
|-----------|---------------|-------------|
| `=` | Assignment / lenient object separator | Assigns values to keys at root/section level. In lenient mode only, MAY also separate keys and values inside inline objects. |
| `^` | Section header | Used to denote section start |
| `:` | Object member separator / lenient assignment | Canonical separator inside inline objects. Also accepted for root-level and section-level assignments in lenient mode (Section 4.3). |
| `,` | Item separator | Used in lists |
| `+` | String concatenation / numeric sign | Joins concatenation operands; also used as a positive sign in numeric literals and exponents |
| `§` | Section header (Unicode alternative) | Used to denote section start |
| `>` | Section header (quote-like ASCII fallback) | Used to denote section start |
| `<` | Section header (ASCII fallback) | Used to denote section start |
| `/* */` | Block comment | Marks multi-line comment block |
| `//` | Inline comment |   |
| `#` | Comment | Begins a comment outside string literals and backticked identifiers; everything from `#` to the end of the line is ignored |
| `;` | Full-line comment |   |
| `[ ]` | List literal |  |
| `{ }` | Object literal |  |
| `` ` `` | Identifier delimiter | Opens and closes a backticked identifier |
| `--` | Line disabling |  |
| `/END` | Document terminator | Marks the end of a YINI document; case-insensitive, optional in lenient mode, and required in strict mode |
| `%` | Binary prefix (deprecated) | Begins a binary number; use `0b` instead (see [Section 7.4](#74-number-formats)) |
| `hex:` | Hexadecimal number prefix | Begins an explicit hexadecimal number literal; case-insensitive |
| `@` | Directive prefix | Reserved for future syntax |

#### 12.1.2. Reserved Keywords
The following keywords are restricted and SHOULD NOT be used as bare identifiers (e.g., for keys, values, or section names) unless enclosed in quotes or backticks:
- `/END` _(case-insensitive)_
- `@ver`, `@version`
- `@include`, `@anchor`, `@alias`

Use of these keywords outside their defined roles may result in a parse error.

### 12.2. Well-Formedness Requirements
A YINI file is considered **well-formed** if it adheres to the core syntactic and structural rules defined in this specification.

#### 12.2.1. Structural Requirements
Note: In lenient mode, top-level members outside any section may be accepted. In strict mode, the document structure is further restricted; see Section 12.3 and Section 13.1.

- In lenient (default) mode, a document MAY contain **zero or more root-level members, section-level members, and sections**. Conforming lenient-mode parsers MUST accept root-level orphan members.
- In strict mode, a document MUST contain **exactly one explicit top-level section**. All members MUST appear inside that section or one of its subsections.
- Section headers MUST begin with a valid marker (`^`, `§`, `>`, or `<`).
- In repeated/basic section headers, whitespace between the marker and the section name is optional.
- In numeric shorthand section headers, at least one space or tab is required after the number before the section name.
- Keys are case-sensitive. Spaces, quotes, and other special characters are allowed only in backticked identifiers.
- **Duplicate keys** within the **same section and nesting level** are not allowed.
  1. In lenient mode, the first definition wins: the first key definition MUST be kept, later duplicate key definitions MUST be ignored, and the implementation MUST report the duplicate as a warning diagnostic.
  2. In strict mode, any duplicate key MUST result in an error.
  3. In neither mode may an implementation silently overwrite an earlier key with a later one. This rule reflects an intentionally conservative approach. It avoids surprising behavior in large files and prevents accidental overrides later in the document.
- **Duplicate sections** with the same name under the **same parent section or document root** are not allowed.
  A duplicate section MUST produce an error diagnostic in both lenient and strict
  mode and make the document invalid. Implementations MUST NOT merge, overwrite,
  or extend the earlier section with the later section. A partial recovery
  result MUST NOT reinterpret the duplicate block's contents as belonging to
  another section or context. See Section 14.1.2 for partial recovery rules.
- **Member and subsection names share one namespace within a container.**
  A member and an immediate child section under the same document root or
  parent section MUST NOT have the same identifier.

  Such a cross-kind name collision MUST result in an error in both lenient
  and strict mode. Implementations MUST NOT overwrite, merge, coerce, or
  reinterpret either construct.

  This rule ensures that every well-formed YINI container can be represented
  as an object without losing information.

  Thus this becomes invalid:
  ```
  ^ A
  x = 1
  ^^ x // Error: conflicts with member `x` in section `A`.
  ```
- Lines that do not match any syntactic role (member, comment, section, terminator) are considered malformed.
- The document terminator (`/END`) is **optional in lenient (default) mode** and **required in strict mode**.
- **In lenient (default) mode, an empty document is permitted.** A document that contains only whitespace, comments, and/or disabled lines (`--`) is considered empty. In such cases, the parser MUST NOT fail; it SHOULD instead report a warning diagnostic indicating that the document appears empty or contains no meaningful content.
- **In strict mode, an empty document is invalid.** A document that contains only whitespace, comments, and/or disabled lines (`--`) MUST result in an error.

#### 12.2.2. Character Encoding
See [§2.1, File Encoding](#21-file-encoding) for the UTF-8 requirement and the handling of an initial byte order mark.

#### 12.2.3. Line Endings

Implementations MUST recognize the following line endings:

- LF (`U+000A`)
- CRLF (`U+000D U+000A`)
- CR (`U+000D`)

In lenient mode, mixed line-ending forms are allowed but SHOULD produce a
warning. In strict mode: A document MUST use one line-ending form
consistently, mixed forms MUST result in an error.

Parsers MUST check the file's original line endings before normalizing string values. Characters produced by escape sequences do not count as source line endings.

`EOF` MAY terminate an otherwise complete final logical line. Implementations MUST NOT reject an otherwise valid document solely because its final line has no trailing `LF`, `CRLF`, or `CR`. This rule applies in both lenient and strict mode.
  
#### 12.2.4. Valid Value Types
- Values MUST be one of the supported data types: **String**, **Number**, **Boolean**, **Null**, **List**, or **Object**.
- Boolean values are **case-insensitive**: `True`, `On`, `Yes`, etc.
- Null values: `null` and `None` in any casing are interpreted as the same null value.
- Member separators follow Sections 4.3 and 9.2.

#### 12.2.5. Document Terminator
**Note:** The authoritative syntax and placement rules for the document terminator are defined in Section 3.5, "Document Terminator". This section restates the validation requirements by mode.

- In lenient mode, the terminator is optional.
- In strict mode, the terminator is required.
- See Section 3.5, "Document Terminator", for terminator syntax.
- A valid YINI file in **strict mode** MUST end with the terminator marker (`/END`).
- A valid YINI file in **lenient mode** MAY end with the terminator marker (`/END`).
- A valid terminator line MAY end directly at `EOF`; a trailing line ending is not required.
- Only one terminator is permitted per file.
- Missing terminators:
  * **In lenient mode:** No error is required.
  * **In strict mode:** MUST be treated as an error.
- After the terminator, only whitespace and comments are allowed.
- Any other content appearing after the terminator MUST result in an error.

##### Table: Terminator Requirement by Mode
| Mode | Terminator Requirement |
|---|---|
| Lenient | Optional |
| Strict  | Required |

#### 12.2.6. Escaping and String Literals
- Escape sequences are **ONLY allowed** in Escaped strings and their Triple-Quoted forms, prefixed with `E`/`e` or the deprecated `C`/`c` aliases.
- Triple-Quoted Strings MUST use `"""` for both opening and closing (`'''` is not supported).
- Block Strings MUST use `b`, `B`, or `block` in any capitalization as the prefix immediately followed by `"""`, and satisfy the multiline delimiter and indentation rules in Section 6.4.

#### 12.2.7. Shortest Valid YINI Documents in Strict Mode
- **Valid short documents in strict mode:**
  - The shortest valid strict-mode document is:
    ```yini
    ^T
    /END
    ```
    **Note:** This document contains a single explicit top-level section named T and the required document terminator. The section is empty, so implementations SHOULD report a warning (see Section 5).

- **Invalid short documents:**
  - ❌  Invalid: no title section present in strict mode:
    ```yini
    /END
    ```

### 12.3. Lenient vs. Strict Modes

Non-strict mode (lenient mode) is the default mode of operation. Parsers SHOULD operate in this mode by default unless explicitly configured to use strict mode.

Some YINI parsers may support multiple **validation modes**:

#### Lenient Mode

- **Lenient mode** is the default mode of operation.
  - Useful for hand-edited configuration files.
  - Permissive with minor issues (for example, trailing commas after the last value/member are ignored, and mixed line endings are tolerated).
  - Root-level orphan members are permitted and MUST be accepted. In the abstract YINI data model, they are mounted directly on the document root alongside explicitly defined top-level sections.
  - The document terminator (`/END`) is optional in lenient mode and MAY be omitted entirely. If present, it marks the end of the YINI document. Any non-comment, non-whitespace content appearing after it MUST result in an error.
  - All typing rules still apply. For example, string literals MUST be quoted: if a value is not quoted, it is not a string — no exceptions.
  - Every assignment requires an explicit value. Missing values MUST produce an error (see Section 8.2).
  - A trailing comma after the last value/member inside a list or object is ignored.
  - Both member separators are accepted, as defined in Sections 4.3 and 9.2.
  - In lenient (default) mode, an empty document is permitted. For this purpose, a document containing only whitespace, comments, and/or disabled lines (`--`) is considered empty. An implementation MUST NOT treat such a document as a parse failure solely because it is empty; however, it SHOULD report a warning diagnostic indicating that the document appears empty or contains no meaningful content.

#### Strict Mode

- **Strict mode** is an optional mode with stricter rules.
  - Intended for production and tool-chain use.
  - Enforces full well-formedness.
  - Every assignment requires an explicit value, as in lenient mode (see Section 8.2).
  - Stray trailing commas after the last value/member inside lists and objects are not permitted.
  - Strict mode requires exactly one explicit top-level section. Any additional sections MUST appear only as subsections nested within that section. Top-level orphan members are not allowed in strict mode. Otherwise, an error MUST be reported.
  - A document declaring `@yini lenient` MUST produce a mode-mismatch warning in strict mode and MUST still satisfy all strict-mode content and structural requirements. See Section 2.4.1. Strict mode MAY also be used when the declaration is absent.
  - The document terminator (`/END`) MUST be present in a YINI document in strict mode. It marks the end of the document. Any non-comment, non-whitespace content appearing after it MUST result in an error.

    **Note:** Requiring exactly one explicit top-level section and `/END` helps detect incomplete documents. A fragment without the required top-level section or terminator is invalid in strict mode. These checks do not guarantee detection of every truncation, split, or partial copy: a fragment containing a complete top-level section and `/END` may still form a structurally valid document.

  - Empty sections are valid with a recommended warning, as defined in Section 5.
  - Members use their canonical separators, as defined in Sections 4.3 and 9.2.
  - Files intended for strict-mode parsing MAY use the `.strict.yini` filename suffix as described in Section 2.2.1. This suffix is only a naming convention and does not select strict mode or replace strict-mode validation. An explicit `@yini strict` declaration MAY still be used when the document should declare its expected mode.
  - In strict mode, an empty document is invalid. For this purpose, a document containing only whitespace, comments, and/or disabled lines (`--`) is considered empty. Parsing such a document MUST result in an error.

Implementations SHOULD clearly document the validation mode in use and describe which rules are fully enforced under strict parsing.

Example:
```yini
; Lenient mode examples:
list_bracketed1 = [1, 2, ]      // ✅ → [1, 2]
object1 = { a: 1, b: 2, }       // ✅ → {a: 1, b: 2} (trailing comma dropped)
object2 = { a = 1, b = 2 }      // ✅ Lenient only; formatter should normalize to { a: 1, b: 2 }
object3 = { a: 1, b = 2 }       // ⚠️ Discouraged mixing; formatter should normalize to `:`


; Strict mode examples:
list_bracketed2 = [1, 2, ]      // ❌ Error: stray trailing comma
object4 = { a: 1, b: 2, }       // ❌ Error: stray trailing comma
object5 = { a = 1, b = 2 }      // ❌ Error: `=` not allowed inside inline objects in strict mode

list_bracketed3 = [1, 2]        // ✅ OK
object6 = { a: 1, b: 2 }        // ✅ OK
```

#### 12.3.1. Table: Lenient vs. Strict Mode
| Feature                 | Lenient Mode (Default) | Strict Mode | Notes |
|-------------------------|:----------------------:|:-----------:|-------|
| Explicit string quoting               | ✅ | ✅ | All strings MUST be enclosed with `"` or `'` — no ambiguity over strings.|
| Empty sections allowed                | ✅ | ✅ | Implementations SHOULD warn when a section has neither members nor subsections. See Section 5. |
| Duplicate keys | ⚠️ First wins | ❌ Error | Later duplicate keys are ignored in lenient mode and MUST produce a warning diagnostic. |
| Duplicate sections under the same parent | ❌ Error | ❌ Error | A duplicate section makes the document invalid in both modes. Implementations MUST NOT merge or overwrite sections. |
| Exactly one explicit top-level section required | ❌ | ✅ | In strict mode, all other sections MUST be nested within it.  |
| Top-level orphan members allowed      | ✅ | ❌ | In lenient mode they are mounted directly on the document root. |
| `/END` required at end of document                       | ❌ | ✅ |   |
| `:` for root-level or section-level assignments | ✅ | ❌ | See Section 4.3. Canonical assignment spelling uses `=`. |
| `=` inside inline objects | ✅ | ❌ | Conforming lenient-mode parsers MUST accept `key = "value"` inside `{ ... }`; strict mode requires canonical `key: "value"`. |
| Mixed `:` and `=` inside same inline object | ⚠️ Valid but discouraged | ❌ | Conforming lenient-mode parsers MUST accept mixed separators, but formatters SHOULD normalize all inline object members to `:`. |
| Trailing commas after value (inside lists/objects)| ✅ | ❌ | In lenient mode the comma is ignored, error in strict mode  |
| Missing value | ❌ Error | ❌ Error | Every assignment requires an explicit value. See Section 8.2. |
| Empty value before comma | ❌ Error | ❌ Error | Applies to cases such as `key = ,`, `[1, , 2]`, or `{ a: , b: 2 }`. Both modes MUST report an error; recovery does not make the document valid. |
| Invalid escape sequences | ❌ Error | ❌ Error | Both modes MUST report an error. Continuing to collect diagnostics does not make the document valid. |
| String concatenation with non-string scalar operands | ✅ | ❌ | The first operand must be a string literal. See [§6.6](#66-string-concatenation). |
| Multi-line concatenation after `+` | ✅ | ✅ | See [§6.6](#66-string-concatenation) for operator placement. |

⚠️ Strict mode enforces a stricter contract suitable for automated validation and reproducible builds. Lenient mode favors user-friendliness and flexibility for human editing.

Example:
```yini
// Lenient:
key1 =         // ❌ Error: Missing value.
key2 = ,       // ❌ error: unexpected comma

// Strict:
key1 =         // ❌ error: missing value
key2 = ,       // ❌ error: unexpected comma
```

## 13. Implementation Rules

The following guidance is here to assist developers implementing YINI parsers, engines, or tools. These notes aim to promote consistent interpretation of YINI syntax across different platforms and environments.

See also Section 12.2, "Well-Formedness Requirements", for formal validation criteria.

### 13.1. Top-Level Sections and Document Root

A YINI document may contain both explicit top-level sections and, in lenient mode only, top-level members that are not placed inside any explicit section. Such members are referred to here as **orphan members**.

#### 13.1.1. Lenient Mode: Orphan Members
In lenient mode, orphan members are permitted and MUST be accepted.  
NOTE: In strict mode, orphan members are forbidden.

In the abstract YINI data model, orphan members MUST be mounted directly on the document root alongside explicitly defined top-level sections.

For example:

```yini
name = "App"

^ Server
host = "localhost"
```

MUST be represented conceptually as:
```json
{
  "name": "App",
  "Server": {
    "host": "localhost"
  }
}
```

Implementations MUST NOT place orphan members under an implicit `base`, `root`, or other implementation-defined section in the abstract parsed result.

A host-language API MAY expose an additional wrapper object if required by that API. Such a wrapper is not part of the YINI data model and MUST NOT change the conceptual document structure or YINI-to-JSON conversion.

An orphan member and an explicitly defined top-level section MUST NOT have the same name. Such a collision MUST result in an error.

#### 13.1.2. Top-Level Section Mounting
Explicitly defined top-level sections are mounted directly onto the parsed result. Their hierarchy MUST still be respected: descending into deeper nesting may not skip intermediate levels.

This applies:
- A level-3 section MUST follow a level-2 section.
- Skipping levels when descending (for example, level 1 directly to level 3) is invalid.

#### 13.1.3. Strict Mode
In strict mode, there MUST be exactly one explicit top-level section.

Any additional sections MUST appear only as subsections nested within that section.
Top-level orphan members are not allowed in strict mode.
Otherwise, an error MUST be reported.

### 13.2. Line Handling and Whitespace

- Parsers MUST recognize LF (`0x0A`), CRLF (`0x0D 0x0A`), and CR (`0x0D`) as logical line endings for syntax. They MUST check the original source line endings as specified in Section 12.2.3.
- In both parsing modes, each source line ending kept in a Triple-Quoted String or Block String value MUST become one LF (`U+000A`). This includes Raw forms. Normalization MUST occur before escape sequences are interpreted. Characters produced by escapes MUST NOT be normalized. See Sections 6.3 and 6.4.
- Parsers MUST also treat `EOF` as terminating an otherwise complete final logical line. A trailing line-ending sequence is not required in either lenient or strict mode.
- Spaces and tabs surrounding a key or section-name token are insignificant
  and MUST be ignored.
- Content inside a backticked identifier MUST NOT be trimmed or otherwise
  modified. Leading and trailing spaces inside the backticks are part of the
  identifier.
- Full-line and inline comments may follow key-value members or appear on separate lines.
- Whitespace is permitted within lists, including across lines.

### 13.3. Value and Null Handling

* Missing values MUST produce an error in both modes. See Section 8.2.
* Key uniqueness:
  - Keys MUST be unique within the same section and nesting level.
  - In **lenient mode**, later duplicate keys MUST be ignored, and the implementation MUST report the duplicate as a warning diagnostic.
  - In **strict mode**, any duplicate key MUST result in an error.
  - In neither mode may an implementation silently overwrite an earlier key with a later one.
  
### 13.4. Boolean Canonicalization

* Boolean literals are **case-insensitive**.
* The following values MUST be interpreted as Booleans:
  * `true`, `yes`, `on` -> `true`
  * `false`, `no`, `off` -> `false`
* Boolean literals MUST NOT be written as `1` or `0`. Host applications MAY perform their own conversions after parsing, but such conversions are outside the YINI data model and this specification.

### 13.5. Objects
Inline object members use `:` as the canonical separator:

```yini
obj = { a: 1, b: 2 }
```

Section 9.2 defines the equivalent lenient forms shown below.

```yini
obj = { a = 1, b = 2 }
```

Mixed object separators are also valid in lenient mode.

```yini
obj = { a: 1, b = 2 }  // Discouraged in lenient mode; invalid in strict mode.
```

Any empty slot inside `{ ... }`, for example:

```yini
object = { a: 1, , b: 2 }
```

MUST produce an error diagnostic in both lenient and strict mode. A parser MAY
continue to collect diagnostics, but the document remains invalid. It MUST NOT
accept the empty slot by inserting `null` or dropping the slot from a successful
parse result.

### 13.6. Lists

The syntax for a list is:
  **Bracketed form:**
  ```yini
  items = ["a", "b", "c"]
  ```
  * A bracketed list line MUST NOT begin with a comma.
  * In lenient mode, a trailing comma in `[ ]` is ignored.
  * In strict mode, a trailing comma in `[ ]` MUST result in an error.

The opening `[` must follow the assignment separator on the same logical line (Section 4.3). Otherwise the member has no value, as in this invalid example:
  ```yini
  invalidList = // Error in both modes: Missing value.
  [1, 2, 3]     // Invalid standalone line; not the value of invalidList.
  ```

### 13.7. String Concatenation

See [§6.6](#66-string-concatenation) for the concatenation rules and [§6.7](#67-scalar-conversion-in-lenient-concatenation) for scalar conversion in lenient mode.

Implementations SHOULD report invalid concatenation with diagnostics that identify the reason, such as:
- Non-string operand in strict mode.
- Concatenation expression does not begin with a string literal.
- List or inline object used as a concatenation operand.
- Line break before the + operator.

### 13.8. String Literal Types
**Note:** If text is not quoted, it MUST NOT be interpreted as a string literal.

| Type                   | Prefix           | Example    | Behavior |
|------------------------|------------------|------------|----------|
| (Raw) String           | _None_, `R`, or `r`| "Some text"| Text is as-is (raw), no escaping,  backslash is literal, preserves all whitespace|
| Escaped String | `E` or `e`; `C`/`c` deprecated aliases | `e"..."` | Escape sequences are interpreted|
| Triple-Quoted String   | _None_, `R`, or `r`       | `"""..."""`   | Multiline; keeps spaces, tabs, and line breaks; backslashes are literal; source line endings become LF |
| Escaped Triple-Quoted String | `E` or `e`; `C`/`c` deprecated aliases | `E"""..."""` | Multiline; source line endings become LF before escape processing; escape results stay unchanged |
| Block String | `b`, `B`, or `block` in any capitalization | `b"""`, `B"""`, or `block"""`, then optional ASCII spaces or tabs and a line break | Multiline literal; keeps content line breaks as LF; removes structural indentation |

### 13.9. Comments

Implementations MUST recognize comments according to Section 3.3, "Comments".

In summary:
- `//` begins a line comment outside string literals and backticked identifiers.
- `#` begins a line comment outside string literals and backticked identifiers.
- `/* ... */` begins a block comment outside string literals and backticked identifiers.
- `;` begins a full-line comment only when it is the first non-whitespace character on a line.
- Nested block comments are not supported.
- Comments may appear only where whitespace is allowed and MUST NOT split tokens.
- On the same line as a Block String delimiter, a parser MUST reject a comment directly after the opening quotes. After the closing quotes, it MUST accept a `//` or `#` line comment, including after optional ASCII spaces or tabs. A `/* ... */` comment may follow a valid `+` or `,` as described in Section 6.4.

Implementations SHOULD remove or ignore comments during parsing before semantic interpretation, while preserving source-position information when useful for diagnostics.
They MUST still account for line endings inside block comments when enforcing same-logical-line requirements.

### 13.10. Additional Implementation Guidance

Implementations are encouraged to provide the following features to improve parser robustness, diagnostics, and developer experience:

- Support both **lenient** and **strict** parsing modes.

- Attach **position metadata**, such as line and column numbers, to tokens, parsed values, and diagnostics.

- Normalize scalar values to platform-agnostic canonical representations before exposing parsed output. For example:
  * **Booleans** SHOULD be represented as the logical values `true` and `false`.
  * **Null** SHOULD be represented as the logical null value.

  The concrete host-language representation may differ by implementation, but the exposed semantic value SHOULD remain equivalent.

  For example, the same YINI logical values may be represented by different host-language values:

  | YINI logical value | JavaScript / TypeScript | Python |
  |--------------------|-------------------------|--------|
  | Boolean true       | `true`                  | `True` |
  | Boolean false      | `false`                 | `False`|
  | Null               | `null`                  | `None` |

- Support configurable **diagnostic severity thresholds** for parser recovery and abort behavior.

  Recommended severity thresholds:
  * **Level 0 — Recover when possible:** Report errors and warnings, but attempt to continue parsing where recovery is possible.
  * **Level 1 — Abort on errors:** Continue after warnings, but abort when an error is encountered.
  * **Level 2 — Abort on warnings and errors:** Abort when either a warning or an error is encountered.

When recovering from invalid syntax, implementations MAY use internal placeholder
names or recovery nodes. They MUST still report the required error diagnostics
and mark the document as invalid. Any partial result MUST be clearly identified
as a recovery result. See Section 14.1.2, "Graceful Degradation".

## 14. Compatibility and Versioning
This section covers YINI's compatibility and interoperability principles.

### 14.1. Fallback Rules
#### 14.1.1. Invalid Sections or Keys
- Invalid key names or section headers MUST produce an error diagnostic in both
  lenient and strict mode.
  
#### 14.1.2. Graceful Degradation
**Document validity and parser recovery are separate decisions.** A parser can
continue looking for problems after an error without accepting the document as
valid.

Unless this specification explicitly permits a form in the active mode,
violations of its syntax or semantic requirements MUST produce an error
diagnostic in both modes. Unsupported or unrecognized syntax, including inactive
reserved constructs, MUST also produce an error diagnostic.

Implementations MAY continue parsing after an error to collect further
diagnostics or produce a partial recovery result. Recovery MUST NOT lower the
required diagnostic severity or change the document's invalid status. Any
partial result MUST be clearly identified and MUST NOT be presented as a
successful, conforming YINI parse result.

Warning diagnostics for constructs explicitly permitted by the active mode do
not, by themselves, make a document invalid. For example, first-wins duplicate
key handling is valid in lenient mode and requires a warning. Missing values,
duplicate sections, empty collection slots, and unsupported escapes are invalid
in both modes and require errors.

For example, both assignments below are invalid in both modes:

```yini
text = E"\123"     // Error: use the YINI escape \o123 instead.
items = [1, , 3]   // Error: missing list value.
```

An editor may show a partial result to help locate more errors. An application
must still be told that the document is invalid.

### 14.2. Versioning Strategy
The YINI Specification uses Semantic Versioning-style version numbers to signal format evolution.

Version identifiers use the form:

```txt
MAJOR.MINOR.PATCH[-STAGE.N]
```

Examples:
```
1.0.0-RC.6
1.0.0
1.1.0
```

- **MAJOR:** Incompatible changes.
- **MINOR:** Backward-compatible additions.
- **PATCH:** Backward-compatible clarifications, corrections, and non-breaking fixes.
- **STAGE:** Optional pre-release stage, such as Beta or RC.

Before the final `1.0.0` release, staged labels such as Beta and RC indicate that the format is intended to be close to stable, but may still receive clarifications or breaking adjustments before final release.

### 14.3. Encoding Notes
#### 14.3.1 Required Encoding
See [§2.1, File Encoding](#21-file-encoding) for the required encoding.

#### 14.3.2 Byte Order Mark (BOM)
See the BOM policy in [§2.1](#21-file-encoding).

#### 14.3.3 Shebang Line (Optional)
A shebang line may affect script execution in Unix environments. See [§2.3](#23-optional-shebang-) for its placement and how YINI parsers handle it.

### 14.4. JSON Compatibility

**YINI documents can be serialized (converted) to JSON while preserving their data hierarchy, value types, and identifier text, provided the target JSON implementation can represent those values without loss.**

Comments and other YINI syntax-only constructs are not preserved in JSON.

Converting JSON to YINI may require mapping choices and is subject to YINI's rules for identifiers and numeric values.

Although YINI and JSON are distinct formats with different goals, their core data models are closely aligned.

Comments, disabled lines, the `@yini` marker, and the document terminator are metadata or syntax-only constructs. They are not represented as JSON values.

Not every JSON document maps directly or cleanly to YINI:

- A top-level JSON array cannot directly become a complete YINI document unless it is wrapped in a member or section.
- JSON object keys may be any string, including empty strings or strings containing characters that require backticked identifiers in YINI.
- Some JSON structures may require a chosen mapping strategy when converted to YINI, especially when deciding whether nested JSON objects should become inline objects or nested sections.

Therefore, JSON-to-YINI conversion can preserve the same data model when a suitable mapping strategy is used, but it is not always a purely mechanical one-to-one syntax conversion.

#### Converting YINI to JSON
- **Keys / Identifiers:** YINI identifiers become JSON object member names. When serialized as JSON, all keys are written as JSON strings.
- **Value types (String, Number, Boolean, Null, List):** Direct mapping is possible between YINI and JSON native types.
- **Lists (Arrays):** Lists `[]` map 1-to-1.
- **Sections:** YINI sections correspond to nested objects `{}` in JSON.
- **String types:** ⚠️ All strings become plain JSON strings once parsed, escaping is normalized when serialized.

#### Metadata Limitations
- 🚫 Metadata (such as comments and the document terminator) will not be carried over to JSON.

#### Summary
A well-formed YINI document can be converted to a JSON object with equivalent structure, value types, and identifier names, provided the converter represents its numeric values without loss. YINI-specific syntax, such as comments and the document terminator, is not preserved.  

Conversely, a valid JSON object can be mapped into a YINI document, provided that JSON-specific constructs (such as deeply nested objects) are expressed as sections and that YINI syntax rules are respected.

**Table: Correspondence Between YINI and JSON**

| Entity / Feature    | To YINI                                             | To JSON                               | Notes                                                                             |
|---------------------|----------------------------------------------------|--------------------------------------|-----------------------------------------------------------------------------------|
| Structure Mapping   | ✅ Yes (sections become objects)                   | ✅ Yes (objects, nested)              | Each YINI section is mapped to a JSON object.                                     |
| Types Mapping       | ✅ Yes (direct type mapping)                       | ✅ Yes (direct type mapping)          | All core types (string, number, bool, null, object, list) are preserved.          |
| Key/Value Syntax    | ✅ Root/section: `key = "value"`<br>Object: `key: "value"` canonical | ✅ Keys always quoted, `:` for objects | YINI's canonical separators depend on context. See Sections 4.3 and 9.2 for lenient alternatives. |
| Identifiers (Keys)  | ✅ Unquoted, or backticked if needed               | ✅ Must always be quoted              | Backticks in YINI for special chars; JSON always quotes keys.                     |
| Comments            | ✅ Supported (full-line, inline, or multi-line)                 | 🚫 Not supported (discarded)          | Comments are dropped when converting to JSON.                                     |
| Terminator          | ✅ Supported in YINI (`/END`)                       | 🚫 Not supported in JSON            | YINI's document terminator has no JSON equivalent and is ignored when converting to JSON.                              |

### See also:
See Sections 15.3 and 15.4 for examples of YINI ⇆ JSON mappings.

## 15. Examples

### 15.1. Minimal Example
```yini
^ Prefs

name = "Kim"
entries = 10
enabled = true
```

**Explanation:**
  - Begins with a single section `^ Prefs`.
  - Contains three keys (`name`, `entries`, `enabled`) with string, number, and boolean values, respectively.

### 15.2. Realistic Config Use Cases
#### 15.2.1. User Preferences Configuration
```yini
^ Preferences

theme = "dark"
language = "en"
notifications = true
volume = 85
recent_files = [
    "report.yini",
    "draft_0423.yini",
    "budget2025.yini"
]
```

#### 15.2.2. Application Settings with Sections
```yini
^ Database
host = "localhost"
port = 5432
username = "appuser"
password = "s3cret"

^ Logging
level = "debug"
file = "/var/log/myapp.log"
rotate = true

^ Features
enable_experimental = false
api_version = "v2.1"
```

**Notes:**
- The `^` marker cleanly divides logical domains into sections.

#### 15.2.3. Script Metadata
```yini
^ Metadata
name = "Data Fetch Script"
version = "1.3.0"
author = "Jane Doe"
schedule = "daily"
active = true
```

#### 15.2.4. Feature Flags
```yini
^ FeatureFlags
debug = true
experimental_ui = false
use_cache = true
cache_expiry = 86400  		// In seconds
last_purge_date = "2025-05-25"	// YYYY-MM-DD
```

#### 15.2.5. Feature Toggles with Alternative Syntax
```yini
/*
  Feature Toggles with Alternative Syntax
*/

< `Feature Toggles`
`Debug` = ON
`Experimental UI` = OFF
`Night Mode` = OFF
`Use Cache` = ON

    << `Cache Config`
    `Cache Expiry` = 86400  		// In seconds
    `Last Purge Date (YYYY-MM-DD)` = "2025-05-25"
```

**Notes:**
- Uses the alternative section marker `<`.
- Demonstrates alternative boolean literals: `ON` and `OFF`.
- `Cache Config` is a nested subsection of `Feature Toggles`.
- All keys and section header identifiers are enclosed in backticks, allowing the use of spaces and special characters.

### 15.3. Examples of YINI → JSON Mapping

#### 15.3.1. Simple Flat Structure to JSON
**YINI:**
```yini
^ User
name = "Alice"
age = 28
active = true
```

**JSON Equivalent:**
```json
{
  "User": {
    "name": "Alice",
    "age": 28,
    "active": true
  }
}
```

#### 15.3.2. Nested Sections (multiple levels) to JSON
**YINI:**
```yini
^ Settings
theme = "dark"
language = "en"

    ^^ Display
    resolution = "1920x1080"
    fullscreen = true
```

**JSON Equivalent:**
```json
{
  "Settings": {
    "theme": "dark",
    "language": "en",
    "Display": {
      "resolution": "1920x1080",
      "fullscreen": true
    }
  }
}
```

#### 15.3.3. Lists (Arrays) to JSON
**YINI:**
```yini
^ Server
hosts = ['server1.example.com', 'server2.example.com']
```

**JSON Equivalent:**
```json
{
  "Server": {
    "hosts": [
      "server1.example.com",
      "server2.example.com"
    ]
  }
}
```

#### 15.3.4. Nulls and Booleans to JSON

**Note:** Null and boolean literals (e.g., `Null`, `None`, `True`, `On`, `Yes`) in YINI are **case-insensitive**, while keys are **case-sensitive**.

**YINI:**
```yini
^ Flags
enabled = On
archived = Off
description = None
```

**JSON Equivalent:**
```json
{
  "Flags": {
    "enabled": true,
    "archived": false,
    "description": null
  }
}
```

### 15.4. Examples of JSON → YINI Mapping

#### 15.4.1. Simple JSON Object to YINI
**JSON:**
```json
{
  "Profile": {
    "username": "bob",
    "age": 35,
    "verified": true
  }
}
```

**YINI Equivalent:**
```yini
^ Profile
username = "bob"
age = 35
verified = true
```

#### 15.4.2. Nested JSON Objects to YINI
**JSON:**
```json
{
  "App": {
    "version": "2.5",
    "settings": {
      "theme": "light",
      "notifications": true
    }
  }
}
```

**YINI Equivalent:**
```yini
^ App
version = "2.5"

    ^^ settings
    theme = "light"
    notifications = true
```

#### 15.4.3. JSON Array to YINI
**JSON:**
```json
{
  "Servers": {
    "hosts": ["alpha.local", "beta.local", "gamma.local"]
  }
}
```

**YINI Equivalent:**
```yini
^ Servers
hosts = ["alpha.local", "beta.local", "gamma.local"]
```

### 15.5. Large-Scale Real-World Configuration Example A: Corporate SaaS Platform  

This is a lenient-mode example. It has multiple top-level sections and no `/END`.

- [YINI configuration](./Examples/Large-Scale%20Real-World%20Configuration%20Examples/a-corporate-saas-platform.yini)
- [JSON equivalent](./Examples/Large-Scale%20Real-World%20Configuration%20Examples/a-corporate-saas-platform.json)

### 15.6. Large-Scale Real-World Configuration Example B: High-Security Distributed Control System

This is a lenient-mode example. It has multiple top-level sections and no `/END`.

- [YINI configuration](./Examples/Large-Scale%20Real-World%20Configuration%20Examples/b-high-security-distributed-control-system.yini)
- [JSON equivalent](./Examples/Large-Scale%20Real-World%20Configuration%20Examples/b-high-security-distributed-control-system.json)

### 15.7. Large-Scale Real-World Configuration Example C: Industrial Monitoring & Automation Platform  

This example is valid when parsed in strict mode.

- [YINI configuration](./Examples/Large-Scale%20Real-World%20Configuration%20Examples/c-industrial-monitoring-and-automation-platform.strict.yini)
- [JSON equivalent](./Examples/Large-Scale%20Real-World%20Configuration%20Examples/c-industrial-monitoring-and-automation-platform.json)

## 16. Appendices and Reserved Areas
### 16.1. License
Apache License, Version 2.0, January 2004,
http://www.apache.org/licenses/
Copyright 2024-2026 Gothenburg, Marko K. Seppänen, (Sweden via
Finland).

### 16.2. Acknowledgments
_YINI would not exist in its current form without the many insights, challenges, and constructive feedback contributed by the community._

For more details, see section D.2, _“Acknowledgments & Special Thanks”_, in the [Rationale](./RATIONALE.md) document.

### 16.3. Author(s)
This specification is created and maintained by Marko K. Seppänen.

#### Creator
First authored in **2024 in Gothenburg, Sweden,** by **Marko K. Seppänen** (Sweden via Finland).

Mr. Seppänen has been programming since the **mid-1980s**, starting with platforms and languages such as **BASIC and various BASIC dialects, C, Java, and Assembler**, and later programming across both mainstream and more niche languages — from **C#** to **Haskell** and **Erlang**.  

He studied **Computer Science & Technology** and **Master's in Software Development** with a focus on **Programming Languages**, at **Chalmers University of Technology** (Gothenburg, Sweden).  

Professionally, he has **decades of experience in software development and engineering**, particularly in **TypeScript, JavaScript, Python, PHP,** and **full-stack web development**, as well as **tooling and both user- and developer-focused systems**.

### 16.4. Spec Changes
Recent changes and updates **to this YINI specification**.

This section keeps the three most recent version groups. See [earlier specification changes](./Docs/SPEC-HISTORY.md) for older entries.

Notes:
- More details of the feedback, see section D.2, _“Acknowledgments & Special Thanks”_, in the [Rationale](./RATIONALE.md) document.
- All dates in international format, YYYY-MM-DD.

#### v1.0.0-RC.7x/RC.8-WIP

- **Changed:** In Escaped Strings, `\o` consumes the entire following ASCII digit run and `\0` rejects a following ASCII digit. See §6.2.1.
- **Added:** Lenient root-level and section-level assignments accept `:` as an alternative to canonical `=`. Strict section members require `=`. See Section 4.3.
- **Clarified:** The `hex:` number prefix applies in value positions. In a permitted member position, `hex:10` assigns decimal `10` to the key `hex`.
- **Changed:** Missing assignment values now produce an error in both modes, including comment-only values such as `color = #FF9900`. Existing lenient files must supply the intended value explicitly. See Section 8.2.
- **Added:** Case-insensitive `None` as an alias for `null`. The canonical spelling remains `null`.
- **Clarified:** Empty sections have neither members nor subsections. They are valid in both modes, but implementations SHOULD warn. See Section 5.
- **Changed:** Renamed Command Strings to Block Strings and replaced the `command` prefix with case-insensitive `block` and `b` prefixes. The `command` prefix is no longer supported in either parsing mode.
- **Changed:** §3.2 defines literal control characters for every string form and backticked identifiers. Both modes reject literal NUL in Raw and Escaped strings, including triple-quoted forms.
- **Changed:** Both modes now allow trailing ASCII spaces and tabs after either Block String delimiter.
- **Changed:** A Block String can be followed on its closing line by a concatenation operator or a comma allowed by the surrounding list or inline object.
- **Changed:** Both modes accept `//` and `#` line comments directly after the closing quotes of a Block String.

#### v1.0.0 RC 7
- **Deprecated:** The Classic String name and `C`/`c` prefixes. Use Escaped String and `E`/`e` for new documents; `C`/`c` remain valid with identical behavior in both parsing modes, including Triple-Quoted strings.
- **Deprecated:** The `%` binary prefix in favor of `0b`. It remains valid in both parsing modes; implementations SHOULD issue a deprecation warning recommending `0b`.
- **Changed:** Duplicate sections under the same parent now produce an error and invalidate the document in both modes. Lenient first-wins handling for duplicate keys is unchanged.
- **Clarified:** Mode declarations do not change the active parser mode. Declaring strict while parsing leniently requires an error and rejection. Declaring lenient while parsing strictly requires a warning; acceptance still depends on passing all strict validation requirements.
- **Changed:** In lenient mode, a missing root-level or section-level value still becomes `null`, but now MUST produce a warning diagnostic. This includes assignments followed only by a comment, such as `color = #FF9900`. Strict mode still rejects missing values.
- **Changed:** Made number-to-string conversion in lenient-mode concatenation
  deterministic. Decimal numbers keep a normalized form of their source
  spelling: digit separators and unnecessary plus signs are removed, and `E`
  is normalized to `e`. Non-decimal integers are converted exactly to base 10,
  and negative zero is preserved. For example, `1e3` remains `1e3`, while
  `0xFF` becomes `255`.
- **Changed:** Standardized orphan-member handling in lenient mode. Conforming
  lenient-mode parsers MUST accept root-level orphan members and mount them
  directly on the abstract document root alongside top-level sections. The
  previous implementation-dependent implicit `base` mapping is no longer part
  of the YINI data model. In practice, orphan members and top-level sections
  appear as siblings in the parsed output rather than placing orphan members
  inside a separate `base` object.
- **Changed:** Backticked identifiers now reject raw C1 control characters (U+007F–U+009F) in addition to C0 control characters (U+0000–U+001F). Only `` \` `` and `\\` are valid escape sequences; control-character escapes are not supported.
- **Changed:** Source LF, CRLF, and CR line endings now become LF in all multiline string values, including Raw and Escaped Triple-Quoted Strings and Command Strings, in both modes. Previously, their original characters were preserved. Escape results stay unchanged. Mixed-line-ending checks still use the original source.
- **Changed:** Removed the lenient-mode fallback that allowed implementations to retain or remap invalid key and section names. Both lenient-mode and strict-mode parsers MUST report an error with diagnostic information.
- **Fixed:** `\xhh` defined now as a short Unicode escape, using exactly 2 hexadecimal digits. Denotes the Unicode code point U+00hh; never a raw byte, since YINI has no byte-string literal type.
- **Added:** Command Strings using the lowercase `command"""` form. They preserve command lines while removing structural indentation and have no execution semantics. The `c` prefix remains Classic, not a Command String alias.
- **Added:** `E` and `e` as aliases for `C` and `c` on Classic (Escaped) strings, including Triple-Quoted strings. All four prefixes use the same escape rules and produce the same string values.
- **Added:** Backticked identifiers now support `\`` for a literal backtick and `\\` for a literal backslash. Updated the ANTLR lexer to recognize these forms.
- **Added:** Classic strings now support `\`` for a literal backtick.
- **Clarified:** Section 7.4 now states that non-decimal integer literals share the signed 64-bit range in both modes, with hexadecimal overflow examples.
- **Clarified:** The `=` inline object member separator is valid YINI syntax
  in lenient mode, not an optional parser extension. Conforming lenient-mode
  parsers MUST accept both `:` and `=`, including mixed separators within the
  same inline object. The canonical separator remains `:`, and formatters
  SHOULD normalize object members to `:`.
- **Clarified:** Appendix 16.7 is informational, not a list of accepted YINI
  whitespace. Only `SPACE` and `TAB` are syntactic horizontal whitespace; only
  `LF`, `CRLF`, and `CR` are line endings. Unicode line and paragraph separators
  (`U+2028` and `U+2029`) are not YINI line endings.
- **Clarified:** End-of-file (`EOF`) may terminate an otherwise complete final logical line in both lenient and strict mode. A lenient document may end immediately after its final assignment, and a strict document may end immediately after `/END`, without a trailing line ending.
- **Clarified:** YINI-to-JSON conversion preserves structure, value types, and identifier names when the converter can represent numeric values without loss. YINI-specific syntax, including comments and the document terminator, is not preserved.

#### v1.0.0 RC 6, 2026-05-30
- **Changed:** The `#` character now always begins a comment outside string literals. No whitespace is required before or after `#`.
- **Changed:** Increased the maximum repeated section marker depth from 6 to 9 because section marker separators (`_`) may now be used to make headers easier to read. Repeated marker headers may now express levels 1–9 directly, while numeric shorthand remains required for levels 10 and deeper.
- **Added:** Added the explicit hexadecimal notation `hex:` as an alternative to `0x...`. The `hex:` prefix is case-insensitive and MUST be followed immediately by hexadecimal digits or an allowed digit separator.
- **Removed:** Support for `#` as a hexadecimal number prefix was removed. Hexadecimal numbers MUST instead be written using `0x...` or the explicit `hex:` form.
- **Removed:** Hyper Strings (H-Strings) were removed. While useful for readable long-form text, they served a narrow use case and overlapped with existing string forms. Their removal keeps the core language smaller, clearer, and more predictable.
- **Added:** In lenient mode, authors MAY use `=` as an alternative to `:`, and conforming lenient-mode parsers MUST accept both separators. The canonical form remains `key: "value"`.
- **Clarified:** In strict mode, inline object members MUST use `:`. Using `=` inside inline objects is invalid, whether mixed with `:` or used consistently.
- **Clarified:** Tools and formatters SHOULD normalize inline object members to `:`.
- **Changed:** Updated string concatenation rules. In both modes, a concatenation expression MUST begin with a string literal. In strict mode, all concatenation operands MUST be string literals. In lenient mode, additional operands MAY be string literals, number literals, boolean literals, or null literals. Numeric addition is not defined. Non-string scalar operands are converted to their parsed canonical string representation before concatenation. A concatenation expression MAY span multiple source lines only when the line break occurs after the `+` operator; a line break before `+` is invalid. Lists and inline objects MUST NOT be used as concatenation operands.
- **Clarified:** Missing values vs. trailing commas:
  * If the value is the keyword `null` (case-insensitive), or if a root-level or section-level member has no value after `=` in lenient mode, it is treated as **Null**.
  * Missing values inside lists or objects are not treated as `Null`. A trailing comma inside a list or object is permitted only in lenient mode and is ignored; in strict mode it is an error.
- **Added:** For readability, an underscore character `_` may appear after a base prefix or between successive digits.
- **Added:** For readability, added support for section marker separators `_`.
- **Added:** Added optional mode declarations to the YINI marker using `@yini strict` and `@yini lenient`. These declarations state the document's expected parser mode but MUST NOT automatically switch the active parser mode. If `@yini strict` is parsed in lenient mode, the parser MUST emit a mode-mismatch error. If `@yini lenient` is parsed in strict mode, the parser MUST emit a mode-mismatch warning.
- **Clarified:** Defined empty-document handling by mode. In lenient mode, a document containing only whitespace, comments, and/or disabled lines is permitted but SHOULD produce a warning. In strict mode, such a document is invalid and MUST result in an error.
- **Changed:** Re-added `>` as a supported ASCII section marker based on feedback. It is now documented as a quote-like ASCII fallback marker, with a portability caveat because some email clients, forum renderers, and Markdown-like environments may treat it as a quote prefix.

---

### 16.5. Formal Grammar

The formal ANTLR4 grammar is not reproduced directly in this specification
document because of its length. It is included separately in the YINI
specification repository and release package:

- [ANTLR4 grammar directory](./Grammar-ANTLR4/)
- [YINI lexer grammar](./Grammar-ANTLR4/YiniLexer.g4)
- [YINI parser grammar](./Grammar-ANTLR4/YiniParser.g4)

The grammar defines YINI's principal lexical and syntactic structure. Some
validation requirements—such as parsing-mode rules, duplicate-name handling,
section nesting, and other semantic constraints—are enforced outside the
grammar and are defined by this specification.

The grammar accompanying YINI Specification 1.0.0-RC.7 is version
1.4.0-RC.1.

If the grammar and this specification conflict, this specification takes
precedence.

**Grammar scope:**

For diagnostic purposes, the ANTLR4 grammar intentionally recognizes a
superset of well-formed YINI syntax in some areas. This allows parser and validator implementations to recognize malformed constructs and provide specific,
user-friendly diagnostics.

Successful recognition by the ANTLR4 grammar alone does not establish that a
document is well-formed or conforming. All normative syntactic, structural,
mode-specific, and semantic requirements in this specification MUST still be
validated.

The implementing parser or validator MUST enforce same-logical-line rules using
the source's line boundaries, including those inside skipped block comments,
and MUST check the original placement of shebang-like sequences. These checks
need not be enforced by the ANTLR4 grammar. A lexer token or grammar error for a
misplaced `#!` MUST NOT override its required treatment as a comment in lenient
mode.

The grammar recognizes leading numeric signs as separate tokens. The implementing parser or validator MUST check that each sign immediately precedes its number without intervening whitespace or comments.

### 16.6. Common Mistakes and Pitfalls
Below are some common mistakes and misunderstandings when writing YINI files, especially for users familiar with other formats such as YAML, JSON, or classic INI. This table clarifies syntax edge cases and helps avoid subtle bugs.

#### Trailing commas in list and objects
Trailing commas after values or members inside lists or objects never produce `Null` values. Strict mode disallows a comma with no element after it altogether.

✅ YINI Syntax Cheatsheet – Common Confusions
| **Element**       | **Correct Syntax**              | **Common Mistake**              | **Clarification** |
|-------------------|----------------------------------|----------------------------------|--------------------|
| Root/section member | `name = "John"` | Non-canonical lenient form: `name: "John"` | See Section 4.3 for separator rules. Strict section members require `=`. |
| List assignment | `items = ["a", "b", "c"]` | `items: "a", "b", "c"` or bare `items:` | A list requires brackets and must start on the separator's logical line, including with lenient `:` assignments. |
| Inline List        | `items = ["a", "b", "c"]`       | `items =` followed by newline and `[` on next line | The line break leaves `items` without a value, which is an error in both modes. The `[` on the next line is not its value. |
| Trailing comma (inline) | `list = ["a", "b", "c",]`   | Empty value assumed to be null           | The comma is ignored, and does NOT add any `null` item at the end of the list. The result is same as: `list = ["a", "b", "c"]` |
| Comments | `# Comment`, `#Comment`, or `// Comment` | Assuming `#Comment` is not a comment | Outside string literals and backticked identifiers, `#` always begins a comment. No whitespace is required. |
| Hex values | `color = 0xFF0033` or `color = hex:FF0033` | `color = #FF0033` | `#FF0033` is a comment, leaving `color` without a value. This is an error in both modes. |
| Disable line       | `--key = "something"`           | Treated like a comment          | Entire line is ignored, including valid config syntax. |
| List nesting       | `list = [[1, 2], [3, 4]]`       | Using inner lists without brackets | All nested lists MUST be bracketed explicitly. |
| Section skipping   | `^^ Section`, `^^^ Subsection`  | Jumping directly to `^^^`       | ❌ Invalid — cannot skip intermediate nesting levels. |
| Inline object member separator | `obj = { a: 1, b: 2 }` | Non-canonical lenient form: `obj = { a = 1, b = 2 }` | `:` is the canonical separator inside inline objects. The `=` form is valid in lenient mode and conforming lenient-mode parsers MUST accept it, but formatters SHOULD normalize it to `:`. In strict mode, `=` inside inline objects is invalid. |
| Mixed object separators | `obj = { a: 1, b: 2 }` | `obj = { a: 1, b = 2 }` | Mixing `:` and `=` inside the same inline object is discouraged in lenient mode and invalid in strict mode. |
| Quote characters | `text = "hello"` or `text = 'hello'` | Using curly quotes as delimiters (start/end characters): `text = “hello”` | String delimiters MUST be plain ASCII quotes: `'` U+0027 or `"` U+0022. Curly quotes may appear inside strings as ordinary text, but they do not delimit strings. |
| String concatenation start | `text = "value: " + 123` | `text = 123 + " value"` | The first example uses a number as a later operand in lenient mode. See [§6.6](#66-string-concatenation). |
| Multi-line concatenation | `text = "hello " +`<br>`       "world"` | Placing `+` at the start of the next line | See the line-break rule in [§6.6](#66-string-concatenation). |

---

### 16.7. 🧾 Unicode Whitespace Characters
*Informational; not part of YINI's syntactic whitespace rules.*

In this version of YINI, `U+0020` `SPACE` and `U+0009` `TAB` are the only syntactic
horizontal whitespace characters. `LF`, `CRLF`, and `CR` are the only recognized
line endings, as defined in Section 3.2. The remaining characters in this
table are neither syntactic whitespace nor line endings in YINI.

| Code Point | Character Name                | Abbreviation | Unicode Category | Notes                                 |
|------------|-------------------------------|--------------|------------------|----------------------------------------|
| `U+0009`   | -                             | TAB          | Cc               | Common ASCII tab                       |
| `U+000A`   | LINE FEED                     | LF           | Cc               | Newline / Unix line ending             |
| `U+000D`   | CARRIAGE RETURN               | CR           | Cc               | Used in Windows line endings           |
| `U+0020`   | -                             | SPACE        | Zs               | Standard space                         |
| `U+00A0`   | NO-BREAK SPACE                | NBSP         | Zs               | Common in HTML                         |
| `U+1680`   | OGHAM SPACE MARK              |              | Zs               | Rare, historic                         |
| `U+2000`   | EN QUAD                       |              | Zs               | Typographic space                      |
| `U+2001`   | EM QUAD                       |              | Zs               | Typographic space                      |
| `U+2002`   | EN SPACE                      |              | Zs               | Narrower than EM space                 |
| `U+2003`   | EM SPACE                      |              | Zs               | Wider than EN space                    |
| `U+2004`   | THREE-PER-EM SPACE            |              | Zs               | Typographic space                      |
| `U+2005`   | FOUR-PER-EM SPACE             |              | Zs               | Typographic space                      |
| `U+2006`   | SIX-PER-EM SPACE              |              | Zs               | Typographic space                      |
| `U+2007`   | FIGURE SPACE                  |              | Zs               | Aligns with numeric digits             |
| `U+2008`   | PUNCTUATION SPACE             |              | Zs               | Same width as a period                 |
| `U+2009`   | THIN SPACE                    |              | Zs               | Narrow space                           |
| `U+200A`   | HAIR SPACE                    |              | Zs               | Very narrow space                      |
| `U+202F`   | NARROW NO-BREAK SPACE         |              | Zs               | Used in Mongolian, etc.                |
| `U+205F`   | MEDIUM MATHEMATICAL SPACE     |              | Zs               | Used in math layout                    |
| `U+3000`   | IDEOGRAPHIC SPACE             |              | Zs               | Full-width space in CJK                |
| `U+2028`   | LINE SEPARATOR                |              | Zl               | Not a YINI line ending    |
| `U+2029`   | PARAGRAPH SEPARATOR           |              | Zp               | Not a YINI line ending.                        |

---

**^ YINI Specification ≡**  
> A clear, structured, and human-friendly configuration format.  

[yini-lang.org](https://yini-lang.org?utm_source=github&utm_campaign=yini_spec_rc7&utm_content=spec_footer&utm_medium=referral) · [YINI-lang on GitHub](https://github.com/YINI-lang/)  
