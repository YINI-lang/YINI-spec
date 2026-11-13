# YINI Grammar Test Samples

These files are parser and validator fixtures, not tutorial examples.

The `Valid` directories contain inputs that should parse for the named mode.
Some valid samples intentionally rely on behavior that should produce a warning,
such as lenient duplicate keys where the first definition wins, or a document
declaring `@yini lenient` that satisfies all strict-mode requirements.

The `Invalid` directories contain focused negative fixtures. Each invalid file
starts with a short comment naming the rule being tested and whether the primary
failure is lexical, syntactic, or semantic.

Grammar recognition alone does not validate semantic fixtures. In particular,
numeric bounds and rounding, invalid escape sequences, marker positions, and
recovery-result validity must be checked by the implementing parser or validator.
The mode-declaration mismatch fixtures are also semantic. A document declaring
`@yini strict` is invalid when parsed in lenient mode. A document declaring
`@yini lenient` produces a warning when parsed in strict mode, but is valid if it
satisfies all strict-mode content and structural requirements. The declaration
does not change the active parsing mode. See Section 2.4.1 of the specification.
The duplicate-section fixtures are semantic errors in both modes; duplicate-key
handling remains mode-specific.
The same applies to line endings inside skipped block comments and the position
of shebang-like comments.
Leading numeric signs are separate tokens. Host validation must reject whitespace
or comments between a sign and its number, and include the sign when validating
the numeric value or normalizing its source spelling. Numeric concatenation
operands remain invalid in strict mode even when grammar recognition succeeds.
For Command Strings, the host validator must also check structural indentation
and that the closing delimiter occupies its own line. The lexer recognizes the
multiline token but does not perform those value and placement checks.
The numeric-boundary and recovery fixtures cover both lenient and strict mode.

User-facing examples live in `../../Examples/`.
