# MINI-CONFIG
Minimalistic initialization configuration markup language format.

---

## General Objective
`miniCONFIG` aims to be a simple and (relatively) lightweight text-based markup language format, for storing configurations, settings and preferences in software. It should be language-independent and platform-independent as far as possible.

It aims to be even more simple and lightweight than similar formats (no specific names mentioned). No unnecessary extra niceties (due to keeping the format simple and lightweight) with regards to types (this can be taken care of by the host language if desired or needed). Yet expressive enough to store the most important data types like strings, numbers, booleans and lists in sections or nested sections.

## Design Goals
1. miniCONFIG should be simple and (relatively) lightweight.
2. miniCONFIG should be easy to implement and use.
3. miniCONFIG should be easily readable (to some extent) by humans.
4. miniCONFIG should be non-verbose, not use excessive or unnecessary words.
5. miniCONFIG data/document should be portable between platforms and programming languages.
6. miniCONFIG should support one-pass processing.

## Trivia
MINI-CONFIG stands for Minimalistic INI Configuration Object Notation File. Actually in the beginning M stood for Marko's (after the author) but was changed to stand for minimalistic.

## Specification
There exists a draft (work in progress) of the **[miniCONFIG spec](./miniCONFIG spec.md)**.

## Example
```
# Prefs

HomeDir = "C:\Users\John Smith"
KeyWords: "pear", "orange", "banana"
Buffers = 10

###
```
