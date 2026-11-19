module AstToSsa (translate) where

import qualified Ast
import qualified Ssa

translate :: Ast.Program -> Ssa.Program
translate _ = Ssa.Program
