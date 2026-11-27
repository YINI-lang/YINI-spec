# AGENTS.md

AI agent instructions for the YINI specification repository.

Read the [shared YINI project instructions](../yini-ecosystem/AGENTS.md)
before making changes.

## Repository guidance

- `YINI-Specification.md` defines language behavior. `RATIONALE.md` is an
  informative companion, and the specification takes precedence.
- Preserve the rationale's specification-aligned numbering and existing links.
- Keep edits focused and preserve existing changes and historical material.
- Do not invent syntax, rules, design motivations, or implementation status.
- Do not change grammar, examples, published PDFs, or release metadata unless
  the task requires it.
- For prose changes, inspect the Markdown rendering, check affected links, and
  run `git diff --check`. Run any relevant existing checks for other changes.
- Do not create commits, tags, branches, releases, or publish artifacts unless
  explicitly requested.

## Specification change history

- Add specification change notes to the appropriate version group in
  §16.4, “Spec Changes”. Use the existing upcoming/WIP group when applicable.
- Keep the newest three version groups in §16.4, newest first. Count an
  upcoming/WIP group as one of the three.
- When adding a version group would exceed this limit, move the oldest
  group in full to `Docs/SPEC-HISTORY.md`. Keep archived groups newest first.
- When archiving, preserve the entries' wording, historical meaning,
  version labels, and recorded dates. Adjust heading levels and relative
  links as needed for their new location.
- Maintain links between §16.4 and the archive. Identify the archived
  entries as changes to earlier specification versions.
- Before finishing an archival move, compare the moved entries with the
  originals and verify that each version group appears once across
  §16.4 and the archive. Apply the prose checks under Repository guidance.
- Record the archival move briefly in the current `CHANGELOG.md` section.
