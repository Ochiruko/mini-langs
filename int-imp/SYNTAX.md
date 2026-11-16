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
unreachable. A `return` may appear anywhere in the body, at any depth, including
inside a `body` form. `return-block` does not count toward this rule.

A function with no `return` statements evaluates to nothing. Nothing cannot be
passed as an argument or assigned.

    (fn fact (n acc)
        (return (zero? n acc (fact (sub n 1) (mul n acc)))))

## Bodies

A body is a sequence of statements. A statement is an expression, `set`,
`return`, or `return-block`:

    (foo arg1 ... argn)          ; call
    (set x 100)                  ; assign a literal
    (set x (bar arg1 ... argn))  ; assign the result of a call
    (set x (zero? p t f))        ; assign the result of a conditional
    (zero? p t f)                ; expression as a statement
    (return x)                   ; return from the function
    (return-block x)             ; return from the enclosing body

### `body`

`(body s1 ... sn)` is a special form for a sequence of statements. It is an
expression. `(return-block x)` ends the enclosing `body` and makes `x` its value.
For example:

    (set x (zero? p (body (set y 1) (return-block y)) 0))

`return` inside a `body` exits the enclosing function, not the body.

A `body` that ends without a `return-block` evaluates to nothing, like a function
with no `return`.

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

An expression is a name, a literal, a call `(f e1 ... en)`, a `zero?` form, or a `body` form.
Call arguments and the operands of `zero?` may all be nested expressions.
