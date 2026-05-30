# YINI Examples

This directory contains user-facing examples for learning and reviewing YINI.

Recommended reading order:

1. `Lenient/Short-1.yini`
2. `Lenient/Simple-1.yini` and `Lenient/Simple-2.yini`
3. `Lenient/Sections.yini`
4. `Lenient/Lists.yini`, `Lenient/Nested-Objects.yini`, and `Lenient/Strings.yini`
5. `Strict/Short-1.yini`
6. `Strict/Nested-Sections.yini`
7. `Large-Scale Real-World Configuration Examples/`

The `Lenient` directory shows the default human-friendly parsing mode. The
`Strict` directory contains examples intended to be parsed in strict mode. Most
strict examples also include `@yini strict` for clarity, but parser mode is
still selected by the parser, CLI option, API, or host application.

Expected JSON outputs for a few small examples are provided in
`Expected-JSON/`. These are intended as lightweight reference outputs for
developers and parser authors.

Technical edge cases and invalid parser fixtures live under
`../Grammar-ANTLR4/Test-samples/`.
