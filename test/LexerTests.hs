module LexerTests where

import UnitTest
import Lexer.Lexer

validInputs :: [String]
validInputs =
  [ "3.45 + 10"
  , "1+2"
  , "(1 + 2) * 3"
  , "10 / (5 - 3)"
  , "2^3 + 4"
  , "123"
  , "0.5 + 0.25"
  , "((1))"
  , "(1 + 2" -- parser problem
  ]

invalidInputs :: [String]
invalidInputs =
  [ "1 + 2.3.4"
  , "3."
  , ".5"
  , "2 + a"
  , "5 + @"
  , "1..2"
  ]

lexerSucceeds :: String -> Test
lexerSucceeds input =
  assertRight
    ("Lexer aceita entrada válida: " ++ show input)
    (lexer input)

lexerFails :: String -> Test
lexerFails input =
  assertLeft
    ("Lexer rejeita entrada inválida: " ++ show input)
    (lexer input)

data LexerTests = LexerTests
instance TestSuite LexerTests where
  tests _ =
    map lexerSucceeds validInputs
    ++
    map lexerFails invalidInputs