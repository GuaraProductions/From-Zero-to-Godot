# Herança

No capítulo anterior, vimos que as **Classes** funcionam como moldes para criar objetos. Agora, imagine que você está a criar um jogo com vários tipos de inimigos: um **Orc**, um **Esqueleto** e um **Dragão**. Todos eles têm coisas em comum, como vida, posição no mapa e a capacidade de sofrer dano. Seria muito cansativo escrever o mesmo código de "vida" para cada um deles, certo?

É aqui que entra a **Herança**. Na programação, a herança permite que uma classe "filha" herde automaticamente todas as características e comportamentos de uma classe "pai". É como na biologia: você herda traços dos seus pais, mas continua a ser uma pessoa única com as suas próprias características.

## A Hierarquia na Engine

A Godot Engine é inteiramente construída sobre este conceito. Quando você cria um script e vê no topo a linha `extends Sprite2D`, está a dizer ao computador: "Este meu script é um filho do Sprite2D; ele já sabe como mostrar imagens, mas eu vou adicionar algo novo a ele".

- **Classe Pai (Superclasse)**: É a base que contém o que é comum a todos (ex: a classe `Inimigo`)
- **Classe Filha (Subclasse)**: É a versão especializada que recebe tudo do pai e adiciona os seus próprios detalhes (ex: o `Dragão`, que herda de `Inimigo`, mas adiciona a função `cuspir_fogo()`)

## Composição da Sintaxe

No GDScript, a palavra-chave que ativa a herança é o `extends`. Ela define de quem o seu script "nasceu".

```
  extends  Inimigo  <-- O seu script agora tem tudo o que o Inimigo tem
  -------  -------
     |        |
  Palavra   Nome da 
  Chave     Classe Pai
```

## Exemplo Prático para Testar

Vamos ver como isto funciona na prática. Imagine que temos um script base para todos os seres vivos do jogo:

```gdscript
# SER_VIVO.GD (O Pai)
class_name SerVivo
extends Node

var saude = 100

func receber_dano(quantidade):
	saude -= quantidade
	print("Saúde atual: ", saude)

# ---------------------------------------------------------

# JOGADOR.GD (O Filho)
extends SerVivo # Aqui a herança acontece!

func _ready():
	# Nota que não criamos a variável 'saude' aqui, 
	# mas temos acesso a ela porque herdamos do SerVivo.
	receber_dano(20)
	print("O jogador ainda tem ", saude, " de vida.")
```

## Por que usar Herança?

✅ **Reutilização**: Escreve o código uma vez e usa em dez lugares diferentes

✅ **Organização**: Se precisar de mudar a forma como o dano é calculado em todo o jogo, só precisa alterar a classe pai, e todos os filhos serão atualizados automaticamente

✅ **Padronização**: Garante que todos os seus inimigos se comportem de forma parecida, evitando erros inesperados