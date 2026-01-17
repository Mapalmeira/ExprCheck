module ParserTests where

import UnitTest
import Lexer.Lexer
import Parser.Parser
import Parser.AST

-- Dense tests
parseString :: String -> Either String Ast
parseString input =
  case lexer input of
    Left err -> Left (show err)
    Right tokens ->
      case parse tokens of
        Left err  -> Left (show err)
        Right ast -> Right ast

testPrecedence :: Test
testPrecedence =
  let input = "1 + 2 * 3"
      expected = Right (Binary Plus (IntVal 1) (Binary Star (IntVal 2) (IntVal 3)))
  in assertEquals
       ("Parser aceita entrada válida: " ++ input ++ " com saída verificada")
       expected
       (parseString input)

testParen :: Test
testParen =
  let input = "(1 + 2) * 3"
      expected = Right (Binary Star (Binary Plus (IntVal 1) (IntVal 2)) (IntVal 3))
  in assertEquals
       ("Parser aceita entrada válida: " ++ input ++ " com saída verificada")
       expected
       (parseString input)

testPow :: Test
testPow =
  let input = "4 * 2 ^ 3"
      expected = Right (Binary Star (IntVal 4) (Binary Caret (IntVal 2) (IntVal 3)))
  in assertEquals
       ("Parser aceita entrada válida: " ++ input ++ " com saída verificada")
       expected
       (parseString input)

-- Quick tests
otherValidInputs =
  [ "5"
  , "+5"
  , "5+3"
  , "5.3 + 2"
  , "5.3^2"
  , "+5.3^2"
  , "5^(5+3+2)"
  , "5-(5+(5-(5)))"
  , "(5+3) * (5-3)"
  , "5*(5-3)"
  , "((((5))))"
  , "+(+(+(5)))"
  , "5^(5+3+2)"
  , "5 ++ 5"
  ,"0"
  , "-5"
  , "-(5)"
  , "3-2-1"
  , "8/4/2"
  , "2^3^2"
  , "(2^3)^2"
  , "4*(3+2^2)"
  , "6/3+1"
  , "6/(3+1)"
  , "1+2+3+4"
  , "1*(2+(3*(4+5)))"
  , "10-3*2"
  , "(10-3)*2"
  , "5/2.5"
  , "2.5*4"
  , "-2.5^2"
  , "+(3-1)*2"
  , "((2+3)*5)^2"
  ]

otherInvalidInputs =
  [ "()"
  , "--5"
  , "5+-+-+-+-+-5"
  , "( 5 * 2"
  , "+"
  , "-"
  , "^"
  , "*5"
  , "/2"
  , "5/"
  , "5+"
  , "5**2"
  , "5//2"
  , "5^^2"
  , "(5+3))"
  , "((5+3)"
  , "5+(+)"
  , "(*)"
  , "2^(^3)"
  , "3+*4"
  , "3/^2"
  , "5(3+2)"
  , "(5)3"
  , "5..2"
  ]

parserSucceeds :: TestName -> Test
parserSucceeds input =
  assertRight
    ("Parser aceita entrada válida: " ++ show input)
    (parseString input)

parserFails :: TestName -> Test
parserFails input =
  assertLeft
    ("Parser rejeita entrada inválida: " ++ show input)
    (parseString input)

-- Test suite
data ParserTests = ParserTests

instance TestSuite ParserTests where
  tests _ =
    [ testPrecedence
    , testParen
    , testPow
    ]
    ++ map parserSucceeds otherValidInputs
    ++ map parserFails otherInvalidInputs