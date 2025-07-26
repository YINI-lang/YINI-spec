# Contributing

* First things first, welcome!
* Feedback, bug reports, suggestions, and code contributions are welcome!

---

Even though `YINI-spec` is still in beta, your feedback, suggestions, and contributions are highly valued. 

If you find any bugs or errors in the `YINI` specification, grammar, or elsewhere, feel free to add a new issue or make a PR :)

## Quick Start

The easiest and fastest way **to test the grammar** (without the need to install anything) is as follows:

1. Open **ANTLR Lab** in your browser, http://lab.antlr.org/

2. **Copy the lexer into ANTLR Lab:**
   1. Find the dir "Grammar-ANTLR4" in this repo.
   2. Open the file "YiniLexer.g4" and copy all its contents.
   3. In the **ANTLR Lab** in your browser. At the top-left, click "Lexer" to open the lexer input field.
   4. In that lexer field, delete any existing text, then paste in the contents you copied from "YiniLexer.g4".

3. **Copy the parser into ANTLR Lab:**
   1. Find the dir "Grammar-ANTLR4" in this repo.
   2. Open the file "YiniParser.g4" and copy all its contents.
   3. In the **ANTLR Lab** in your browser. At the top-left, click "Parser" to open the parser input field.
   4. In that parser field, delete any existing text, then paste in the contents you copied from "YiniParser.g4".

4. **Copy a YINI source into ANTLR Lab:**
   1. Go to the **"Examples"** dir in this repo.
   2. Open any example file (for example **"Short-1.yini"**) and copy all its contents.
   3. In the **ANTLR Lab** in your browser, find the "Input"-field on the right. Delete any existing text there, then paste in the contents you copied from "Short-1.yini" (or what ever you just copied).

5. **Run the YINI source:**
   1. In the **ANTLR Lab**, look to the right and make sure the **"Start rule"-field** says "yini", if not replace it with "yini".
   2. Now, click the button "Run".

6. If everything is correct, a parse tree should appear as the result in the **ANTLR Lab**.

### Common Issues When Running

If you don't see a parse tree or get an error when clicking "Run", check the following:

- **Lexer Not Loaded Correctly** - Make sure you copied the full content of "YiniLexer.g4" into the Lexer field in ANTLR Lab.

- **Parser Not Loaded Correctly** - Make sure you copied the full content of "YiniParser.g4" into the Parser field in ANTLR Lab.

- **A message in the console says "No such start rule: Program"** - Double-check that the "Start rule" field (on the right) is set to "yini".
