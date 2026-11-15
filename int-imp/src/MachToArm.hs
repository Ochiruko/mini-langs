module MachToArm (translate) where

import qualified Arm
import qualified Mach

translate :: Mach.Program -> Arm.Program
translate Mach.Program = Arm.Program
