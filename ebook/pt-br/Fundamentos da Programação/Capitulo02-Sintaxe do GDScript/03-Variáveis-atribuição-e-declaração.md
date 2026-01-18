# Variáveis, atribuição e declaração

Agora que você já entende o que é uma linguagem e como a lógica funciona, é hora de aprender a escrever os seus primeiros comandos. O conceito mais fundamental na programação são as variáveis. Você pode imaginar uma variável como uma pequena "caixa" vazia dentro da memória do computador, onde você guarda uma informação para usar depois. Sem as variáveis, o computador não teria como armazenar dados durante a execução de um programa.

## Declaração e Identificadores

Para criar essa "caixa", usamos um processo chamado declaração. No GDScript, você avisa à Engine que quer criar uma nova variável usando a palavra reservada var. Em seguida, você deve escolher um nome para ela, que chamamos de identificador. Esse nome é arbitrário e pode ser qualquer coisa que ajude você a identificar o dado, como pingo, vida ou pontuacao. Declarar é simplesmente dizer: "Ei, Engine, reserve um espaço na memória com este nome".

## Atribuição

Depois de declarar a variável, você precisa colocar um valor dentro dela através da atribuição. Usamos o símbolo de igual (=) para essa tarefa. Na programação, o = funciona como uma ordem de "guarde o valor da direita dentro da variável que está na esquerda". Você também pode realizar a declaração e a atribuição na mesma linha, o que torna o código mais prático.

## Composição da Sintaxe

Veja abaixo como a estrutura da variável é montada. O GDScript usa espaços e palavras específicas para que o computador entenda o que você está criando:

```
  var  nome_da_variavel  =  100
  ---  ----------------  -  ---
   |          |          |   |
Palavra    Identifi-   Sinal Valor/
Chave      cador       de =  Expressão
```

## Exemplo Prático para Testar

Para testar na sua máquina, abra a Godot, crie um script vazio e insira o código abaixo dentro da função _ready(). Ao rodar a cena, os valores aparecerão no painel de Saída (Output).

```gdscript
func _ready():
	# 1. Declaração simples (caixa vazia)
	var vida_do_player
	
	# 2. Atribuição (colocando valor na caixa)
	vida_do_player = 100
	
	# 3. Declaração e Atribuição na mesma linha
	var nome_do_personagem = "Guará"
	var estamina = 55.5
	var mana_cheia = true
	
	# Exibindo os valores no painel de Saída (Output)
	print("Nome: ", nome_do_personagem)
	print("Vida: ", vida_do_player)
	print("Mana está cheia? ", mana_cheia)
```

## Tipos de Dados Básicos

O GDScript consegue identificar automaticamente o que você guarda na variável, mas é importante conhecer os tipos principais:

- String: Usada para textos, sempre escrita entre aspas (ex: "Olá").
- Integer (int): Números inteiros, positivos ou negativos (ex: 550).
- Float: Números com casas decimais (ex: 15.5).
- Boolean (bool): Representa apenas dois estados, true (verdadeiro) ou false (falso), como um interruptor de luz.