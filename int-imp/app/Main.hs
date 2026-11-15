module Main (main) where

import qualified Arm
import qualified AstToSsa
import qualified MachToArm
import qualified Parser
import qualified SsaToMach
import qualified Ast.Tc as Tc

main :: IO ()
main =
  case Parser.parse "" >>= Tc.check of
    Left err -> putStrLn err
    Right ast ->
      print (MachToArm.translate (SsaToMach.translate (AstToSsa.translate ast)) :: Arm.Program)
