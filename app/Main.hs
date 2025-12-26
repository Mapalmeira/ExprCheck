module Main where

import Lexer.Lexer

testCases :: [String]
testCases =
  [ "3.45 + 10"
  , "1+2"
  , "(1 + 2) * 3"
  , "10 / (5 - 3)"
  , "2^3 + 4"
  , "123"
  , "0.5 + 0.25"
  , "((1))"
  -- inválidos
  , "1 + 2.3.4"
  , "3."
  , ".5"
  , "2 + a"
  , "5 + @"
  , "1..2"
  , "(1 + 2"
  ]

runTest :: String -> IO ()
runTest input = do
  putStrLn $ "\nEntrada: " ++ show input
  case lexer input of
    Left err     -> putStrLn $ "Erro: " ++ err
    Right tokens -> putStrLn $ "Tokens: " ++ show tokens

main :: IO ()
main = mapM_ runTest testCases
