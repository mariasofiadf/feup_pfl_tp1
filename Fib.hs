import BigNumber
--1.1
fibRec:: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec(n-1) + fibRec(n-2)

fibs :: (Integral a) => [a]
fibs = [0,1] ++ zipWith (+) fibs (tail fibs)

--1.2
fibLista :: (Integral a) => a -> a
fibLista n = fibs !! fromIntegral n

--1.3
fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = list !! fromIntegral n where list = [0,1] ++ zipWith (+) list (tail list)

--fibLista:: (Integral a) => a -> a

fibRecBN :: BigNumber -> BigNumber
fibRecBN (BigNumber _ [0]) = BigNumber Pos [0]
fibRecBN (BigNumber Neg _) = error"BigNumber must be positive for fibonacci"
fibRecBN (BigNumber Pos [1]) = BigNumber Pos [1]
fibRecBN bn = (fibRecBN (bn `subBN` scanner"1")) `somaBN` (fibRecBN (bn `subBN` scanner"2"))

fibsBN :: [BigNumber]
fibsBN = [scanner"0",scanner"1"] ++ zipWith (somaBN) fibsBN (tail fibsBN)

fibListaBN :: BigNumber -> BigNumber
fibListaBN bn = fibsBN !! read (output bn)

fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN bn = list !! read (output bn) where list = [scanner"0",scanner"1"] ++ zipWith (somaBN) list (tail list)