module Main (main) where

import Control.Monad (unless)
import Project (greet)
import System.Exit (die)

main :: IO ()
main = do
    unless (greet "world" == "Hello, world!") $
        die "greet must produce the starter command's greeting"
    unless (greet "Haskell" == "Hello, Haskell!") $
        die "greet must use the supplied name"
