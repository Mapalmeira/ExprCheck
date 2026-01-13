module Main where

import UnitTest
import LexerTests
import ParserTests

main :: IO ()
main = do
  runSuite LexerTests
  runSuite ParserTests