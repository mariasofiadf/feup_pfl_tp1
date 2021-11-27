module BigNumber (BigNumber(..), Sign(..), scanner, output, somaBN, subBN) where
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
import Data.Char
import Text.Html (yellow)

data BigNumber = BigNumber Sign [Int] deriving Show


data Sign = Pos | Neg deriving (Show,Eq)


scanner:: String -> BigNumber
scanner "" = error"Invalid input in function scanner"
scanner ['0'] = BigNumber (charToSign '0') (stringToList "0")
scanner ('0':xs) = scanner xs
scanner (x:xs) = BigNumber (charToSign x) (stringToList (x:xs))



--for scanner
charToSign :: Char -> Sign
charToSign s    | s == '-' = Neg
                | isDigit s  = Pos
                | otherwise = error"Invalid input in function charToSign"

--for scanner
stringToList :: String -> [Int]
stringToList "" = []
stringToList [x]    | isDigit x = [digitToInt x]
                    | x == '-' = []
                    | otherwise = error"Invalid Input in function stringToList"
stringToList (x:xs) =  stringToList [x] ++ stringToList xs


output :: BigNumber -> String
output (BigNumber sign list) = signToString sign ++ listToString list

signToString :: Sign -> String
signToString s  | s == Pos = ""
                | s == Neg = "-"
                | otherwise = error"error";

listToString :: [Int] -> String
listToString = foldr (\ x -> (++) [intToDigit x]) ""

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

--igual
biggerAbsList:: [Int] -> [Int] -> Bool
biggerAbsList [][] = False
biggerAbsList (x:xs) (y:ys) | length (removeLzero(x:xs)) > length (removeLzero(y:ys)) = True
                            | length (x:xs)  < length (y:ys) = False
                            | otherwise = if x /= y then x > y
                                        else biggerAbsList xs ys

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN (BigNumber Pos list1) (BigNumber Pos list2) = BigNumber Pos (reverse (sumLists (reverse list1) (reverse list2)))
somaBN (BigNumber Neg list1) (BigNumber Neg list2) = BigNumber Neg (reverse (sumLists (reverse list1) (reverse list2)))
somaBN (BigNumber Pos list1) (BigNumber Neg list2)  | biggerAbsList  list1 list2 = BigNumber Pos (reverse (subLists (reverse list1) (reverse list2)))
                                                    | otherwise = BigNumber Neg (reverse (subLists (reverse list2) (reverse list1)))
somaBN (BigNumber Neg list1) (BigNumber Pos list2)  | biggerAbsList  list1 list2 = BigNumber Neg (reverse (subLists (reverse list1) (reverse list2)))
                                                    | otherwise = BigNumber Pos (reverse (subLists (reverse list2) (reverse list1)))

--longest list comes first
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


divList::[Int] -> [Int] -> Int -> [Int]
divList l1 [0] n = []
divList [] l2 n = []
divList l1 l2 n | biggerAbsList l2 l1 = []
                | (quo >= 1 || n /= 0) && (length conc > 1)  = quo : divList nextDiv l2 (n+1)
                | otherwise  = quo1 : divList nextDiv1 l2 (n+1)
                        where div = removeLzero(take (length l2) l1)
                              div1 = removeLzero(take (length l2 + 1) l1)
                              quo = divSmallList div l2 1
                              quo1 = divSmallList div1 l2 1
                              nextDiv =  removeLzero(reverse (subLists (reverse div) ( mulList (reverse l2) [quo])) ++ drop (length l2) l1)
                              nextDiv1 =  removeLzero(reverse (subLists (reverse div1) ( mulList (reverse l2) [quo1])) ++ drop (length l2 +1) l1)
                              conc = drop (length l2) l1



l11:: [Int]
l11 = [4,2,4,8]

l22:: [Int]                        
l22 = [2,5]

l111:: [Int]
l111 = [1,0,0]


l3:: [Int]
l3 = [3,7,5,0,0]

l4:: [Int]                        
l4 = [1,0]

--subList::[Int] -> [Int] -> [Int]
--subList (x:xs) (y:ys) = []

--