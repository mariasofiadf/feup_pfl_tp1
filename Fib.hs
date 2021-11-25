--1.1
fibRec:: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec(n-1) + fibRec(n-2)

fibs :: (Integral a) => [a]
fibs = [0,1] ++ zipWith (+) fibs (tail fibs)
--1.2
fibLista :: (Integral a) => a -> a
fibLista n = fibs !! (fromIntegral n)

--1.3
fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = list !! (fromIntegral n) where list = [0,1] ++ zipWith (+) list (tail list)

--fibLista:: (Integral a) => a -> a