module Parser.AST where

-- Tipo que representa operações binárias
data BinOp
    = Plus
    | Minus
    | Star
    | Slash
    | Caret
    deriving (Show, Eq)

data Exp
    = IntVal Int
    | RealVal Double
    | Binary BinOp Exp Exp
    | UnaryNeg Exp
    | UnaryPos Exp
    deriving (Show, Eq)
