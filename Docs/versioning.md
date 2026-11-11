# Versioning

This document explains how component versions are recorded in the YINI
specification repository.

The [YINI Specification](../YINI-Specification.md) defines language behavior
and takes precedence over this guide.

## Component Versions

The specification and ANTLR4 grammar have separate version numbers.
The specification package follows the specification version.

| Component             | Version source        |
|-----------------------|-----------------------|
| YINI specification    | specification         |
| ANTLR4 lexer grammar  | grammar               |
| ANTLR4 parser grammar | grammar               |
| Specification package | Follows specification |

A specification version and its corresponding grammar version do not
necessarily have the same number.

## Version Records

| File | Contents |
|------|----------|
| [versions.json](../versions.json) | Current specification and grammar versions. |
| [compatibility.json](./compatibility.json) | Historical specification-to-grammar version pairs. |
| [README.md](../README.md#version-mapping-table) | Human-readable version mapping table. |

The current version pair should agree across these files.

A version mapping identifies the grammar associated with a specification
release. It does not establish parser conformance or compatibility with
other specification versions.

## Specification Version Numbers

See [§14.2, Versioning Strategy](../YINI-Specification.md#142-versioning-strategy)
for the specification's version format and the meaning of major, minor,
patch, and prerelease identifiers.

Before the final 1.0.0 release, Beta and RC versions may still receive
breaking adjustments.

## Preparing a Release

When preparing a release:

1. Confirm the specification and grammar versions being released.
2. Update the current version pair in `versions.json`.
3. Add the corresponding pair to `Docs/compatibility.json` and the
   README's Version Mapping Table.
4. Check that component version strings and changelog entries agree
   with the intended release.
5. Follow the [Maintainer Guide](./Maintainer-Doc.md#release-process)
   for release preparation and publication.
