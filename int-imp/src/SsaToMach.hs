module SsaToMach (translate) where

import qualified Mach
import qualified Ssa

translate :: Ssa.Program -> Mach.Program
translate Ssa.Program = Mach.Program
