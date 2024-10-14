# TODO

## Add support for Ignore Line token `--`
GRAMMAR: If a **line starts with `--`** then the rest of the line should be ignored.

## Add support for Terminal Token `###`
GRAMMAR: Change terminal token (`/END`) or add support for terminal token `###` as well.

For this propably need to split the grammar into lexer and parser and use mode feature in ANTLR4... (Proparbly, not 100% sure yet) So it doesn't clash with section headers with level 3 or higher.

