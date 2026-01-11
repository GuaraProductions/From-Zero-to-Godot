# Composição

Depois de explorarmos a **Herança**, é fundamental conhecermos o seu "parceiro" inseparável na Engine: a **Composição**. Enquanto a herança define **o que um objeto é** (um Lobo Guará **é** um Animal), a composição define **o que um objeto tem** (um Personagem **tem** um Inventário, **tem** uma Barra de Vida).

Na Godot, a composição é o **coração do fluxo de trabalho**. Em vez de criar uma classe gigante com milhares de linhas de código, nós dividimos as funcionalidades em pequenos pedaços (Nodes) e os juntamos para formar algo maior.

## Herança vs. Composição

Muitos programadores iniciantes tentam resolver tudo com herança, criando árvores genealógicas complexas que se tornam difíceis de manter. A regra de ouro na Godot é: **"Prefira composição sobre herança"** sempre que possível.

### Herança

Cria uma relação **rígida**. Se você mudar o "Pai", todos os "Filhos" mudam, o que pode causar bugs em cascata.

### Composição

Cria uma relação **flexível**. Você pode adicionar ou remover funcionalidades (como um componente de "Efeito de Fogo") sem quebrar a lógica base do personagem.

## Composição na Interface da Godot

A interface da Engine é o exemplo visual perfeito da composição. Quando você olha para a aba **Cena**, a estrutura de "Nós" (Nodes) é a composição em ação:

- O **Node Principal** (ex: `CharacterBody2D`) é o corpo
- Os **Nodes Filhos** (ex: `Sprite2D` para visual, `CollisionShape2D` para física) são os componentes que dão habilidades a esse corpo

## Composição via Código
No GDScript, a composição acontece quando uma classe guarda uma referência a outra classe dentro de uma variável.

```gdscript
# No arquivo Inventario.gd
class_name Inventario
var itens = []

func adicionar_item(item):
    itens.append(item)
```

```gdscript
# No arquivo Player.gd
extends Node2D

# O Player NÃO é um Inventário, ele TEM um Inventário.
var mochila = Inventario.new() # Composição acontecendo aqui!

func _ready():
    mochila.adicionar_item("Poção de Cura")
Composição com Nodes (Cenas)
Outra forma poderosa de composição é usar o get_node() ou o atalho $ para acessar componentes que você montou na interface.
```

```gdscript
func _ready():
    # Acessando o componente de animação (Composição de Nodes)
    $AnimationPlayer.play("andar")
```

## Vantagens da Composição

✅ **Flexibilidade**: Você pode criar um "Inimigo" e um "Player" usando o mesmo componente de "Saúde".

✅ **Manutenção Fácil**: Se o componente de "Inventário" der erro, você só precisa consertar um arquivo, sem medo de quebrar toda a hierarquia de herança do jogo.

✅ **Modularidade**: Você constrói seu jogo como se estivesse montando blocos de LEGO. Você adiciona apenas os componentes que uma classe precisa.