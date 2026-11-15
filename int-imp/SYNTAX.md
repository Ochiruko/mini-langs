# int-imp syntax

int-imp is a small imperative language with functions and a single type, the integer.
Source is S-expressions, read by the sexp parser and Megaparsec.
Arguments are passed by reference.

## Program

A program is an output header, a `main`, and any number of functions.
There are no globals and no modules, apart from the output variables below.

    (out outvar1 ... outvarn)
    (main
        body)

`out` names the variables that `main` assigns. Their final values are printed
after the program runs.

## Functions

    (fn (arg1 ... argn) body)

## Bodies

A body is a sequence of statements:

    (foo arg1 ... argn)          ; call
    (set x 100)                  ; assign a literal
    (set x (bar arg1 ... argn))  ; assign the result of a call

## Open questions

- How is a function named? `(fn (args) body)` has no name slot.
- How does a function return a value, given `(set x (bar ...))`? A
  by-reference argument plus a mutated variable, or an explicit return form?
- Where do the `out` variables live, given that there are no globals?
  `main`-local variables made visible to `out`?
- What expressions exist besides literals and calls? There is no arithmetic,
  conditional or loop yet.
