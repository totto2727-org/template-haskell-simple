module ProjectSpec (spec) where

import Project (greet)
import Test.Hspec (Spec, describe, it, shouldBe)

spec :: Spec
spec = describe "greet" $ do
    it "produces the starter command's greeting" $
        greet "world" `shouldBe` "Hello, world!"
    it "uses the supplied name" $
        greet "Haskell" `shouldBe` "Hello, Haskell!"
