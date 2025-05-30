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
 v1.0.0 Beta 6 + Updates
 
 Feedback, bug reports and improvements are welcomed here
 https://github.com/YINI-lang/YINI-spec
 
 http://yini-lang.org
 */

lexer grammar YiniLexer;

fragment EBD: ('0' | '1') ('0' | '1') ('0' | '1');

// COMMENT: BLOCK_COMMENT | LINE_COMMENT;

//SECTION_HEAD: HASH+ [ \t]+ WS* IDENT NL+;
SECTION_HEAD: SECTION_MARKER [ \t]* WS* IDENT NL+;

//SECTION_MARKER: SS+ | EUR+ | GT+; SECTION_MARKER : [\u00A7\u20AC\u003E]+; // §, €
fragment SECTION_MARKER: CARET+ | TILDE+ | SS+ | EUR+;

TERMINAL_TOKEN options {
	caseInsensitive = true;
}: '/END';

SS: '\u00A7'; // Section sign §.
EUR: '\u20AC'; // Euro sign €.
CARET: '^';
TILDE: '~';
GT: '>'; // Greater Than.

EQ: '=';
HASH: '#';
COMMA: ',';
COLON: ':';
OB: '['; // Opening Bracket.
CB: ']'; // Closing Bracket.
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

EMPTY_LIST: '[' ']';

SHEBANG: '#!' ~[\n\r\b\f\t]* NL;

KEY: IDENT;

IDENT: ('a' ..'z' | 'A' ..'Z' | '_') (
		'a' ..'z'
		| 'A' ..'Z'
		| '0' ..'9'
		| '_'
	)*
	| IDENT_BACKTICKED;

IDENT_BACKTICKED: '`' ~[\u0000-\u001F`]* '`'; // No newlines, tabs, or C0 controls.

NUMBER:
	INTEGER ('.' INTEGER?)? EXPONENT?
	| SIGN? '.' DIGIT+ EXPONENT?
	| SIGN? (
		BIN_INTEGER
		| OCT_INTEGER // Make sure to not clash with boolean ON | OFF.
		| DUO_INTEGER
		| HEX_INTEGER
	);

STRING:
	RAW_STRING
	| HYPER_STRING
	| CLASSIC_STRING
	| TRIPLE_QUOTED_STRING
	| C_TRIPLE_QUOTED_STRING;

TRIPLE_QUOTED_STRING:
	//'"""' (~["] | '"' ~["] | '""' ~["])* '"""';
	[Rr]? '"""' .*? '"""'; // Greedy-safe because of .*? (non-greedy).

C_TRIPLE_QUOTED_STRING: [Cc] '"""' (ESC_SEQ | ~["])* '"""';

// Raw string literal, treats the backslash character (\) as a literal.
RAW_STRING:
	//('r' | 'R')? '\'' ~(['\n\r\b\f\t])* '\'' | ('r' | 'R')? '"' ~(["\n\r\b\f\t])* '"';
	[Rr]? '\'' ~['\r\n]* '\''
	| [Rr]? '"'
		{ _input.LA(2) != '"' }?    // <-- make sure we’re not looking at C""…
		 ~["\r\n]* '"';

// Hyper string literal.
HYPER_STRING: [Hh] '\'' (~['])* '\''
	| [Hh] '"' ( ~["])* '"';

// Classic string literal.
CLASSIC_STRING:
	[Cc] '\'' (ESC_SEQ | ~[\u0000-\u001F '])* '\''
  	| [Cc] '"'
  		{ _input.LA(2) != '"' }?    // <-- make sure we’re not looking at C""…
    	(ESC_SEQ | ~[\u0000-\u001F "])* '"';

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
fragment DUO_DIGIT: DIGIT | [xe] | [XE]; // x = 10, e = 11.
fragment HEX_DIGIT: DIGIT | [a-f] | [A-F];

fragment FRACTION: '.' DIGIT+;

fragment EXPONENT: ('e' | 'E') SIGN? DIGIT+;

fragment SIGN: ('+' | '-');

NL: ( WS* COMMENT* SINGLE_NL COMMENT*);

SINGLE_NL: ('\r' '\n'? | '\n');

WS: [ \t]+ -> skip;

/*
 DISABLE_LINE:
 Skip lines starting with `--`.
 */
DISABLE_LINE: ('--' ~[\r\n]*) -> skip;

COMMENT: LINE_COMMENT | INLINE_COMMENT | BLOCK_COMMENT;
/*
 FULL_LINE_COMMENT:
 Remains in input, but hidden
 (doesn't interfere with parsing).
 */
LINE_COMMENT: (';' ~[\r\n]*) -> channel(HIDDEN);

/*
 INLINE_COMMENT: 
 Remains in input, but hidden (doesn't interfere with parsing).
 */
INLINE_COMMENT: ('//' | '#' [ \t]+) ~[\r\n]* -> channel(HIDDEN);

/*
 BLOCK_COMMENT:
 Can appear anywhere, spanning multiple lines.
 Remains in input, but hidden
 (doesn't interfere with parsing).
 */
BLOCK_COMMENT:
	'/*' .*? '*/' -> channel(HIDDEN); // Block AKA Multi-line comment.