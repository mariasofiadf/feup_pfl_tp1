# Casos de teste

Para testar o correto funcionamento das nossas funções realizamos unit testing utilizando o módulo Test.HUnit. Estes unit tests encontram-se nos ficheiros FibTest.hs e BigNumberTest.hs. Ambos têm uma função runAllTests que corre todos os testes e mostra os resultados.

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

### charToSign (usada em scanner)

Transforma char em Sign. Se o char for '-' é retornado Neg e se o char for um digito, é retornado Pos. Se o char não for '-' nem um digito, é retornado erro. 

### stringToList (usada em scanner)

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

## subBN

Esta função transforma uma subtração numa soma, alterando o sinal do segundo BigNumber e chama a função somaBN.