module MachToX64 (translate) where

import qualified X64
import qualified Mach

translate :: Mach.Program -> X64.Program
translate Mach.Program = X64.Program
