module AstToSsa (translate) where

import qualified Ast
import qualified Ssa

translate :: Ast.Program -> Ssa.Program
translate Ast.Program = Ssa.Program
