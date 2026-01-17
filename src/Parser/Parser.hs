module Parser.Parser where

import Lexer.Token
import Parser.AST

-- Tipo de retorno das funções do parser:
-- Ou um erro (Left), ou uma tupla com a AST e os Tokens restantes (Right)
type ParseResult = Either String (Ast, [Token])

-- Ponto de entrada principal
-- Retorna uma mensagem de erro ou a AST completa
parse :: [Token] -> Either String Ast
parse tokens =
    case parseSum tokens of
        -- Sucesso: Consumiu tudo e sobrou apenas o EOF
        Right (ast, [TokEOF])  -> Right ast
        -- Erro: Sobraram tokens extras
        Right (_, extraTokens) ->
            Left ("[Erro sintático] Tokens extras encontrados: " ++ show extraTokens)
        -- Erro propagado
        Left err -> Left err

-- NÍVEL 1: Soma e Subtração
parseSum :: [Token] -> ParseResult
parseSum tokens =
    case parseMul tokens of
        Left err          -> Left err
        Right (ast, rest) -> sumBuilder ast rest

sumBuilder :: Ast -> [Token] -> ParseResult
sumBuilder ast (TokPlus : rest) =
    case parseMul rest of
        Left err -> Left err
        Right (nextAst, nextRest) ->
            sumBuilder (Binary Plus ast nextAst) nextRest

sumBuilder ast (TokMinus : rest) =
    case parseMul rest of
        Left err -> Left err
        Right (nextAst, nextRest) ->
            sumBuilder (Binary Minus ast nextAst) nextRest

sumBuilder ast tokens = Right (ast, tokens)

-- NÍVEL 2: Multiplicação e Divisão
parseMul :: [Token] -> ParseResult
parseMul tokens =
    case parsePow tokens of
        Left err          -> Left err
        Right (ast, rest) -> mulBuilder ast rest

mulBuilder :: Ast -> [Token] -> ParseResult
mulBuilder ast (TokStar : rest) =
    case parsePow rest of
        Left err -> Left err
        Right (nextAst, nextRest) ->
            mulBuilder (Binary Star ast nextAst) nextRest

mulBuilder ast (TokSlash : rest) =
    case parsePow rest of
        Left err -> Left err
        Right (nextAst, nextRest) ->
            mulBuilder (Binary Slash ast nextAst) nextRest

mulBuilder ast tokens = Right (ast, tokens)

-- NÍVEL 3: Potenciação (associativa à direita)
parsePow :: [Token] -> ParseResult
parsePow tokens =
    case parseUnary tokens of
        Left err          -> Left err
        Right (ast, rest) -> powBuilder ast rest

powBuilder :: Ast -> [Token] -> ParseResult
powBuilder ast (TokCaret : rest) =
    case parsePow rest of
        Left err -> Left err
        Right (nextAst, nextRest) ->
            Right (Binary Caret ast nextAst, nextRest)

powBuilder ast tokens = Right (ast, tokens)

-- NÍVEL 4: Operadores Unários
parseUnary :: [Token] -> ParseResult
parseUnary (TokMinus : rest) =
    case parsePrimary rest of
        Left err -> Left err
        Right (ast, nextRest) ->
            Right (UnaryNeg ast, nextRest)

parseUnary (TokPlus : rest) =
    case parsePrimary rest of
        Left err -> Left err
        Right (ast, nextRest) ->
            Right (UnaryPos ast, nextRest)

parseUnary tokens = parsePrimary tokens

-- NÍVEL 5: Literais e Parênteses
parsePrimary :: [Token] -> ParseResult
parsePrimary (TokInt n : rest) =
    Right (IntVal n, rest)

parsePrimary (TokReal n : rest) =
    Right (RealVal n, rest)

parsePrimary (TokLParen : rest) =
    case parseSum rest of
        Left err -> Left err
        Right (ast, TokRParen : nextRest) ->
            Right (ast, nextRest)
        Right (_, nextRest) ->
            Left ("[Erro sintático] Esperava-se um ')' mas encontrou: " ++ show nextRest)

parsePrimary tokens =
    Left ("[Erro sintático] Esperava-se um número ou '(' em: " ++ show tokens)
