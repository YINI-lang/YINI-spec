# YINI Grammar Test Samples

These files are parser and validator fixtures, not tutorial examples.

The `Valid` directories contain inputs that should parse for the named mode.
Some lenient valid samples intentionally rely on behavior that should produce a
warning, such as duplicate keys where the first definition wins.

The `Invalid` directories contain focused negative fixtures. Each invalid file
starts with a short comment naming the rule being tested and whether the primary
failure is lexical, syntactic, or semantic.

User-facing examples live in `../../Examples/`.
