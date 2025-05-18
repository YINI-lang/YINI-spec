# Rationale

This document outlines the **background**, **design motivations**, and **format comparisons** that led to the creation of YINI. It aims to explain **why YINI exists**, what problems it solves, and how its structure and features were shaped by practical needs and lessons from other formats.

## Background and Intent

### Why was YINI created in the first place?

### What was missing from existing formats?

### What inspired its design?

## 📊 Comparison: YINI vs Other Formats
| Feature                       | INI | JSON | YAML | TOML | **YINI** |
|-------------------------------|:---:|:----:|:----:|:----:|:--------:|
| Typing (bool, list, null)     | ❌  | ✅   | ✅   | ✅   | ✅ |
| Section nesting               | ❌  | ❌   | ✅   | ✅   | ✅ |
| Human-friendly  & clean syntax| ✅  | ❌   | ➖[1]   | ➖[2]  | ✅|
| Readable multi-line strings   | ❌  | ❌   | ✅   | ✅   | ✅ |
| Flexible boolean literals     | ❌  | ❌   | ➖[3]  | ✅   | ✅ |
| Comment support               | ✅  | ❌   | ✅   | ✅   | ✅ |
| Escape sequence support       | ❌  | ✅   | ✅   | ✅   | ✅ |
| Quoted strings mandatory      | ✅  | ❌   | ❌   | ✅   | ✅|
| Clean, minimal syntax         | ✅  | ❌   | ❌   | ➖[2]   | ✅|
| Multiple comment styles       | ➖  | ❌   | ❌   | ❌   | ✅ |
| Strict vs lenient modes       | ❌  | ❌   | ❌   | ❌   | ✅ |
| Disable valid lines           | ❌  | ❌   | ❌   | ❌   | ✅ |

[1] YAML's syntax can be seen as complex or inconsistent for some users, especially around indentation and implicit typing.  
[2] Some users find TOML's use of `[`, `]`, and `.` visually noisy in deeply nested files.  
[3] YAML's flexible boolean handling can result in unintended type coercion, as behavior varies between parsers.

**Legend:**
- ✅ = Yes / Fully supported
- ❌ = Not supported
- ➖ = Partial, debated, or implementation-dependent
