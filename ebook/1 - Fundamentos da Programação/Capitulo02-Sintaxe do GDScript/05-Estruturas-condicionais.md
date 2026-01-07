# Estruturas Condicionais

As **estruturas condicionais** são as ferramentas que permitem ao seu programa tomar decisões. Até agora, vimos o código como uma linha reta, mas com as condicionais, criamos "bifurcações" onde o software decide qual caminho seguir dependendo dos dados. Se uma condição for verdadeira, um bloco de código é executado; caso contrário, o programa pode seguir um caminho alternativo ou simplesmente ignorar aquela parte.

## 1. O Bloco If, Elif e Else

Essas palavras-chave formam a base da lógica de decisão no GDScript:

- **If (Se)**: É o ponto de partida que avalia se uma expressão é verdadeira para executar o código logo abaixo dele.
- **Elif (Senão Se)**: Serve para verificar uma segunda ou terceira condição caso a primeira (o `if`) tenha sido falsa.
- **Else (Senão)**: É o "porto seguro"; se nenhuma das condições anteriores for atendida, o código dentro do `else` será executado obrigatoriamente.

### Composição da Sintaxe

No GDScript, a **indentação** (o espaço no início da linha) é obrigatória para definir o que está dentro da condicional.

```
  if  vida  <=  0 :
  --  ----------- -
   |       |      |
Palavra Expressão Dois-pontos (Indica que o 
Chave   Lógica    bloco de código começa abaixo)
```

## 2. A Estrutura Match

O **match** é uma alternativa mais organizada ao `if` quando você precisa comparar uma única variável com vários valores fixos (conhecido em outras linguagens como `switch/case`). Ele verifica o conteúdo da variável e pula direto para o "caso" correspondente.

## Exemplo Prático para Testar

Copie este código para a função `_ready()` no seu Godot para testar como o programa reage a diferentes valores:

```gdscript
func _ready():
	var pontos_time_a = 50
	var pontos_time_b = 50

	# Exemplo com If, Elif e Else
	if pontos_time_a > pontos_time_b:
		print("O time A venceu!") 
	elif pontos_time_b > pontos_time_a:
		print("O time B venceu!") 
	else:
		print("Houve um empate.")

	# Exemplo com Match (avaliando apenas uma variável)
	var estado_player = "morto"
	
	match estado_player:
		"saudável":
			print("O player está pronto para lutar!")
		"ferido":
			print("O player precisa de cura.")
		"morto":
			print("Fim de jogo.")
		_: # O símbolo "_" funciona como o "else" do match (caso padrão)
			print("Estado desconhecido.") 
```

> 💡 **Dica**: Experimente mudar os valores de `pontos_time_a`, `pontos_time_b` e `estado_player` para ver diferentes resultados!