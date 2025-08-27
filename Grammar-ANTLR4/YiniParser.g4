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
 2.0.0-rc.1 - 2025 Aug.
 
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
  : prolog? stmt* terminal_stmt? EOF
  ;

/* -------- Prolog / terminal_stmt -------- */

prolog
  : SHEBANG eol*       // shebang present
  | eol+               // or at least one blank/comment line
  ;

terminal_stmt
  //: TERMINAL_TOKEN (eol | INLINE_COMMENT? NL*) // '/END' line, allow trailing comments/blank
  : TERMINAL_TOKEN ( eol | INLINE_COMMENT )? NL*
  ;

/* -------- Statements (flat) -------- */

stmt
  : eol				// BlankOrComment
  | SECTION_HEAD	// SectionHeader
  | assignment		// key = value
  | colon_list_decl	// ListAfterColon
  | meta_stmt       // Note: The implementing parser is responsible for enforcing YINI marker constraints.
  | bad_member      // BadMember
  ;

// Any tokens and statements starting with an AT (@).
meta_stmt
  : directive
  | pre_processing_command
  | bad_meta_text eol
  ;

/*
 * Directives (pragmas): parser hints that affect mode/behavior but
 * don't change document content.
 */
directive
  : YINI_TOKEN eol
  ;

/*
 * Pre-processing directives: instructions that modify the document itself
 * by including or transforming content before/while parsing.
 */
pre_processing_command
  : INCLUDE_TOKEN WS* string_literal? eol
  ;

/* A single physical "end-of-line" unit (blank or comment then NL).
   Use this everywhere instead of sprinkling NL* / INLINE_COMMENT* */
eol
  : INLINE_COMMENT? NL+
  ;

/* -------- Members / assignments -------- */

/* Assignment is always: KEY = value/literal */
assignment
  : member eol
  ;

/* KEY = value  (value may be empty in lenient-mode -> NULL by convention,
 * enforced and validated in host code, not here.)
 * @note (!) KEY, EQ, and value MUST be on the same line!
 */
member:
  KEY WS? EQ WS? value? // Empty value is treated as NULL.
  ;

/**
 * Declaration of a colon list:
 *   KEY: [NL|EOL] elements   (colon-form lists)
 *
 * @note KEY and the colon (:) must appear on the same line. The list
 *       elements may optionally start on the following line.
 *
 * @note A colon list declaration cannot appear inline inside another
 *       value or literal, it is only valid as a member of a section.
 */
 colon_list_decl
  //: KEY WS? COLON WS? elements? eol
  : KEY WS? COLON (eol | WS+)* elements (eol | WS+)* eol
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

/** Folded, comma-separated values, commas optional only between elements
 *  @note Any value in elements can not be a colon_list_decl!
 */
elements
  : value (NL* COMMA NL* value)* COMMA?
  //: element COMMA? | element COMMA elements
  ;
  
 //element: NL* value NL* | NL* list_literal NL*;

/* -------- Terminals forwarded from the lexer -------- */

number_literal   : NUMBER;
null_literal     : NULL;							// NOTE: NULL is case-insensitive.
string_literal   : STRING string_concat*;
string_concat    : NL* PLUS NL* STRING;
boolean_literal  : BOOLEAN_TRUE | BOOLEAN_FALSE;	// NOTE: Booleans are case-insensitive.

bad_meta_text
  : META_INVALID
  ;

/* For catching bad member syntax.
 * Keep a narrow error production, don't over-greedy-capture.
 */
bad_member
  : WS? (REST | value)? WS? EQ (value | REST) eol?
  ;
