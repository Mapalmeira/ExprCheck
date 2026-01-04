module Parser.AST where

-- Tipo que representa operações binárias
data BinOp
    = Plus
    | Minus
    | Star
    | Slash
    | Caret
    deriving (Show, Eq)

data Expr
    = IntVal Int
    | RealVal Double
    | Binary BinOp Expr Expr
    | UnaryNeg Expr
    | UnaryPos Expr
    deriving (Show, Eq)
