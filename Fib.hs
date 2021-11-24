--1.1
fibRec:: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec(n-1) + fibRec(n-2)

--1.2
fibLista:: [Integer]
fibLista = [0,1] ++ zipWith (+) fibLista (tail fibLista)

--fibLista:: (Integral a) => a -> a