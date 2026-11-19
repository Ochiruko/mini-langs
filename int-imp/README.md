# int-imp

An imperative language with functions and one type, the 32-bit signed integer.
Programs are S-expressions.

- `SYNTAX.md` defines the language.
- `examples/tour.imp` is a program that uses every feature. `examples/tour.out` is
  its expected output.

## Compiler structure

Each IR is a module, and each translation between IRs is its own module:

    Parser -> Ast -> Ast.Tc -> AstToSsa -> Ssa -> SsaToMach -> Mach -> MachToX64 -> X64

`Ast.Tc` is the typechecker and a submodule of `Ast`.

Status: only this module skeleton exists. Each IR is a placeholder `Program` type,
the parser accepts any input, and no translation does any work.

## Building

Requires GHC 9.10 and cabal (`int-imp.cabal` pins `base ^>=4.20`).

    cabal build
    cabal run int-imp

`cabal run int-imp` currently runs the placeholder pipeline on an empty program
and prints `Program`.

## Possible additions

Neither is in the language yet, and either may be added later:

- `block`: a form that groups statements into one expression, so a `zero?` branch
  in expression position can run statements before producing its value.
- Case expressions: a multi-way branch on an integer. No syntax has been designed.
