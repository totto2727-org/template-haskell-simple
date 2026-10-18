module Main (main) where

import Project (greet)
import Test.Hspec (describe, hspec, it, shouldBe)

main :: IO ()
main = hspec $
    describe "greet" $ do
        it "produces the starter command's greeting" $
            greet "world" `shouldBe` "Hello, world!"
        it "uses the supplied name" $
            greet "Haskell" `shouldBe` "Hello, Haskell!"
