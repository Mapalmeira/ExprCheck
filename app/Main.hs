module Main where

import Data.Char (toUpper)
import System.IO (hFlush, stdout)

import Lexer.Lexer
import Lexer.Token
import Parser.Parser
import Parser.AST

main :: IO ()
main = do
  printHeader
  loop

loop :: IO ()
loop = do
  expr <- prompt "\nDigite a expressão a validar: "

  putStrLn "\nSelecione o nível de verificação:"
  putStrLn "A) Léxico"
  putStrLn "B) Sintático"
  choice <- prompt "Escolha (A/B): "

  case map toUpper choice of
    "A" -> runLexical expr
    "B" -> runSyntactic expr
    _   -> putStrLn "\nOpção inválida."

  again <- prompt "\nDeseja validar outra expressão? (Y/N): "
  case map toUpper again of
    "Y" -> loop
    _   -> putStrLn "\nAté logo!"

runLexical :: String -> IO ()
runLexical expr =
  case lexer expr of
    Left err -> printLexicalError err
    Right tokens -> do
      putStrLn "\n[Validação Léxica]"
      putStrLn "  - Tokens"
      printTokensTree "    " tokens

runSyntactic :: String -> IO ()
runSyntactic expr =
  case lexer expr of
    Left err -> printLexicalError err
    Right tokens -> do
      putStrLn "\n[Validação Léxica]"
      putStrLn "  - Tokens"
      printTokensTree "    " tokens

      putStrLn "\n[Validação Sintática]"
      case parse tokens of
        Left err -> do
          putStrLn "  - Erro Sintático"
          putStrLn $ "    " ++ err
        Right ast -> do
          putStrLn "  - AST"
          printAST "    " ast

printLexicalError :: LexerError -> IO ()
printLexicalError err = do
  putStrLn "\n[Validação Léxica]"
  putStrLn "  - Erro Léxico"
  putStrLn $ "    " ++ show err

printTokensTree :: String -> [Token] -> IO ()
printTokensTree prefix tokens =
  mapM_ printOne (zip tokens [1..])
  where
    lastIndex = length tokens
    printOne (tok, i)
      | i == lastIndex = putStrLn $ prefix ++ "└── " ++ show tok
      | otherwise     = putStrLn $ prefix ++ "├── " ++ show tok

printAST :: String -> Exp -> IO ()
printAST prefix =
  printAST' prefix True

printAST' :: String -> Bool -> Exp -> IO ()
printAST' prefix isLast expr = do
  putStrLn $ prefix ++ branch ++ label
  case expr of
    Binary _ l r -> do
      let newPrefix = prefix ++ indent
      printAST' newPrefix False l
      printAST' newPrefix True  r

    UnaryNeg e -> do
      let newPrefix = prefix ++ indent
      printAST' newPrefix True e

    UnaryPos e -> do
      let newPrefix = prefix ++ indent
      printAST' newPrefix True e

    _ -> pure ()
  where
    branch = if isLast then "└── " else "├── "
    indent = if isLast then "    " else "│   "

    label =
      case expr of
        IntVal n      -> "IntVal " ++ show n
        RealVal r     -> "RealVal " ++ show r
        UnaryNeg _    -> "UnaryNeg"
        UnaryPos _    -> "UnaryPos"
        Binary op _ _ -> "Binary " ++ show op

printHeader :: IO ()
printHeader = do
  putStrLn "\n========================================================"
  putStrLn "=== Bem-vindo ao validador de expressões matemáticas ==="
  putStrLn "========================================================"

prompt :: String -> IO String
prompt msg = do
  putStr msg
  hFlush stdout
  getLine