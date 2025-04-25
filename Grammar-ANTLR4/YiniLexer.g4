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
 v1.0.0 Beta 3
 
 Feedback, bug reports and improvements are welcomed here
 https://github.com/YINI-lang/YINI-spec
 
 http://yini-lang.org
 */

lexer grammar YiniLexer;

fragment EBD: ('0' | '1') ('0' | '1') ('0' | '1');

COMMENT: BLOCK_COMMENT | LINE_COMMENT;

//SECTION_HEAD: HASH+ [ \t]+ WS* IDENT NL+;
SECTION_HEAD: SECTION_MARKER [ \t]+ WS* IDENT NL+;

//SECTION_MARKER: SS+ | EUR+ | GT+; SECTION_MARKER : [\u00A7\u20AC\u003E]+; // §, €, >
fragment SECTION_MARKER: HASH+ | SS+ | EUR+ | TILDE+ | GT+;

TERMINAL_TOKEN options {
	caseInsensitive = true;
	//}: '/END' | (SS SS SS) | (EUR EUR EUR) | '\u003E\u003E\u003E';
}: '/END' | '###';

SS: '\u00A7'; // Section sign §.
EUR: '\u20AC'; // Euro sign €.
GT: '>'; // Greater Than.
TILDE: '~';

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
	| PHRASE;

PHRASE: '`' ~[\r\n]* '`'; // NOTE: Only for keys!

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
	| TRIPLE_QUOTED_STRING;

// Raw string literal, treats the backslash character (\) as a literal.
RAW_STRING:
	//('r' | 'R')? '\'' ~(['\n\r\b\f\t])* '\'' | ('r' | 'R')? '"' ~(["\n\r\b\f\t])* '"';
	('r' | 'R')? '\'' ~['\r\n]* '\''
	| ('r' | 'R')? '"' ~["\r\n]* '"';

// Hyper string literal.
HYPER_STRING: ('h' | 'H') '\'' (~['])* '\''
	| ('h' | 'H') '"' ( ~["])* '"';

// Classic string literal.
CLASSIC_STRING: ('c' | 'C') '\'' (ESC_SEQ | ~('\''))* '\''
	| ('c' | 'C') '"' ( ESC_SEQ | ~('"'))* '"';

TRIPLE_QUOTED_STRING:
	'"""' (~["] | '"' ~["] | '""' ~["])* '"""';

// Note: Like 8.2 in specification.
ESC_SEQ: '\\' (["']) | ESC_SEQ_BASE;

// Note: Except does'n not include quotes `"`, `'`.
ESC_SEQ_BASE: '\\' ([nrbft\\/0] | UNICODE);

fragment UNICODE: 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;

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

NL: (WS* COMMENT* SINGLE_NL COMMENT*);

SINGLE_NL: ('\r' '\n'? | '\n');

WS: [ \t]+ -> skip;

BLOCK_COMMENT:
	'/*' .*? '*/' -> skip; // Block AKA Multi-line comment.

LINE_COMMENT: '//' ~[\r\n]* -> skip;