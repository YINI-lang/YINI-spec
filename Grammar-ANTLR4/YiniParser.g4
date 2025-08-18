/*
 YINI grammar in ANTLR 4.
 
 Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 Copyright 2024-2025 Gothenburg, Marko K. S. (Sweden via
 Finland).
 */

/* 
 This grammar aims to follow, as closely as possible,
 the YINI format specification version:
 1.1.0-rc.1 - 2025 Aug.
 
 Feedback, bug reports and improvements are welcomed here
 https://github.com/YINI-lang/YINI-spec
 
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
  : prolog? stmt* terminal? EOF
  ;

/* -------- Prolog / terminal -------- */

prolog
  : SHEBANG eol*       // shebang present
  | eol+               // or at least one blank/comment line
  ;

terminal
  //: TERMINAL_TOKEN (eol | INLINE_COMMENT? NL*) // '/END' line, allow trailing comments/blank
  : TERMINAL_TOKEN ( eol | INLINE_COMMENT )? NL*
  ;

/* -------- Statements (flat) -------- */

stmt
  : eol				// BlankOrComment
  | SECTION_HEAD	// SectionHeader
  | assignment		// KeyValue
  | listAfterColon	// ListAfterColon
  | marker_stmt     // Note: The implementing parser is responsible for enforcing YINI marker constraints.
  | bad_member      // BadMember
  ;

marker_stmt
  : YINI_MARKER eol
  ;

/* A single physical "end-of-line" unit (blank or comment then NL).
   Use this everywhere instead of sprinkling NL* / INLINE_COMMENT* */
eol
  : INLINE_COMMENT? NL+
  ;

/* -------- Members / assignments -------- */

/* Assignment is always: KEY = value/literal */
assignment
//  : KEY WS? EQ WS? value? eol
  : member eol
  ;

/* KEY = value  (value may be empty in lenient-mode -> NULL by convention,
 * enforced and validated in host code, not here.)
 */
member:
  KEY WS? EQ WS? value? // Empty value is treated as NULL.
  ;

/* KEY : elements  (colon-form lists) */
listAfterColon
  : KEY WS? COLON WS? elements? eol
  ;

/* -------- Values -------- */
value
  : null_literal
  | string_literal
  | number_literal
  | boolean_literal
  | list_literal
  | object_literal
  ;

/* Object_literal is defined with object members such as { key: value, ... }
 * with optional trailing comma and newlines tolerated 
 */
object_literal
  : OC NL* object_members? NL* CC NL*
  | EMPTY_OBJECT NL*
  ;

// A object_members is one or more key=value pairs separated by commas.
object_members
  : object_member (COMMA NL* object_member)* COMMA?
  ;

object_member
  : KEY WS? COLON NL* value
  ;

/* [ value, ... ] with optional trailing comma and newlines tolerated */
list_literal
  : OB NL* elements? NL* CB NL*
  | EMPTY_LIST NL*
  ;

/* Folded, comma-separated values; commas optional only between elements */
elements
  : value (NL* COMMA NL* value)* COMMA?
  ;

/* -------- Terminals forwarded from the lexer -------- */

number_literal   : NUMBER;
null_literal     : NULL;							// NOTE: NULL is case-insensitive.
string_literal   : STRING string_concat*;
string_concat    : NL* PLUS NL* STRING;
boolean_literal  : BOOLEAN_TRUE | BOOLEAN_FALSE;	// NOTE: Booleans are case-insensitive.

/* For catching bad member syntax.
 * Keep a narrow error production, don't over-greedy-capture.
 */
bad_member
  : WS? (REST | value)? WS? EQ (value | REST) eol?
  ;
