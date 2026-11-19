module Parser (parse) where

import Ast (Program (..))

-- | Parse source text into an AST.
parse :: String -> Either String Program
parse _ = Right (Program [] [] [])
