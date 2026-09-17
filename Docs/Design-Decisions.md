# YINI Design Decisions by Specification Section

This companion to the [YINI Specification](../YINI-Specification.md) explains the reasons behind its rules. Its headings follow the specification's section numbers and names so that a decision can be found beside the rule it explains.

For the broader background, design goals, and comparisons with other formats, see [Rationale](../RATIONALE.md).

This document is informative. The specification defines YINI's rules if the wording here differs. The explanations below are a working draft based on the specification and the existing rationale.

A **TODO** marks a decision whose motivation still needs to be written or confirmed. 

A standalone `-` means the section is intentionally skipped here because it introduces, summarizes, or illustrates rules explained elsewhere.

---

## [1. Introduction](../YINI-Specification.md#1-introduction)

### 1.1. What is YINI?

-

### 1.2. Purpose and Design Goals

-

### 1.3. Background and Intent

-

### 1.4. Key Features

-

### 1.5. Terminology

-

## [2. File Structure](../YINI-Specification.md#2-file-structure)

### 2.1. File Encoding

Requiring UTF-8 gives documents one portable text encoding. Accepting an initial UTF-8 BOM for compatibility lets a parser handle files produced by tools that add one, without making the BOM the recommended form.

### 2.2. File Extension

The `.yini` extension makes the format recognizable to people, editors, and file-based tools. It is a convention rather than a parsing rule because YINI can also be read from streams or embedded text.

#### 2.2.1. Strict-Mode Filename Suffix

The optional `.strict.yini` suffix signals an author's intent to readers and tools. Keeping mode selection external prevents a filename from silently changing parser behavior.

### 2.3. Optional Shebang (`#!`)

An optional first-line shebang allows a YINI file to participate in command-line workflows. Restricting it to the beginning keeps later `#` text under the ordinary comment rule.

### 2.4. YINI Marker (`@yini`)

The marker identifies the format even when a filename is unavailable. Making it optional keeps small configuration files short.

#### 2.4.1. Optional Mode Declaration

A mode declaration records the document's expected validation mode. The caller still chooses the active mode; a mismatch produces a diagnostic instead of silently changing the parser's behavior. See [Rationale §B.2.8](../RATIONALE.md#b28-mode-declarations).

## [3. Syntax Overview](../YINI-Specification.md#3-syntax-overview)

### 3.1. General Syntax Rules

-

### 3.2. Whitespace and Indentation

Indentation is visual rather than structural so that reformatting does not change the section hierarchy. Spaces and tabs remain significant only where a rule needs them to separate tokens.

### 3.3. Comments

Comments support human-edited files without adding data to the parsed result. Recognizing them only outside strings and identifiers prevents ordinary text from being mistaken for a comment.

#### 3.3.1. Inline Comments

Treating `#` as a comment marker everywhere outside strings and identifiers removes the former context-sensitive distinction between comments and `#`-prefixed hexadecimal values. Hexadecimal values have explicit alternatives. See [Rationale §B.2.2](../RATIONALE.md#b22-the--marker-as-a-comment-symbol).

TODO: Add the motivation for retaining both `#` and `//`.

#### 3.3.2. Multi-line Block Comments

TODO: Explain the need for comments spanning several lines and the decision not to support nested block comments.

#### 3.3.3. Full-line Comments

TODO: Explain why `;` is limited to full-line comments rather than also serving as an inline marker.

### 3.4. Identifiers

Simple identifiers cover common names with little punctuation. Backticked identifiers allow spaces and other characters when a name needs them, while preserving the boundary of the name. Escaping the delimiter and backslash lets either character appear inside the name. Preserving spaces inside backticks keeps distinct names distinct.

TODO: Document the reason for the exact set of allowed identifier escapes and control-character restrictions.

### 3.5. Document Terminator

Requiring `/END` in strict mode makes completion explicit and helps detect some truncated documents. Keeping it optional in lenient mode avoids ceremony for ordinary hand-edited files. The marker cannot detect every possible truncation. See [Rationale §B.2.5](../RATIONALE.md#b25-why-strict-mode-requires-end).

### 3.6. Disable Line

Disabled lines let an author temporarily exclude a complete configuration line while leaving it visible in the file. Ignoring the whole line avoids partly applying disabled syntax.

TODO: Explain why this needs a separate `--` form rather than an ordinary comment.

## [4. Keys and Values](../YINI-Specification.md#4-keys-and-values)

### 4.1. Key Naming Rules

Requiring the same identifier forms for keys and section names avoids separate naming systems. A unique key within its container gives each name one value.

### 4.2. Value Types (Simple, Compound, Special)

The small set of scalar and compound types covers common configuration data and can be represented naturally in an object-based data model. TODO: Explain the choice to keep date-time and other specialized types outside the current core.

### 4.3. Type Rules

Syntax determines a value's type. Quoting every string prevents an unquoted word from changing meaning when a keyword or number form is added. Requiring an opening bracket or brace on the assignment line distinguishes a compound value from a missing value followed by another line.

## [5. Section Headers](../YINI-Specification.md#5-section-headers)

### 5.1. Syntax

A header makes a section boundary visible without relying on indentation. TODO: Explain the spacing difference between repeated markers and numeric shorthand.

### 5.2. Section Markers (`^`, `§`, `>`, or `<`)

The caret is the primary marker because it is ASCII and visually distinct. The alternatives serve different display or portability preferences; their caveats are documented so authors can choose deliberately. See [Rationale §B.2.4](../RATIONALE.md#b24-summary-of-marker-characters).

### 5.3. Nested Sections

Repeated markers expose depth in the header itself. Requiring each deeper level to follow its parent avoids creating an unspecified intermediate section. Returning to an established shallower depth remains straightforward.

TODO: Explain the chosen maximum depth of 255.

#### 5.3.1. Section Marker Separators

Optional underscores make longer repeated-marker sequences easier to count without changing their depth. See [Rationale §B.2.7](../RATIONALE.md#b27-section-marker-separators-and-repeated-marker-depth).

#### 5.3.2. Shorthand Section Heading

Numeric shorthand prevents headers from growing into long runs of markers. Repeated markers remain available through depth 9, where they can still be read and counted; deeper levels use the number. See [Rationale §B.2.7](../RATIONALE.md#b27-section-marker-separators-and-repeated-marker-depth).

## [6. String Literals](../YINI-Specification.md#6-string-literals)

### 6.1. Raw Strings (R-Strings)

Raw strings are the default because configuration often contains paths, URLs, patterns, and other text where a backslash should stay literal. The optional `R` prefix makes that intent visible without changing the value. See [Rationale §B.2.6.1](../RATIONALE.md#b261-raw-strings).

### 6.2. Classic Strings (C-Strings)

The explicit `C` prefix opts into escape processing when a value needs characters that are difficult or impossible to write directly. It prevents an ordinary raw string from interpreting a backslash unexpectedly. See [Rationale §B.2.6.2](../RATIONALE.md#b262-classic-strings).

#### 6.2.1. Escape Sequences

The defined escape list makes decoding predictable across parsers. In particular, `\xhh` denotes a Unicode code point, not a byte, because YINI strings contain text rather than raw bytes. The `\o` prefix makes the octal base explicit. See [Rationale §B.2.3](../RATIONALE.md#b23-non-standard-octal-escape) and [§B.2.10](../RATIONALE.md#b210-escape-sequence-xhh-but-yini-strings-are-unicode).

TODO: Explain the choice of every individual escape only where its purpose is not already conventional.

### 6.3. Triple-Quoted Strings

Triple quotes make multi-line text possible without concatenating many single-line literals. Preserving line breaks lets authors use them for text whose layout matters. A `C` prefix remains available when that text also needs escapes. See [Rationale §B.2.6.3](../RATIONALE.md#b263-triple-quoted-strings).

### 6.4. String Types Summary

-

### 6.5. String Concatenation

The `+` operator joins strings without adding arithmetic or a general expression language. Requiring the first operand to be a string keeps the expression recognizable as concatenation. Strict mode requires all operands to be strings; lenient mode permits later scalar operands for convenience. Lists and objects have no implicit string form. See [Rationale §B.2.9](../RATIONALE.md#b29-string-concatenation-and-non-arithmetic-).

### 6.6. Scalar Conversion in Lenient Concatenation

The conversion rules give permitted scalar operands one predictable spelling. Normalizing the source number text without first passing it through a potentially lossy floating-point value avoids implementation-dependent output; non-decimal integers become base-10 text.

## [7. Number Literals](../YINI-Specification.md#7-number-literals)

### 7.1. Numbers

Rejecting unnecessary leading zeros avoids competing spellings that readers may interpret differently. TODO: Document the intended numeric precision and range model.

### 7.2. Digit Separators

Underscores let authors group digits for readability without changing the numeric value. Limiting their positions keeps the number boundary clear.

### 7.3. Exponent Format

Exponent notation expresses very large or small decimal values compactly. TODO: Explain any compatibility reasons behind its exact accepted spelling.

### 7.4. Number Formats

Base prefixes make a number's base explicit. The `hex:` form replaces the removed `#` hexadecimal notation, leaving `#` unambiguously a comment marker. See [Rationale §B.2.2](../RATIONALE.md#b22-the--marker-as-a-comment-symbol).

TODO: Explain the uses for each supported non-decimal base and its alternative notation.

## [8. Boolean and Null Literals](../YINI-Specification.md#8-boolean-and-null-literals)

### 8.1. Booleans

TODO: Explain why `yes`/`no` and `on`/`off` are accepted alongside `true`/`false`, including the choice to make them case-insensitive.

### 8.2. Null Literal

Explicit `null` works in every mode and position. A missing root-level or section-level value becomes null only in lenient mode; missing values inside collections stay invalid so separators cannot silently create extra elements.

TODO: Explain the choice to treat an empty member value as null rather than as an empty string.

## [9. Object Literals](../YINI-Specification.md#9-object-literals)

### 9.1. Objects (using <code>{</code> and <code>}</code>)

Inline objects express a small nested group as a value without opening a new section. Requiring member separators and unique names keeps that group representable as a map.

### 9.2. Object Member Separators

The canonical `:` distinguishes entries inside an object value from ordinary `=` assignments. Lenient mode also accepts `=` for authors who use assignment syntax throughout a file; strict mode keeps one canonical form.

## [10. List Literals](../YINI-Specification.md#10-list-literals)

### 10.1. Bracketed Lists (`[...]`)

Brackets show exactly where a list begins and ends, including when it spans lines or contains nested values. A lenient trailing comma helps hand editing; strict mode omits that optional punctuation for a more uniform list form.

## [11. Reserved and Future Constructs](../YINI-Specification.md#11-reserved-and-future-constructs)

### 11.1. Future / Reserved Features (For Future Use)

Listing possible future constructs keeps readers from mistaking them for current syntax. TODO: Explain which spellings, if any, are reserved now and what compatibility promise that reservation makes.

#### 11.1.1. Anchors and Aliases

TODO: Record the use case and the reason this feature is deferred.

#### 11.1.2. Includes

TODO: Record the use case and the reason this feature is deferred.

#### 11.1.3. Date-time Type

TODO: Record the use case and the reason dates and times remain strings for now.

## [12. Validation Rules](../YINI-Specification.md#12-validation-rules)

### 12.1. Reserved Syntax

Reservation protects structural punctuation from acquiring unrelated meanings in ordinary values or identifiers. TODO: Clarify the intended compatibility policy for future reserved constructs.

#### 12.1.1. Reserved Characters

TODO: Explain any reserved character whose purpose is not already covered in its syntax section.

#### 12.1.2. Reserved Keywords

TODO: Explain which keywords are reserved for a future feature and why each needs reservation now.

### 12.2. Well-Formedness Requirements

Collecting validation requirements gives implementers a checklist across the syntax chapters. This section should restate those rules rather than introduce a different meaning for them.

#### 12.2.1. Structural Requirements

Duplicate names cannot be merged or overwritten without changing the data a reader might expect. In lenient mode the first definition wins with a warning; strict mode rejects the duplicate. Member and child-section names share a namespace so each container can become one object without collisions.

#### 12.2.2. Character Encoding

See §2.1. TODO: Add any motivation specific to validation of malformed UTF-8.

#### 12.2.3. Line Endings

Recognizing LF, CRLF, and CR lets files from different environments be parsed. Strict mode rejects mixed forms to make inconsistency visible; lenient mode accepts them with a warning.

#### 12.2.4. Valid Value Types

The limited set of types keeps parsed values predictable. See §4.2.

#### 12.2.5. Document Terminator

See §3.5 and [Rationale §B.2.5](../RATIONALE.md#b25-why-strict-mode-requires-end).

#### 12.2.6. Escaping and String Literals

Limiting escapes to explicitly marked Classic strings preserves the literal meaning of Raw strings. See §§6.1–6.2.

#### 12.2.7. Shortest Valid YINI Documents in Strict Mode

-

### 12.3. Lenient vs. Strict Modes

Lenient mode accommodates hand editing while retaining defined meanings for accepted syntax. Strict mode is intended for stronger validation. The mode table makes those differences visible in one place.

TODO: Explain the reason for each mode difference not already addressed in its syntax section.

#### 12.3.1. Table: Lenient vs. Strict Mode

-

## [13. Implementation Rules](../YINI-Specification.md#13-implementation-rules)

### 13.1. Top-Level Sections and Document Root

A defined document root gives parsers a common abstract shape and supports consistent conversion to object-based formats.

#### 13.1.1. Lenient Mode: Orphan Members

Mounting orphan members directly beside top-level sections gives a document one shared root mapping. An implicit `base` wrapper would make the same source produce different trees in different implementations.

#### 13.1.2. Top-Level Section Mounting

Mounting top-level sections directly preserves their names and nesting in the parsed result. The no-skipped-level rule ensures every child has an explicit parent.

#### 13.1.3. Strict Mode

One explicit top-level section gives strict documents a visible root and rules out orphan members. See also §3.5 for the separate terminator requirement.

### 13.2. Line Handling and Whitespace

Logical line recognition is needed for syntax across platforms. Preserving original line-ending characters inside triple-quoted strings prevents structural parsing from silently changing a string value.

### 13.3. Value and Null Handling

Lenient empty values have a defined null meaning. First-wins duplicate handling avoids silently replacing an earlier setting; a diagnostic still alerts the author. See §§8.2 and 12.2.1.

### 13.4. Boolean Canonicalization

Mapping the accepted boolean spellings to two logical values prevents source spelling from leaking into the data model.

### 13.5. Objects

TODO: Add implementation-specific motivation beyond the object syntax and separator decisions in §9.

### 13.6. Lists

TODO: Add implementation-specific motivation beyond the bracket and separator decisions in §10.

### 13.7. String Concatenation

TODO: Add implementation-specific motivation beyond the rules and scalar conversion in §§6.5–6.6.

### 13.8. String Literal Types

TODO: Add implementation-specific motivation beyond the distinctions in §§6.1–6.4.

### 13.9. Comments

TODO: Add implementation-specific motivation beyond the lexical boundaries in §3.3.

### 13.10. Additional Implementation Guidance

Position metadata and clear diagnostics help authors locate mistakes. TODO: Explain which recommendations are essential for interoperability and which are only developer-experience guidance.

## [14. Compatibility and Versioning](../YINI-Specification.md#14-compatibility-and-versioning)

### 14.1. Fallback Rules

Diagnostic recovery can help an editor show further errors, but accepting an implementation-dependent rewrite of an invalid name would make the parsed data vary across parsers.

#### 14.1.1. Invalid Sections or Keys

Removing the former retain-or-remap fallback avoids assigning different names to the same invalid source text. TODO: Revisit whether the current lenient-mode `SHOULD` error is strong enough for a common conformance result.

#### 14.1.2. Graceful Degradation

TODO: Define the intended boundary between a diagnostic recovery result and a valid YINI document.

### 14.2. Versioning Strategy

Version labels signal when a format change can affect existing documents or parsers. TODO: Clarify what compatibility promises apply to the specification versus the grammar package.

### 14.3. Encoding Notes

See §§2.1 and 2.3. TODO: Add compatibility reasoning specific to BOM and shebang handling.

#### 14.3.1. Required Encoding

See §2.1. TODO: Explain any compatibility consequences of rejecting non-UTF-8 input.

#### 14.3.2. Byte Order Mark (BOM)

Accepting an initial UTF-8 BOM as an option helps interoperability with tools that emit one, while keeping BOM-free UTF-8 the preferred form.

#### 14.3.3. Shebang Line (Optional)

See §2.3. TODO: Record any additional compatibility reason for permitting a first-line shebang.

### 14.4. JSON Compatibility

Object-like structure and the shared scalar types make JSON a useful interchange target. The compatibility claim is qualified because a converter may lose numeric precision, YINI-only syntax is omitted, and converting JSON back may require mapping choices. A YINI identifier's text should become the same JSON object key when conversion is lossless.

## [15. Examples](../YINI-Specification.md#15-examples)

-

## [16. Appendices and Reserved Areas](../YINI-Specification.md#16-appendices-and-reserved-areas)

-
