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

    (fn name (arg1 ... argn) body)

A function returns with `(return x)`, the last statement of its body.

## Bodies

A body is a sequence of statements:

    (foo arg1 ... argn)          ; call
    (set x 100)                  ; assign a literal
    (set x (bar arg1 ... argn))  ; assign the result of a call
    (set x (zero? p t f))        ; assign the result of a conditional
    (return x)                   ; return a value

## Identifiers

Variable and function names may contain uppercase and lowercase letters, `'`,
`?` and `_`. They may also contain digits and `-`, but neither can be the first
character. So names and integer literals never overlap, and there are no
negative literals: write `(sub 0 5)` for -5.

## Literals

Integers are the only values. Literal forms:

    0xN   hexadecimal
    0dN   decimal
    0bN   binary
    N     decimal (same as 0dN)

## Prelude

Arithmetic (`add`, `mul`, ...) is provided by the prelude as ordinary functions.

There are no conditional statements or loops. Iteration is recursion, and tail
call elimination is planned for later.

### `zero?`

`(zero? p t f)` is a special form, not a function. It evaluates `p`, then
evaluates and returns `t` if `p` is 0, otherwise evaluates and returns `f`. Only
the chosen branch is evaluated, so recursion in a branch terminates.

## Open questions

- `return` is always the last statement, since there is no statement-level
  branching, so it cannot return early. It is equivalent to "the last value is
  returned", just with explicit syntax. Is that what you want?
- `t` and `f` in `zero?` are evaluated lazily, so they must be expressions
  (names, literals, calls, nested `zero?`). Can ordinary call arguments also be
  nested expressions, or only names and literals?
- Can a literal be a call argument, as in `(add x 1)`? Arguments are passed by
  reference, so the compiler would pass a fresh temporary holding 1, and any
  write the callee makes to it would be discarded.
