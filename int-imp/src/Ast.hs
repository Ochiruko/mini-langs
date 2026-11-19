module Ast
  ( Program (..)
  , Fn (..)
  , Stmt (..)
  , Expr (..)
  , Name
  ) where

import Data.Int (Int32)

type Name = String

-- | A whole program: the @out@ variables, the body of @main@, and the other
-- functions. @main@ is kept separate because it takes no arguments and is
-- not callable.
data Program = Program
  { outs :: [Name]
  , mainBody :: [Stmt]
  , fns :: [Fn]
  }
  deriving (Show, Eq)

data Fn = Fn
  { fnName :: Name
  , fnParams :: [Name]
  , fnBody :: [Stmt]
  }
  deriving (Show, Eq)

data Stmt
  = SCall Name [Expr]
  -- ^ @(foo e1 ... en)@. The result, if any, is dropped.
  | Set Name Expr
  -- ^ Copies the value into the variable's box, creating a local if needed.
  | Return Expr
  | IfZero Expr [Stmt] [Stmt]
  -- ^ Statement @zero?@: the first branch runs when the scrutinee is 0.
  deriving (Show, Eq)

data Expr
  = Var Name
  | Lit Int32
  | Call Name [Expr]
  | Zero Expr Expr Expr
  -- ^ Expression @zero?@: only the chosen branch is evaluated.
  deriving (Show, Eq)
