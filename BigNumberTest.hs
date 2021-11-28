module BigNumberTests (allBNTests) where 
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

testSomaBN1= TestCase (assertEqual "somaBN 5 23" (scanner"28") (somaBN (scanner"5")(scanner"23")))
testSomaBN2= TestCase (assertEqual "somaBN 0 0" (scanner"0") (somaBN (scanner"0")(scanner"0")))
testSomaBN3= TestCase (assertEqual "somaBN -35 23" (scanner"-12") (somaBN (scanner"-35")(scanner"23")))
testSomaBN4= TestCase (assertEqual "somaBN -5 -23" (scanner"-28") (somaBN (scanner"-5")(scanner"-23")))
testSomaBN5= TestCase (assertEqual "somaBN -5 0" (scanner"-5") (somaBN (scanner"-5")(scanner"0")))

testsSoma = TestList [testSomaBN1,testSomaBN2,testSomaBN3,testSomaBN4,testSomaBN5]

testSubBN1= TestCase (assertEqual "subBN 5 23" (scanner"-18") (subBN (scanner"5")(scanner"23")))
testSubBN2= TestCase (assertEqual "subBN 0 0" (scanner"-0") (subBN (scanner"0")(scanner"0")))
testSubBN3= TestCase (assertEqual "subBN -35 23" (scanner"-58") (subBN (scanner"-35")(scanner"23")))
testSubBN4= TestCase (assertEqual "subBN -5 -23" (scanner"18") (subBN (scanner"-5")(scanner"-23")))
testSubBN5= TestCase (assertEqual "subBN -5 0" (scanner"-5") (subBN (scanner"-5")(scanner"0")))

testsSub = TestList [testSubBN1,testSubBN2,testSubBN3,testSubBN4,testSubBN5]

allBNTests = TestList [testsScanner, testsOutput, testsSoma, testsSub]

runAllTests :: IO Counts
runAllTests = runTestTT allBNTests