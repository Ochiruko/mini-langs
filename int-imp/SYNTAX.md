# int-imp syntax

int-imp is a small imperative language with functions and a single type, the integer.
Arguments are passed by reference. Expressions nest freely.

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

If a function contains any `return` statement, every path through its body must
contain at least one `return` statement, including paths that are logically
unreachable. A `return` may appear anywhere in the body. A path is a choice of
branch at each `zero?` statement.

A function with no `return` statements evaluates to nothing. Nothing cannot be
passed as an argument or assigned.

    (fn fact (n acc)
        (return (zero? n acc (fact (sub n 1) (mul n acc)))))

    (fn fact2 (n acc)
        (zero? n (return acc) (return (fact2 (sub n 1) (mul n acc)))))

## Bodies

A body is a sequence of statements. A statement is a function call, a `zero?`
form, `set`, or `return`:

    (foo arg1 ... argn)          ; call
    (set x 100)                  ; assign a literal
    (set x (bar arg1 ... argn))  ; assign the result of a call
    (set x (zero? p t f))        ; assign the result of a conditional
    (zero? p t f)                ; conditional as a statement
    (return x)                   ; return a value

## Identifiers

Variable and function names may contain uppercase and lowercase letters, `'`,
`?` and `_`. They may also contain digits and `-`, but neither can be the first
character.

## Literals

Integers are the only values. Literals may be negative, as in `-5`. Literal forms:

    0xN   hexadecimal
    0dN   decimal
    0bN   binary
    N     decimal (same as 0dN)

## Prelude

Arithmetic (`add`, `mul`, ...) is provided by the prelude as ordinary functions.

There are no conditional statements or loops. Iteration is recursion, and tail
call elimination is planned for later.

### `zero?`

`(zero? p t f)` is a special form, not a function. It evaluates `p` first, then
evaluates and returns `t` if `p` is 0, otherwise evaluates and returns `f`. Only
the chosen branch is evaluated, so recursion in a branch terminates.

## Literal arguments

A literal may be a call argument, as in `(add x 1)`. Arguments are passed by
reference, so the compiler passes a fresh temporary holding the literal. Once the
call has finished evaluating, any write the callee made to the temporary is
discarded.

## Expressions

An expression is a name, a literal, a call `(f e1 ... en)`, or a `zero?` form.
Call arguments and the operands of `zero?` may all be nested expressions.
