# int-imp syntax

int-imp is an imperative language with functions and one type, the 32-bit signed
integer. Arguments are passed by reference.

## Variables and boxes

Every variable (an `out` variable, a parameter or a local) is a box: a mutable
cell holding one 32-bit signed integer. Expressions evaluate to plain integers,
never to boxes.

- A name used as an argument passes its box. The callee's parameter is that
  same box, so the callee's writes are visible to the caller. Passing the same
  name twice aliases the two parameters.
- Any other argument is evaluated, stored in a fresh box, and that box is
  passed. Writes the callee makes to it are discarded.
- A name used anywhere else reads its box at that moment.
- `set x e` evaluates `e` and copies the value into `x`'s box. It never rebinds
  `x`, so `(set y x)` leaves `y` and `x` independent.
- Boxes are only passed downward. A function cannot return or store a box, so
  a box never outlives the call that created it.
- Arguments are evaluated left to right. A name argument is not read, so a
  later argument that writes to it is seen by the callee.
- Arithmetic wraps modulo 2^32.

A `;` starts a comment that runs to the end of the line.

## Program

    (out outvar1 ... outvarn)
    (main s1 ... sn)
    functions...

The `out` variables are the only globals. Any function, `main` included, may
assign them. There are no modules.

All `out` variables start as 0. When `main` finishes, each is printed on its own
line, in `out` order, as `name: 0xhex, 0ddec`, with single spaces. Hex digits are
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

`set x e` copies the value of `e` into `x` if `x` is an `out` variable, a
parameter, or an existing local. Otherwise it creates a local variable `x` of the
enclosing function.

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

## Names and literals

A name consists of the characters `A-Z`, `a-z`, `0-9`, `-`, `'`, `?` and `_`. Its
first character is not a digit or `-`.

A literal is `0xN` or a decimal `N`. Either may be preceded by `-`: `-0x10`, `-5`.
A literal outside the 32-bit range is a parse error.

## Prelude

The prelude provides `add`, `sub` and `mul`. There are no loops. Iteration is recursion, and
tail call elimination is a goal.

## Not yet specified

- Reading a local on a path where it has not been assigned yet. The typechecker
  will likely reject it.

## Possible additions

- `block`: a sequence of statements usable as an expression, with `return-block`
  to give its value.
- Case expressions.
- `while`, for early returns from loops.
