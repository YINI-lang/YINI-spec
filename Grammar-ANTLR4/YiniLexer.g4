/*
  YINI grammar in ANTLR 4.
 
  Apache License, Version 2.0, January 2004,
  http://www.apache.org/licenses/
  Copyright 2024-2026 Gothenburg, Marko K. S. (Sweden via
  Finland).
*/

/* 
  This LEXER grammar aims to follow, as closely as possible (*),
  the YINI format specification version:
  1.2.0-rc.1x - 2026 Apr.

  *) NOTE: Some rules are intentionally more permissive than the specification
  requires. This relaxation allows the host parser to detect syntax errors
  esier and provide clearer, more meaningful error messages. In the end, it is
  the responsibility of the implementing parser to fully enforce all rules of
  the YINI specification.

  Feedback, bug reports and improvements are welcomed here:

  GitHub:   https://github.com/YINI-lang
  Homepage: http://yini-lang.org
*/

lexer grammar YiniLexer;

@members {
  // Below is TypeScript code:
  public atLineStart(): boolean { return this.column === 0; }
}

YINI_TOKEN options {
	caseInsensitive = true;
}: '@yini';

// @note Experimental / for future / testing.
INCLUDE_TOKEN options {
	caseInsensitive = true;
}: '@include';

// @note Experimental / for future / testing.
DEPRECATED_TOKEN options {
	caseInsensitive = true;
}: '@deprecated';

fragment EBD: ('0' | '1') ('0' | '1') ('0' | '1');

fragment HSPACE : [ \t];

// SECTION_HEAD: SECTION_MARKER HSPACE* WS* IDENT NL+;
SECTION_HEAD
  // : SECTION_MARKER HSPACE+ SECTION_NAME_PART NL+ // Requires hor-WS between marker and name.
  : SECTION_MARKER HSPACE* SECTION_NAME_PART NL+   // Does NOT require hor-WS between marker and name.
  ;

// Section markers: '^', '<', '§'.
// – Up to six repeated markers are allowed (the parser must enforce the ≤ 6 rule).
// – For levels beyond 6, use the numeric shorthand form (e.g. ^7, <12, §100).
fragment SECTION_MARKER
    : SECTION_MARKER_BASIC_REPEAT // Classic/repeating marker section headers (e.g. ^^ SectionName).
    | SECTION_MARKER_SHORTHAND // Numeric shorthand section headers (e.g. ^7 SectionName.
	| SECTION_MARKER_INVALID // Catch invalid/errornous section markers, so it can be forwarded to the parser to show an error message.
    ;

// Match one or more of the same marker.  Parser must check "count ≤ 6.",
// this check is deferred to the parser, which
// gives more control and enables better user feedback
fragment SECTION_MARKER_BASIC_REPEAT
    : CARET+   // Up to 6 carets (implemented parser must reject more than 6)
    | LT+      // Up to 6 LS characters
    | SS+      // Up to 6 '§' characters
    ;

// Shorthand: a single marker followed by a positive integer (1 or larger).
// Examples: ^7, <12, §100
fragment SECTION_MARKER_SHORTHAND
    : (CARET | LT | SS) [1-9] DIGIT* HSPACE
    ;

fragment SECTION_MARKER_INVALID
    : (CARET | LT | SS)+ DIGIT+
    ;

TERMINAL_TOKEN options {
	caseInsensitive = true;
}: '/END';

SS: '\u00A7'; // Section sign §.
CARET: '^';
GT: '>'; // Greater Than.
LT: '<'; // Less Than.

EQ: '=';
HASH: '#';
COMMA: ',';
COLON: ':';
OB: '['; // Opening Bracket.
CB: ']'; // Closing Bracket.
OC: '{'; // Opening Curly Brace.
CC: '}'; // Closing Curly Brace.
PLUS: '+';
DOLLAR: '$';
// ASTERIX: '*';
PC: '%'; // PerCent sign.
AT: '@';
SEMICOLON: ';';

BOOLEAN_FALSE options {
	caseInsensitive = true;
}: 'false' | 'off' | 'no';

BOOLEAN_TRUE options {
	caseInsensitive = true;
}: 'true' | 'on' | 'yes';

NULL options {
	caseInsensitive = true;
}: 'null';

EMPTY_OBJECT: '{}';
EMPTY_LIST: '[]';

SHEBANG: '#!' ~[\n\r\b\f\t]* NL;

// NOTE: NUMBER must come before KEY, IDENT, etc.
NUMBER:
	SIGN? INTEGER ('.' DIGIT+)? EXPONENT?
	| SIGN? '.' DIGIT+ EXPONENT?
	| SIGN? (
		BIN_INTEGER
		| OCT_INTEGER // Make sure to not clash with boolean ON | OFF.
		| DUO_INTEGER
		| HEX_INTEGER
	);

// KEY: IDENT;
KEY
  : SECTION_NAME_PART
  | IDENT_INVALID
  ;

// fragment IDENT
//   : IDENT_SIMPLE
// 	| IDENT_BACKTICKED
// 	| IDENT_INVALID;
fragment SECTION_NAME_PART
  : IDENT_SIMPLE_LX
  | IDENT_BACKTICKED
  ;

// fragment DOTTED_COMPOUND_NAME
//   : (IDENT_SIMPLE | IDENT_BACKTICKED) ('.' (IDENT_SIMPLE | IDENT_BACKTICKED))+
//   ;

fragment IDENT_SIMPLE_START : [a-zA-Z_];
fragment IDENT_SIMPLE_CHAR  : [a-zA-Z0-9_];

// fragment IDENT_SIMPLE       : IDENT_SIMPLE_START IDENT_SIMPLE_CHAR*;

// NOTE: This lexer rule is intentionally relaxed to allow `.` as well.
// This makes it possible for the parser (or later validation step) to detect
// dotted compound names and report a more user-friendly error message, even
// though such names are invalid in the YINI specification.
//
// IMPORTANT: The parser/validator must still check identifiers for illegal
// characters and reject invalid dotted names accordingly.
//
// Examples of invalid dotted compound names:
//     key.two
//     main.`illegal key`
//     another.key.2
//     `yet another`.illegal.key
fragment IDENT_SIMPLE_LX       : IDENT_SIMPLE_START (IDENT_SIMPLE_CHAR | '.')*;

// IDENT_BACKTICKED: '`' ~[\u0000-\u001F`]* '`'; // No newlines, tabs, or C0 controls.
fragment IDENT_BACKTICKED: '`' ~[\u0000-\u001F`]* '`'; // No newlines, tabs, or C0 controls.

// Illegal prefix characters and characters inside strings are deferred to the
// parser, which gives more control and enables better user feedback (e.g.,
// pinpointing the exact location of invalid characters, etc).

STRING
    : TRIPLE_QUOTED_STRING
    | SINGLE_OR_DOUBLE
    ;

TRIPLE_QUOTED_STRING:
	//'"""' (~["] | '"' ~["] | '""' ~["])* '"""';
	[RrCc]? '"""' .*? '"""'
	; // Greedy-safe because of .*? (non-greedy).

SINGLE_OR_DOUBLE:
	R_AND_C_STRING
	| HYPER_STRING
	;

/**
 * Common rule for RAW and CLASSIC string literals.
 * Illegal characters are deferred to the parser, which gives more control
 * and enables better user feedback (e.g., pinpointing the exact location of
 * invalid characters). Additionally, this simplifies the lexer rule.
 *
 * Rather than having the lexer reject on any "illegal" character, lets the
 * parser catch it so you can give a more precise error message. 
 *
 * @note If refactoring rule(s), make sure C-strings can include \' and \" as well.
 */
R_AND_C_STRING:
	[RrCc]? '\'' 	('\\\'' | ~['\r\n])* '\''
	| [RrCc]? '"'	('\\"' | ~["\r\n])* '"';


// Hyper string literal.
HYPER_STRING: [Hh] '\'' (~['])* '\''
	| [Hh] '"' ( ~["])* '"';

// Note: Like 8.2 in specification.
ESC_SEQ: '\\' (["']) | ESC_SEQ_BASE;

// Note: Except does'n not include quotes `"`, `'`.
ESC_SEQ_BASE: '\\' ([\\0?abfnrtv] | UNICODE16 | UNICODE32);
// TODO: Add support for \oOOO (up to 3 digits, valid range \o0 – \o377)

fragment UNICODE16: 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;
fragment UNICODE32:
	'U' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;

fragment INTEGER: DECIMAL_INTEGER;

// Note: 0 or higher than 1, no leading 0s allowed (for ex: `01`)
fragment DECIMAL_INTEGER: '0' | SIGN? [1-9] DIGIT*;

fragment BIN_INTEGER: ('0' ('b' | 'B') BIN_DIGIT+)
	| ('%' BIN_DIGIT+);
fragment OCT_INTEGER:
	'0' ('o' | 'O') OCT_DIGIT+; // Make sure to not clash with boolean ON | OFF.
fragment DUO_INTEGER: '0' ('z' | 'Z') DUO_DIGIT+;
fragment HEX_INTEGER: ('0' ('x' | 'X') HEX_DIGIT+)
	| ('#' HEX_DIGIT+);

fragment DIGIT: [0-9];

fragment BIN_DIGIT: '0' | '1';
fragment OCT_DIGIT: [0-7];
fragment DUO_DIGIT: DIGIT | [xeab] | [XEAB]; // x = A = 10, e = B = 11.
fragment HEX_DIGIT: DIGIT | [a-f] | [A-F];

fragment FRACTION: '.' DIGIT+;

fragment EXPONENT: ('e' | 'E') SIGN? DIGIT+;

fragment SIGN: ('+' | '-');

NL: ( WS* COMMENT* SINGLE_NL COMMENT*);
SINGLE_NL: ('\r' '\n'? | '\n');

WS: HSPACE+ -> skip;

/*
 BLOCK_COMMENT:
 Can appear anywhere, spanning multiple lines.
 Remains in input, but hidden
 (doesn't interfere with parsing).
 */
BLOCK_COMMENT:
	'/*' .*? '*/' -> skip; // Block AKA Multi-line comment.
	
COMMENT: LINE_COMMENT | INLINE_COMMENT | BLOCK_COMMENT;

fragment DISABLE_LINE_MARKER: '--';

/*
 FULL_LINE_COMMENT:
 Remains in input, but hidden
 (doesn't interfere with parsing).
 */
//LINE_COMMENT: ((DISABLE_LINE|';') ~[\r\n]*) -> skip;
LINE_COMMENT
  : {this.atLineStart()}? HSPACE* (DISABLE_LINE_MARKER | SEMICOLON) ~[\r\n]* -> skip
  ;

/*
 INLINE_COMMENT: 
 Remains in input, but hidden (doesn't interfere with parsing).
 */
INLINE_COMMENT: ('//' | '#' HSPACE+) ~[\r\n]* -> skip;

IDENT_INVALID
    : [0-9][a-zA-Z0-9_]*
    ;

// For matching bad character.
fragment REST_CHAR:
    ~([@ \t\r\n'"`=,0123456789/-] | '[' | ']' | '{' | '}' | ':')
    ;

// For catching bad content.
REST: REST_CHAR (REST_CHAR)*;

// For catching bad meta commands.
META_INVALID: AT WS? REST REST*;
