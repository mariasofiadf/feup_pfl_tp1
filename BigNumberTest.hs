import BigNumber
import Test.HUnit

testScanner1= TestCase (assertEqual "scanner 5" (BigNumber Pos [5]) (scanner "5"))
testScanner2 = TestCase (assertEqual "scanner 0" (BigNumber Pos [0]) (scanner "0"))
testScanner3 = TestCase (assertEqual "scanner 0" (BigNumber Neg [0]) (scanner "-0"))
testScanner4 = TestCase (assertEqual "scanner -125" (BigNumber Neg [1,2,5]) (scanner "-125"))
testScanner5 = TestCase (assertEqual "scanner 567" (BigNumber Pos [5,6,7]) (scanner "567"))
testScanner6 = TestCase (assertEqual "scanner -123456789" (BigNumber Neg [1,2,3,4,5,6,7,8,9]) (scanner "-123456789"))

testsScanner = TestList [testScanner1, testScanner2, testScanner3, testScanner4, testScanner5, testScanner6]

testOutput1= TestCase (assertEqual "output 5" "5" (output (BigNumber Pos [5])))
testOutput2 = TestCase (assertEqual "output 0" "0" (output (BigNumber Pos [0])))
testOutput3 = TestCase (assertEqual "output 0" "0" (output (BigNumber Neg [0])))
testOutput4 = TestCase (assertEqual "output -125" "-125" (output (BigNumber Neg [1,2,5])))
testOutput5 = TestCase (assertEqual "output 567" "567"  (output (BigNumber Pos [5,6,7])))
testOutput6 = TestCase (assertEqual "output -123456789" "-123456789" (output (BigNumber Neg [1,2,3,4,5,6,7,8,9])))

testsOutput= TestList [ testOutput1, testOutput2, testOutput3, testOutput4, testOutput5, testOutput6]

allTests = TestList [testsScanner, testsOutput]

runAllTests :: IO Counts
runAllTests = runTestTT allTests