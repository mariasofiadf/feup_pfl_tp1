module Fib (fibRec, fibLista, fibListaInfinita) where
import BigNumber


--1.1 função recursiva para obter o número de Fibonacci de ordem n
fibRec:: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n    | n >= 0 = fibRec(n-1) + fibRec(n-2)
            | otherwise = error"fibRec only accepts non negative input"

--a função fibs retorna uma lista infinita tal que lista !! i contém o número de Fibonacci de ordem i
--usada em 1.2 fibLista
fibs :: (Integral a) => [a]
fibs = [0,1] ++ zipWith (+) fibs (tail fibs)

--1.2 função que usa uma lista de resultados parciais (fibs) para obter o número de Fibonacci de ordem i
fibLista :: (Integral a) => a -> a
fibLista n  | n>=0 = fibs !! fromIntegral n
            | otherwise = error"fibLista only accepts non negative input"

--1.3 função que gera uma lista infinita tal que lista !! i contém o número de Fibonacci de ordem i e retorna esse número de Fibonacci
fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = list !! fromIntegral n where list = [0,1] ++ zipWith (+) list (tail list)


--3 função recursiva para obter o número de Fibonacci de ordem n
fibRecBN :: BigNumber -> BigNumber
fibRecBN (BigNumber _ [0]) = BigNumber Pos [0]
fibRecBN (BigNumber Neg _) = error"BigNumber must be positive for Fibonacci"
fibRecBN (BigNumber Pos [1]) = BigNumber Pos [1]
fibRecBN bn = fibRecBN (bn `subBN` scanner"1") `somaBN` fibRecBN (bn `subBN` scanner"2")

--fibsBN retorna uma lista infinita tal que lista !! i contém o número (BigNumber) de Fibonacci de ordem i
--usada em fibListaBN
fibsBN :: [BigNumber]
fibsBN = [scanner"0",scanner"1"] ++ zipWith somaBN fibsBN (tail fibsBN)

--3 função que usa uma lista de resultados parciais (fibsBN) para obter o número de Fibonacci de ordem i
fibListaBN :: BigNumber -> BigNumber
fibListaBN bn = fibsBN !! read (output bn)

--3 função recursiva para obter o número de Fibonacci de ordem n
fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN bn = list !! read (output bn) where list = [scanner"0",scanner"1"] ++ zipWith somaBN list (tail list)
