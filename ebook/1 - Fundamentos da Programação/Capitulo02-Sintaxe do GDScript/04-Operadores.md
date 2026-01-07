# Operadores

No desenvolvimento de jogos, você passará boa parte do tempo realizando cálculos e comparações, como diminuir a vida de um inimigo, verificar se o jogador tem moedas suficientes ou decidir se uma fase foi concluída. Para isso, o GDScript oferece três tipos principais de operadores.

1. Operadores Aritméticos
Os operadores aritméticos são usados para realizar cálculos matemáticos com valores numéricos. Eles seguem a lógica da matemática tradicional que aprendemos na escola.

- **Soma (+)**: Adiciona dois valores.
- **Subtração (-)**: Subtrai um valor de outro.
- **Multiplicação (*)**: Multiplica dois valores.
- **Divisão (/)**: Divide um valor pelo outro.
- **Módulo (%)**: Retorna o resto de uma divisão inteira. Por exemplo, 11 % 2 resulta em 1, pois 11 dividido por 2 dá 5 e sobra 1.

### Ordem de Precedência
O computador segue uma ordem de prioridade: multiplicações, divisões e módulos são resolvidos antes de somas e subtrações. Para mudar essa ordem, usamos parênteses ().

```
  var  calculo  =  ( 10  +  2 )  * 5
  ---  -------  -  ------------------
   |      |     |          |
Palavra Identifi- =    Expressão com 
Chave   cador          Parênteses
```

2. Operadores Relacionais
Esses operadores servem para estabelecer a relação entre dois valores, comparando-os e retornando sempre um resultado Booleano (true ou false).

- **Maior que (>)** e **Menor que (<)**: Comparam se um valor é superior ou inferior ao outro.
- **Maior ou igual (>=)** e **Menor ou igual (<=)**: Comparam incluindo a igualdade.
- **Igual a (==)**: Verifica se dois valores são idênticos. Atenção: Usamos dois sinais de igual para diferenciar da atribuição simples.
- **Diferente de (!=)**: Verifica se os valores são distintos.

3. Operadores Lógicos
Os operadores lógicos são usados para combinar múltiplas condições booleanas.

- **And (and)**: A expressão só é verdadeira se todas as condições individuais forem verdadeiras.
- **Or (or)**: A expressão é verdadeira se pelo menos uma das condições for verdadeira.

## Exemplo Prático para Testar
Copie o código abaixo para a função _ready() do seu script para ver os operadores em ação no painel de Saída:

```
func _ready():
	# Operadores Aritméticos
	var vida = 100
	vida = (vida - 20) + 5 # 80 + 5 = 85 
	var resto = 11 % 2 # Resultado: 1 
	
	# Operadores Relacionais
	var pontos_time_a = 50
	var pontos_time_b = 30 
	var vitoria_a = pontos_time_a > pontos_time_b # Resultado: true [cite: 584, 588]
	
	# Operadores Lógicos
	var tem_chave = true
	var porta_destrancada = false
	var pode_passar = tem_chave and porta_destrancada # Resultado: false [cite: 516]
	
	print("Vida: ", vida)
	print("Venceu? ", vitoria_a)
	print("Pode passar? ", pode_passar)
```