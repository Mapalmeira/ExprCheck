module ParserTests where

import UnitTest
import Lexer.Lexer
import Parser.Parser
import Parser.AST

-- Dense tests
parseString :: String -> Either String Exp
parseString input =
  case lexer input of
    Left err -> Left (show err)
    Right tokens -> parse tokens

testPrecedence :: Test
testPrecedence =
  let input = "1 + 2 * 3"
      expected = Right (Binary Plus (IntVal 1) (Binary Star (IntVal 2) (IntVal 3)))
  in assertEquals input expected (parseString input)

testParen :: Test
testParen =
  let input = "(1 + 2) * 3"
      expected = Right (Binary Star (Binary Plus (IntVal 1) (IntVal 2)) (IntVal 3))
  in assertEquals input expected (parseString input)

testPow :: Test
testPow =
  let input = "4 * 2 ^ 3"
      expected = Right (Binary Star (IntVal 4) (Binary Caret (IntVal 2) (IntVal 3)))
  in assertEquals input expected (parseString input)

testSyntaxError :: Test
testSyntaxError =
  let input = "( 5 * 2"
  in assertLeft input (parseString input)

testMultipleSign :: Test
testMultipleSign =
  let input = "5 ++ 5"
  in assertRight input (parseString input)


-- Quick tests
otherValidInputs = 
  [ "5"
  ,  "+5"
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
  ]

otherInvalidInputs = 
  [ "()"
  , "5+-+-+-+-+-5"
  ]

parserSucceeds :: String -> Test
parserSucceeds input =
  assertRight
    ("Parser aceita entrada válida: " ++ show input)
    (parseString input)

parserFails :: String -> Test
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
    , testSyntaxError
    , testMultipleSign
    ]
    ++
    map parserSucceeds otherValidInputs
    ++
    map parserFails otherInvalidInputs