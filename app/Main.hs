module Main where

import Data.Char (toUpper)
import Lexer.Lexer
import System.IO (hFlush, stdout)

main :: IO ()
main = do
  putStrLn "\n========================================================"
  putStrLn "=== Bem-vindo ao validador de expressões matemáticas ==="
  putStrLn "========================================================\n"
  mainLoop

mainLoop :: IO ()
mainLoop = do
  expr <- prompt "Digite a expressão a validar: "
  putStrLn "\nSelecione o nível de verificação:"
  putStrLn "A) Léxico"
  putStrLn "B) Sintático"
  level <- prompt "Escolha (A/B): "

  case map toUpper level of
    "A" -> validateLexer expr
    "B" -> putStrLn "\nAnalisador sintático em construção.\n"
    _   -> putStrLn "\nOpção inválida."

  cont <- prompt "\nDeseja validar outra expressão? (Y/N): "
  if map toUpper cont == "Y" then mainLoop else putStrLn "\nAté logo!"

validateLexer :: String -> IO ()
validateLexer expr = do
  putStrLn "\n[Etapa - Validação Léxica]"
  case lexer expr of
    Left err     -> putStrLn $ show err
    Right tokens -> do
      putStrLn "A expressão é lexicamente válida. Tokens gerados:\n"
      putStrLn $ show tokens

prompt :: String -> IO String
prompt msg = do
  putStr msg
  hFlush stdout
  getLine