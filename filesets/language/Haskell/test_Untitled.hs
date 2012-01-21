module Test_Untitled where

import Test.HUnit
import Untitled

answer_test = TestCase (assertEqual "Testing answer" (6 * 9) answer)

tests = TestList [answer_test]
main = do runTestTT tests
