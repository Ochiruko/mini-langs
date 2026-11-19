# int-imp syntax

int-imp is an imperative language with functions and one type, the 32-bit signed
integer. Arguments are passed by reference.

A `;` starts a comment that runs to the end of the line.

## Program

    (out outvar1 ... outvarn)
    (main s1 ... sn)
    functions...

The `out` variables are the only globals. Any function, `main` included, may
assign them. There are no modules.

When `main` finishes, each `out` variable is printed on its own line, in `out`
order, as `name: 0xhex, 0ddec`. Each line has three columns: `name:`, `0xhex,`
and `0ddec`. The columns are separated by one space and left aligned, and every
column except the last is padded to the width of its widest entry. Hex digits are
lowercase. A negative value has its `-` before the prefix, as in `-0x7e`.

## Functions

    (fn name (arg1 ... argn) s1 ... sn)

    (fn fact (n acc)
        (return (zero? n acc (fact (sub n 1) (mul n acc)))))

A function with no `return` evaluates to nothing. Nothing cannot be passed as an
argument or assigned.

If a function contains any `return`, every path through it must contain a
`return`, including paths that are logically unreachable. A path is a choice of
branch at each statement-level `zero?`.

`set x e` assigns `x` if `x` is an `out` variable, a parameter, or an existing
local. Otherwise it creates a local variable `x` of the enclosing function.

## Statements

A statement is a call, `set`, `return`, or `zero?`:

    (foo e1 ... en)                    ; call
    (set x e)
    (return e)                         ; exits the enclosing function
    (zero? p (t1 ... tn) (f1 ... fm))  ; `p` is an expression; the branches are
                                       ; lists of statements, possibly empty

The statement `zero?` evaluates `p`, then runs the statements of the first branch
if `p` is 0 and of the second branch otherwise.

## Expressions

An expression is a name, a literal, a call `(f e1 ... en)`, or
`(zero? p t f)`, where `p`, `t` and `f` are expressions. Call arguments, the
operands of `zero?`, and the operands of `set` and `return` may be any
expression.

The expression `zero?` evaluates `p` first. If `p` is 0 it evaluates `t` and
takes its value, otherwise it does the same with `f`. The other branch is not
evaluated.

An argument that is not a name is passed as a fresh temporary. Writes the callee
makes to it are discarded once the call finishes evaluating.

## Names and literals

A name consists of the characters `A-Z`, `a-z`, `0-9`, `-`, `'`, `?` and `_`. Its
first character is not a digit or `-`.

A literal is `0xN`, `0dN`, `0bN`, or `N`, which is the same as `0dN`. Each form
may be preceded by `-`: `-0x10`, `-5`.

## Prelude

The prelude provides arithmetic functions, including `add`, `sub` and `mul`. Its
full contents are not decided. There are no loops. Iteration is recursion, and
tail call elimination is a goal.

## Not yet specified

- Behavior on integer overflow and on literals outside the 32-bit range.

## Possible additions

- `block`: a sequence of statements usable as an expression, with `return-block`
  to give its value.
- Case expressions.
- `while`: a loop statement, which would make early `return` from inside a loop
  possible. No syntax has been designed.
