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
  1.2.0-rc.2xx + UPDATES/WIP - >2026 Apr (v1.0.0-rc.5 YINI Spec Package).

  *) NOTE: Some rules are intentionally more permissive than the specification
  requires. This relaxation allows the host parser to detect syntax errors
  easier and provide clearer, more meaningful error messages. In the end, it is
  the responsibility of the implementing parser to fully enforce all rules of
  the YINI specification.

  Feedback, bug reports, and improvements are welcome here:

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

fragment SEP: '_';

/*
 * Digit separators:
 * - Allowed between digits.
 * - Allowed immediately after a base prefix.
 * - Not allowed at the end.
 * - Not allowed adjacent to another underscore.
 */
fragment DEC_DIGITS
  : DIGIT (SEP? DIGIT)*
  ;

fragment BIN_DIGITS
  : SEP? BIN_DIGIT (SEP? BIN_DIGIT)*
  ;

fragment OCT_DIGITS
  : SEP? OCT_DIGIT (SEP? OCT_DIGIT)*
  ;

fragment DUO_DIGITS
  : SEP? DUO_DIGIT (SEP? DUO_DIGIT)*
  ;

fragment HEX_DIGITS
  : SEP? HEX_DIGIT (SEP? HEX_DIGIT)*
  ;

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
  | [1-9] (SEP? DIGIT)*
  ;

fragment INTEGER
  : DECIMAL_INTEGER
  ;

fragment FRACTION
  : '.' DEC_DIGITS
  ;

fragment EXPONENT
  : [eE] SIGN? DEC_DIGITS
  ;

fragment BIN_INTEGER
  : '0' [bB] BIN_DIGITS
  | '%' BIN_DIGITS
  ;

fragment OCT_INTEGER
  : '0' [oO] OCT_DIGITS // Make sure to not clash with boolean ON | OFF.
  ;

fragment DUO_INTEGER
  : '0' [zZ] DUO_DIGITS
  ;

fragment HEX_INTEGER
  : '0' [xX] HEX_DIGITS            // 0xFFAA00
  | [hH] [eE] [xX] ':' HEX_DIGITS  // hex:ffaa00, HEX:FFAA00
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

// Section markers: '^', '§', '>', '<'.
// - Up to nine repeated markers are allowed.
// - For levels beyond 9, use the numeric shorthand form (e.g. ^10, §100, >12, <12).
// - Repeated/basic form supports optional '_' separators between same marker chars.
// - Numeric shorthand form does NOT support '_' separators.
// - The parser/visitor must enforce the maximum repeated-marker depth and maximum section depth.
// Keep the order as 1, 2, and 3.
fragment SECTION_MARKER
  : SECTION_MARKER_SHORTHAND         // (1) Numeric shorthand section headers (e.g. ^7 SectionName).
  | SECTION_MARKER_BASIC_REPEAT      // (2) Classic/repeating marker section headers (e.g. ^^ SectionName).
  | SECTION_MARKER_INVALID           // (3) Captures malformed section markers so the parser/validator can report a clearer error.
  ;

// Repeated/basic marker form.
// Underscores may appear only between two identical section marker characters.
// Match one or more of the same marker. Parser must check "count ≤ 9",
// for level 10 and deeper, numeric shorthand is required.
// This check is deferred to the parser, which
// gives more control and enables better user feedback.
fragment SECTION_MARKER_BASIC_REPEAT
  : CARET_MARKERS
  | SS_MARKERS
  | GT_MARKERS
  | LT_MARKERS
  ;

fragment CARET_MARKERS
  : CARET (SEP? CARET)*
  ;

fragment SS_MARKERS
  : SS (SEP? SS)*
  ;

fragment GT_MARKERS
  : GT (SEP? GT)* // >
  ;

fragment LT_MARKERS
  : LT (SEP? LT)* // <
  ;

// Shorthand: a single marker followed by a positive integer (1 or larger).
// Examples: ^7, <12, §100
fragment SECTION_MARKER_SHORTHAND
  : (CARET | SS | GT | LT ) [1-9] DIGIT*
  ;

fragment SECTION_MARKER_INVALID
  : (CARET | SS | GT | LT | SEP)+ DIGIT*
  ;

// For matching bad character.
fragment REST_CHAR
  // : ~([@ \t\r\n'"`=,0123456789/-] | '[' | ']' | '{' | '}' | ':')
  // :~([@#> \t\r\n'"`=,0123456789/-] | '[' | ']' | '{' | '}' | ':')
  : ~([@#^§>< \t\r\n'"`=,0123456789/-] | '[' | ']' | '{' | '}' | ':')
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
  // : SECTION_MARKER HSPACE* SECTION_NAME_PART HSPACE* EOL+ // Repeated/basic section headers do not require whitespace before the name.
  : SECTION_MARKER_SHORTHAND HSPACE+ SECTION_NAME_PART HSPACE* EOL+
  | SECTION_MARKER_BASIC_REPEAT HSPACE* SECTION_NAME_PART HSPACE* EOL+  
  ;

INVALID_SECTION_HEAD
  // : (CARET | SS | GT | LT | SEP)+ ~[\r\n]* EOL+
  : (CARET | SS | GT | LT | SEP) ~[\r\n]* EOL+
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

// STRING
//   : TRIPLE_QUOTED_STRING
//   | SINGLE_OR_DOUBLE
//   ;

// TRIPLE_QUOTED_STRING
//   : [RrCc]? '"""' .*? '"""'
//   ; // Greedy-safe because of .*? (non-greedy).

// SINGLE_OR_DOUBLE
//   : R_AND_C_STRING
//   ;

/**
 * Common rule for RAW and CLASSIC string literals.
 * Illegal characters are deferred to the parser, which gives more control
 * and enables better user feedback (e.g., pinpointing the exact location of
 * invalid characters). Additionally, this simplifies the lexer rule.
 *
 * Rather than having the lexer reject on any "illegal" character, let the
 * implemented parser catch it so you can give a more precise error message.
 *
 * @note If refactoring rule(s), make sure C-strings can include \' and \" as well.
 */
// R_AND_C_STRING
//   : [RrCc]? '\'' ('\\\'' | ~['\r\n])* '\''
//   | [RrCc]? '"'  ('\\"'  | ~["\r\n])* '"'
//   ;

STRING
  : CLASSIC_TRIPLE_QUOTED_STRING
  | RAW_TRIPLE_QUOTED_STRING
  | CLASSIC_SINGLE_OR_DOUBLE_STRING
  | RAW_SINGLE_OR_DOUBLE_STRING
  ;

fragment RAW_TRIPLE_QUOTED_STRING
  : [Rr]? '"""' .*? '"""'
  ;

fragment CLASSIC_TRIPLE_QUOTED_STRING
  // : [Cc] '"""' .*? '"""'
  : [Cc] '"""' ( '\\' . | . )*? '"""'
  ;

fragment RAW_SINGLE_OR_DOUBLE_STRING
  : [Rr]? '\'' ~['\r\n]* '\''
  | [Rr]? '"'  ~["\r\n]* '"'
  ;

fragment CLASSIC_SINGLE_OR_DOUBLE_STRING
  : [Cc] '\'' ('\\' ~[\r\n] | ~['\\\r\n])* '\''
  | [Cc] '"'  ('\\' ~[\r\n] | ~["\\\r\n])* '"'
  ;

// NOTE: This NUMBER rule must come before KEY, IDENT, etc.
NUMBER
  : SIGN? INTEGER FRACTION? EXPONENT?
  | SIGN? FRACTION EXPONENT?
  | SIGN? (BIN_INTEGER | OCT_INTEGER | DUO_INTEGER | HEX_INTEGER)
  ;

/* ------------------------------------------------------------------
 * Punctuation / symbols
 * ------------------------------------------------------------------ */

CARET: '^';
SS: '\u00A7'; // Section sign §.
GT: '>'; // Greater Than.
LT: '<'; // Less Than.

EQ: '=';
// NOTE: Do not include '#' here, because it would conflict with comment tokenization.
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
  | '#' ~[\r\n]*
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

DISABLED_LINE
  : DISABLE_LINE_MARKER ~[\r\n]*
  ;

/*
 FULL_LINE_COMMENT:
 This rule intentionally does not enforce "start of line" in the lexer.
 The parser or later validation step must verify that FULL_LINE_COMMENT appears
 only where a full-line comment is allowed.
*/
// todo: if it doesn't work, try delete skip
FULL_LINE_COMMENT
  //: ('\r\n' | '\r' | '\n') HSPACE* (DISABLE_LINE_MARKER | SEMICOLON) ~[\r\n]* -> skip
  //: HSPACE* (DISABLE_LINE_MARKER | SEMICOLON) ~[\r\n]* -> skip // This (may?) accidentally allow invalid inline semicolon comments.
  : ';' ~[\r\n]*
  ;

/*
 INLINE_COMMENT:
 Remains in input, but hidden (doesn't interfere with parsing).
 */
INLINE_COMMENT
  : ('//' | '#') ~[\r\n]* -> skip
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
