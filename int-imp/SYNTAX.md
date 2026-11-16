# int-imp syntax

int-imp is a small imperative language with functions and a single type, the integer.
Source is S-expressions, read by the sexp parser and Megaparsec.
Arguments are passed by reference.

## Program

A program is an output header, a `main`, and any number of functions.
There are no modules. The only globals are the output variables below.

    (out outvar1 ... outvarn)
    (main
        body)

`out` names the global variables that `main` assigns. Their final values are
printed after the program runs.

## Functions

    (fn (arg1 ... argn) body)

## Bodies

A body is a sequence of statements:

    (foo arg1 ... argn)          ; call
    (set x 100)                  ; assign a literal
    (set x (bar arg1 ... argn))  ; assign the result of a call

## Identifiers

Variable and function names may contain uppercase and lowercase letters, `-`,
`'`, `?`, `_` and digits. A name cannot start with a digit, so names and
integer literals never overlap.

## Literals

Integers are the only values. Literal forms:

    0xN   hexadecimal
    0dN   decimal
    0bN   binary
    N     decimal (same as 0dN)

## Prelude

Arithmetic (`add`, `mul`, ...) is provided by the prelude as ordinary functions.

There are no conditionals or loops. Iteration is recursion, and tail call
elimination is planned for later. Branching is done by the one lazy prelude
function, `zero?`, since the arithmetic functions cannot express laziness.

## Open questions

- How is a function named? `(fn (args) body)` has no name slot.
- How does a function return a value, given `(set x (bar ...))`? A
  by-reference argument plus a mutated variable, or an explicit return form?
- What is the call form of `zero?`, and what are its lazy operands? A
  by-reference int cannot stand for an unevaluated branch, so they must be
  bodies or function names, which would make `zero?` a special form rather than
  a function. Is that intended?
- Are negative literals allowed (`-5`)? `-` is a legal identifier character.
- Can a literal be an argument (`(add x 1)`)? With call-by-reference it needs an
  implicit temporary.
