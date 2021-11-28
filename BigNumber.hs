
module BigNumber (BigNumber(..), Sign(..), scanner, output, somaBN, subBN, mulBN, divBN, safeDivBN) where
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
import Data.Char
--import Text.Html (yellow)





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
somaBN (BigNumber Pos list1) (BigNumber Neg list2)  | biggerAbsList  list1 list2 = BigNumber Pos (removeLeftZeros(reverse (subLists (reverse list1) (reverse list2))))
                                                    | otherwise = BigNumber Neg (reverse (subLists (reverse list2) (reverse list1)))
somaBN (BigNumber Neg list1) (BigNumber Pos list2)  | biggerAbsList  list1 list2 = BigNumber Neg (removeLeftZeros(reverse (subLists (reverse list1) (reverse list2))))
                                                    | otherwise = BigNumber Pos (reverse (subLists (reverse list2) (reverse list1)))


removeLeftZeros :: [Int] -> [Int]
removeLeftZeros [0] = [0]
removeLeftZeros (0:xs) = removeLeftZeros xs
removeLeftZeros xs = xs

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

--list multiplication
mulList:: [Int] -> [Int] -> [Int]
mulList xs [0] = [0]
mulList [0] ys = [0]
mulList xs [] = []
mulList [] ys = []
mulList xs (y:ys) = sumLists (multLA xs y 0) (0: mulList xs ys)


mulBN:: BigNumber -> BigNumber -> BigNumber
mulBN (BigNumber sign1 list1) (BigNumber sign2 list2) =  BigNumber sign (removeLeftZeros(reverse (mulList (reverse list1) (reverse list2))))
                                                        where sign | sign1 == sign2 = Pos
                                                                   |otherwise = Neg



--Returns true if two lists have the same value
equalList:: [Int] -> [Int] -> Bool
equalList l1 l2 = removeLeftZeros l1 == removeLeftZeros l2

--Basically subtracting until the divisor is smaller than the dividend
--It's not the fastest way, and will only be used to help in the division
divSmallList:: [Int] -> [Int] -> [Int] -> [Int]
divSmallList l1 l2 n  |equalList l1 [0] = n
                        |biggerAbsList l2 l1 = n
                        |otherwise = divSmallList sub l2 cont where sub = removeLeftZeros(reverse (subLists (reverse l1)(reverse l2)))
                                                                    cont = removeLeftZeros(reverse (sumLists (reverse n) [1]))
--Divides two lists 
divList::[Int] -> [Int]-> [Int]
divList l1 [0] = []
divList [] l2 = []
divList l1 l2 | biggerAbsList l2 l1 = []
                | biggerAbsList quo [1] || equalList quo [1] = quo ++ divList nextDiv l2 --quo maior ou igual a 1
                | otherwise  = quo1 ++ divList nextDiv1 l2
                        where div = removeLeftZeros(take (length l2) l1)
                              div1 = removeLeftZeros(take (length l2 + 1) l1)
                              quo = divSmallList div l2 [0]
                              quo1 = divSmallList div1 l2 [0]
                              nextDiv =  removeLeftZeros(reverse (subLists (reverse div) ( mulList (reverse l2) quo)) ++ drop (length l2) l1)
                              nextDiv1 =  removeLeftZeros(reverse (subLists (reverse div1) ( mulList (reverse l2) quo1)) ++ drop (length l2 +1) l1)

--Param: Dividend Divisor Quot
--Returns de reminder of the division
calcReminder:: [Int] -> [Int] -> [Int] -> [Int]
calcReminder l1 l2 quo | null (removeLeftZeros(reverse (subLists (reverse l1) (mulList (reverse quo) (reverse l2))))) = [0]
                        |otherwise = removeLeftZeros(reverse (subLists (reverse l1) (mulList (reverse quo) (reverse l2))))

--BigNumber division
divBN:: BigNumber -> BigNumber -> (BigNumber , BigNumber)
divBN (BigNumber sign1 list1) (BigNumber sign2 list2) =  (BigNumber sign result , BigNumber Pos (removeLeftZeros remainder))
                                                      where result = divList list1 list2
                                                            remainder = calcReminder list1 list2 result
                                                            sign | sign1 == sign2 = Pos
                                                                 |otherwise = Neg
--Prevents division by zero
safeDivBN:: BigNumber -> BigNumber -> Maybe (BigNumber, BigNumber)
safeDivBN bn1 (BigNumber sign2 list2)
      | equalList list2 [0] =  Nothing --divisor not 0, so it uses normal BN division
      |otherwise = Just (divBN bn1 (BigNumber sign2 list2))
