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
        Right (exp, [TokEOF])        -> Right exp
        Right (_, extraTokens) -> Left ("[Erro sintático] Tokens extras encontrados: " ++ show extraTokens)
        Left err               -> Left err

-- Soma e Subtração
parseSum :: [Token] -> ParseResult
parseSum tokens =
    case parseMul tokens of
        Left err          -> Left err
        Right (exp, rest) -> sumBuilder exp rest

sumBuilder :: Exp -> [Token] -> ParseResult
sumBuilder exp (TokPlus : rest) =
    case parseMul rest of
        Left err                  -> Left err
        Right (nextExp, nextRest) -> sumBuilder (Binary Plus exp nextExp) nextRest
sumBuilder exp (TokMinus : rest) =
    case parseMul rest of
        Left err                  -> Left err
        Right (nextExp, nextRest) -> sumBuilder (Binary Minus exp nextExp) nextRest
sumBuilder exp tokens = Right (exp, tokens)

-- Multiplicação e Divisão
parseMul :: [Token] -> ParseResult
parseMul tokens =
    case parsePow tokens of
        Left err          -> Left err
        Right (exp, rest) -> mulBuilder exp rest

mulBuilder :: Exp -> [Token] -> ParseResult
mulBuilder exp (TokStar : rest) =
    case parsePow rest of
        Left err                  -> Left err
        Right (nextExp, nextRest) -> mulBuilder (Binary Star exp nextExp) nextRest
mulBuilder exp (TokSlash : rest) =
    case parsePow rest of
        Left err                  -> Left err
        Right (nextExp, nextRest) -> mulBuilder (Binary Slash exp nextExp) nextRest
mulBuilder exp tokens = Right (exp, tokens)

-- Potenciação
parsePow :: [Token] -> ParseResult
parsePow tokens =
    case parseUnary tokens of
        Left err          -> Left err
        Right (exp, rest) -> powBuilder exp rest

powBuilder :: Exp -> [Token] -> ParseResult
powBuilder exp (TokCaret : rest) =
    case parsePow rest of
        Left err                  -> Left err
        Right (nextExp, nextRest) -> Right (Binary Caret exp nextExp, nextRest)
powBuilder exp tokens = Right (exp, tokens)

-- Unários
parseUnary :: [Token] -> ParseResult
parseUnary (TokMinus : rest) =
    case parsePrimary rest of
        Left err -> Left err
        Right (exp, nextRest) -> Right (UnaryNeg exp, nextRest)
parseUnary (TokPlus : rest) =
    case parsePrimary rest of
        Left err -> Left err
        Right (exp, nextRest) -> Right (UnaryPos exp, nextRest)
parseUnary tokens = parsePrimary tokens

-- Número e Parênteses
parsePrimary :: [Token] -> ParseResult
parsePrimary (TokInt n : rest) = Right (IntVal n, rest)
parsePrimary (TokReal n : rest) = Right (RealVal n, rest)
parsePrimary (TokLParen : rest) =
    case parseSum rest of
        Left err                          -> Left err
        Right (exp, TokRParen : nextRest) -> Right (exp, nextRest)
        Right (_, nextRest)               -> Left ("[Erro sintático] Esperava-se um ')' em: " ++ show nextRest) 
parsePrimary tokens = Left ("[Erro sintático] Esperava-se um '(' ou número em: " ++ show tokens)
