module LexerTests where

import UnitTest
import Lexer.Lexer

validInputs :: [String]
validInputs =
  [ ""
  , "0"
  , "42"
  , "3.14"
  , "0.001"
  , "1+2"
  , "1 + 2"
  , "1-2"
  , "1 * 2"
  , "1/2"
  , "2^3"
  , "2^3^4"
  , "(1)"
  , "((1))"
  , "(1 + 2)"
  , "(1 + 2) * 3"
  , "1 + (2 * 3)"
  , "(1 + 2 * 3"
  , "1 + 2)"
  , "()"
  , "( )"
  , "((()))"
  , "1 + -2"
  , "-1 + 2"
  , "+1"
  , "+1.5"
  , "-3.5"
  , "1+-2"
  , "1--2"
  , "1++2"
  , "1**2"
  , "1//2"
  , "1^^2"
  , "  1   +    2  "
  ]

invalidInputs :: [String]
invalidInputs =
  [ "."
  , ".."
  , "..."
  , ".1"
  , "1."
  , "1.."
  , "1.2.3"
  , "00.1.2"
  , "1 + a"
  , "a + 1"
  , "1 + A"
  , "x"
  , "@"
  , "#"
  , "$"
  , "%"
  , "&"
  , "!"
  , "?"
  , "1 + @"
  , "2 & 3"
  , "4 | 5"
  , "6 ~ 7"
  , "8 = 9"
  , "10 , 11"
  , "12 ; 13"
  , "14 : 15"
  , "16 _ 17"
  , "18 ` 19"
  ]

lexerSucceeds :: TestName -> Test
lexerSucceeds input =
  assertRight
    ("Lexer aceita entrada válida: " ++ show input)
    (lexer input)

lexerFails :: TestName -> Test
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