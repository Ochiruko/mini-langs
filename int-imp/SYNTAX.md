# int-imp syntax

An imperative language with functions and one type, the integer. Arguments are
passed by reference.

## Program

    (out outvar1 ... outvarn)
    (main body)
    functions...

The `out` variables are the only globals. `main` assigns them, and their final
values are printed after the program runs. There are no modules.

## Functions

    (fn name (arg1 ... argn) body)

    (fn fact (n acc)
        (return (zero? n acc (fact (sub n 1) (mul n acc)))))

A function with no `return` evaluates to nothing, which cannot be passed or
assigned. If a function has any `return`, every path through it must contain one,
including logically unreachable paths. `return-block` does not count.

## Bodies

A body is a sequence of statements. A statement is an expression, `set`,
`return`, or `return-block`:

    (foo arg1 ... argn)          ; call
    (set x 100)
    (set x (bar arg1 ... argn))
    (return x)                   ; exits the enclosing function, at any depth
    (return-block x)             ; ends the enclosing `body` with value x

## Expressions

An expression is a name, a literal, a call `(f e1 ... en)`, a `zero?` form, or a
`body` form. Expressions nest, and may appear as statements.

`(zero? p t f)` is a special form. It evaluates `p` first, then evaluates and
returns `t` if `p` is 0, otherwise `f`. Only the chosen branch is evaluated.

`(body s1 ... sn)` is a sequence of statements. Its value is the `x` of its
`return-block`, or nothing if it ends without one.

    (set x (zero? p (body (set y 1) (return-block y)) 0))

## Names and literals

Names may contain letters, digits, `-`, `'`, `?` and `_`. The first character
cannot be a digit or `-`.

Literals are `0xN`, `0dN`, `0bN`, and `N` (same as `0dN`), and may be negative:
`-5`.

## Prelude

Arithmetic (`add`, `mul`, ...) is provided as ordinary functions. There are no
loops. Iteration is recursion, and tail call elimination is planned.

A literal call argument is passed as a fresh temporary. Writes the callee makes to
it are discarded once the call finishes evaluating.
