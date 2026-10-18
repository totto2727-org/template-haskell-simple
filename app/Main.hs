module Main (main) where

import Project (greet)

main :: IO ()
main = putStrLn (greet "world")
