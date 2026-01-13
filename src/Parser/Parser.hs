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
        -- Consumiu todos os tokens possíveis e sobrou apenas o TokEOF
        Right (ast, [TokEOF])  -> Right ast
        -- Consumiu todos os tokens possíveis e sobrou mais do que so ó o TokEOF
        Right (_, extraTokens) -> Left ("[Erro sintático] Tokens extras encontrados: " ++ show extraTokens)
        Left err               -> Left err

-- Soma e subtração
parseSum :: [Token] -> ParseResult
parseSum tokens =
    case parseMul tokens of
        Left err          -> Left err
        Right (ast, rest) -> sumBuilder ast rest

sumBuilder :: Exp -> [Token] -> ParseResult
-- Caso seja uma soma
sumBuilder ast (TokPlus : rest) =
    -- Processa o lado direito da soma
    case parseMul rest of
        Left err                  -> Left err
        -- Adiciona a soma encontrada à AST antes da chamada recursiva
        Right (nextAst, nextRest) -> sumBuilder (Binary Plus ast nextAst) nextRest
-- Caso seja uma subtração
sumBuilder ast (TokMinus : rest) =
    -- Processa o lado direito da subtração
    case parseMul rest of
        Left err                  -> Left err
        -- Adiciona a subtração encontrada à AST antes da chamada recursiva
        Right (nextAst, nextRest) -> sumBuilder (Binary Minus ast nextAst) nextRest
-- Caso não seja uma soma nem uma subtração, retorna o que recebeu
sumBuilder ast tokens = Right (ast, tokens)

-- Multiplicação e divisão
parseMul :: [Token] -> ParseResult
parseMul tokens =
    case parsePow tokens of
        Left err          -> Left err
        Right (ast, rest) -> mulBuilder ast rest

mulBuilder :: Exp -> [Token] -> ParseResult
-- Caso seja uma multiplicação
mulBuilder ast (TokStar : rest) =
    -- Processa o lado direito da multiplicação
    case parsePow rest of
        Left err                  -> Left err
        -- Adiciona a multiplicação encontrada à AST antes da chamada recursiva
        Right (nextAst, nextRest) -> mulBuilder (Binary Star ast nextAst) nextRest
-- Caso seja uma divisão
mulBuilder ast (TokSlash : rest) =
    -- Processa o lado direito da divisão
    case parsePow rest of
        Left err                  -> Left err
        -- Adiciona a divisão encontrada à AST antes da chamada recursiva
        Right (nextAst, nextRest) -> mulBuilder (Binary Slash ast nextAst) nextRest
-- Caso não seja uma multiplicação nem uma divisão, retorna o que recebeu
mulBuilder ast tokens = Right (ast, tokens)

-- Potenciação
parsePow :: [Token] -> ParseResult
parsePow tokens =
    case parseUnary tokens of
        Left err          -> Left err
        Right (ast, rest) -> powBuilder ast rest

powBuilder :: Exp -> [Token] -> ParseResult
-- Caso seja uma potenciação
powBuilder ast (TokCaret : rest) =
    -- Processa o lado direito (expoente) da potenciação recursivamente
    case parsePow rest of
        Left err                  -> Left err
        -- Adiciona a potência encontrada à AST depois da chamada recursiva
        Right (nextAst, nextRest) -> Right (Binary Caret ast nextAst, nextRest)
-- Caso não seja uma potenciação, retorna o que recebeu
powBuilder ast tokens = Right (ast, tokens)

-- Unários
parseUnary :: [Token] -> ParseResult
-- Caso seja um unário negativo
parseUnary (TokMinus : rest) =
    -- Processa o primário que deve vir em seguida
    case parsePrimary rest of
        Left err -> Left err
        Right (ast, nextRest) -> Right (UnaryNeg ast, nextRest)
-- Caso seja um unário positivo
parseUnary (TokPlus : rest) =
    -- Processa o primário que deve vir em seguida
    case parsePrimary rest of
        Left err -> Left err
        Right (ast, nextRest) -> Right (UnaryPos ast, nextRest)
-- Caso não seja um unário, processa o primário que deve vir no lugar do sinal do unário
parseUnary tokens = parsePrimary tokens

-- Número e parênteses
parsePrimary :: [Token] -> ParseResult
-- Caso seja um número inteiro
parsePrimary (TokInt n : rest) = Right (IntVal n, rest)
-- Caso seja um número real
parsePrimary (TokReal n : rest) = Right (RealVal n, rest)
-- Caso seja um '('
parsePrimary (TokLParen : rest) =
    -- Processa a expressão após o '('
    case parseSum rest of
        Left err                          -> Left err
        -- Caso o resto dos tokens após a expressão inicie com ')'
        Right (ast, TokRParen : nextRest) -> Right (ast, nextRest)
        -- Caso o resto dos tokens não inicie com o ')' esperado
        Right (_, nextRest)               -> Left ("[Erro sintático] Esperava-se um ')' em: " ++ show nextRest) 
-- Caso não encontre um primário
parsePrimary tokens = Left ("[Erro sintático] Esperava-se um '(' ou número em: " ++ show tokens)
