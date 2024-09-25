# MINI specification

A MINI file is a configuration file for computer software that consists of plain text with a structure and syntax comprising key–value, and/or key–values, pairs organized in sections.

## Whitespaces

Tabs and horizontal whitespaces are ignored.

## Values & Native Types
A MINI value MUST be of one of the following native types:
- String
- Number
- Boolean
- List/array (a sequence consisting of strings, numbers, or booleans)
- NULL

## Key/Value Pairs
Comes in two forms:
1. A single value: a key-value pair that holds only one value.
2. A list of values: a key-values pair that holds zero or more values (or elements). Elements are separated by commas.

### A Key/Value Pair
The key is on the left of a equals sign `=` and the value is on the right.
> key = "value"
or
> lives = 3

### A Key/Value-list Pair
The key is on the left of a colon sign `:` and the values are on the right, each value separated by comma. (A final comma `,` may be accepted so parsing is not broken.)
> key: "value1", "value2", "value3"
or
> fruits: "pear", "orange", "banana"

## Sections

Key/Value Pairs are organized into sections denoted by multiple hash signs `#`.

To create a section, two hash signs `##` should be put in front and back of a word or phrase on its own line. Between the hash signs; the left and right section word/phrase should be trimmed of whitespaces, other whilespaces in the middle should be normalized to max one consecutive underline character `_`.
A section line is followed by an arbitrary number of Key/Value(s) pairs, each starting on a separate line.

> ## section ##
or
> ## my section ##

## Sections in Sections
To nest a section under another section, add one extra hash sign at the front and back more than the number of hash signs in the section you want to nest.
>## section ##
>### subsection ###

## String ##
--todo--

## Number ##
--todo--
  
## Boolean ##
--todo--
  
## List (array) ##
--todo--
  
## NULL ##
--todo--

---

By Marko K. Seppänen.

