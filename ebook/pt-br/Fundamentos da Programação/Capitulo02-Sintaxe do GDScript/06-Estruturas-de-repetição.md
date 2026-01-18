# Estruturas de Repetição (Loops)

As **estruturas de repetição**, também conhecidas como **loops**, são fundamentais para quando precisamos que o computador execute o mesmo bloco de código várias vezes sem que precisemos escrevê-lo repetidamente. Imagine que você quer criar 10 inimigos em uma fase ou somar todos os itens de um inventário; sem os loops, você teria que escrever 10 linhas manuais, mas com eles, você escreve apenas uma instrução que se repete.

No GDScript, as duas principais formas de repetição são o **for** e o **while**.

## 1. O Loop For

O `for` é geralmente utilizado quando sabemos exatamente quantas vezes queremos repetir algo ou quando queremos percorrer uma lista de itens. Ele funciona como um "percorredor": ele pega um item de cada vez em uma sequência e executa o código para cada um deles.

### Composição da Sintaxe

Para repetir um número específico de vezes, usamos a função `range()`, que cria uma sequência de números.

```
  for  i  in  range(10):
  ---  -  --  ---------
   |   |  |       |
Palavra Var. Palavra Sequência de 0 a 9
Chave   Aux. Chave   (10 repetições)
```

## 2. O Loop While

O **while** (que significa "enquanto") é mais flexível e perigoso. Ele executa o código enquanto uma condição lógica for verdadeira. Se a condição nunca se tornar falsa, o programa entra em um **loop infinito**, o que faz o computador travar ou fechar o jogo.

> ⚠️ **Atenção**: Sempre garanta que a condição do `while` eventualmente se torne falsa!

## Exemplo Prático para Testar

Copie o código abaixo para o seu Godot para ver a diferença entre os dois. Note que no `while` precisamos atualizar manualmente o contador para que ele não rode para sempre.

```gdscript
func _ready():
	print("--- Testando o FOR ---")
	# O range(5) vai de 0 até 4 (5 números no total)
	for i in range(5):
		print("Repetição do For número: ", i)
	
	print("\n--- Testando o WHILE ---")
	var contador = 0
	# Enquanto o contador for menor que 5, o código roda
	while contador < 5:
		print("Repetição do While número: ", contador)
		# MUITO IMPORTANTE: Aumentar o contador para o loop ter um fim
		contador += 1 
```

## O que você aprendeu aqui?

- **For**: Ótimo para tarefas definidas (como "mande 10 inimigos para a tela")
- **While**: Usado para situações que dependem de uma condição externa (como "enquanto o player estiver vivo, continue o jogo")
- **Loop Infinito**: Acontece no `while` se você esquecer de atualizar a condição de parada

> 💡 **Dica**: Quando possível, prefira o `for` porque ele é mais seguro e difícil de criar loops infinitos!