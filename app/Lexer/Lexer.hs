module Lexer.Lexer where

import Data.Char (isDigit, isSpace)
import Lexer.Token

-- Tipo de erro do Lexer
data LexerError
    = LexerError String String
    deriving (Eq)

instance Show LexerError where
    show (LexerError msg occ) = "Erro léxico: " ++ msg ++ ": " ++ occ

lexer :: String -> Either LexerError [Token]
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
        _   -> Left (LexerError "Caractere inválido encontrado" [c])
  where
    addToken tok =
        case lexer cs of
            Left err   -> Left err
            Right toks -> Right (tok : toks)

-- Processa números inteiros e reais
lexerNum :: String -> Either LexerError [Token]
lexerNum cs =
    let (numPart, rest) = span isDigit cs
    in case rest of
        ('.':restAfterDot) ->
            let (fracPart, restAfterFrac) = span isDigit restAfterDot
            in if null fracPart
               then Left (LexerError "Número real mal formado (espera-se números após o ponto)" (numPart ++ "."))
               else case restAfterFrac of
                   ('.':_) -> Left (LexerError "Erro Léxico: Número real mal formado (múltiplos pontos)" (numPart ++ "." ++ fracPart ++ "."))
                   _ -> case lexer restAfterFrac of
                       Left err   -> Left err
                       Right toks -> Right (TokReal (read (numPart ++ "." ++ fracPart)) : toks)

        _ -> case lexer rest of
            Left err   -> Left err
            Right toks -> Right (TokInt (read numPart) : toks)
