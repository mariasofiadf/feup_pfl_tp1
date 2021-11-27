import BigNumber
import Test.HUnit

testScanner1= TestCase (assertEqual "scanner 5" (BigNumber Pos [5]) (scanner "5"))
testScanner2 = TestCase (assertEqual "scanner 0" (BigNumber Pos [0]) (scanner "0"))
testScanner3 = TestCase (assertEqual "scanner 0" (BigNumber Neg [0]) (scanner "-0"))
testScanner4 = TestCase (assertEqual "scanner -125" (BigNumber Neg [1,2,5]) (scanner "-125"))
testScanner5 = TestCase (assertEqual "scanner 567" (BigNumber Pos [5,6,7]) (scanner "567"))
testScanner6 = TestCase (assertEqual "scanner 567" (BigNumber Neg [1,2,3,4,5,6,7,8,9]) (scanner "-123456789"))

testsScanner = TestList [TestLabel "test1" testScanner1, TestLabel "test2" testScanner2, TestLabel "test3" testScanner3,TestLabel "test4" testScanner4,TestLabel "test5" testScanner5,TestLabel "test6" testScanner6]

testOutput1= TestCase (assertEqual "output 5" "5" (output (BigNumber Pos [5])))
testOutput2 = TestCase (assertEqual "output 0" "0" (output (BigNumber Pos [0])))
testOutput3 = TestCase (assertEqual "output 0" "0" (output (BigNumber Neg [0])))
testOutput4 = TestCase (assertEqual "output -125" "-125" (output (BigNumber Neg [1,2,5])))
testOutput5 = TestCase (assertEqual "output 567" "567"  (output (BigNumber Pos [5,6,7])))
testOutput6 = TestCase (assertEqual "output 567" "-123456789" (output (BigNumber Neg [1,2,3,4,5,6,7,8,9])))

testsOutput= TestList [TestLabel "test1" testOutput1, TestLabel "test2" testOutput2, TestLabel "test3" testOutput3,TestLabel "test4" testOutput4,TestLabel "test5" testOutput5,TestLabel "test6" testOutput6]
