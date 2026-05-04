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
  1.2.0-rc.2xx + UPDATES - 2026 Apr (v1.0.0-rc.5 YINI Spec Package).

  *) NOTE: Some rules are intentionally more permissive than the specification
  requires. This relaxation allows the host parser to detect syntax errors
  easier and provide clearer, more meaningful error messages. In the end, it is
  the responsibility of the implementing parser to fully enforce all rules of
  the YINI specification.

  Feedback, bug reports and improvements are welcomed here:

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
  : TERMINAL_TOKEN eol*
  ;

/* ------------------------------------------------------------------
 * Statements (flat)
 * ------------------------------------------------------------------ */

stmt
  : eol             // BlankOrComment
  | SECTION_HEAD    // SectionHeader
  | invalid_section_stmt
  | assignment      // key = value
  | meta_stmt       // Note: The implementing parser is responsible for enforcing YINI marker constraints.
  | bad_member      // BadMember
  ;

invalid_section_stmt
  : INVALID_SECTION_HEAD
  ;

// Any tokens and statements starting with an AT (@).
meta_stmt
  : directive
  | annotation
  | bad_meta_text eol
  ;

/*
 * Directives (pragmas): parser hints that affect mode/behavior but
 * don't change document content. Must appear at top before any
 * sections or members.
 */
directive
  : YINI_TOKEN eol
  | INCLUDE_TOKEN string_literal? eol
  ;

/*
 * Pre-processing directives: instructions that modify the document itself
 * by including or transforming content before/while parsing.
 */
// pre_processing_command
//   : INCLUDE_TOKEN string_literal? eol
//   ;

/*
 * Metadata attached to a specific element (key, section, function,
 * class, variable). Does not change source, but adds semantic
 * meaning or tooling hints.
 *
 * @note Experimental / for future / testing.
 */
annotation
  : DEPRECATED_TOKEN eol
  ;

/* A single physical "end-of-line" unit.
   Use this everywhere instead of sprinkling NL* in statement rules. */
eol
  : NL+
  ;

/* ------------------------------------------------------------------
 * Members / assignments
 * ------------------------------------------------------------------ */

/* Assignment is always: KEY = value/literal */
assignment
  : member eol
  ;

/* KEY = value  (value may be empty in lenient mode -> NULL by convention,
 * enforced and validated in host code, not here.)
 *
 * @note (!) KEY, EQ, and value MUST be on the same line!
 */
member
  : KEY EQ value? // Empty value is treated as NULL.
  ;

/* ------------------------------------------------------------------
 * Values
 * ------------------------------------------------------------------ */

value
  : null_literal
  | string_literal
  | number_literal
  | boolean_literal
  | list_literal
  | object_literal
  ;

/* Object literal.
 * Canonical object members use `key: value`.
 * In lenient mode, `key = value` may also be accepted.
 * In strict mode, `=` inside inline objects is invalid and must be rejected
 * by semantic validation.
 */
object_literal
  : OC NL* object_members? NL* CC NL*
  | EMPTY_OBJECT NL*
  ;

// Object members are one or more key/value entries separated by commas.
// Canonical syntax uses `key: value`.
// In lenient mode, `key = value` may also be accepted (in the host parser).
// In the host parser, strict mode validation must reject `=` inside inline objects.
object_members
  : object_member (COMMA NL* object_member)* COMMA?
  ;

object_member
  : KEY object_member_separator NL* value
  ;

object_member_separator
  : COLON // The canonical form.
  | EQ    // Optional ONLY in lenient mode.
  ;

/* [ value, ... ] with optional trailing comma and newlines tolerated */
list_literal
  : OB NL* elements? NL* CB NL*
  | EMPTY_LIST NL*
  ;

/** Folded, comma-separated values (list elements), for bracketed lists.
 *  Elements are regular values only.
 */
elements
  : value (NL* COMMA NL* value)* COMMA?
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

string_literal
  : STRING string_concat*
  ;

string_concat
  : NL* PLUS NL* STRING
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
