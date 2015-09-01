module Test_Hiker where

import Test.HUnit
import Hiker

life_the_universe_and_everything_test = TestCase (assertEqual "answer" (42) answer)

tests = TestList [life_the_universe_and_everything_test]
main = do runTestTT tests
