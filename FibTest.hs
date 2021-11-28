module FibTests (allFibTests) where
import Fib
import BigNumber
import Test.HUnit
import GHC.IO.Exception (assertError)

testfibRec1 = TestCase (assertEqual "fibRec 5" 5 (fibRec 5))
testfibRec2 = TestCase (assertEqual "fibRec 10" 55 (fibRec 10))
testfibRec3 = TestCase (assertEqual "fibRec 0" 0 (fibRec 0))
testfibRec4 = TestCase (assertEqual "fibRec 1" 1 (fibRec 1))

testsFibRec = TestList [testfibRec1, testfibRec2, testfibRec3, testfibRec4]
--runTestTT testsFibRec

testfibLista1 = TestCase (assertEqual "fibLista 5" 5 (fibLista 5))
testfibLista2 = TestCase (assertEqual "fibLista 10" 55 (fibLista 10))
testfibLista3 = TestCase (assertEqual "fibLista 0" 0 (fibLista 0))
testfibLista4 = TestCase (assertEqual "fibLista 1" 1 (fibLista 1))

testsFibLista = TestList [testfibLista1, testfibLista2, testfibLista3, testfibLista4]

testfibListaInfinita1 = TestCase (assertEqual "fibListaInfinita 5" 5 (fibListaInfinita 5))
testfibListaInfinita2 = TestCase (assertEqual "fibListaInfinita 10" 55 (fibListaInfinita 10))
testfibListaInfinita3 = TestCase (assertEqual "fibListaInfinita 0" 0 (fibListaInfinita 0))
testfibListaInfinita4 = TestCase (assertEqual "fibListaInfinita 1" 1 (fibListaInfinita 1))

testsFibListaInfinita = TestList [testfibListaInfinita1,testfibListaInfinita2, testfibListaInfinita3, testfibListaInfinita4]

testsFib = TestList [testsFibRec,testsFibLista,testsFibListaInfinita]


testfibRecBN1 = TestCase (assertEqual "fibRecBN 5" (scanner"5") (fibRecBN (scanner"5")))
testfibRecBN2 = TestCase (assertEqual "fibRecBN 10" (scanner"55") (fibRecBN (scanner"10")))
testfibRecBN3 = TestCase (assertEqual "fibRecBN 0" (scanner"0") (fibRecBN (scanner"0")))
testfibRecBN4 = TestCase (assertEqual "fibRecBN 1" (scanner"1") (fibRecBN (scanner"1")))


testsFibRecBN = TestList [testfibRecBN1, testfibRecBN2, testfibRecBN3, testfibRecBN4]

testfibListaBN1 = TestCase (assertEqual "fibListaBN 5" (scanner"5") (fibListaBN (scanner"5")))
testfibListaBN2 = TestCase (assertEqual "fibListaBN 10" (scanner"55") (fibListaBN (scanner"10")))
testfibListaBN3 = TestCase (assertEqual "fibListaBN 0" (scanner"0") (fibListaBN (scanner"0")))
testfibListaBN4 = TestCase (assertEqual "fibListaBN 1" (scanner"1") (fibListaBN (scanner"1")))

testsFibListaBN = TestList [testfibListaBN1, testfibListaBN2, testfibListaBN3, testfibListaBN4]

testfibListaInfinitaBN1 = TestCase (assertEqual "fibListaInfinitaBN 5" (scanner"5") (fibListaInfinitaBN (scanner"5")))
testfibListaInfinitaBN2 = TestCase (assertEqual "fibListaInfinitaBN 10" (scanner"55") (fibListaInfinitaBN (scanner"10")))
testfibListaInfinitaBN3 = TestCase (assertEqual "fibListaInfinitaBN 0" (scanner"0") (fibListaInfinitaBN (scanner"0")))
testfibListaInfinitaBN4 = TestCase (assertEqual "fibListaInfinitaBN 1" (scanner"1") (fibListaInfinitaBN (scanner"1")))

testsFibListaInfinitaBN = TestList [testfibListaInfinitaBN1, testfibListaInfinitaBN2, testfibListaInfinitaBN3, testfibListaInfinitaBN4]

testsFibBN = TestList [testsFibRecBN,testsFibListaBN,testsFibListaInfinitaBN]

allFibTests = TestList [testsFib, testsFibBN]

runAllTests :: IO Counts
runAllTests = runTestTT allFibTests