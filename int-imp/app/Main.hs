module Main (main) where

import qualified Ast.Tc as Tc
import qualified AstToSsa
import qualified Parser

-- The pipeline currently stops at Ssa.
main :: IO ()
main =
  case Parser.parse "" >>= Tc.check of
    Left err -> putStrLn err
    Right ast -> print (AstToSsa.translate ast)
