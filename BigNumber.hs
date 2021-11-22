import Data.Char (digitToInt, intToDigit)

data BigNumber = BigNumber Sign [Int] deriving Show

data Sign = Pos | Neg deriving Show


--"1234"
scanner:: String -> BigNumber
scanner (x:xs) = BigNumber (getSign x) (getDigits (x:xs))

getSign :: Char -> Sign
getSign s   | s == '-' = Neg
            | s `elem` ['0','1','2','3','4','5','6','7','8','9'] = Pos
            | otherwise = error ("Invalid Input")
 
getDigits :: String -> [Int]
getDigits "" = []
getDigits (x:[])    | x `elem` ['0','1','2','3','4','5','6','7','8','9'] = [digitToInt x]
                    | x == '-' = []
                    | otherwise = error ("Invalid Input")
getDigits (x:xs) = getDigits [x] ++ getDigits xs

getSignFromBN :: BigNumber -> Sign
getSignFromBN (BigNumber sign _) = sign

getDigitsFromBN :: BigNumber -> String
getDigitsFromBN (BigNumber _ []) = ""
getDigitsFromBN (BigNumber _ (x:xs)) = [intToDigit x] ++ (getDigitsFromBN (BigNumber Pos xs))


output :: BigNumber -> String
output bn = ""
