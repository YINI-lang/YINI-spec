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

parser grammar YiniParser;
options {
	tokenVocab = YiniLexer;
	caseInsensitive = false;
}

//comment: BLOCK_COMMENT | LINE_COMMENT; NL: LINE_COMMENT+ | NL+;

yini: SHEBANG? COMMENT* NL* section+ NL* EOF;

section:
	SECTION_HEAD section_members
	| SECTION_HEAD section
	| terminal_line;

terminal_line: TERMINAL_TOKEN (NL+ | COMMENT? NL*);

section_members: member+;

member:
	//| KEY EQ NL+ // Empty value is treated as NULL.
	KEY EQ value? NL+ // Empty value is treated as NULL.
	//| KEY COLON elements? NL+
	| member_colon_list;
//| STRING COLON value? NL+; // ???

member_colon_list: KEY COLON elements? NL+;

value:
	list_in_brackets
	| string_literal
	| number_literal
	| boolean_literal
	| NULL; // NOTE: In specs NULL should be case-insensitive.

list: elements | list_in_brackets;

list_in_brackets: OB NL* elements NL* CB | EMPTY_LIST;

elements: element COMMA? | element COMMA elements;

element: NL* value NL* | NL* list_in_brackets NL*;

number_literal: NUMBER;

string_literal: STRING string_concat*;
string_concat: NL* PLUS NL* STRING;

// NOTE: In specs boolean literals should be case-insensitive.
boolean_literal: BOOLEAN_FALSE | BOOLEAN_TRUE;