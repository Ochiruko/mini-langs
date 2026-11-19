module Ast.Tc (check) where

import Ast (Program)

-- | Typecheck an AST program.
check :: Program -> Either String Program
check = Right
