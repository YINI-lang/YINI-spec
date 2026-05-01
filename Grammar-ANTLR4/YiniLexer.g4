/*
  YINI grammar in ANTLR 4.
 
  Apache License, Version 2.0, January 2004,
  http://www.apache.org/licenses/
  Copyright 2024-2026 Gothenburg, Marko K. S. (Sweden via
  Finland).
*/

/* 
  This LEXER grammar aims to follow, as closely as possible (*),
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

lexer grammar YiniLexer;

/* ------------------------------------------------------------------
 * Fragments
 * ------------------------------------------------------------------ */

fragment EBD: ('0' | '1') ('0' | '1') ('0' | '1');
fragment HSPACE: [ \t];
fragment DIGIT: [0-9];
fragment SIGN: ('+' | '-');

fragment IDENT_SIMPLE_START: [a-zA-Z_];
fragment IDENT_SIMPLE_CHAR : [a-zA-Z0-9_];

fragment BIN_DIGIT: '0' | '1';
fragment OCT_DIGIT: [0-7];
fragment DUO_DIGIT: DIGIT | [xXeEaAbB]; // x = A = 10, e = B = 11.
fragment HEX_DIGIT: DIGIT | [a-fA-F];

fragment UNICODE16
  : 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
  ;

fragment UNICODE32
  : 'U' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
        HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
  ;

// Note: 0 or higher than 1, no leading 0s allowed (for ex: `01`)
fragment DECIMAL_INTEGER
  : '0'
  | [1-9] DIGIT*
  ;

fragment INTEGER
  : DECIMAL_INTEGER
  ;

fragment FRACTION
  : '.' DIGIT+
  ;

fragment EXPONENT
  : [eE] SIGN? DIGIT+
  ;

fragment BIN_INTEGER
  : '0' [bB] BIN_DIGIT+
  | '%' BIN_DIGIT+
  ;

fragment OCT_INTEGER
  : '0' [oO] OCT_DIGIT+ // Make sure to not clash with boolean ON | OFF.
  ;

fragment DUO_INTEGER
  : '0' [zZ] DUO_DIGIT+
  ;

fragment HEX_INTEGER
  : '0' [xX] HEX_DIGIT+
  | '#' HEX_DIGIT+
  ;

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
fragment IDENT_SIMPLE_LX
  : IDENT_SIMPLE_START (IDENT_SIMPLE_CHAR | '.')*
  ;

// IDENT_BACKTICKED: '`' ~[\u0000-\u001F`]* '`'; // No newlines, tabs, or C0 controls.
fragment IDENT_BACKTICKED
  : '`' ~[\u0000-\u001F`]* '`' // No newlines, tabs, or C0 controls.
  ;

fragment SECTION_NAME_PART
  : IDENT_SIMPLE_LX
  | IDENT_BACKTICKED
  ;

// Section markers: '^', '<', '§'.
// – Up to six repeated markers are allowed (the parser must enforce the ≤ 6 rule).
// – For levels beyond 6, use the numeric shorthand form (e.g. ^7, <12, §100).
fragment SECTION_MARKER
  : SECTION_MARKER_BASIC_REPEAT      // Classic/repeating marker section headers (e.g. ^^ SectionName).
  | SECTION_MARKER_SHORTHAND         // Numeric shorthand section headers (e.g. ^7 SectionName).
  | SECTION_MARKER_INVALID           // Captures malformed section markers so the parser/validator can report a clearer error.
  ;

// Match one or more of the same marker. Parser must check "count ≤ 6".
// This check is deferred to the parser, which
// gives more control and enables better user feedback.
fragment SECTION_MARKER_BASIC_REPEAT
  : CARET+
  | LT+
  | SS+
  ;

// Shorthand: a single marker followed by a positive integer (1 or larger).
// Examples: ^7, <12, §100
fragment SECTION_MARKER_SHORTHAND
  : (CARET | LT | SS) [1-9] DIGIT* HSPACE
  ;

fragment SECTION_MARKER_INVALID
  : (CARET | LT | SS)+ DIGIT+
  ;

// For matching bad character.
fragment REST_CHAR
  : ~([@ \t\r\n'"`=,0123456789/-] | '[' | ']' | '{' | '}' | ':')
  ;

/* ------------------------------------------------------------------
 * Structural / directive tokens
 * ------------------------------------------------------------------ */

SHEBANG
  : '#!' ~[\r\n]* EOL
  ;

YINI_TOKEN options { caseInsensitive = true; }
  : '@yini'
  ;

// @note Experimental / for future / testing.
INCLUDE_TOKEN options { caseInsensitive = true; }
  : '@include'
  ;

// @note Experimental / for future / testing.
DEPRECATED_TOKEN options { caseInsensitive = true; }
  : '@deprecated'
  ;

TERMINAL_TOKEN options { caseInsensitive = true; }
  : '/END'
  ;

// SECTION_HEAD: SECTION_MARKER HSPACE* WS* IDENT NL+;
SECTION_HEAD
  // : SECTION_MARKER HSPACE+ SECTION_NAME_PART NL+ // Requires hor-WS between marker and name.
  // : SECTION_MARKER HSPACE* SECTION_NAME_PART NL+   // Repeated/basic section headers do not require whitespace before the name.
  : SECTION_MARKER HSPACE* SECTION_NAME_PART HSPACE* EOL+ // Repeated/basic section headers do not require whitespace before the name.
  ;

INVALID_SECTION_HEAD
  : (CARET | LT | SS)+ ~[\r\n]* EOL+
  ;

/* ------------------------------------------------------------------
 * Keywords / literals
 * ------------------------------------------------------------------ */

BOOLEAN_FALSE options { caseInsensitive = true; }
  : 'false' | 'off' | 'no'
  ;

BOOLEAN_TRUE options { caseInsensitive = true; }
  : 'true' | 'on' | 'yes'
  ;

NULL options { caseInsensitive = true; }
  : 'null'
  ;

EMPTY_OBJECT
  : '{}'
  ;

EMPTY_LIST
  : '[]'
  ;

STRING
  : TRIPLE_QUOTED_STRING
  | SINGLE_OR_DOUBLE
  ;

TRIPLE_QUOTED_STRING
  : [RrCc]? '"""' .*? '"""'
  ; // Greedy-safe because of .*? (non-greedy).

SINGLE_OR_DOUBLE
  : R_AND_C_STRING
  ;

/**
 * Common rule for RAW and CLASSIC string literals.
 * Illegal characters are deferred to the parser, which gives more control
 * and enables better user feedback (e.g., pinpointing the exact location of
 * invalid characters). Additionally, this simplifies the lexer rule.
 *
 * Rather than having the lexer reject on any "illegal" character, let the
 * parser catch it so you can give a more precise error message.
 *
 * @note If refactoring rule(s), make sure C-strings can include \' and \" as well.
 */
R_AND_C_STRING
  : [RrCc]? '\'' ('\\\'' | ~['\r\n])* '\''
  | [RrCc]? '"'  ('\\"'  | ~["\r\n])* '"'
  ;

// // Hyper string literal.
// HYPER_STRING
//   : [Hh] '\'' (~['])* '\''
//   | [Hh] '"'  (~["])* '"'
//   ;

// NOTE: NUMBER must come before KEY, IDENT, etc.
NUMBER
  : SIGN? INTEGER FRACTION? EXPONENT?
  | SIGN? FRACTION EXPONENT?
  | SIGN? (BIN_INTEGER | OCT_INTEGER | DUO_INTEGER | HEX_INTEGER)
  ;

/* ------------------------------------------------------------------
 * Punctuation / symbols
 * ------------------------------------------------------------------ */

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

/* ------------------------------------------------------------------
 * Line structure / skipped trivia
 * ------------------------------------------------------------------ */

fragment EOL
  : SECTION_TAIL_COMMENT* NL
  ;

NL
  : ('\r' '\n'? | '\n')+
  ;

fragment SECTION_TAIL_COMMENT
  : '//' ~[\r\n]*
  | '#' HSPACE+ ~[\r\n]*
  ;

WS
  : HSPACE+ -> skip
  ;

/*
 BLOCK_COMMENT:
 Can appear anywhere, spanning multiple lines.
 Remains in input, but hidden
 (doesn't interfere with parsing).
 */
BLOCK_COMMENT
  : '/*' .*? '*/' -> skip // Block AKA Multi-line comment.
  ;

fragment DISABLE_LINE_MARKER
  : '--'
  ;

/*
 FULL_LINE_COMMENT:
 This rule intentionally does not enforce "start of line" in the lexer.
 The parser or later validation step must verify that FULL_LINE_COMMENT appears
 only where a full-line comment is allowed.
*/
// todo: if it doesn't work, try delete skip
FULL_LINE_COMMENT
  : HSPACE* (DISABLE_LINE_MARKER | SEMICOLON) ~[\r\n]* -> skip
  //: ('\r\n' | '\r' | '\n') HSPACE* (DISABLE_LINE_MARKER | SEMICOLON) ~[\r\n]* -> skip
  ;

/*
 INLINE_COMMENT:
 Remains in input, but hidden (doesn't interfere with parsing).
 */
INLINE_COMMENT
  : ('//' | '#' HSPACE+) ~[\r\n]* -> skip
  ;

/* ------------------------------------------------------------------
 * Identifiers / invalid / catch-all
 * ------------------------------------------------------------------ */

// KEY: IDENT;
KEY
  : SECTION_NAME_PART
  | IDENT_INVALID
  ;

IDENT_INVALID
  : [0-9][a-zA-Z0-9_]*
  ;

// Catch-all for otherwise unclassified invalid content.
REST
  : REST_CHAR+
  ;

// Captures malformed @-prefixed directives/metadata.
META_INVALID
  : AT REST+
  ;
