module Parser.Parser where

import Lexer.Token
import Parser.AST

-- Tipo de retorno das funções do parser
-- Ou um erro, ou (AST até então, Tokens a serem processados)
type ParseResult = Either String (Exp, [Token])

-- Ponto de entrada
-- Retorna uma mensagem de erro ou a AST resultante
parse :: [Token] -> Either String Exp
parse tokens =
    case parseSum tokens of
        Right (exp, [])        -> Right exp
        Right (_, extraTokens) -> Left ("[Erro sintático] Tokens extras encontrados: " ++ show extraTokens)
        Left err               -> Left err

-- Soma e Subtração
parseSum :: [Token] -> ParseResult
parseSum tokens =
    case parseMul tokens of
        Left err          -> Left err
        Right (exp, rest) -> sumBuilder exp rest

sumBuilder :: Exp -> [Token] -> ParseResult
sumBuilder exp [] = Right (exp, [])
sumBuilder exp (token : rest) =
    case token of
        TokPlus  -> process Plus
        TokMinus -> process Minus
        _        -> Right (exp, token : rest)
    where
        process op =
            case parseMul rest of
                Left err                  -> Left err
                Right (nextExp, nextRest) -> sumBuilder (Binary op exp nextExp) nextRest

-- Multiplicação e Divisão
parseMul :: [Token] -> ParseResult
parseMul tokens =
    case parsePow tokens of
        Left err          -> Left err
        Right (exp, rest) -> mulBuilder exp rest

mulBuilder :: Exp -> [Token] -> ParseResult
mulBuilder exp [] = Right (exp, [])
mulBuilder exp (token : rest) =
    case token of
        TokStar  -> process Star
        TokSlash -> process Slash
        _        -> Right (exp, token : rest)
    where
        process op =
            case parsePow rest of
                Left err                  -> Left err
                Right (nextExp, nextRest) -> mulBuilder (Binary op exp nextExp) nextRest

-- Potenciação
parsePow :: [Token] -> ParseResult
parsePow tokens =
    case parsePrimary tokens of
        Left err -> Left err
        Right (exp, rest) -> powBuilder exp rest

powBuilder :: Exp -> [Token] -> ParseResult
powBuilder exp (TokCaret : rest) =
    case parsePrimary rest of
        Left err -> Left err
        Right (nextExp, nextRest) -> powBuilder (Binary Caret exp nextExp) nextRest
powBuilder exp rest = Right (exp, rest)

-- Átomos, Parênteses e Unários
parsePrimary :: [Token] -> ParseResult
parsePrimary (TokInt n : rest) = Right (IntVal n, rest)
parsePrimary (TokReal n : rest) = Right (RealVal n, rest)
parsePrimary (TokLParen : rest) =
    case parseSum rest of
        Left err                          -> Left err
        Right (exp, TokRParen : nextRest) -> Right (exp, nextRest)
        Right (_, nextRest)               -> Left ("[Erro sintático] Esperava-se um ')' em: " ++ show nextRest) 
parsePrimary (TokMinus : rest) =
    case parsePrimary rest of
        Left err              -> Left err
        Right (exp, nextRest) -> Right (UnaryNeg exp, nextRest)
parsePrimary (TokPlus : rest) =
    case parsePrimary rest of
        Left err              -> Left err
        Right (exp, nextRest) -> Right (UnaryPos exp, nextRest)
parsePrimary tokens = Left ("[Erro sintático] Esperava-se um '(', número ou sinal em: " ++ show tokens)
