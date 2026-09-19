/*
  YINI grammar in ANTLR 4.
 
  Apache License, Version 2.0, January 2004,
  http://www.apache.org/licenses/
  Copyright 2024-2026 Gothenburg, Marko K. S. (Sweden via
  Finland).
*/

/* 
  This PARSER grammar aims to follow, as closely as possible (*),
  the latest released version of the YINI format specification 1.0.0.
  Version:
  1.3.0-rc.2 - 2026 Sep (v1.0.0-rc.7 YINI Spec Package).

  *) NOTE: Some rules are intentionally more permissive than the specification
  requires. This relaxation allows the host parser to detect syntax errors
  easier and provide clearer, more meaningful error messages. In the end, it is
  the responsibility of the implementing parser to fully enforce all rules of
  the YINI specification.

  Feedback, bug reports, and improvements are welcome here:

  GitHub:   https://github.com/YINI-lang
  Homepage: http://yini-lang.org
*/

parser grammar YiniParser;

options {
  tokenVocab = YiniLexer;
  caseInsensitive = false;
}

/*
  High-level idea:
  - Parse a tolerant, flat stream of statements.
  - SECTION_HEAD tokens signal section headers (with level encoded by the lexer).
  - The host parser (visitor) maintains a section stack to build the final tree.
  - Marker (@yini etc.) constraints are validated in host code, not here.
*/

yini
  : prolog? stmt* terminal_stmt? EOF
  ;

/* ------------------------------------------------------------------
 * Prolog / terminal
 * ------------------------------------------------------------------ */

prolog
  : SHEBANG eol*
  | eol+
  ;

terminal_stmt
  : TERMINAL_TOKEN terminal_trivia*
  ;

// Fulfills the spec rule that after /END, only whitespace and
// comments may appear.
terminal_trivia
  : eol
  | full_line_comment_stmt
  ;

/* ------------------------------------------------------------------
 * Statements (flat)
 * ------------------------------------------------------------------ */

stmt
  : eol                     // BlankOrComment
  | full_line_comment_stmt
  | disabled_line_stmt
  | SECTION_HEAD            // SectionHeader
  | invalid_section_stmt
  | assignment              // key = value
  | meta_stmt               // Note: The implementing parser is responsible for enforcing YINI marker constraints.
  | bad_member              // BadMember
  ;

full_line_comment_stmt
  : FULL_LINE_COMMENT eol?
  ;

disabled_line_stmt
  // : DISABLED_LINE eol?
  : DISABLED_LINE
  ;

invalid_section_stmt
  : INVALID_SECTION_HEAD
  ;

// Any tokens and statements starting with an AT (@).
meta_stmt
  : directive
  | annotation
  | bad_meta_text line_end
  ;

/*
 * Directives (pragmas): parser hints that affect mode/behavior but
 * don't change document content. Must appear at top before any
 * sections or members.
 */
directive
  : yini_directive
  | INCLUDE_TOKEN string_literal? line_end
  ;

yini_directive
  : YINI_TOKEN yini_mode_declaration? line_end
  ;

// IMPORTANT: Do not add lexer tokens like STRICT_MODE and LENIENT_MODE,
// because then strict = true or lenient = false could stop parsing
// as normal keys.
yini_mode_declaration
  : KEY // Host validation checks for "strict" or "lenient" case-insensitively.
  ;

/*
 * Metadata attached to a specific element (key, section, function,
 * class, variable). Does not change source, but adds semantic
 * meaning or tooling hints.
 *
 * @note Experimental / for future / testing.
 */
annotation
  : DEPRECATED_TOKEN line_end
  ;

/* A single physical "end-of-line" unit.
   Use this everywhere instead of sprinkling NL* in statement rules. */
eol
  : NL+
  ;

// EOF may terminate an otherwise complete final logical line.
line_end
  : eol
  | EOF
  ;

/* ------------------------------------------------------------------
 * Members / assignments
 * ------------------------------------------------------------------ */

// Previous wording: Assignment is always: KEY = value/literal.
/* Assignment is always: identifier = value/literal */
assignment
  : member line_end
  ;

/*
 * Previous wording: KEY, EQ, and the first value token MUST be on the same logical line.
 * @note The identifier, EQ, and the first value token MUST be on the same logical line.
 * A concatenation expression may continue onto following lines only when
 * the previous line ends with PLUS.
 */
// Boolean and null spellings are also valid names in identifier positions.
// Preserve the token's original text: identifiers remain case-sensitive.
identifier
  : KEY
  | BOOLEAN_TRUE
  | BOOLEAN_FALSE
  | NULL
  ;

member
  // : KEY EQ value? // Missing value is validated by mode in host code.
  : identifier EQ value? // Missing value is validated by mode in host code.
  ;

/* ------------------------------------------------------------------
 * Values
 * ------------------------------------------------------------------ */

value
  : concat_expression
  | scalar_value
  | list_literal
  | object_literal
  ;

scalar_value
  : null_literal
  | string_literal
  | number_literal
  | boolean_literal
  ;

/*
 * String concatenation.
 *
 * Spec behavior:
 * - The + operator is exclusively string concatenation when accepted.
 * - YINI does not define numeric addition.
 * - A concatenation expression MUST begin with a string literal.
 * - A newline MAY appear after +.
 * - A newline MUST NOT appear before +.
 * - Lists and inline objects are never valid operands.
 *
 * Strict-vs-lenient validation:
 * - Strict mode: every concat operand MUST be STRING.
 * - Lenient mode: the first operand MUST be STRING.
 *   Later operands MAY be STRING, NUMBER, BOOLEAN, or NULL.
 */
// This accepts:
//
// message = "hello " + "world"
// longText = "hello " +
//            "world"
//
// label = "port-" +
//         5432
//
// And rejects:
//
// message = "hello "
//         + "world"
//
// txt1 = 8080 + " is the port"
// txt2 = 1 + 2 + "3"
//
// because concatenation must begin with a string literal.
concat_expression
  : STRING concat_tail+
  ;

concat_tail
  // : PLUS NL* concat_operand
  : PLUS multiline_trivia* concat_operand
  ;

concat_operand
  : STRING
  | NUMBER
  | BOOLEAN_TRUE
  | BOOLEAN_FALSE
  | NULL
  ;

string_literal
  : STRING
  ;

/* Object literal.
 * Canonical object members use `key: value`.
 * In lenient mode, `key = value` may also be accepted.
 * In strict mode, `=` inside inline objects is invalid and must be rejected
 * by semantic validation.
 */
object_literal
  // : OC NL* object_members? NL* CC NL*
  // | EMPTY_OBJECT NL*
  : OC multiline_trivia* object_members? multiline_trivia* CC
  | EMPTY_OBJECT
  ;

// Object members are one or more key/value entries separated by commas.
// Canonical syntax uses `key: value`.
// In lenient mode, `key = value` may also be accepted (in the host parser).
// In the host parser, strict mode validation must reject `=` inside inline objects.
object_members
  // : object_member (COMMA NL* object_member)* COMMA?
  : object_member
    (multiline_trivia* COMMA multiline_trivia* object_member)*
    (multiline_trivia* COMMA)?
  ;

object_member
  // : KEY object_member_separator value
  : identifier object_member_separator value
  ;

object_member_separator
  : COLON // The canonical form.
  | EQ    // Optional ONLY in lenient mode.
  ;

/* [ value, ... ] with optional trailing comma and newlines tolerated */
list_literal
  // : OB NL* elements? NL* CB NL*
  // | EMPTY_LIST NL*
  : OB multiline_trivia* elements? multiline_trivia* CB
  | EMPTY_LIST
  ;

/** Folded, comma-separated values (list elements), for bracketed lists.
 *  Elements are regular values only.
 */
elements
  // : value (NL* COMMA NL* value)* COMMA?
  : value
    (multiline_trivia* COMMA multiline_trivia* value)*
    (multiline_trivia* COMMA)?
  ;

// Tokens allowed where a construct permits continuation onto another line.
// Host validation must check that comment and disabled-line markers are the
// first non-space/tab content on their source line. A comma starting a list
// line must still be rejected under specification section 13.6.
// These tokens stay visible so their positions can be checked.
multiline_trivia
  : NL
  | DISABLED_LINE
  | FULL_LINE_COMMENT
  ;

/* ------------------------------------------------------------------
 * Terminals forwarded from the lexer
 * ------------------------------------------------------------------ */

number_literal
  : NUMBER
  ;

null_literal
  : NULL // NOTE: NULL is case-insensitive.
  ;

boolean_literal
  : BOOLEAN_TRUE
  | BOOLEAN_FALSE // NOTE: Booleans are case-insensitive.
  ;

/* ------------------------------------------------------------------
 * Error helpers
 * ------------------------------------------------------------------ */

bad_meta_text
  : META_INVALID
  ;

/* For catching bad member syntax.
 * Keep a narrow error production, don't over-greedy-capture.
 */
bad_member
  : (REST | value)? EQ (value | REST) eol?
  ;
