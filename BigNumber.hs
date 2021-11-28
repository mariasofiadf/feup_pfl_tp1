module BigNumber (BigNumber(..), Sign(..), scanner, output, somaBN, subBN) where
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-deferred-out-of-scope-variables #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
import Data.Char
import Text.Html (yellow)

data BigNumber = BigNumber Sign [Int] deriving (Show,Eq)

data Sign = Pos | Neg deriving (Show,Eq)

--Transforma uma string em BigNumber utilizando as funções auxiliares charToSign e stringToList
scanner:: String -> BigNumber
scanner "" = error"Invalid input in function scanner"
scanner ['0'] = BigNumber (charToSign '0') (stringToList "0")
scanner ('0':xs) = scanner xs
scanner (x:xs) = BigNumber (charToSign x) (stringToList (x:xs))

--Usada no scanner. Transforma um char em Sign
charToSign :: Char -> Sign
charToSign s    | s == '-' = Neg
                | isDigit s  = Pos
                | otherwise = error"Invalid input in function charToSign"

--Usada no scanner. Transforma string de dígitos, com ou sem sinal, numa lista de inteiros (menores que 10)
stringToList :: String -> [Int]
stringToList "" = []
stringToList [x]    | isDigit x = [digitToInt x]
                    | x == '-' = []
                    | otherwise = error"Invalid Input in function stringToList"
stringToList (x:xs) =  stringToList [x] ++ stringToList xs

--Transforma um BigNumber numa String. Para isso chama as funções signToString e listToString e concatena os seus resultados.
output :: BigNumber -> String
output (BigNumber _ [0]) = "0"
output (BigNumber sign list) = signToString sign ++ listToString list

--Transforma Sign em String
signToString :: Sign -> String
signToString s  | s == Pos = ""
                | s == Neg = "-"
                | otherwise = error"signToString error";

--Transforma lista de dígitos numa String de dígitos
listToString :: [Int] -> String
listToString = foldr (\ x -> (++) [intToDigit x]) ""

--Calcula a soma de duas listas que representam números inteiros não negativos.
sumLists :: [Int] -> [Int] -> [Int]
sumLists [] [] = []
sumLists [x] [] | x < 10 = [x]
                | otherwise = [x`mod`10,1]
sumLists [] [y] | y < 10 = [y]
                | otherwise = [y`mod`10,1]
sumLists x [] = x
sumLists [] y = y
sumLists [x] [y]    | sum >= 10 = [sum`mod`10,1]
                    | otherwise = [sum]
                    where sum = x + y
sumLists (x:xs) (y:ys)  | sum >= 10 && (length xs > length ys) = sum`mod`10 : sumLists (head xs + 1 : tail xs) ys
                        | sum >= 10 = sum`mod`10 : sumLists xs (head ys + 1 : tail ys)
                        | otherwise = sum : sumLists xs ys
                        where sum = x + y


removeRzero:: [Int] -> [Int]
removeRzero list = reverse (dropWhile (== 0) (reverse list))

removeLzero:: [Int] -> [Int]
removeLzero =  dropWhile (== 0)

--As listas representa números inteiros não negativos e a função verifica se o primeiro número é maior que o segundo
biggerAbsList:: [Int] -> [Int] -> Bool
biggerAbsList [][] = False
biggerAbsList [] _ = False
biggerAbsList _ [] = False
biggerAbsList (x:xs) (y:ys) | length (x:xs) > length (y:ys) = True

                            | length (x:xs)  < length (y:ys) = False
                            | otherwise = if x /= y then x > y
                                        else biggerAbsList xs ys

--Soma dois BigNumber e chama sumLists ou subLists dependendo dos sinais dos BigNumbers.
somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN (BigNumber Pos list1) (BigNumber Pos list2) = BigNumber Pos (reverse (sumLists (reverse list1) (reverse list2)))
somaBN (BigNumber Neg list1) (BigNumber Neg list2) = BigNumber Neg (reverse (sumLists (reverse list1) (reverse list2)))
somaBN (BigNumber Pos list1) (BigNumber Neg list2)  | biggerAbsList  list1 list2 = BigNumber Pos (reverse (subLists (reverse list1) (reverse list2)))
                                                    | otherwise = BigNumber Neg (reverse (subLists (reverse list2) (reverse list1)))
somaBN (BigNumber Neg list1) (BigNumber Pos list2)  | biggerAbsList  list1 list2 = BigNumber Neg (reverse (subLists (reverse list1) (reverse list2)))
                                                    | otherwise = BigNumber Pos (reverse (subLists (reverse list2) (reverse list1)))


--Calcula a subtração da segunda lista à primeira. 
--As listas representa números inteiros não negativos.
--O número maior vem necessariamente primeiro.
subLists :: [Int] -> [Int] -> [Int]
subLists [] []  = []
subLists [x] [] = [x]
subLists [] [y] = [y]
subLists x []   = x
subLists [] y  = y
subLists [x] [y] = [abs (x-y)]
subLists (x:xs) (y:ys)  | x < y && (length xs > length ys) = sub : subLists (head xs - 1 : tail xs) ys
                        | x < y = sub : subLists xs (head ys + 1 : tail ys)
                        | otherwise = sub : subLists xs ys
                        where sub   | x >= y = x - y
                                    | otherwise = (10+x) - y

--Calcula a subtração do segundo BigNumber ao primeiro. 
--Para isso, transforma a subtração numa soma, alterando o sinal do segundo BigNumber e chama a função somaBN.
subBN :: BigNumber -> BigNumber -> BigNumber
subBN bg (BigNumber sign list)  | sign == Neg = somaBN bg (BigNumber Pos list)
                                | otherwise = somaBN bg (BigNumber Neg list)


-- param: list value overflow -> list
-- value < 10
multLA:: [Int] -> Int -> Int -> [Int]
multLA [] y ov = [ov]
multLA (x:xs) y ov = (mul+ov) `mod` 10 : multLA xs y ((mul + ov) `div` 10)
                where mul = x * y

--list multiplication (lists reversed)
mulList:: [Int] -> [Int] -> [Int]
mulList xs [0] = [0]
mulList [0] ys = [0]
mulList xs [] = []
mulList [] ys = []
mulList xs (y:ys) = removeRzero(sumLists (multLA xs y 0) (0: mulList xs ys))

mulBN:: BigNumber -> BigNumber -> BigNumber
mulBN (BigNumber sign1 list1) (BigNumber sign2 list2) =  BigNumber sign (reverse (mulList (reverse list1) (reverse list2)))
                                                        where sign | sign1 == sign2 = Pos
                                                                   |otherwise = Neg




--Basically subtracting until the divisor is smaller than the dividend
--It's not the fastest way, and will only be used to help in the division
divSmallList:: [Int] -> [Int] -> Int -> Int
divSmallList list1 list2 n | biggerAbsList( reverse(mulList( reverse list2) [n])) list1 = n - 1
                      | otherwise = divSmallList list1 list2 (n+1)


divList::[Int] -> [Int]-> [Int]
divList l1 [0] = []
divList [] l2 = []
divList l1 l2 | biggerAbsList l2 l1 = []
                | quo >= 1  = quo : divList nextDiv l2
                | otherwise  = quo1 : divList nextDiv1 l2
                        where div = removeLzero(take (length l2) l1)
                              div1 = removeLzero(take (length l2 + 1) l1)
                              quo = divSmallList div l2 1
                              quo1 = divSmallList div1 l2 1
                              nextDiv =  removeLzero(reverse (subLists (reverse div) ( mulList (reverse l2) [quo])) ++ drop (length l2) l1)
                              nextDiv1 =  removeLzero(reverse (subLists (reverse div1) ( mulList (reverse l2) [quo1])) ++ drop (length l2 +1) l1)

--BigNumber division
divBN:: BigNumber -> BigNumber -> (BigNumber , BigNumber)
divBN (BigNumber sign1 list1) (BigNumber sign2 list2) =  (BigNumber sign result , BigNumber Pos (removeLzero remainder))
                                                      where result = divList list1 list2
                                                            remainder = reverse (subLists (reverse list1) (mulList (reverse result) (reverse list2)))
                                                            sign | sign1 == sign2 = Pos
                                                                 |otherwise = Neg
--Prevents division by zero
safeDivBN:: BigNumber -> BigNumber -> Maybe (BigNumber, BigNumber)
safeDivBN bn1 (BigNumber sign2 list2)
      | removeLzero list2 /= [] = Just (divBN bn1 (BigNumber sign2 list2)) --divisor not 0, so it uses normal BN division
      |otherwise = Nothing






--Returns true if two lists have the same value
equalList:: [Int] -> [Int] -> Bool
equalList l1 l2 = removeLzero l1 == removeLzero l2

--Basically subtracting until the divisor is smaller than the dividend
--It's not the fastest way, and will only be used to help in the division
divSmallList1:: [Int] -> [Int] -> [Int] -> [Int]
divSmallList1 list1 list2 n  | biggerAbsList( reverse(mulList( reverse list2) n)) list1 = subLists n [1]
                             | otherwise = divSmallList1 list1 list2 (sumLists n [1])



--Param: Dividend Divisor
--Returns the list of squares of the divisor, until it exceeds the dividend
squareList:: [Int] -> [Int] -> [[Int]]
squareList l1 l2| biggerAbsList l2 l1 = []
                 | otherwise = l2 : squareList l1 (reverse (mulList (reverse l2) (reverse l2)))

--Param: Dividend Divisor Quot
--Returns de reminder of the division
calcReminder:: [Int] -> [Int] -> [Int] -> [Int]
calcReminder l1 l2 quo | null (removeLzero(reverse (subLists (reverse l1) (mulList (reverse quo) (reverse l2))))) = [0]
                        |otherwise = removeLzero(reverse (subLists (reverse l1) (mulList (reverse quo) (reverse l2))))

--
divSquare:: [Int] -> [[Int]] -> [([Int],[Int])]
divSquare l1 [] = []
divSquare l1 l2 = (quo, reminder) : divSquare reminder (init l2)
            where quo = reverse(divSmallList1 l1 (last l2) [1])
                  reminder = calcReminder l1 (last l2) quo

one:: [Int]
one = [1]

l5:: [[Int]]
l5 = [[3],[9],[8,1]]

l6:: [Int]
l6 = [1,0,0,0]

l7:: [Int]
l7 = [3]

l8:: [([Int],[Int])]
l8 = [([1,2],[2,8]),([3],[1]),([0],[1])]


--Param: (List of squares) (list of tuples with quotients and reminders) (divisor)
--Returns the final divisor
calcQuo:: [[Int]] -> [([Int],[Int])] -> [Int] -> [Int] -- l5 l8 l7
calcQuo [] [] _= []
calcQuo [] _ _ = []
calcQuo _ [] _ = []
calcQuo (x:xs) (y:ys) d = reverse(sumLists (divSmallList1 (reverse mult) d one) (reverse(calcQuo xs ys d)))
                        where mult = mulList (reverse x) (reverse(fst y))

divList1:: [Int] -> [Int] -> [Int]
divList1 l1 l2 = calcQuo (reverse squares) quoTuple l2 -- 
            where squares = squareList l1 l2 --l5 = l6 l7 
                  quoTuple = divSquare l1 squares --l8 = l6 l5