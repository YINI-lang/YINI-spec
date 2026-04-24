# Contributing

First of all, welcome!  

Feedback, bug reports, suggestions, and code contributions are welcome!

---

If you find a bug or error in the `YINI` specification, grammar, or related files, feel free to open an issue or submit a pull request.

## Quick Start

There are two simple ways to try the grammar:

1. Use **ANTLR Lab** in the browser.
2. Run the grammar locally from the terminal with the provided `Taskfile.yaml`.

---

## Option 1: Test the grammar in ANTLR Lab

This is the quickest way to try the grammar in a browser:

1. Open **ANTLR Lab** in your browser, http://lab.antlr.org/

2. **Copy the lexer into ANTLR Lab:**
   1. Open the `Grammar-ANTLR4` directory in this repository.
   2. Open the file "YiniLexer.g4" and copy all its contents.
   3. In the **ANTLR Lab** in your browser. At the top-left, click "Lexer" to open the lexer input field.
   4. In that lexer field, delete any existing text, then paste in the contents you copied from "YiniLexer.g4".

3. **Copy the parser into ANTLR Lab:**
   1. Open `YiniParser.g4` and copy its full contents.
   2. In ANTLR Lab, click **Parser** in the top-left area.
   3. Remove any existing text and paste in the contents of `YiniParser.g4`.

4. **Copy a YINI example into the input field**
   1. Open the `Examples` directory in this repository.
   2. Open any example file, for example `Short-1.yini`, and copy its contents.
   3. In ANTLR Lab, find the **Input** field on the right.
   4. Remove any existing text and paste in the YINI example.

5. **Run the YINI source:**
   1. In the **ANTLR Lab**, look to the right and make sure the **"Start rule"-field** says `yini`, if not, replace it with `yini`.
   2. Now, click the button "Run".

6. **Expected result**
   If everything is loaded correctly, a parse tree should appear in ANTLR Lab.

---

## Option 2: Test the grammar from the terminal

A `Taskfile.yaml` is provided in `./Grammar-ANTLR4/` for simple local testing.

### Requirements

Make sure the following are available:

- `task`
- `antlr4-parse`

### Run from the grammar directory

Open a terminal in:

```sh
./Grammar-ANTLR4
```

Then run one of the following:
```sh
task parse:gui
task parse:tokens
task parse:trace
task parse:tree
```

You can also provide another input file:

```sh
task parse:tree INPUT=my-other-file.yini
task parse:gui INPUT=../Examples/Short-1.yini
```

### What the tasks do
- `task parse:gui`
  Opens the ANTLR parse viewer.
- `task parse:tokens`
  Prints lexer and parser tokens.
- `task parse:trace`
  Prints parser trace output.
- `task parse:tree`
  Prints the parse tree in the terminal.

---

## Common Issues

If you don't see a parse tree or get an error when clicking "Run", check the following:

- **Lexer Not Loaded Correctly** - Make sure you copied the full contents of `YiniLexer.g4` into the Lexer field in ANTLR Lab.

- **Parser Not Loaded Correctly** - Make sure you copied the full content of `YiniParser.g4` into the Parser field in ANTLR Lab.

- **A message in the console says "No such start rule: Program"** - Double-check that the "Start rule" field (on the right) is set to "yini".
