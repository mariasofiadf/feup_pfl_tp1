import Fib
import Test.HUnit
import GHC.IO.Exception (assertError)

testfibRec1 = TestCase (assertEqual "fibRec 5" 5 (fibRec 5))
testfibRec2 = TestCase (assertEqual "fibRec 10" 55 (fibRec 10))
testfibRec3 = TestCase (assertEqual "fibRec 0" 0 (fibRec 0))
testfibRec4 = TestCase (assertEqual "fibRec 1" 1 (fibRec 1))

testsFibRec = TestList [TestLabel "test1" testfibRec1, TestLabel "test2" testfibRec2, TestLabel "test3" testfibRec3,TestLabel "test4" testfibRec4]
--runTestTT testsFibRec

testfibLista1 = TestCase (assertEqual "fibLista 5" 5 (fibLista 5))
testfibLista2 = TestCase (assertEqual "fibLista 10" 55 (fibLista 10))
testfibLista3 = TestCase (assertEqual "fibLista 0" 0 (fibLista 0))
testfibLista4 = TestCase (assertEqual "fibLista 1" 1 (fibLista 1))

testsFibLista = TestList [TestLabel "test1" testfibLista1, TestLabel "test2" testfibLista2, TestLabel "test3" testfibLista3,TestLabel "test4" testfibLista4]

testfibListaInfinita1 = TestCase (assertEqual "fibListaInfinita 5" 5 (fibListaInfinita 5))
testfibListaInfinita2 = TestCase (assertEqual "fibListaInfinita 10" 55 (fibListaInfinita 10))
testfibListaInfinita3 = TestCase (assertEqual "fibListaInfinita 0" 0 (fibListaInfinita 0))
testfibListaInfinita4 = TestCase (assertEqual "fibListaInfinita 1" 1 (fibListaInfinita 1))

testsFibListaInfinita = TestList [TestLabel "test1" testfibListaInfinita1, TestLabel "test2" testfibListaInfinita2, TestLabel "test3" testfibListaInfinita3,TestLabel "test4" testfibListaInfinita4]

testsFib = TestList [TestLabel "testsFibRec" testsFibRec, TestLabel "testsFibLista" testsFibLista, TestLabel "testsFibListaInf" testsFibListaInfinita]