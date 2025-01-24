# TODO

## Add support for Ignore Line token `--`
GRAMMAR: If a **line starts with `--`** then the rest of the line should be ignored.

## Add support for Terminal Token `###`
GRAMMAR: Change terminal token (`/END`) or add support for terminal token `###` as well.

For this propably need to split the grammar into lexer and parser and use mode feature in ANTLR4... (Proparbly, not 100% sure yet) So it doesn't clash with section headers with level 3 or higher.

## Rename pure strings to raw strings
What? Rename the word pure to raw, in documentation and the grammar.
Why? To make the name of (pure) string more clear what it is by using the same name as in e.g. Python raw string.
Where? In the readme, spec and about files, plus also in the grammar itself.
