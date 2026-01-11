# Polimorfismo

Chegamos ao último dos quatro pilares da Programação Orientada a Objetos: o **Polimorfismo**. O nome vem do grego e significa "muitas formas". Na programação, esse conceito permite que objetos diferentes respondam à mesma chamada de função de maneiras diferentes, de acordo com a sua própria natureza.

Imagine que você tem um jogo com vários animais. Você pode criar um comando geral chamado `emitir_som()`. Embora o comando seja o mesmo, o "Cachorro" vai responder latindo, enquanto o "Gato" vai responder miando. O código que envia a ordem não precisa saber qual é o animal específico; ele apenas confia que qualquer animal sabe como emitir um som.

## Sobrescrita de Funções (Override)

No GDScript, a forma mais comum de aplicar o polimorfismo é através da **sobrescrita**. Isso acontece quando uma classe filha herda uma função da classe pai, mas decide mudar o que essa função faz para se ajustar às suas necessidades.

Na Engine Godot, você já usa o polimorfismo o tempo todo sem perceber! Funções como `_ready()` ou `_process()` já existem na base da Engine, mas você as "sobrescreve" no seu script para dar o seu próprio comportamento personalizado ao seu objeto.

## Composição da Sintaxe

Para que o polimorfismo funcione via herança, a classe filha deve usar o mesmo nome de função definido na classe pai:

```
  # Na Classe Pai:
  func agir(): 
      print("Ação genérica")

  # Na Classe Filha:
  func agir():  <-- O mesmo nome da função original
      print("Ação especializada!") <-- Um comportamento novo
```

## Exemplo Prático para Testar

Veja como podemos tratar diferentes tipos de personagens como se fossem apenas um "Combatente", mas cada um agindo de um jeito único:

**Arquivo: Combatente.gd (Classe Pai)**

```gdscript
class_name Combatente
extends Node

func atacar():
	print("O combatente ataca de forma básica.")
```

**Arquivo: Arqueiro.gd (Classe Filha)**

```gdscript
extends Combatente

func atacar():
	print("O arqueiro dispara uma flecha certeira!")
```

**Arquivo: Guerreiro.gd (Classe Filha)**

```gdscript
extends Combatente

func atacar():
	print("O guerreiro golpeia com sua espada!")
```

**No seu Script Principal**

```gdscript
func _ready():
	# Criamos uma lista (Array) de combatentes diferentes
	var time = [Arqueiro.new(), Guerreiro.new()]
	
	for membro in time:
		# POLIMORFISMO: Chamamos a mesma função 'atacar', 
		# mas cada um responde do seu jeito!
		membro.atacar()
```

## Vantagens do Polimorfismo

✅ **Flexibilidade**: Você pode adicionar novos tipos de personagens ou inimigos ao jogo sem precisar mudar o código que faz eles atacarem

✅ **Organização**: Permite tratar grupos de objetos diferentes de forma uniforme

✅ **Código Limpo**: Evita o uso excessivo de "ifs" para checar qual é o tipo do objeto antes de realizar uma ação comum