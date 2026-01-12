module ParserTests where

import UnitTest
import Lexer.Lexer
import Parser.Parser
import Parser.AST

parseString :: String -> Either String Exp
parseString input =
  case lexer input of
    Left err -> Left (show err)
    Right tokens -> parse tokens

testPrecedencia :: Test
testPrecedencia =
  let input = "1 + 2 * 3"
      expected = Right (Binary Plus (IntVal 1) (Binary Star (IntVal 2) (IntVal 3)))
  in assertEquals input expected (parseString input)

testParenteses :: Test
testParenteses =
  let input = "(1 + 2) * 3"
      expected = Right (Binary Star (Binary Plus (IntVal 1) (IntVal 2)) (IntVal 3))
  in assertEquals input expected (parseString input)

testPotencia :: Test
testPotencia =
  let input = "4 * 2 ^ 3"
      expected = Right (Binary Star (IntVal 4) (Binary Caret (IntVal 2) (IntVal 3)))
  in assertEquals input expected (parseString input)

testErroSintatico :: Test
testErroSintatico =
  let input = "( 5 * 2"
  in assertLeft input (parseString input)

testBugConhecido :: Test
testBugConhecido =
  let input = "5 ++ 5"
  in assertRight input (parseString input)

data ParserTests = ParserTests

instance TestSuite ParserTests where
  tests _ =
    [ testPrecedencia
    , testParenteses
    , testPotencia
    , testErroSintatico
    , testBugConhecido
    ]