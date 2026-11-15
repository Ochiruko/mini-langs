module Main (main) where

import qualified X64
import qualified AstToSsa
import qualified MachToX64
import qualified Parser
import qualified SsaToMach
import qualified Ast.Tc as Tc

main :: IO ()
main =
  case Parser.parse "" >>= Tc.check of
    Left err -> putStrLn err
    Right ast ->
      print (MachToX64.translate (SsaToMach.translate (AstToSsa.translate ast)) :: X64.Program)
