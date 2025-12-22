module Main where

import Lexer.Lexer

main :: IO ()
main = print (lexAll "5+4")
