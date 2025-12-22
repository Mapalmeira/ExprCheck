module Lexer.Lexer where

import Lexer.Token

lexAll :: String -> [Token]
lexAll _ = [TokEOF]
