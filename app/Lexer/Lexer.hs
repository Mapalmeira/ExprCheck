module Lexer.Lexer where

import Data.Char (isDigit, isSpace)
import Lexer.Token

lexer :: String -> Either String [Token]
lexer [] = Right [TokEOF]
lexer (c:cs)
    | isSpace c = lexer cs
    | isDigit c = lexerNum (c:cs)
    | otherwise = case c of
        '+' -> addToken TokPlus
        '-' -> addToken TokMinus
        '*' -> addToken TokStar
        '/' -> addToken TokSlash
        '^' -> addToken TokCaret
        '(' -> addToken TokLParen
        ')' -> addToken TokRParen
        _   -> Left $ "Erro Léxico: Caractere inválido encontrado: '" ++ [c] ++ "'"
  where
    addToken tok =
        case lexer cs of
            Left err   -> Left err
            Right toks -> Right (tok : toks)

-- Processa números inteiros e reais
lexerNum :: String -> Either String [Token]
lexerNum cs =
    let (numPart, rest) = span isDigit cs
    in case rest of
        ('.':restAfterDot) ->
            let (fracPart, restAfterFrac) = span isDigit restAfterDot
            in if null fracPart
               then Left "Erro Léxico: Número real mal formado (espera-se números após o ponto)"
               else case restAfterFrac of
                   ('.':_) -> Left "Erro Léxico: Número real mal formado (múltiplos pontos)"
                   _ -> case lexer restAfterFrac of
                       Left err   -> Left err
                       Right toks -> Right (TokReal (read (numPart ++ "." ++ fracPart)) : toks)

        _ -> case lexer rest of
            Left err   -> Left err
            Right toks -> Right (TokInt (read numPart) : toks)
