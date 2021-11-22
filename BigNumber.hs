import Data.Char (digitToInt, intToDigit)

data BigNumber = BigNumber Sign [Int] deriving Show

data Sign = Pos | Neg deriving (Show,Eq)


--"1234"
scanner:: String -> BigNumber
scanner (x:xs) = BigNumber (charToSign x) (stringToList (x:xs))

charToSign :: Char -> Sign
charToSign s   | s == '-' = Neg
            | s `elem` ['0','1','2','3','4','5','6','7','8','9'] = Pos
            | otherwise = error ("Invalid Input")

stringToList :: String -> [Int]
stringToList "" = []
stringToList (x:[])    | x `elem` ['0','1','2','3','4','5','6','7','8','9'] = [digitToInt x]
                    | x == '-' = []
                    | otherwise = error ("Invalid Input")
stringToList (x:xs) = stringToList [x] ++ stringToList xs

signToString :: Sign -> String
signToString s  | s == Pos = ""
                | s == Neg = "-"
                | otherwise = error"error";

listToString :: [Int] -> String
listToString = foldr (\ x -> (++) [intToDigit x]) ""


output :: BigNumber -> String
output (BigNumber sign list) = signToString sign ++ listToString list
