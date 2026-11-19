module Main (main) where

import qualified Ast.Tc as Tc
import qualified AstToSsa
import qualified MachToX64
import qualified Parser
import qualified SsaToMach
import qualified X64

main :: IO ()
main =
  case Parser.parse "" >>= Tc.check of
    Left err -> putStrLn err
    Right ast ->
      print (MachToX64.translate (SsaToMach.translate (AstToSsa.translate ast)) :: X64.Program)
