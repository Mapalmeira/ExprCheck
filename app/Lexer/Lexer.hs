{-# LANGUAGE InstanceSigs #-}
module Lexer.Lexer where

import Data.Char (isDigit, isSpace)
import Lexer.Token

-- Tipo de erro do Lexer
data LexerError
    = LexerError String String
    deriving (Eq)

instance Show LexerError where
    show :: LexerError -> String
    show (LexerError msg occ) = "Erro léxico: " ++ msg ++ ": " ++ occ

-- Empilha um token e continua o lexer no restante
addToken :: Token -> String -> Either LexerError [Token]
addToken tok rest =
    case lexer rest of
        Left err   -> Left err
        Right toks -> Right (tok : toks)

lexer :: String -> Either LexerError [Token]
lexer [] = Right [TokEOF]
lexer (c:cs)
    | isSpace c = lexer cs
    | isDigit c = lexerNum (c:cs)
    | otherwise = case c of
        '+' -> addToken TokPlus cs
        '-' -> addToken TokMinus cs
        '*' -> addToken TokStar cs
        '/' -> addToken TokSlash cs
        '^' -> addToken TokCaret cs
        '(' -> addToken TokLParen cs
        ')' -> addToken TokRParen cs
        _   -> Left (LexerError "Caractere inválido encontrado" [c])

-- Processa números inteiros e reais
lexerNum :: String -> Either LexerError [Token]
lexerNum input =
    let (intPart, rest) = span isDigit input
    in case rest of
        ('.':restAfterDot) -> lexerRealFrac intPart restAfterDot
        _ -> addToken (TokInt (read intPart)) rest

-- Processa a parte fracionária de números reais após um ponto ser detectado
lexerRealFrac :: String -> String -> Either LexerError [Token]
lexerRealFrac intPart restAfterDot =
    let (fracPart, restAfterFrac) = span isDigit restAfterDot
        numberStr = intPart ++ "." ++ fracPart
    in case fracPart of
        [] -> Left (LexerError "Número real mal formado (esperava-se números após o ponto)" (intPart ++ "."))
        _  -> case restAfterFrac of
            '.':_ -> Left (LexerError "Número real mal formado (múltiplos pontos)" (numberStr ++ "."))
            _     -> addToken (TokReal (read numberStr)) restAfterFrac