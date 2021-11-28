# Casos de teste

Para testar o correto funcionamento das nossas funções realizamos unit testing utilizando o módulo Test.HUnit. Estes unit tests encontram-se nos ficheiros FibTest.hs e BigNumberTest.hs. Ambos têm uma função runAllTests que corre todos os testes e mostra os resultados. Nota: Estes testes apenas correm em linux.

# Explicação do funcionamento das funções

## fibRec

Esta função calcula o número de Fibonacci de ordem i, recursivamente.

## fibLista

Esta função calcula o número de Fibonacci de ordem i, utilizando uma lista de resultados parciais (função fibs).

## fibListaInfinita

Esta função calcula o número de Fibonacci de ordem i, gerando uma lista infinita com os números de Fibonacci e retorna o elemento de ordem i.

## scanner

Esta função recebe uma string e retorna um BigNumber. A string de input é analisada de dois modos distintos:
1. Analisa o primeiro caracter para ver se é um sinal negativo '-' ou se é um digito. No caso de ser '-', o BigNumber terá Sign = Neg e no caso de ser um dígito o BigNumber terá Sign = Pos. Para isto utilizamos uma função auxiliar charToSign.
2. Analisa a string como um todo, ignorando o caracter '-', no caso de existir e guarda o valor absoluto do número na lista do BigNumber. Para tal, utilizamos uma função auxiliar stringToList.
Depois de obtermos o Sign e a lista de dígitos podemos retornar o BigNumber desejado.

### charToSign

Transforma char em Sign. Se o char for '-' é retornado Neg e se o char for um digito, é retornado Pos. Se o char não for '-' nem um digito, é retornado erro. 

### stringToList

Transforma string em [Int]. Se o primeiro caracter for '-', é ignorado. Caso contrário, e se não for um digito, é lançado o erro. Esta função percorre recursivamente a string enquanto o char atual for um dígito. Chegando ao fim, é retornada a lista dos dígitos do valor absoluto número de input.

## output

Esta função recebe um BigNumber e retorna uma string.
Para o fazer, utiliza duas funções auxiliar, signToString e listToString, e concatena os seus resultados.

### signToString

Esta função recebe Sign e, no caso de ser Pos retorna "" e no caso de ser Neg retorna "-".

### listToString

Esta função recebe uma lista de inteiros menores que 10 (dígitos) e junta-os numa string. 


## somaBN

Esta função recebe dois BigNumber e retorna a sua soma em BigNumber. No caso de dois números positivos ou dois números negativos, chama a função auxiliar sumLists. No caso de números de sinais diferentes, é chamada a função auxiliar subLists.

### sumLists

Esta função soma as listas dos digitos de dois BigNumber e funciona para números positivos. Para tal, recebe as listas em ordem inversa.

### subLists

Esta função recebe duas listas de digitos e subtrai a segunda lista de digitos à primeira. Esta função assume que ambos o valores são positivos e que a primeira lista representa um valor maior que a segunda.

### biggerAbsList

As listas representa números inteiros não negativos. A função retorna True se o primeiro número for maior que o segundo e False no caso contrário.

## subBN

Esta função transforma uma subtração numa soma, alterando o sinal do segundo BigNumber e chama a função somaBN.

# Resposta à pergunta 4

As funções para calcular números de Fibonacci, usando (Int -> Int) são limitadas pelo número máximo que cabe em 64 bits pois Int's são guardados com precisão fixa. Por outro lado, ao usar (Integer -> Integer), como Integer é guardado com precisão arbitrária, o valor máximo é apenas limitado pela memória do computador. O mesmo acontece usando BigNumber, o valor máximo é apenas limitado pela memória do computador. 

Independentemente do tipo usado, Int, Integer ou BigNumber, a velocidade do calculo de números de Fibonacci é sempre limitada pelo processador.

Para Integral's podemos perceber que, usando a opção :set +s do ghci, o calculo é muito mais rápido e ocupa muito menos memória usando a função fibListaInfinita. Isto acontece porque a função fibRec é ineficiente por ser recursiva e fazer cálculos repetidos. A função fibLista, ao chamar a função recursiva fibs (para obter a lista com números de Fibonacci), está a alocar memória por cada chamada a fibs. Em contraste às funções anteriores, a função fibListaInfinita é eficiente em termos de tempo de execução e de memória utilizada.

    *Fib> :set +s
    *Fib> fibRec 30
    832040
    (4.53 secs, 1,750,889,192 bytes)  
    *Fib> fibLista 30
    832040
    (5.53 secs, 1,729,716,248 bytes)
    *Fib> fibListaInfinita 30
    832040
    (0.01 secs, 72,456 bytes)

Podemos fazer a mesma análise quando usamos BigNumber's. O cálculo usando a função recursiva fibRecBN é bastante demorado e custoso em termos de memória. Por outro lado, as funções fibListaBN e fibListaInfinitaBN são de eficiência comparável para números pequenos, tanto em termos de tempo de execução como em memória necessária. Para números maiores podemos verificar que a função fibListaInfinitaBN demora menos de metade do tempo que a fibListaBN demora.

    *Fib> :set +s
    *Fib> fibRecBN (scanner"30")
    BigNumber Pos [8,3,2,0,4,0]
    (22.66 secs, 7,899,762,224 bytes)
    *Fib> fibListaBN (scanner"30")
    BigNumber Pos [8,3,2,0,4,0]
    (0.08 secs, 91,632 bytes)
    *Fib> fibListaInfinitaBN (scanner"30")
    BigNumber Pos [8,3,2,0,4,0]
    (0.01 secs, 165,984 bytes)

    *Fib> fibListaBN (scanner"10000")
    ...
    (94.91 secs, 8,027,967,544 bytes)
    *Fib> fibListaInfinitaBN (scanner"10000")
    ...
    (40.28 secs, 8,028,041,896 bytes)