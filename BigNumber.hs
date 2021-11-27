module BigNumber (BigNumber(..), Sign(..), scanner, output, somaBN, subBN) where
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
import Data.Char
import Text.Html (yellow)

data BigNumber = BigNumber Sign [Int] deriving (Show,Eq)

data Sign = Pos | Neg deriving (Show,Eq)


scanner:: String -> BigNumber
scanner "" = error"Invalid input in function scanner"
scanner ['0'] = BigNumber (charToSign '0') (stringToList "0")
scanner ('0':xs) = scanner xs
scanner (x:xs) = BigNumber (charToSign x) (stringToList (x:xs))

--usada no scanner
charToSign :: Char -> Sign
charToSign s    | s == '-' = Neg
                | isDigit s  = Pos
                | otherwise = error"Invalid input in function charToSign"

--usada no scanner
stringToList :: String -> [Int]
stringToList "" = []
stringToList [x]    | isDigit x = [digitToInt x]
                    | x == '-' = []
                    | otherwise = error"Invalid Input in function stringToList"
stringToList (x:xs) =  stringToList [x] ++ stringToList xs


output :: BigNumber -> String
output (BigNumber _ [0]) = "0"
output (BigNumber sign list) = signToString sign ++ listToString list

signToString :: Sign -> String
signToString s  | s == Pos = ""
                | s == Neg = "-"
                | otherwise = error"signToString error";

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

--igual
biggerAbsList:: [Int] -> [Int] -> Bool
biggerAbsList [][] = False
biggerAbsList [] _ = False
biggerAbsList _ [] = False
biggerAbsList (x:xs) (y:ys) | length (x:xs) > length (y:ys) = True
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

--O número maior vem necessariamente primeiro
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

--list multiplication
mulList:: [Int] -> [Int] -> [Int]
mulList xs [0] = [0]
mulList [0] ys = [0]
mulList xs [] = []
mulList [] ys = []
mulList xs (y:ys) = sumLists (multLA xs y 0) (0: mulList xs ys)

mulBN:: BigNumber -> BigNumber -> BigNumber
mulBN (BigNumber sign1 list1) (BigNumber sign2 list2) =  BigNumber sign (reverse (mulList (reverse list1) (reverse list2)))
                                                        where sign | sign1 == sign2 = Pos
                                                                   |otherwise = Neg