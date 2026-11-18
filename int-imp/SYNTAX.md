# int-imp syntax

An imperative language with functions and one type, the integer. Arguments are
passed by reference. `;` starts a comment that runs to the end of the line.

## Program

    (out outvar1 ... outvarn)
    (main s1 ... sn)
    functions...

The `out` variables are the only globals. Any function, `main` included, may
assign them. There are no modules.

When `main` finishes, each `out` variable is printed on its own line, in `out`
order:

    name: 0xhex, 0ddec

The three columns (`name:`, `0xhex,`, `0ddec`) are left aligned and padded to the
widest entry in the column. Hex digits are lowercase. A negative value has its
`-` before the prefix, as in `-0x7e`.

## Functions

    (fn name (arg1 ... argn) s1 ... sn)

    (fn fact (n acc)
        (return (zero? n acc (fact (sub n 1) (mul n acc)))))

A function with no `return` evaluates to nothing, which cannot be passed or
assigned. If a function has any `return`, every path through it must contain one,
including logically unreachable paths. A path is a choice of branch at each
`zero?`. `return-block` does not count.

`set` on an `out` variable assigns it. `set` on any other new name creates a local
variable of the enclosing function.

## Statements

A statement is an expression, `set`, `return`, or `return-block`:

    (foo arg1 ... argn)          ; call
    (set x 100)
    (set x (bar arg1 ... argn))
    (zero? p t f)                ; `t` and `f` are statements
    (return x)                   ; exits the enclosing function, at any depth
    (return-block x)             ; ends the enclosing `block` with value x

## Expressions

An expression is a name, a literal, a call `(f e1 ... en)`, a `zero?` form, or a
`block` form. Expressions nest.

`(zero? p t f)` is a special form. It evaluates `p` first, then evaluates `t` if
`p` is 0, otherwise `f`. Only the chosen branch is evaluated. In expression
position, `t` and `f` are expressions and the form has the chosen branch's value.
In statement position, `t` and `f` are statements and the form has no value.

`(block s1 ... sn)` is a sequence of statements. Its value is the `x` of its
`return-block`, or nothing if it ends without one. It lets a branch of `zero?`
hold several statements.

    (set x (zero? p (block (set y 1) (return-block y)) 0))

## Names and literals

Names may contain letters, digits, `-`, `'`, `?` and `_`. The first character
cannot be a digit or `-`.

Literals are `0xN`, `0dN`, `0bN`, and `N` (same as `0dN`). Each may have a `-`
prefix: `-0x10`, `-5`.

## Prelude

Arithmetic (`add`, `sub`, `mul`, ...) is provided as ordinary functions. There
are no loops. Iteration is recursion, and tail call elimination is a goal.

A literal call argument is passed as a fresh temporary. Writes the callee makes to
it are discarded once the call finishes evaluating.
