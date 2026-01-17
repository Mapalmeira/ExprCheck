module Parser.AST where

-- Tipo que representa operações binárias
data BinOp
    = Plus
    | Minus
    | Star
    | Slash
    | Caret
    deriving (Show, Eq)

data Ast
    = IntVal Int
    | RealVal Double
    | Binary BinOp Ast Ast
    | UnaryNeg Ast
    | UnaryPos Ast
    deriving (Show, Eq)
