grammar miniconfig;

prog	: rules TERMINAL_TOKEN
	;

rules	: rule
	| rule rules
	;

rule	: section_head member+;

section_head
	: '#' IDENT NL
	;
	
TERMINAL_TOKEN
	: '###'
	;
	
member	: IDENT  '='  value NL
	| IDENT  ':'  list NL
	;

IDENT  :	('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')* ;
    
list	: elements	
	| NL elements
	;

elements	: element
		| element ',' elements
		;
	
element	: value
	| value NL
	;

value	: STRING
	| NUMBER
	;
	
// TODO: make a literal accepting "main.c"
STRING
    :  ( ESC_SEQ | ~('\\' | '"') )*
    |  '"' ( ESC_SEQ | ~('\\' | '"') )* '"'
    ;

NUMBER	: INTEGER OPT_FRACTION OPT_EXPONENT
	;
	
INTEGER	: DIGIT
	| ONENINE DIGITS
	| '-' DIGIT
	| '-' ONENINE DIGITS
	;
	
DIGITS	: DIGIT	
	| DIGIT DIGITS
	;

DIGIT	: '0'	
	| ONENINE
	;

ONENINE	: '1'..'9';

OPT_FRACTION
	: ''
	| DIGITS
	;

OPT_EXPONENT
	: ''
	| ('e'|'E') OPT_SIGN DIGITS
	;

OPT_SIGN	: ''
	| ('+' | '-')
	;
	
fragment
HEX_DIGIT : ('0'..'9' | 'a'..'f' | 'A'..'F') ;

fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   UNICODE_ESC
    |   OCTAL_ESC
    ;

fragment
OCTAL_ESC
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESC
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;

COMMENT
    :   '//' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;}
    |   '/*' ( options {greedy=false;} : . )* '*/' {$channel=HIDDEN;}
    ;

WS  :   (' ' | '\t')+ {$channel=HIDDEN;} ;

NL  :   ( '\r\n' | '\r')+ {$channel=HIDDEN;} ;

