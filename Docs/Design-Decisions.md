# YINI Design Decisions by Specification Section

This companion to the [YINI Specification](../YINI-Specification.md) explains the reasons behind its rules. Its headings follow the specification's section numbers and names so that a decision can be found beside the rule it explains.

For the broader background, design goals, and comparisons with other formats, see [Rationale](../RATIONALE.md).

This document is informative. The specification defines YINI's rules if the wording here differs. The explanations below are a working draft based on the specification and the existing rationale.

A **TODO** marks a decision whose motivation still needs to be written or confirmed. 

A standalone `-` means the section is intentionally skipped here because it introduces, summarizes, or illustrates rules explained elsewhere.

Language comparisons below apply only to the specific behavior stated. TypeScript follows JavaScript syntax for these examples; see the [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/typescript-from-scratch.html).

---

## [1. Introduction](../YINI-Specification.md#1-introduction)

### 1.1. What is YINI?
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

A mode declaration records the document's expected validation mode. Having `@yini strict` switch the parser automatically would be convenient, but it would let a file change the validation policy chosen by its caller. YINI instead leaves mode selection with the caller and diagnoses a mismatch. The declaration remains optional so ordinary files do not need extra ceremony. See [Rationale §B.2.8](../RATIONALE.md#b28-mode-declarations).

## [3. Syntax Overview](../YINI-Specification.md#3-syntax-overview)

### 3.1. General Syntax Rules
-

### 3.2. Whitespace and Indentation

Indentation is visual rather than structural so that reformatting does not change the section hierarchy. Spaces and tabs remain significant only where a rule needs them to separate tokens.

### 3.3. Comments

Comments support human-edited files without adding data to the parsed result. Recognizing them only outside strings and identifiers prevents ordinary text from being mistaken for a comment.

#### 3.3.1. Inline Comments

Earlier drafts allowed a compact, CSS-like hexadecimal value such as `#FF0033`, while `#` followed by whitespace began a comment. That was useful for color values, but the meaning of `#` depended on the next character. Treating it as a comment marker everywhere outside strings and identifiers makes comments easier to recognize. 

Hexadecimal values remain available through `0x` and `hex:`. The cost is losing the familiar CSS spelling. See [Rationale §B.2.2](../RATIONALE.md#b22-the--marker-as-a-comment-symbol) and [§D.3.2](../RATIONALE.md#d32-why--as-hexadecimal-notation-was-removed).

TODO: Add the motivation for retaining both `#` and `//`.

**Comparable behavior:** YINI's `#` line comments work like Python's `#` comments, and YINI's `//` line comments work like JavaScript and TypeScript `//` comments: each marker consumes the rest of the line outside a string. See the [Python lexical reference](https://docs.python.org/3/reference/lexical_analysis.html#comments) and [ECMAScript comments](https://tc39.es/ecma262/multipage/ecmascript-language-lexical-grammar.html#sec-comments).

**Further matches:** Go, Java, and C11 also use `//` to begin a line comment. See the [Go specification](https://go.dev/ref/spec#Comments), [Java Language Specification](https://docs.oracle.com/javase/specs/jls/se25/html/jls-3.html#jls-3.7), and [C11 draft, §6.4.9](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf#page=93).

**Further matches:** C#, C++, Kotlin, and Swift also use `//` for comments that end at the line break. See the [C# language specification](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/lexical-structure#633-comments), [C++ draft](https://eel.is/c++draft/lex.comment), [Kotlin language specification](https://kotlinlang.org/spec/syntax-and-grammar.html#lexical-grammar), and [Swift book](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics/).

**Specification:** [§3.3.1, Inline Comments](../YINI-Specification.md#331-inline-comments).

#### 3.3.2. Multi-line Block Comments

TODO: Explain the need for comments spanning several lines and the decision not to support nested block comments.

**Comparable behavior:** JavaScript and TypeScript also use `/* ... */` for block comments and do not nest them. See [ECMAScript comments](https://tc39.es/ecma262/multipage/ecmascript-language-lexical-grammar.html#sec-comments).

**Further matches:** Go, Java, and C11 also end a `/* ... */` comment at the first `*/`, without nesting. See the [Go specification](https://go.dev/ref/spec#Comments), [Java Language Specification](https://docs.oracle.com/javase/specs/jls/se25/html/jls-3.html#jls-3.7), and [C11 draft, §6.4.9](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf#page=93).

**Further matches:** C# and C++ also use nonnested `/* ... */` comments. See the [C# language specification](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/lexical-structure#633-comments) and [C++ draft](https://eel.is/c++draft/lex.comment).

**Specification:** [§3.3.2, Multi-line Block Comments](../YINI-Specification.md#332-multi-line-block-comments).

#### 3.3.3. Full-line Comments

TODO: Explain why `;` is limited to full-line comments rather than also serving as an inline marker.

### 3.4. Identifiers

Simple identifiers keep common names easy to scan and tokenize. Allowing arbitrary punctuation in every identifier would make boundaries less obvious; requiring backticks for less common names keeps that flexibility explicit. Escaping the delimiter and backslash lets those characters appear inside a backticked name, including when mapping a name that contains a backtick from another format. This costs an extra escape rule and means a literal backslash inside a backticked name must be written as `\\`. Spaces inside backticks remain significant so distinct source names do not collapse to one name.

TODO: Document the reason for the exact set of allowed identifier escapes and control-character restrictions.

**Comparable behavior:** Python and JavaScript/TypeScript names are also case-sensitive: `Title` and `title` are distinct names. The permitted identifier characters differ. See [Python names](https://docs.python.org/3/reference/lexical_analysis.html#names) and [ECMAScript identifiers](https://tc39.es/ecma262/multipage/ecmascript-language-lexical-grammar.html#sec-names-and-keywords).

**Further match:** Kotlin also uses backticks to quote identifiers that need characters outside its ordinary identifier form, including spaces. Its allowed characters differ; YINI additionally defines `` \` `` for a backtick inside an identifier. See the [Kotlin language specification](https://kotlinlang.org/spec/syntax-and-grammar.html#identifiers).

**Specification:** [§3.4, Identifiers](../YINI-Specification.md#34-identifiers).

### 3.5. Document Terminator

Requiring `/END` in strict mode makes completion explicit. A missing marker can reveal some truncated or partly copied documents that an end-of-file check would accept. The cost is an extra line in every strict document, so lenient mode keeps it optional for hand-edited files. 

The marker improves detection but cannot prove that all intended content is present: a fragment containing a complete section and `/END` may still be valid. See [Rationale §B.2.5](../RATIONALE.md#b25-why-strict-mode-requires-end).

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

The caret is the primary marker because it is ASCII, visually distinct, and easy to repeat to show depth. The `§` marker offers a visual alternative but needs Unicode-aware tools. The `>` marker is ASCII but may be treated as a quotation prefix by email or Markdown-like tools; `<` offers another ASCII choice.

Supporting alternatives gives authors options at the cost of more syntax for readers and parsers to recognize, so the spec recommends a clear default. See [Rationale §B.2.4](../RATIONALE.md#b24-summary-of-marker-characters).

### 5.3. Nested Sections

Repeated markers expose depth in the header itself. Requiring each deeper level to follow its parent avoids creating an unspecified intermediate section. Returning to an established shallower depth remains straightforward.

TODO: Explain the chosen maximum depth of 255.

#### 5.3.1. Section Marker Separators

Optional underscores make longer repeated-marker sequences easier to count without changing their depth. 

They add another valid spelling for the same header, but allow levels through 9 to stay visible as repeated markers without becoming one hard-to-count run. See [Rationale §B.2.7](../RATIONALE.md#b27-section-marker-separators-and-repeated-marker-depth).

#### 5.3.2. Shorthand Section Heading

Numeric shorthand prevents headers from growing into long runs of markers. Repeated markers keep shallower depth visually apparent, while a number is easier to read once that run becomes long. Allowing both forms through depth 9 adds two spellings for those levels; requiring the numeric form beyond 9 puts a limit on that visual complexity. See [Rationale §B.2.7](../RATIONALE.md#b27-section-marker-separators-and-repeated-marker-depth).

## [6. String Literals](../YINI-Specification.md#6-string-literals)

### 6.1. Raw Strings (R-Strings)

Raw strings are the default because configuration often contains paths, URLs, patterns, and other text where a backslash should stay literal. 

This avoids accidental interpretation of `\n` or `\t` in ordinary values. The trade-off is that an author must choose a different string form when the value needs an escaped quote or control character. The optional `R` prefix can make raw intent visible without changing the value. See [Rationale §B.2.6.1](../RATIONALE.md#b261-raw-strings).

**Comparable behavior:** Rust raw string literals and Go backtick string literals also leave backslashes uninterpreted. Their delimiters and other string rules differ from YINI's. See the [Rust Reference](https://doc.rust-lang.org/reference/tokens.html#raw-string-literals) and [Go specification](https://go.dev/ref/spec#String_literals).

**Further matches:** C# raw strings and C++ raw string literals also keep backslashes literal. Their delimiters differ from YINI's. See the [C# language specification](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/lexical-structure#6456-string-literals) and [C++ draft](https://eel.is/c++draft/lex.string).

**Specification:** [§6.1, Raw Strings](../YINI-Specification.md#61-raw-strings-r-strings).

### 6.2. Classic Strings (C-Strings)

The explicit `C` prefix opts into escape processing when a value needs a quote, control character, or Unicode escape. Making this behavior the default would shorten some escaped values but make ordinary backslashes surprising. Requiring the prefix gives the author control at the cost of another string form to learn. See [Rationale §B.2.6.2](../RATIONALE.md#b262-classic-strings).

#### 6.2.1. Escape Sequences

The defined escape list makes decoding predictable across parsers. A traditional C-style octal escape such as `\123` is shorter, but does not show its number base; YINI uses `\o123` to make that choice visible. The familiar `\xhh` spelling could suggest a byte, but YINI strings contain Unicode text, so it denotes code point U+00hh. These choices keep familiar escape forms where useful while giving them one text-based interpretation. See [Rationale §B.2.3](../RATIONALE.md#b23-non-standard-octal-escape) and [§B.2.10](../RATIONALE.md#b210-escape-sequence-xhh-but-yini-strings-are-unicode).

TODO: Explain the choice of every individual escape only where its purpose is not already conventional.

**Comparable behavior:** In Python and JavaScript/TypeScript string literals, `\xhh` also consumes exactly two hexadecimal digits and denotes the character U+00hh. This matches that one escape in YINI Classic strings. See [Python escape sequences](https://docs.python.org/3/reference/lexical_analysis.html#escape-sequences) and [ECMAScript string literals](https://tc39.es/ecma262/multipage/ecmascript-language-lexical-grammar.html#sec-literals-string-literals).

**Specification:** [§6.2.1, Escape Sequences](../YINI-Specification.md#621-escape-sequences).

### 6.3. Triple-Quoted Strings

Triple quotes make multi-line text possible without concatenating many single-line literals. Preserving line breaks suits values whose layout matters; it also means source formatting and line-ending changes can change the value. A `C` prefix remains available when the text needs escapes. An earlier H-string form instead folded whitespace for prose, but its separate normalization rules were judged too much complexity for the core format. See [Rationale §B.2.6.3](../RATIONALE.md#b263-triple-quoted-strings) and [§D.3.3](../RATIONALE.md#d33-hyper-strings-h-strings).

**Comparable behavior:** Python also uses triple quotes to write a string across multiple lines. Its default escape and line-ending rules differ from YINI's Raw Triple-Quoted Strings. See [Python string literals](https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals).

**Further match:** Kotlin also uses `""" ... """` for multiline text without backslash escapes. Kotlin still interpolates `$` expressions; YINI does not. See the [Kotlin language specification](https://kotlinlang.org/spec/expressions.html#string-interpolation-expressions).

**Specification:** [§6.3, Triple-Quoted Strings](../YINI-Specification.md#63-triple-quoted-strings).

### 6.4. String Types Summary
-

### 6.5. String Concatenation

The `+` operator joins strings without adding arithmetic or a general expression language. Requiring the first operand to be a string rules out expressions such as `1 + 2 + "3"`, which could otherwise suggest either addition or concatenation. Strict mode requires every operand to be a string for an explicit, simple contract. Lenient mode permits later scalar operands for convenience, but needs conversion rules as a result. 

Lists and objects stay excluded because their string forms would need another set of choices. See [Rationale §B.2.9](../RATIONALE.md#b29-string-concatenation-and-non-arithmetic-).

### 6.6. Scalar Conversion in Lenient Concatenation

The conversion rules give permitted scalar operands one predictable spelling. 

Converting through a host-language number would look simple, but could round a large value or turn `1e3` into `1000` in one implementation while another preserves the exponent form. Normalizing the source spelling avoids that divergence; non-decimal integers still become exact base-10 text. The trade-off is that this conversion preserves some lexical choices, such as decimal points and exponent digits, rather than producing one shortest numeric spelling.

## [7. Number Literals](../YINI-Specification.md#7-number-literals)

### 7.1. Numbers

Rejecting unnecessary leading zeros avoids competing spellings that readers may interpret differently. TODO: Document the intended numeric precision and range model.

**Comparable behavior:** Python also rejects nonzero decimal integer literals with leading zeros, such as `01`. YINI additionally rejects forms such as `00`, `00.5`, and `01e3`. See [Python integer literals](https://docs.python.org/3/reference/lexical_analysis.html#integer-literals).

**Further match:** Kotlin rejects any decimal integer literal with more than one digit that starts with `0`, including `00` and `01`. See the [Kotlin language specification](https://kotlinlang.org/spec/expressions.html#integer-literals).

**Specification:** [§7.1, Numbers](../YINI-Specification.md#71-numbers).

### 7.2. Digit Separators

Underscores let authors group digits for readability without changing the numeric value. Limiting their positions keeps the number boundary clear.

**Comparable behavior:** Python also allows underscores between digits and immediately after a base prefix, as in `0x_FF`. See [Python numeric literals](https://docs.python.org/3/reference/lexical_analysis.html#integer-literals).

**Further match:** Go uses the same underscore positions for its base-prefixed integer literals. See the [Go specification](https://go.dev/ref/spec#Integer_literals).

**Further matches:** C#, Kotlin, and Swift also use underscores to group digits without changing the numeric value. C# permits `0b_0010`, matching YINI's separator immediately after a base prefix. The full placement rules differ. See [C# integer literals](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/integral-numeric-types#integer-literals), [Kotlin integer literals](https://kotlinlang.org/spec/expressions.html#integer-literals), and [Swift integer literals](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/lexicalstructure/).

**Specification:** [§7.2, Digit Separators](../YINI-Specification.md#72-digit-separators).

### 7.3. Exponent Format

Exponent notation expresses very large or small decimal values compactly. TODO: Explain any compatibility reasons behind its exact accepted spelling.

**Comparable behavior:** Python and JavaScript/TypeScript also accept `e` or `E` followed by an optional sign and decimal digits in numeric literals, as in `3e4` and `2E-3`. See [Python floating-point literals](https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals) and [ECMAScript numeric literals](https://tc39.es/ecma262/multipage/ecmascript-language-lexical-grammar.html#sec-literals-numeric-literals).

**Further matches:** Go and Rust also accept these decimal exponent forms. See the [Go specification](https://go.dev/ref/spec#Floating-point_literals) and [Rust Reference](https://doc.rust-lang.org/reference/tokens.html#floating-point-literals).

**Specification:** [§7.3, Exponent Format](../YINI-Specification.md#73-exponent-format).

### 7.4. Number Formats

Base prefixes make a number's base explicit. 

The removed `#` hexadecimal form was compact and familiar for colors, but conflicted with the comment marker. The `hex:` alternative keeps a readable type cue without making `#` context-sensitive; `0x` remains available for authors who prefer a conventional numeric prefix. See [Rationale §B.2.2](../RATIONALE.md#b22-the--marker-as-a-comment-symbol).

TODO: Explain the uses for each supported non-decimal base and its alternative notation.

**Comparable behavior:** Python and JavaScript/TypeScript also use `0b`, `0o`, and `0x` prefixes for binary, octal, and hexadecimal integer literals. YINI defines additional forms. See [Python integer literals](https://docs.python.org/3/reference/lexical_analysis.html#integer-literals) and [ECMAScript numeric literals](https://tc39.es/ecma262/multipage/ecmascript-language-lexical-grammar.html#sec-literals-numeric-literals).

**Further matches:** Go and Rust use the same three base prefixes. See the [Go specification](https://go.dev/ref/spec#Integer_literals) and [Rust Reference](https://doc.rust-lang.org/reference/tokens.html#integer-literals).

**Further matches:** Swift also uses all three prefixes. C# and Kotlin use `0b` and `0x`, but not `0o`. See [Swift integer literals](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics/), [C# integer literals](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/integral-numeric-types#integer-literals), and [Kotlin integer literals](https://kotlinlang.org/docs/numbers.html#declare-integer-values).

**Specification:** [§7.4, Number Formats](../YINI-Specification.md#74-number-formats).

## [8. Boolean and Null Literals](../YINI-Specification.md#8-boolean-and-null-literals)

### 8.1. Booleans

TODO: Explain why `yes`/`no` and `on`/`off` are accepted alongside `true`/`false`, including the choice to make them case-insensitive.

### 8.2. Null Literal

Explicit `null` works in every mode and position. A missing root-level or section-level value becomes null only in lenient mode; missing values inside collections stay invalid so separators cannot silently create extra elements.

TODO: Explain the choice to treat an empty member value as null rather than as an empty string.

## [9. Object Literals](../YINI-Specification.md#9-object-literals)

### 9.1. Objects (using <code>{</code> and <code>}</code>)

Inline objects express a small nested group as a value without opening a new section. Requiring member separators and unique names keeps that group representable as a map.

**Comparable behavior:** A single trailing comma after the last entry adds no entry in Python dictionary displays or JavaScript/TypeScript object literals. YINI has the same result in lenient mode; strict mode rejects the comma. See [Python dictionary displays](https://docs.python.org/3/reference/expressions.html#dictionary-displays) and [ECMAScript object initializers](https://tc39.es/ecma262/multipage/ecmascript-language-expressions.html#sec-object-initializer).

**Further match:** Go also permits a trailing comma in a map composite literal without adding an entry. See the [Go specification](https://go.dev/ref/spec#Composite_literals).

**Specification:** [§9.1, Objects](../YINI-Specification.md#9-object-literals).

### 9.2. Object Member Separators

The canonical `:` distinguishes entries inside an object value from ordinary `=` assignments and follows a familiar map syntax. Allowing `=` in lenient mode is convenient for authors who use assignment syntax throughout a file, but creates two spellings for the same object. Strict mode accepts only `:`, and formatters are advised to use that form, so strict files and formatted files stay consistent.

## [10. List Literals](../YINI-Specification.md#10-list-literals)

### 10.1. Bracketed Lists (`[...]`)

Brackets show exactly where a list begins and ends, including when it spans lines or contains nested values. 

Earlier colon-based list syntax saved some punctuation but added a second way to express the same data, with more grammar rules and edge cases. Keeping bracketed lists gives authors one recognizable structure. A lenient trailing comma still helps hand editing; strict mode omits that optional punctuation for a more uniform list form. See [Rationale §D.3.1](../RATIONALE.md#d31-why-colon-based-lists-were-removed).

**Comparable behavior:** A single trailing comma after the last element adds no element in Python list displays or JavaScript/TypeScript array literals. YINI has the same result in lenient mode; strict mode rejects the comma. See [Python list displays](https://docs.python.org/3/reference/expressions.html#list-displays) and [ECMAScript array initializers](https://tc39.es/ecma262/multipage/ecmascript-language-expressions.html#sec-array-initializer).

**Further matches:** Rust array expressions and Java and C11 array initializers also allow a final comma without adding an element. See the [Rust Reference](https://doc.rust-lang.org/reference/expressions/array-expr.html), [Java Language Specification](https://docs.oracle.com/javase/specs/jls/se25/html/jls-10.html#jls-10.6), and [C11 draft, §6.7.9](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf#page=157).

**Further matches:** Swift array literals also allow a final comma without adding an element. C++ braced array initializers allow one too. See the [Swift book](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/collectiontypes/) and [C++ draft](https://eel.is/c++draft/dcl.init.general).

**Specification:** [§10.1, Bracketed Lists](../YINI-Specification.md#10-list-literals).

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

Duplicate names force a choice: a later definition could replace, merge with, or be ignored in favor of the earlier one. Replacement or merging would let a later block silently change a setting written above it. Lenient mode keeps the first definition and warns; strict mode rejects the duplicate. 

First-wins can also surprise an author expecting an override, which is why the warning matters. Member and child-section names share a namespace so each container can become one object without collisions.

**Comparable behavior:** XML forbids repeating an attribute name in one element's start tag. This matches strict YINI's rejection of duplicate names within the relevant container; lenient YINI instead keeps the first definition and warns. See [XML 1.0, §3.1](https://www.w3.org/TR/xml/#sec-starttags).

**Specification:** [§12.2.1, Structural Requirements](../YINI-Specification.md#1221-structural-requirements).

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

Lenient mode accommodates hand editing, including selected conveniences such as trailing commas and missing member values, while keeping their meaning defined. Strict mode removes those conveniences and requires a visible root section and terminator for stronger validation. 

Two modes add rules that authors and implementers must track, but avoid forcing every small hand-edited file to carry the strict-mode structure.

TODO: Explain the reason for each mode difference not already addressed in its syntax section.

#### 12.3.1. Table: Lenient vs. Strict Mode

-

## [13. Implementation Rules](../YINI-Specification.md#13-implementation-rules)

### 13.1. Top-Level Sections and Document Root

A defined document root gives parsers a common abstract shape and supports consistent conversion to object-based formats.

#### 13.1.1. Lenient Mode: Orphan Members

Mounting orphan members directly beside top-level sections gives a document one shared root mapping. An implicit `base` wrapper might make orphan members easy for one API to group, but it changes the data shape and introduces a name the author did not write. The direct-root rule keeps YINI-to-JSON mapping consistent; an API may still add its own wrapper outside the YINI data model.

#### 13.1.2. Top-Level Section Mounting

Mounting top-level sections directly preserves their names and nesting in the parsed result. The no-skipped-level rule ensures every child has an explicit parent.

#### 13.1.3. Strict Mode

One explicit top-level section gives strict documents a visible root and rules out orphan members. See also §3.5 for the separate terminator requirement.

### 13.2. Line Handling and Whitespace

Logical line recognition is needed for syntax across platforms. Normalizing every CRLF or CR to LF would make multiline values look the same across operating systems, but it would also change text that a triple-quoted string promises to preserve. 

The chosen rule recognizes all supported line endings for structure while retaining their original characters inside the string. This means rewriting a file with different line endings can change a multiline value.

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

The former lenient fallback allowed retaining or remapping illegal characters; that flexibility made the result uncertain. Removing it favors predictable names, while the remaining lenient-mode `SHOULD` error leaves a conformance question to resolve.

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

**Comparable behavior:** XML 1.0 permits an initial UTF-8 BOM and treats it as an encoding signature rather than document content. YINI permits implementations to accept and ignore it. See [XML 1.0, §4.3.3](https://www.w3.org/TR/xml/#charencoding).

**Specification:** [§14.3.2, Byte Order Mark](../YINI-Specification.md#1432-byte-order-mark-bom).

#### 14.3.3. Shebang Line (Optional)

See §2.3. TODO: Record any additional compatibility reason for permitting a first-line shebang.

### 14.4. JSON Compatibility

Object-like structure and the shared scalar types make JSON a useful interchange target. A broad promise of lossless conversion would be attractive, but a converter may lose numeric precision and JSON has no place for comments, markers, or the terminator. Converting JSON back also requires choices about sections versus inline objects and about values or names YINI can represent. The qualified claim promises equivalent parsed data only where the converter can preserve it; a YINI identifier's text should become the same JSON object key in that case.

## [15. Examples](../YINI-Specification.md#15-examples)

-

## [16. Appendices and Reserved Areas](../YINI-Specification.md#16-appendices-and-reserved-areas)

-
