module Lexer.Token where

data Token
  = TokEOF
  | TokLParen
  | TokRParen
  | TokStar
  | TokSlash
  | TokCaret
  | TokPlus
  | TokMinus
  | TokInt Int
  | TokReal Double
  deriving (Eq)

instance Show Token where
  show TokEOF      = "EOF"
  show TokLParen   = "("
  show TokRParen   = ")"
  show TokStar     = "*"
  show TokSlash    = "/"
  show TokCaret    = "^"
  show TokPlus     = "+"
  show TokMinus    = "-"
  show (TokInt n)  = "INT(" ++ show n ++ ")"
  show (TokReal n) = "REAL(" ++ show n ++ ")"
