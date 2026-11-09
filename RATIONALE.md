# YINI Rationale

**Applies to:** YINI Specification v1.0.0-RC.6x
**Author:** Marko K. Seppänen  
**Project:** YINI-lang

**This document explains YINI's rationale, design decisions, and the motivations behind them.**

This companion to the [YINI Specification](./YINI-Specification.md) explains why YINI exists and the reasons behind its rules. It brings together the format's background, design philosophy, comparisons with other formats, decision history, and feature-specific rationale.

This document is informative. The specification defines YINI's rules if the wording here differs. The explanations below may evolve as design decisions are refined.

The numbered portion of **this document follows the specification's section numbers, names, and order.** This **one-to-one** structure makes the motivation for a rule easy to find beside the corresponding specification section. Additional rationale-only headings are deliberately unnumbered.

A **TODO** marks a decision whose motivation still needs to be written or confirmed. 

A standalone `-` means the section is intentionally skipped here due to motivation for this not needed or is explained elsewhere.

---

## Contents

- [Background and Motivation](#background-and-motivation)
- [Design Philosophy](#design-philosophy)
- [Relationship to Other Formats](#relationship-to-other-formats)
- [Specification-aligned Design Decisions](#1-introduction)
- [Historical and Rejected Alternatives](#historical-and-rejected-alternatives)
- [Acknowledgments](#acknowledgments)

---

<a id="a-background-and-motivation"></a>

## Background and Motivation

### Why YINI was created

<a id="a1-why-was-yini-created"></a>

YINI began during a personal project that needed a configuration format in the spirit of INI, but with a well-defined specification and a small set of modern features.

None of the existing formats fully matched that project's needs. INI sometimes felt too limited and lacked one consistent specification. YAML felt too flexible, implicit, and dependent on whitespace, and sometimes cryptic (as the exact syntax was not always easy to remember). JSON's types and data model were close to what was needed, but its syntax felt noisy and restrictive for hand-edited configuration. TOML was solid and well-defined, but could become visually verbose, particularly for deeply nested data.

YINI was created to be:

- **Simple** enough for people to edit without friction.
- **Consistent** enough for machines to parse unambiguously.
- **Cleanly structured** without overly magical or implicit behavior.
- **Modern**, while retaining the readability associated with INI files.

It puts clarity and developer experience first, balancing readable source text with defined grammar and validation rules that support reliable tooling.

Designing the format was also an enjoyable technical challenge. Exploring the boundary between structure and simplicity became worthwhile in itself; wider usefulness is a welcome result.

### Problems YINI aims to solve

<a id="a2-what-was-missing-from-other-formats"></a>

The main design goals are:

- **Human readability:** Configuration is often reviewed and edited directly, so common structures should require little syntactic noise.
- **Unambiguous parsing:** A small, explicit rule set avoids depending on indentation or context-sensitive interpretation.
- **Support for common configuration data:** YINI provides nested sections, defined scalar types, lists, inline objects, multiline strings, comments, and a formal grammar.
- **Predictability:** The same valid document should have the same meaning across platforms and conforming implementations.
- **Explicit validation:** Strict mode makes structural expectations and document completion visible instead of relying only on convention or end-of-file.

Specialized types such as date-time values are intentionally outside the current core and may be considered in a future version. See [§11.1.3](#1113-date-time-type).

### Influences

<a id="b1-what-inspired-its-design"></a>

YINI draws primarily from INI, JSON, Python, Markdown, and C. It borrows familiar ideas where they support configuration work, but does not try to reproduce any one of those languages.

---

<a id="b-design-goals-and-philosophy"></a>

## Design Philosophy

<a id="b2-design-philosophy"></a>

YINI is guided by the following principles:

1. **Clarity over cleverness:** Prefer syntax that is easy to interpret correctly.
2. **Readability without sacrificing structure:** Keep files approachable while supporting nested configuration data.
3. **Simplicity with serious usability:** Remain small, but not so minimal that common configuration needs require workarounds.
4. **Predictability over magic:** Favor explicit and stable interpretation rules.
5. **Explicitness over hidden behavior:** Make structure, delimiters, and validation intent visible in the document.
6. **Structure without visual clutter:** Support hierarchy without making indentation syntactically significant.
7. **Human-friendly and parser-friendly:** Make direct editing comfortable while enabling consistent tooling.

> “I wanted something:
> - Simple and lightweight
> - Human-friendly to read and write
> - Capable of handling structured data
> - But not overly complex or verbose”
>
> — Mr. Seppänen, creator of YINI

<a id="b21-relationship-to-established-design-principles"></a>

### Relationship to Established Design Principles

YINI was not designed by applying one external principle automatically. Instead, several well-known software-design principles influenced the format in a practical way.

The format aligns with **KISS** (_"Keep It Simple, Stupid"_) by keeping the core syntax small and avoiding unnecessary constructs where simpler rules are enough. This is reflected in choices such as explicit section markers, quoted strings, bracketed lists, inline objects, and a limited set of value types.

YINI also follows the **principle of least surprise** / **least astonishment** (POLA). A YINI document should behave in a way that matches what its syntax suggests. For example, indentation may improve readability, but it does not define structure; `#` always begins a comment outside string literals and backticked identifiers; and `+` is defined only as string concatenation, not as a general arithmetic operator.

The principle **explicit is better than implicit** is reflected throughout the format. YINI favors visible section structure, explicit string delimiters (start/end characters), explicit list and object delimiters, and explicit strict-mode document completion using `/END`.

YINI uses an **explicit mode contract**. A mode declaration states how the document expects to be parsed. The parser checks that expectation against its active mode and rejects a mismatch rather than silently changing modes.

At the same time, YINI does not try to follow every possible principle to its extreme. It does not aim for maximum compactness, maximum flexibility, or a large expression system. In several cases, YINI deliberately chooses a slightly more explicit or restricted rule because configuration files are often read, reviewed, edited, and validated over time.

---

<a id="c-yini-vs-other-formats"></a>

## Relationship to Other Formats

<a id="c1-why-not-existing-formats"></a>
<a id="c2-comparison-yini-vs-other-formats"></a>

YINI occupies the space between lightweight INI-style files and more general structured-data formats. The comparisons here describe YINI's design motivation, not an objective ranking of the formats.

| Format | Relationship to YINI |
|--------|---|
| INI    | YINI keeps lightweight assignments and visually clear sections, while adding standardized nesting, value types, and validation rules. |
| JSON   | YINI uses a compatible scalar/list/object data model, while adding comments, simple unquoted identifiers, section syntax, and multiline strings for hand-edited configuration. |
| YAML   | YINI supports nested data and readable multiline text, but avoids indentation-defined structure and a broad set of implicit typing rules. |
| XML | Both can represent hierarchical structured data, but YINI uses lightweight assignments and sections rather than nested tags, aiming to reduce markup and visual overhead in hand-edited configuration. |
| TOML   | YINI shares the goal of a well-defined typed configuration format, but uses repeated section-depth markers, raw-by-default strings, and explicit strict and lenient modes. |
| JSON5  | Both improve hand editing compared with JSON, but YINI uses a section-oriented configuration syntax rather than retaining JSON's brace-oriented document structure. |
| KDL | Both emphasize readable structured data without indentation-defined hierarchy, but KDL uses a node-oriented syntax while YINI retains an assignment-and-section model closer to traditional configuration files. |
| HOCON | Both are designed for human-edited configuration and support nested structures, but HOCON provides more shorthand and substitution-oriented features, while YINI favors a smaller and more explicit syntax. |
| dotenv | Both support simple key-value configuration, but YINI adds standardized nesting, typed values, lists, objects, sections, and other structure beyond flat environment-variable assignments. |

These differences reflect YINI's intended balance:
- Structured sections without indentation semantics or long dotted paths as the only way to express depth.
- Defined strings, numbers, booleans, nulls, lists, and objects.
- Multiple comment forms and a way to disable complete lines temporarily.
- Raw-by-default strings, plus explicit escaped and multiline forms.
- A convenient lenient mode for hand editing and a stricter validation mode for tooling, generated files, and CI workflows.

YINI is not intended to replace every other configuration or serialization format. It is a pragmatic option for cases where a small, readable, structured, and deliberately specified configuration language is useful.

---

## [1. Introduction](./YINI-Specification.md#1-introduction)

### 1.1. What is YINI?
-

### 1.2. Purpose and Design Goals

See [Background and Motivation](#background-and-motivation) and [Design Philosophy](#design-philosophy).

### 1.3. Background and Intent

See [Why YINI was created](#why-yini-was-created) and [Relationship to Other Formats](#relationship-to-other-formats).

### 1.4. Key Features

The motivations for individual features are recorded under their corresponding specification sections below.

### 1.5. Terminology

The specification defines the normative terminology. This document uses the same terms so rationale can be matched directly to the relevant rule.

## [2. File Structure](./YINI-Specification.md#2-file-structure)

### 2.1. File Encoding

Requiring UTF-8 gives documents one portable text encoding. Accepting an initial UTF-8 BOM for compatibility lets a parser handle files produced by tools that add one, without making the BOM the recommended form.

### 2.2. File Extension

The `.yini` extension makes the format recognizable to people, editors, and file-based tools. It is a convention rather than a parsing rule because YINI can also be read from streams or embedded text.

#### 2.2.1. Strict-Mode Filename Suffix

The optional `.strict.yini` suffix signals an author's intent to readers and tools. Keeping mode selection external prevents a filename from silently changing parser behavior.

<a id="rationale-23-optional-shebang"></a>

### 2.3. Optional Shebang (`#!`)

An optional first-line shebang allows a YINI document to participate in command-line workflows.

**On Unix-like systems, a shebang is commonly used to select an interpreter when a file is executed directly.** More generally, the shebang identifies an executable program that is invoked with the file path as an argument, **so the target does not necessarily have to be a programming-language interpreter.**

For the corresponding Linux behavior, see the [`execve(2)` manual page](https://man7.org/linux/man-pages/man2/execve.2.html).

YINI only defines where the shebang may appear and how it is treated by the parser. Whether the shebang is acted upon, and how the referenced program is invoked, is determined by the operating system or other software handling the document.

Restricting the shebang to the beginning of the document prevents later `#!` text from conflicting with YINI's ordinary `#` comment syntax. For encoding and platform compatibility considerations, see [§14.3.3](#1433-shebang-line-optional).

Treating a misplaced `#!` as a `#` comment keeps its lexical meaning consistent. A required strict-mode error makes invalid shebang placement deterministic, while lenient mode retains the comment and recommends a warning.

### 2.4. YINI Marker (`@yini`)

The `@yini` marker is optional because **it is an identification declaration**, not syntax required to determine a document's structure or active parsing mode. A caller already selects the YINI parser and its mode externally. The marker is recommended when a document should identify itself to people or tools—especially when its filename, extension, or surrounding context is unavailable—but requiring it would reject otherwise valid YINI documents and break compatibility with documents written before the marker was introduced.

If using the `@yini` marker, then it is required near the beginning of the document **so that YINI can be identified early and predictably.** Only a shebang, comments, or whitespace may precede it, keeping the declaration separate from document data and avoiding ambiguity with metadata that appears after meaningful content.

#### 2.4.1. Optional Mode Declaration

<a id="b28-mode-declarations"></a>

A mode declaration records the document's expected validation mode:

```yini
@yini strict
@yini lenient
```

**The declaration expresses intent; it does not select or change the parser's active mode.** 

Allowing a document to change the active parsing mode would let the input choose the rules used to validate itself. For example, a file could request lenient parsing even though the calling application requires strict validation, causing input that the application intended to reject to be accepted. Keeping mode selection outside the document makes the validation policy predictable and under the caller's control. The declaration therefore records the author's intent and detects mismatches, but does not override the selected mode.

**Validation policy should be controlled by the application, not by the data being validated.** — If the document can control its own validation policy, it can potentially weaken or alter the checks applied to itself. Keeping validation policy in the application gives the application consistent, predictable control over what it accepts.

An explicit mode declaration must match the parser's active mode. Either mismatch is an error and the document is rejected. Accepting a strict declaration in lenient mode could give users the false impression that the document passed strict validation; accepting a lenient declaration in strict mode would apply different rules from those the author declared. Rejecting both avoids confusion and keeps the declared intent aligned with the validation actually performed.

This is useful for production configuration, CI validation, generated files, and shared project files where validation intent should be visible. The declaration remains optional so ordinary hand-edited files can stay lightweight and let the surrounding parser configuration decide.

## [3. Syntax Overview](./YINI-Specification.md#3-syntax-overview)

### 3.1. General Syntax Rules
-

### 3.2. Whitespace and Indentation

Indentation is visual rather than structural so that reformatting does not change the section hierarchy. Only SPACE (U+0020) and TAB (U+0009) are syntactic horizontal whitespace. They remain significant only where a rule needs them to separate tokens, such as between a numeric shorthand section marker and its section name.

LF, CRLF, and CR are the only recognized logical line endings. Keeping this set explicit prevents Unicode layout characters or other host-language whitespace rules from changing how a YINI document is tokenized. In particular, U+2028 LINE SEPARATOR and U+2029 PARAGRAPH SEPARATOR are text characters, not YINI line endings. Appendix 16.7 is therefore informational rather than an extension of YINI's accepted whitespace.

### 3.3. Comments

Comments in YINI:
- C-style foundation:
  * `//` — Primary line comments.
  * `/* ... */` — Block comments.
- Additional familiarity:
  * `#` — Common in scripting and configuration languages.
  * `;` — Traditional in INI; restricted to full-line comments in YINI.

YINI's comment system primarily follows the C-style model: `//` for line comments and `/* ... */` for block comments. It also supports `#`, which is familiar from scripting languages and configuration formats, and `;` as an INI-inspired full-line comment marker.

Comments support human-edited files without adding data to the parsed result. Recognizing comment markers only outside string literals and backticked identifiers prevents ordinary content from being mistaken for a comment.

#### 3.3.1. Inline Comments

<a id="b22-the--marker-as-a-comment-symbol"></a>
<a id="d32-why--as-hexadecimal-notation-was-removed"></a>
<a id="rejected-hash-hex"></a>

The `//` form is YINI's primary line-comment syntax because YINI's comment system was designed around the familiar C-style convention. The additional `#` form accommodates users coming from scripting languages and configuration formats where `#` is the customary comment marker. Both forms have the same line-comment behavior, although authors are encouraged to use one style consistently within a file.

Earlier drafts allowed a compact, CSS-like hexadecimal value such as `#FF0033`, while `#` followed by whitespace began a comment. That was useful for color values, but the meaning of `#` depended on the next character. Treating it as a comment marker everywhere outside strings and identifiers makes comments easier to recognize. 

The earlier rule required readers and parsers to distinguish these two lines by examining the character after `#`:

```yini
# Comment
#FF0033
```

YINI now uses the simpler rule: outside string literals and backticked identifiers, `#` always begins a comment, with no required whitespace before or after it. Hexadecimal values remain available through `0x...` and the explicit `hex:...` form. The cost is losing the familiar CSS spelling, but the result is easier to read and tokenize consistently.

```yini
name = "YINI" # This is a comment
enabled = true#This is also a comment
path = "C:\#folder" # The # inside the string is not a comment

color1 = 0xFF0033
color2 = hex:FF0033
```

**Similar behavior:** TypeScript uses JavaScript's `//` line-comment convention, while Python uses `#` for line comments. See the [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/typescript-from-scratch.html) and [Python lexical reference](https://docs.python.org/3/reference/lexical_analysis.html#comments).

### 3.3.2. Multi-line Block Comments

The `/* ... */` form completes YINI's C-style comment model and allows explanations or temporarily disabled regions to span several lines without placing a separate marker on every line. Following the conventional C-style rule, a block comment ends at the next `*/` and block comments do not nest. This keeps their boundaries easy to recognize and avoids introducing a separate YINI-specific nesting rule.

Line endings inside block comments remain logical-line boundaries. Preserving those boundaries prevents a comment from making a value on the next source line appear to start on the assignment's line.

**Similar behavior:** TypeScript inherits JavaScript's nonnested `/* ... */` block-comment form. See [ECMAScript comments](https://tc39.es/ecma262/multipage/ecmascript-language-lexical-grammar.html#sec-comments).

### 3.3.3. Full-line Comments

The `;` comment marker comes from YINI's INI heritage: many INI implementations traditionally recognize `;` at the beginning of a comment line. However, in C and related languages, `;` is commonly read as a statement terminator. Allowing it after meaningful YINI content could therefore make it look like statement-level syntax rather than a comment marker.

YINI resolves this conflict by recognizing `;` only as a full-line comment marker, after optional leading spaces or tabs. This preserves the familiar INI convention without introducing semicolon-terminated statements or a third inline-comment form.

### 3.4. Identifiers

**YINI's simple identifiers use a familiar basic ASCII pattern shared by many C-like languages, Python, and many other programming and configuration languages.**

Keeping simple identifiers close to this common denominator makes them immediately familiar and easy to recognize, scan, and tokenize consistently across parsers and tools. It also keeps token boundaries predictable and leaves punctuation available for YINI syntax, reducing the risk that future syntax additions will change how an existing identifier is interpreted.

Backticked identifiers provide an explicit alternative for names that do not fit the simple form, including names containing spaces or punctuation. Inside a backticked identifier, `` \` `` represents a literal backtick and `\\` represents a literal backslash. These escapes allow names from other data models to be represented without making the closing delimiter ambiguous. A literal backslash inside a backticked name must therefore be written as `\\`.

Whitespace surrounding an identifier token is insignificant, but content inside backticks is never trimmed or normalized. Leading, trailing, and internal spaces inside the delimiters are part of the identifier, so distinct source names do not collapse to one name.

**Backticked identifiers are intended to remain names rather than become another form of string literal.**

Raw control characters (U+0000–U+001F and U+007F–U+009F), including tabs and line endings, are prohibited so that identifiers remain visible, readable, and confined to one logical line. Escapes are limited to the two characters that require special handling: the backtick, which closes the identifier, and the backslash, which introduces an escape. This deliberately small escape model keeps parsing predictable and makes the rule straightforward to implement consistently across languages.

**Similar behavior:** C11 identifiers use the same basic ASCII form, but C11 also permits universal character names and implementation-defined characters and applies language-specific keyword and reserved-identifier rules. Kotlin uses backticks for identifiers that need characters outside its ordinary identifier form, including spaces. YINI's allowed characters and escapes differ. See the [C11 committee draft, Section 6.4.2.1](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) and the [Kotlin language specification](https://kotlinlang.org/spec/syntax-and-grammar.html#identifiers).

### 3.5. Document Terminator

<a id="b25-why-strict-mode-requires-end"></a>

Requiring `/END` in strict mode makes completion explicit. A missing marker can reveal some truncated or partly copied documents that an end-of-file check would accept. The cost is an extra line in every strict document, so lenient mode keeps it optional for hand-edited files. 

This is especially useful in validation-oriented workflows, CI pipelines, generated configuration, file transfer, embedding, and copy-and-paste operations. Together with strict mode's structural requirements, it makes incomplete fragments more likely to be rejected rather than silently accepted as complete documents.

The marker improves detection but cannot prove that all intended content is present: a fragment containing a complete section and `/END` may still be valid. It is an explicit completion signal, not an integrity check. Lenient mode leaves the marker optional because its priority is lower-friction hand editing.

**Historical authorial intent behind the spelling (non-normative):**

The `/END` spelling reflects two associations that influenced the author's original choice of marker. The leading `/` recalls an informal convention sometimes used to sign off a message with a slash followed by a name, giving the marker a visual sense of closure. `END` was influenced by the familiar BASIC-family keyword used to end program execution.

Together, these associations motivated the spelling `/END`. This historical note explains the origin of the name only; it does not add any syntax or semantics beyond the document-terminator rules defined by the specification.

### 3.6. Disable Line

Disabled lines let authors temporarily exclude configuration without deleting it. Although an ordinary comment marker could also prevent a line from being parsed, using the separate `--` form distinguishes inactive configuration from explanatory comments.

This distinction is especially useful when skimming a document. Editors and syntax highlighters can present disabled configuration differently from normal comments, for example by using a separate color or visual style. Readers can therefore identify settings that have been temporarily switched off without confusing them with documentation or other commentary.

The rule is deliberately line-oriented: outside strings, backticked identifiers,
and comments, `--` after optional leading spaces or tabs disables the remaining
configuration content on that line. The line ending still separates logical
lines. Each source line that should be disabled must have its own marker.
Keeping `--` as ordinary content inside strings prevents embedded text, such as
SQL comments, from being removed from a multiline value.

## [4. Keys and Values](./YINI-Specification.md#4-keys-and-values)

### 4.1. Key Naming Rules

Requiring the same identifier forms for keys and section names avoids separate naming systems. A unique key within its container gives each name one value.

### 4.2. Value Types (Simple, Compound, Special)

For version 1.0.0, YINI intentionally limits its native value types to the same core categories provided by JSON: string, number, boolean, null, list, and object. This keeps the first stable version focused on the types required for common configuration data while maintaining a familiar, interoperable data model.

Native date, time, date-time, and other specialized types are desirable, but they were classified as nice-to-have rather than essential for version 1.0.0. Values of these kinds can be represented as strings in the current version. Deferring native support does not rule it out; these types remain candidates on YINI's roadmap for versions after 1.0.0.

### 4.3. Type Rules

Syntax determines a value's type. Quoting strings keeps text distinct from number and keyword literals. Requiring an opening bracket or brace on the assignment line distinguishes a compound value from a missing value followed by another line.

Requiring quotes in both modes reduces the ambiguity behind YAML 1.1's "Norway problem". In YINI, `"NO"` is a string, unquoted `NO` is `false`, and unquoted `SE` is an error. Omitting the quotes can still produce an unintended boolean when the text matches a boolean word.

## [5. Section Headers](./YINI-Specification.md#5-section-headers)

### 5.1. Syntax

A header makes a section boundary visible without relying on indentation. Optional spacing allows compact repeated-marker headers such as `^name`; adding a space can make the name easier to read. Numeric shorthand requires a space or tab to keep the depth number separate from the name.

### 5.2. Section Markers (`^`, `§`, `>`, or `<`)

<a id="b24-summary-of-marker-characters"></a>

The caret is the primary marker because it is ASCII, visually distinct, and easy to repeat to show depth. The `§` marker offers a visual alternative but is less portable in ASCII-only tooling. The `>` marker is ASCII but may be treated as a quotation prefix by email or Markdown-like tools; `<` offers another ASCII choice.

The alternative markers address different practical considerations, including ASCII portability, visual distinctiveness, Unicode toolchain support, and compatibility with environments that interpret certain characters specially. Supporting multiple markers gives authors flexibility but increases the syntax that readers, parsers, and tools must recognize. YINI therefore designates `^` as the primary and recommended marker, while treating the other markers as alternatives for specific needs.

| Marker | Status | Example | Rationale or caveat |
|---|---|---|---|
| `^` | Primary | `^^ Section2` | Portable ASCII and the recommended form. |
| `§` | Alternative | `§§ Section2` | Visually distinctive, but less portable than ASCII. |
| `>` | Alternative ASCII fallback | `>> Section2` | Easy to type, but may be interpreted as a quotation prefix. |
| `<` | Alternative ASCII fallback | `<< Section2` | Portable ASCII and easy to count. |

#### Decision history

<a id="section-marker-history"></a>

Earlier drafts experimented with `#`, `~`, `>`, and other section markers. The caret became the primary marker because it is visually distinct, repeatable, and available in 7-bit ASCII. The `~` marker was discontinued because repeated tildes were difficult to count, and the ASCII `<` fallback replaced it. The `€` marker was dropped after v1.0.0-rc.3 because it offered no clear practical benefit over the supported markers. The `>` marker was initially discontinued and later restored with its portability caveat.

The history of `#` as a possible section marker is separate from its former use for CSS-style hexadecimal values. In current YINI, `#` is a comment marker outside strings and identifiers.

### 5.3. Nested Sections

Repeated markers expose depth in the header itself. Requiring each deeper level to follow its parent avoids creating an unspecified intermediate section. Returning to an established shallower depth remains straightforward.

TODO: Explain the chosen maximum depth of 255.

#### 5.3.1. Section Marker Separators

<a id="b27-section-marker-separators-and-repeated-marker-depth"></a>

--TODO: tell from where this was inspired, java? etc... Also a user wish--

Optional underscores make longer repeated-marker sequences easier to count without changing their depth. For example, `^^^_^^^_^^^` is easier to scan than `^^^^^^^^^`.

Keeping `_` available at the start of a section name preserves the same identifier rules for keys and sections. In `^_name`, the underscore starts the name because it is not between two identical markers. A space, as in `^ _name`, makes the boundary easier to read while keeping compact headers valid.

Earlier drafts used a lower maximum repeated-marker depth. Adding separators made levels 1–9 readable enough to write directly, allowing the limit to increase from 6 to 9.

#### 5.3.2. Shorthand Section Heading

Numeric shorthand prevents headers from growing into long runs of markers. Repeated markers keep shallower depth visually apparent, while a number is easier to read once that run becomes long. Allowing both forms through depth 9 adds two spellings for those levels; requiring the numeric form beyond 9 puts a limit on that visual complexity. For example, level 10 uses a form such as `^10 Section` instead of ten repeated markers.

## [6. String Literals](./YINI-Specification.md#6-string-literals)

### 6.1. Raw Strings (R-Strings)

<a id="b26-string-type-motivations"></a>
<a id="b261-raw-strings"></a>

Raw strings are the default because configuration often contains paths, URLs, patterns, and other text where a backslash should stay literal. 

Common examples include file paths, URLs, regular-expression-like fragments, shell commands, and snippets containing backslashes. Taking that text exactly as written avoids the familiar problem where `\n`, `\t`, or `\U` unexpectedly changes an ordinary configuration value.

The trade-off is that an author must choose a different string form when the value needs an escaped quote or control character. The optional `R` prefix can make raw intent visible without changing the value. This balance is the main reason Raw strings became YINI's default string form.

**Similar behavior:** Rust and C# raw string literals also leave backslashes uninterpreted, although their delimiters and other rules differ from YINI's. See the [Rust Reference](https://doc.rust-lang.org/reference/tokens.html#raw-string-literals) and [C# language specification](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/lexical-structure#6456-string-literals).

### 6.2. Classic Strings (C-Strings)

<a id="b262-classic-strings"></a>

An explicit `C` or `E` prefix opts into escape processing when a value needs an embedded newline or tab, a quote inside the quoted value, a control character, or a Unicode escape. Making this behavior the default would shorten some escaped values but make ordinary backslashes surprising. Requiring the prefix gives the author control at the cost of another string form to learn. The Escaped String name and `E`/`e` prefixes are preferred; the Classic String name and `C`/`c` prefixes remain supported but are deprecated.

--TODO: explain why C was chosen (Classic and the C language), and why E is also supported.--

#### 6.2.1. Escape Sequences

<a id="b23-non-standard-octal-escape"></a>
<a id="b210-escape-sequence-xhh-but-yini-strings-are-unicode"></a>

The defined escape list makes decoding predictable across parsers. A traditional C-style octal escape such as `\123` is shorter, but does not show its number base; YINI uses `\o123` by analogy with `\u` and `\U`, making the octal base explicit and the escape more self-describing.

The familiar `\xhh` spelling can suggest a raw byte, but YINI strings contain Unicode text rather than byte arrays. It therefore denotes Unicode code point U+00hh. For example, `\xFF` produces U+00FF, not an uninterpreted byte with value `0xFF`. This matches the resulting character for the corresponding two-digit escape in Python 3 and JavaScript. These choices retain familiar escape forms while giving each one a defined text-based interpretation.

Classic strings also recognize `` \` `` as a literal backtick. This gives the character one explicit escaped spelling in escape-aware text and matches the spelling used inside backticked identifiers.

TODO: Confirm the authorial motivation for retaining `` \` `` in Classic strings even though a backtick is not a Classic-string delimiter, and explain any other individual escape whose purpose is not already conventional.

**Similar behavior:** TypeScript and Python string literals also use exactly two hexadecimal digits for `\xhh` and produce the character U+00hh. See [ECMAScript string literals](https://tc39.es/ecma262/multipage/ecmascript-language-lexical-grammar.html#sec-literals-string-literals) and [Python escape sequences](https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences).

### 6.3. Triple-Quoted Strings

<a id="b263-triple-quoted-strings"></a>

Triple quotes make multi-line text possible without concatenating many single-line literals. They suit embedded text blocks, templates, SQL, prompts, email bodies, certificates, long descriptions, and script fragments.

Keeping spaces, tabs, blank lines, and the positions of line breaks preserves the text's layout. For line endings, YINI gives portability priority over keeping the exact source characters: LF, CRLF, and CR all become LF in the parsed value. Changing a file's line-ending form in an editor or during checkout therefore does not change its multiline string values.

Raw means that backslashes stay literal. The same line-ending rule applies to Raw, Escaped, and Command Strings, so authors do not need to choose a string form for portability. When exact CR or CRLF characters are needed, an Escaped String can express them with `\r` or `\r\n`. Those escape results stay unchanged.

**Similar behavior:** Python also uses triple quotes for multiline strings and converts source line endings to LF, even in raw literals. Unlike YINI, Python interprets escape sequences in strings without a prefix. Python uses `r` to make backslashes literal, while YINI makes backslashes literal by default. See [Python string literals](https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals) and [Python physical lines](https://docs.python.org/3/reference/lexical_analysis.html#physical-lines).

#### Rejected alternative: H-Strings

<a id="d33-hyper-strings-h-strings"></a>
<a id="rejected-h-strings"></a>

Earlier drafts defined Hyper Strings, or H-Strings, with an `H` or `h` prefix. They were intended for long prose-like values such as descriptions, labels, help text, and messages where source formatting should remain readable but exact whitespace did not need to be preserved.

H-Strings treated backslashes literally. They allowed multiline content and normalized consecutive line endings and defined whitespace characters to one U+0020 space, while trimming leading and trailing line endings and whitespace. In effect, they folded visually formatted source text into flowing prose:

In the historical proposal, a line ending meant CR, LF, or CRLF. The normalized whitespace set included the relevant Unicode `Zs`, `Zl`, and `Zp` separator categories and selected `Cc` control characters, primarily from the C0 range U+0000–U+001F. This was an H-String-specific proposal; it does not make those characters syntactic whitespace or line endings in current YINI.

```yini
H"My name is
  John Doe,
  and this is a test string."
```

The historical form above would have produced:

```txt
My name is John Doe, and this is a test string.
```

<a id="why-h-strings-were-removed"></a>

This feature was removed because it introduced another string form with separate whitespace-normalization rules. That increased the language's conceptual surface, parser complexity, documentation burden, and the number of overlapping choices for multiline text. Ordinary Raw strings and Triple-Quoted strings cover the common configuration use cases without those additional rules. H-Strings are historical and are not valid YINI syntax.

--TODO: mention, that if there is strong argument for this it might get reintroduced, propably not due to not wanting to add yet another string type since the effect of H-strings can be done in the host program pretty easily. ---

### 6.4. Command Strings

Command strings let authors write command sequences as one readable, indented block without quoting or concatenating each line. This is similar to [YAML's literal block scalar (`|`)](https://yaml.org/spec/1.2.2/#812-literal-style), using YINI's `command"""..."""` syntax. Removing structural indentation lets a script fit within an indented configuration while preserving the indentation that belongs to the script itself.

Line breaks between content lines are kept, including blank lines. Each becomes LF (`\n`), whether the source file uses LF, CRLF, or CR. This gives the same command text the same value across source line-ending forms. YAML also [normalizes line endings to LF](https://yaml.org/spec/1.2.2/#54-line-break-characters) in its literal blocks (`|`).

The line breaks immediately after the opening delimiter and before the closing delimiter are left out. YINI adds no extra line breaks. This avoids an unexpected final newline becoming part of a command or argument. Authors can include a final LF by writing an empty content line before the closing delimiter:

| Content inside the block | Parsed value (`\n` represents one LF) |
|---|---|
| One line | `"echo first"` |
| Two lines | `"echo first\necho second"` |
| Two lines followed by an empty content line | `"echo first\necho second\n"` |

YINI does not run the commands. The application chooses the shell or terminal interface. If needed, it converts LF to CRLF for a script file or submits each line through the terminal's input API. It can also add a final newline when the input interface requires one. Keeping the source file's line endings would not ensure that they match the target. The commands themselves may still depend on a particular operating system or shell.

### 6.5. String Types Summary
-

### 6.6. String Concatenation

<a id="b29-string-concatenation-and-non-arithmetic-"></a>

The `+` operator joins strings without adding arithmetic or a general expression language. Requiring the first operand to be a string rules out expressions such as `1 + 2 + "3"`, which could otherwise suggest either addition or concatenation. Strict mode requires every operand to be a string for an explicit, simple contract. Lenient mode permits later scalar operands for convenience, but needs conversion rules as a result. 

Optional spacing keeps compact expressions valid without making spaces change their meaning. A numeric operand can still have an explicit sign: in `"a"++42`, the first `+` joins the operands and the second marks the number as positive. Spaces remain recommended because `"a" + +42` is easier to read.

For example, this lenient-mode expression:

```yini
value = "1" + 2 + 3
```

produces the string `"123"`. By contrast, the following is invalid:

```yini
value = 1 + 2 + "3"
```

It produces neither `"123"` nor `"33"`; the expression does not begin with a string, and YINI defines no numeric addition. Lists and objects stay excluded because their string forms would require another set of potentially implementation-dependent choices.

### 6.7. Scalar Conversion in Lenient Concatenation

The conversion rules give permitted scalar operands one predictable spelling. 

Converting through a host-language number would look simple, but could round a large value or turn `1e3` into `1000` in one implementation while another preserves the exponent form. Normalizing the source spelling avoids that divergence. Digit separators and unnecessary plus signs are removed, and `E` is normalized to `e`, giving superficial spelling differences one portable result while preserving meaningful decimal points and exponent digits. Negative zero keeps its sign instead of being silently collapsed to positive zero.

Non-decimal integers are converted exactly to base-10 text, so their string result does not depend on preserving a YINI-specific base prefix. Implementations must perform that conversion without routing the value through a potentially lossy floating-point representation. The trade-off is that decimal normalization preserves more of the source's numeric spelling than a shortest-number formatter would, but that is preferable to implementation-dependent output.

## [7. Number Literals](./YINI-Specification.md#7-number-literals)

### 7.1. Numbers

Rejecting unnecessary leading zeros avoids competing spellings that readers may interpret differently.

Exact signed 64-bit integers and explicitly rounded binary64 floating-point
values give YINI a bounded numeric contract across languages. Larger integers
within that range require a lossless representation even when the host's usual
number type would round them. Ordinary floating-point rounding remains valid,
while overflow and rounding a nonzero value to zero produce errors in both modes.
This keeps common configuration numbers practical without letting the host
language silently determine their meaning. Concatenation retains its separate
source-spelling normalization under §6.7.

**Similar behavior:** Python also rejects nonzero decimal integer literals with leading zeros, such as `01`. YINI additionally rejects forms such as `00`, `00.5`, and `01e3`. See [Python integer literals](https://docs.python.org/3/reference/lexical_analysis.html#integer-literals).

### 7.2. Digit Separators

Underscores let authors group digits for readability without changing the numeric value. Limiting their positions keeps the number boundary clear.

**Similar behavior:** Python and C# also use underscores to group digits without changing their value. Both permit a separator immediately after some base prefixes, although their complete placement rules differ from YINI's. See [Python numeric literals](https://docs.python.org/3/reference/lexical_analysis.html#integer-literals) and [C# integer literals](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/integral-numeric-types#integer-literals).

### 7.3. Exponent Format

Exponent notation expresses very large or small decimal values compactly. TODO: Explain any compatibility reasons behind its exact accepted spelling.

**Similar behavior:** TypeScript and Python also accept `e` or `E` followed by an optional sign and decimal digits, as in `3e4` and `2E-3`. See [ECMAScript numeric literals](https://tc39.es/ecma262/multipage/ecmascript-language-lexical-grammar.html#sec-literals-numeric-literals) and [Python floating-point literals](https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals).

### 7.4. Number Formats

YINI deliberately keeps a `0`-prefixed form for each non-decimal base: `0b`, `0o`, `0z`, and `0x`. Selected aliases offer shorter or more descriptive spellings. Octal has no extra alias. This adds notation to learn, but each form has a fixed meaning. Aliases do not change the numeric value or range.

The removed `#` hexadecimal form was compact and familiar for colors, design systems, and UI configuration, but conflicted with the comment marker. Supporting both uses required a whitespace-sensitive distinction that was workable but unnecessarily surprising.

The `hex:` alternative preserves a readable, explicit type cue without overloading a punctuation character, while `0x` remains available for authors who prefer a conventional programming-language prefix:

```yini
color1 = hex:FF0033
color2 = 0xFF0033

invalid = hex: FF0033  // No space is allowed after the prefix.
```

Using one unambiguous meaning for `#` simplifies tokenization and supports YINI's preference for predictable syntax.

Binary makes flags and bit masks easy to read. The `%` binary prefix is deprecated because it is less conventional, and `%` is commonly associated with modulo operations or percentages in programming. Preferring the explicit `0b` prefix improves readability for developers unfamiliar with number bases.

**Historical note:** The `%` alias was inspired by the author's experience with assembly programming on the Commodore Amiga under AmigaOS. It offered a shorter spelling familiar from assemblers; see [vasm's Motorola syntax](https://github.com/Leffmann/vasm/blob/master/doc/syntax_mot.texi) and [ca65's binary prefix](https://cc65.github.io/doc/ca65.html#ss4.2).

Octal suits Unix file permissions.

Duodecimal supports settings for base-12 counters or educational tools; `0z10` means decimal `12`. The `A`/`B` digits follow the letter-digit pattern used in hexadecimal. The `X`/`E` aliases support another established dozenal convention. See the [Dozenal Society's digit discussion](https://dozenal.org/).

**Similar behavior:** TypeScript and Python also use `0b`, `0o`, and `0x` prefixes for binary, octal, and hexadecimal integer literals. YINI additionally defines word-based and symbolic forms. See [ECMAScript numeric literals](https://tc39.es/ecma262/multipage/ecmascript-language-lexical-grammar.html#sec-literals-numeric-literals) and [Python integer literals](https://docs.python.org/3/reference/lexical_analysis.html#integer-literals).

## [8. Boolean and Null Literals](./YINI-Specification.md#8-boolean-and-null-literals)

### 8.1. Booleans

The `yes`/`no` and `on`/`off` aliases express familiar configuration choices, such as `enabled = yes` or `logging = on`. They produce the same boolean values as `true` and `false`, in both modes. Case-insensitive matching also allows spellings such as `Yes` and `OFF` without changing their meaning. Quoted forms such as `"no"` remain strings.

### 8.2. Null Literal

Explicit `null` works in every mode and position. In lenient mode, a missing root-level or section-level value becomes `null` with a required warning. Missing values inside collections remain errors in both modes.

The warning helps catch accidental omissions, including `color = #FF9900`, where `#` starts a comment. Write `null` explicitly to make the intent clear and avoid this warning.

--TODO: Explain the choice to treat an empty member value as null rather than as an empty string.--

## [9. Object Literals](./YINI-Specification.md#9-object-literals)

### 9.1. Objects (using `{` and `}`)

Inline objects express a small nested group as a value without opening a new section. Requiring member separators and unique names keeps that group representable as a map.

**Similar behavior:** TypeScript and Python also allow a trailing comma after the last object or dictionary entry without creating another entry. YINI permits this only in lenient mode. See [ECMAScript object initializers](https://tc39.es/ecma262/multipage/ecmascript-language-expressions.html#sec-object-initializer) and [Python dictionary displays](https://docs.python.org/3/reference/expressions.html#dictionary-displays).

### 9.2. Object Member Separators

The canonical `:` distinguishes entries inside an object value from ordinary `=` assignments and follows a familiar map syntax. Allowing `=` in lenient mode is convenient for authors who use assignment syntax throughout a file, but creates two spellings for the same object.

Lenient mode defines both separators as standard syntax rather than leaving `=` as an implementation extension. Conforming parsers must therefore accept `:`, `=`, and mixtures of the two within one inline object. Mixed separators are discouraged because they reduce visual consistency, but rejecting them would reintroduce parser-dependent behavior. Strict mode accepts only `:`, and formatters should normalize lenient input to that canonical form so strict files and formatted files remain consistent.

## [10. List Literals](./YINI-Specification.md#10-list-literals)

### 10.1. Bracketed Lists (`[...]`)

<a id="d31-why-colon-based-lists-were-removed"></a>
<a id="rejected-colon-lists"></a>

Brackets show exactly where a list begins and ends, including when it spans lines or contains nested values. 

Earlier drafts experimented with a colon-based list shorthand. Although it saved some punctuation, it added no expressive capability beyond bracketed lists and introduced another grammar path, more edge cases, and a second mental model for the same data.

Keeping only bracketed lists establishes a uniform structure:

- Values are assigned with `=`.
- Lists are delimited by `[ ... ]`.
- `:` is used for object members.

This gives authors one recognizable list representation and keeps both the specification and parser implementations smaller and easier to maintain. A lenient trailing comma still helps hand editing; strict mode omits that optional punctuation for a more uniform list form.

**Similar behavior:** TypeScript and Python also allow a trailing comma after the last array or list element without creating another element. YINI permits this only in lenient mode. See [ECMAScript array initializers](https://tc39.es/ecma262/multipage/ecmascript-language-expressions.html#sec-array-initializer) and [Python list displays](https://docs.python.org/3/reference/expressions.html#list-displays).

## [11. Reserved and Future Constructs](./YINI-Specification.md#11-reserved-and-future-constructs)

### 11.1. Future / Reserved Features _(For Future Use)_

<a id="d4-future-considerations"></a>

Listing possible future constructs keeps readers from mistaking them for current syntax. --TODO: Explain which spellings, if any, are reserved now and what compatibility promise that reservation makes.--

#### 11.1.1. Anchors and Aliases

--TODO: Record the use case and the reason this feature is deferred.--

#### 11.1.2. Includes

--TODO: Confirm the intended include use cases and the authorial reason for deferring the feature.--

A form such as `@include "somefile.yini"` is a possible future feature, but it is not current YINI syntax. Any adopted design would need rules for path resolution, cycles, encoding, parser mode, duplicate names, security boundaries, and the point at which included content enters the data model.

#### 11.1.3. Date-time Type

Native date, time, and date-time values are desirable future features, but they were not considered essential for YINI's first stable release. Version 1.0.0 therefore keeps its native value model aligned with JSON and represents date and time values as strings.

Adding native types responsibly requires decisions about accepted calendars and literal syntax, local times, time-zone names and offsets, precision, normalization, validation, and round-trip preservation. Deferring the feature avoids committing version 1.0.0 to these decisions before their behavior has been designed and validated.

Date, time, and date-time types remain on YINI's post-1.0.0 roadmap, but the current specification defines no native date-time syntax or semantics.

#### Possible future annotations

Annotations such as `@deprecated` or `@experimental` could eventually attach metadata to a section or key and influence validation or semantics without changing the document's basic structure. They are possible future ideas, not current YINI syntax.

#### Possible terminology for future `@` constructs

If YINI adds more `@` constructs, the following terminology could distinguish their roles:

- **Directives or pragmas:** Parser hints that affect mode or behavior without adding document data, such as the current `@yini strict` and `@yini lenient` declarations or a possible future version declaration.
- **Preprocessing directives:** Instructions such as a possible `@include` that transform or expand the document before or during parsing.
- **Annotations:** Metadata such as possible `@deprecated` or `@experimental` markers attached to a key or section and affecting validation or semantics rather than structure.

This terminology is a design proposal and does not reserve or introduce any new syntax.

## [12. Validation Rules](./YINI-Specification.md#12-validation-rules)

### 12.1. Reserved Syntax

Reservation protects structural punctuation from acquiring unrelated meanings in ordinary values or identifiers. --TODO: Clarify the intended compatibility policy for future reserved constructs.--

#### 12.1.1. Reserved Characters

--TODO: Explain any reserved character whose purpose is not already covered in its syntax section.--

#### 12.1.2. Reserved Keywords

--TODO: Explain which keywords are reserved for a future feature and why each needs reservation now.--

### 12.2. Well-Formedness Requirements

Collecting validation requirements gives implementers a checklist across the syntax chapters. This section should restate those rules rather than introduce a different meaning for them.

#### 12.2.1. Structural Requirements

- **Declare:** Introduce an entity with a given name.
- **Define:** Specify the entity's content or initial value.

**Author's words:** *The first-wins rule was also chosen by following a common principle from programming languages: once an entity has been declared and defined (a key-value pair is seen as both a declaration and a definition in YINI), it cannot simply be redeclared without being flagged as a duplicate. On the other hand, explicitly giving an existing declaration a new definition is a different matter, but that goes a little beyond the scope of this rationale.*

---

Duplicate names force a choice: a later definition could replace, merge with, or be ignored in favor of the earlier one. Replacement or merging would let a later definition silently change a setting written above it. A YINI key-value pair both declares its key and defines its value. Following the common rule against redeclaring an already defined entity, a duplicate key does not replace the first value: lenient mode keeps the first value and warns, while strict mode rejects the duplicate. Explicit redefinition is a separate question. Duplicate sections are errors in both modes because a section may contain members and child sections, making an ignored duplicate block's boundaries and contents harder to interpret predictably.

First-wins can also surprise an author expecting an override, which is why the warning matters. Member and child-section names share a namespace so each container can become one object without collisions.


#### 12.2.2. Character Encoding

See §2.1. --TODO: Add any motivation specific to validation of malformed UTF-8.--

#### 12.2.3. Line Endings

Recognizing LF, CRLF, and CR lets files from different environments be parsed. Strict mode rejects mixed forms to make inconsistency visible; lenient mode accepts them with a warning.

These checks use the file's original line endings, so normalization cannot hide mixed forms. Characters produced by escapes belong to the value and do not count as source line endings.

#### 12.2.4. Valid Value Types

The limited set of types keeps parsed values predictable. See §4.2.

#### 12.2.5. Document Terminator

See [§3.5](#35-document-terminator).

#### 12.2.6. Escaping and String Literals

Limiting escapes to explicitly marked Classic strings preserves the literal meaning of Raw strings. See §§6.1–6.2.

#### 12.2.7. Shortest Valid YINI Documents in Strict Mode
-

### 12.3. Lenient vs. Strict Modes

Lenient mode accommodates hand editing, including selected conveniences such as trailing commas and missing member values, while keeping their meaning defined. Strict mode removes those conveniences and requires a visible root section and terminator for stronger validation. 

Two modes add rules that authors and implementers must track, but avoid forcing every small hand-edited file to carry the strict-mode structure.

--TODO: Explain the reason for each mode difference not already addressed in its syntax section.--

#### 12.3.1. Table: Lenient vs. Strict Mode
-

## [13. Implementation Rules](./YINI-Specification.md#13-implementation-rules)

### 13.1. Top-Level Sections and Document Root

A defined document root gives parsers a common abstract shape and supports consistent conversion to object-based formats.

#### 13.1.1. Lenient Mode: Orphan Members

Mounting orphan members directly beside top-level sections gives a document one shared root mapping. An implicit `base` wrapper might make orphan members easy for one API to group, but it changes the data shape and introduces a name the author did not write. The direct-root rule keeps YINI-to-JSON mapping consistent; an API may still add its own wrapper outside the YINI data model.

Because orphan members and explicit top-level sections become siblings, they share the document-root namespace. An orphan member and a top-level section with the same name must therefore be rejected instead of forcing a converter to choose whether that name denotes a scalar value or an object.

#### 13.1.2. Top-Level Section Mounting

Mounting top-level sections directly preserves their names and nesting in the parsed result. The no-skipped-level rule ensures every child has an explicit parent.

#### 13.1.3. Strict Mode

One explicit top-level section gives strict documents a visible root and rules out orphan members. See also §3.5 for the separate terminator requirement.

### 13.2. Line Handling and Whitespace

YINI accepts source files using LF, CRLF, or CR, but multiline string values always use LF for source line breaks. This gives portability priority over preserving the exact line-ending characters. Changing a file's line-ending form should not silently change its configuration values.

Source line endings are normalized before escape sequences are interpreted. This lets Escaped Strings request exact CR or CRLF characters with `\r` or `\r\n`. Normalizing those escape results would change the characters the author requested.

**Similar behavior:** Both Python and YAML convert source CRLF and CR line endings to LF. Python does this even in raw string literals, and YAML does it even in literal blocks (`|`). YINI follows the same rule. See [Python physical lines](https://docs.python.org/3/reference/lexical_analysis.html#physical-lines) and [YAML line break characters](https://yaml.org/spec/1.2.2/#54-line-break-characters).

Validation checks the original source line endings, so strict mode still rejects mixed forms. Applications handle command execution and convert line endings for the target when needed; see §6.4.

### 13.3. Value and Null Handling

Lenient missing values become `null` with a required warning. First-wins duplicate-key handling avoids silently replacing an earlier setting and also requires a warning. See §§8.2 and 12.2.1.

### 13.4. Boolean Canonicalization

Mapping the accepted boolean spellings to two logical values prevents source spelling from leaking into the data model.

### 13.5. Objects

--TODO: Add implementation-specific motivation beyond the object syntax and separator decisions in §9.--

### 13.6. Lists

--TODO: Add implementation-specific motivation beyond the bracket and separator decisions in §10.--

### 13.7. String Concatenation

--TODO: Add implementation-specific motivation beyond the rules and scalar conversion in §§6.6–6.7.--

### 13.8. String Literal Types

TODO: Add implementation-specific motivation beyond the distinctions in §§6.1–6.5.

### 13.9. Comments

TODO: Add implementation-specific motivation beyond the lexical boundaries in §3.3.

### 13.10. Additional Implementation Guidance

Position metadata and clear diagnostics help authors locate mistakes. TODO: Explain which recommendations are essential for interoperability and which are only developer-experience guidance.

## [14. Compatibility and Versioning](./YINI-Specification.md#14-compatibility-and-versioning)

### 14.1. Fallback Rules

Diagnostic recovery can help an editor show further errors, but accepting an implementation-dependent rewrite of an invalid name would make the parsed data vary across parsers.

The removed lenient fallback allowed retaining or remapping illegal characters; that flexibility made the result uncertain. An invalid key or section name must not silently become a valid source name chosen by an implementation. A parser may use an internal placeholder or recovery node to continue producing diagnostics, but that recovery artifact is not valid YINI data and must be reported.

Both modes require an error diagnostic for invalid names. A parser may continue
to locate further problems, but that recovery does not make the document valid.

#### 14.1.1. Invalid Sections or Keys

Removing the former retain-or-remap fallback avoids assigning different names to
the same invalid source text. Requiring an error in both modes gives that text
one common validity outcome.

#### 14.1.2. Graceful Degradation

Continuing after an error helps an editor show several problems at once. It does
not establish that the recovered data is safe to use as valid configuration.
Keeping recovery results explicitly partial and the document invalid allows
helpful diagnostics without letting a parser's chosen repairs change what counts
as valid YINI. Warnings for defined lenient forms, such as first-wins duplicate
keys, remain separate from errors for duplicate sections and invalid syntax.

### 14.2. Versioning Strategy

Version labels signal when a format change can affect existing documents or parsers. TODO: Clarify what compatibility promises apply to the specification versus the grammar package.

A future document-level declaration such as `@yini version 1.0`, `@version 1.0`, or a shorter form such as `@ver 1.0` could make the intended language version visible. No such spelling is defined by the current specification. Choosing one would require a compatibility policy and rules for unsupported, older, and newer versions before it could become valid syntax.

### 14.3. Encoding Notes

See §§2.1 and 2.3. TODO: Add compatibility reasoning specific to BOM and shebang handling.

#### 14.3.1 Required Encoding

See §2.1. TODO: Explain any compatibility consequences of rejecting non-UTF-8 input.

#### 14.3.2 Byte Order Mark (BOM)

Accepting an initial UTF-8 BOM as an option helps interoperability with tools that emit one, while keeping BOM-free UTF-8 the preferred form.

**Similar behavior:** XML 1.0 also treats an initial UTF-8 BOM as an encoding signature rather than document content. See [XML 1.0, §4.3.3](https://www.w3.org/TR/xml/#charencoding).

#### 14.3.3 Shebang Line (Optional)

The primary motivation for supporting shebangs is explained in [§2.3](#rationale-23-optional-shebang).

The shebang also interacts with encoding and platform behavior. YINI parsers may accept a UTF-8 BOM before it, but authors who intend a document to be executed directly should omit the BOM because external tools or operating systems may require `#!` to be the first bytes of the file.

YINI's rules govern parser recognition only. They do not require an operating system or other external program to recognize or act upon the shebang.

### 14.4. JSON Compatibility

Object-like structure and the shared scalar types make JSON a useful interchange target. A broad promise of lossless conversion would be attractive, but a converter may lose numeric precision and JSON has no place for comments, markers, or the terminator. Converting JSON back also requires choices about sections versus inline objects and about values or names YINI can represent. The qualified claim promises equivalent parsed data only where the converter can preserve it; a YINI identifier's text should become the same JSON object key in that case.

## [15. Examples](./YINI-Specification.md#15-examples)

### 15.1. Minimal Example
-

### 15.2. Realistic Config Use Cases
-

#### 15.2.1. User Preferences Configuration
-

#### 15.2.2. Application Settings with Sections
-

#### 15.2.3. Script Metadata
-

#### 15.2.4. Feature Flags
-

#### 15.2.5. Feature Toggles with Alternative Syntax
-

### 15.3. Examples of YINI → JSON Mapping

The examples illustrate the qualified data-model relationship explained in [§14.4](#144-json-compatibility).

#### 15.3.1. Simple Flat Structure to JSON
-

#### 15.3.2. Nested Sections (multiple levels) to JSON
-

#### 15.3.3. Lists (Arrays) to JSON
-

#### 15.3.4. Nulls and Booleans to JSON
-

### 15.4. Examples of JSON → YINI Mapping

See [§14.4](#144-json-compatibility).

#### 15.4.1. Simple JSON Object to YINI
-

#### 15.4.2. Nested JSON Objects to YINI
-

#### 15.4.3. JSON Array to YINI
-

### 15.5. Large-Scale Real-World Configuration Example A: Corporate SaaS Platform
-

### 15.6. Large-Scale Real-World Configuration Example B: High-Security Distributed Control System
-

### 15.7. Large-Scale Real-World Configuration Example C: Industrial Monitoring & Automation Platform
-

## [16. Appendices and Reserved Areas](./YINI-Specification.md#16-appendices-and-reserved-areas)

### 16.1. License
-

### 16.2. Acknowledgments

See [Acknowledgments](#acknowledgments).

### 16.3. Author(s)
-

### 16.4. Spec Changes

This section records changes to the specification rather than introducing additional design rationale.

### 16.5. Formal Grammar

The maintained ANTLR4 grammar is stored separately in the repository's [`Grammar-ANTLR4/`](./Grammar-ANTLR4/) directory. Keeping the grammar in dedicated source files avoids duplicating a long implementation artifact in the prose specification and allows grammar tooling to consume it directly. The grammar accompanying YINI Specification 1.0.0-RC.7 is version 1.4.0-RC.1.

**NOTE:**
The grammar deliberately recognizes some invalid forms so an implementing parser can produce more useful diagnostics. Parsing-mode rules, duplicate-name handling, section nesting, and other semantic constraints remain defined by the specification and are enforced outside the grammar. The specification therefore remains the authority for conformance if the grammar and prose differ.

### 16.6. Common Mistakes and Pitfalls

The specification's examples illustrate consequences of decisions explained under the corresponding syntax sections above.

### 16.7. 🧾 Unicode Whitespace Characters

The appendix is an informational character reference. It does not extend the set of characters accepted as YINI syntactic whitespace or line endings.

---

## Historical and Rejected Alternatives

<a id="d3-rejected-ideas-or-alternatives"></a>

Rejected ideas are documented beside the current feature they affected, so readers can compare the alternative directly with the adopted rule:

- [Earlier section-marker choices](#section-marker-history)
- [`#` as hexadecimal notation](#rejected-hash-hex)
- [Hyper Strings (H-Strings)](#rejected-h-strings)
- [Colon-based lists](#rejected-colon-lists)

These decisions reflect a recurring preference for one clear representation over multiple overlapping forms. Features were removed when their convenience did not justify additional grammar, normalization rules, ambiguity, or implementation burden.

---

<a id="d-reflections-and-acknowledgments"></a>
<a id="d2-acknowledgments--special-thanks"></a>

## Acknowledgments

Parts of the YINI specification and its rationale have benefited from feedback and insights shared by users in the broader community. Thanks go to readers and contributors on Reddit, Medium, and other platforms, including anyone unintentionally omitted here.

Special thanks to:

- User _jaskij_ (Reddit), for feedback during v1.0.0 Beta 6 concerning special characters, Unicode handling, and indentation of nested sections for readability.
- David Demelier (_markand67_), for discussions and feedback during v1.0.0 Beta 3–4 concerning the `/END` terminator, `#` comment syntax, and related design choices.
- User _zanfar_ (Reddit), for feedback concerning `#`.
- User _lelanthran_ (Reddit), for feedback concerning `#`.
- User _saxbophone_ (Reddit), for feedback concerning `#`.
- User _JoshYx_ (Reddit), for raising concerns about forms such as `###`.
- User _tonyp7_ (Reddit), for support and encouragement.
- User _cat_in_the_wall_ (Reddit), for support and encouragement.
- Everyone else who contributed feedback, testing, discussion, or encouragement.

<a id="d1-summary"></a>

YINI aims to make structured configuration easier to read, maintain, validate, and integrate into tooling. It was also created for the enjoyment of exploring how minimalism, clarity, and useful structure can coexist. Feedback, testing, contributions, and adoption across the ecosystem are welcome.

---

**^YINI ≡**

> A clear, structured, and human-friendly configuration format.

[yini-lang.org](https://yini-lang.org/?utm_source=github&utm_medium=referral&utm_campaign=yini_spec&utm_content=doc_footer) · [YINI-lang on GitHub](https://github.com/YINI-lang)
