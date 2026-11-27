# YINI Examples

This directory contains user-facing examples for learning and reviewing YINI.

The `Lenient` directory shows the default human-friendly parsing mode. The
`Strict` directory contains examples intended to be parsed in strict mode. Most
strict examples also include `@yini strict` for clarity, but parser mode is
still selected by the parser, CLI option, API, or host application.

Expected JSON outputs for a few small examples are provided in
`Expected-JSON/`. These are intended as lightweight reference outputs for
developers and parser authors.

Examples use canonical separators by default. The
`Lenient/Assignment-Separators.yini` example demonstrates the lenient `:`
assignment alternative. Formatters should use `=` for those assignments and
keep `:` inside objects.

Technical edge cases and invalid parser fixtures live under
`../Grammar-ANTLR4/Test-samples/`.
