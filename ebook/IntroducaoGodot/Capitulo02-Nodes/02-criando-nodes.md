# Criando e Manipulando Nodes

Vamos colocar a mão na massa e criar nossos primeiros Nodes!

## Criando um Node

### Método 1: Interface Gráfica

1. Clique no botão **"+"** na Scene Tree
2. Procure o tipo de Node desejado
3. Selecione e clique em **"Create"**

### Método 2: Via Código

```gdscript
# Criar um novo Sprite2D
var sprite = Sprite2D.new()

# Adicionar como filho da cena atual
add_child(sprite)

# Definir posição
sprite.position = Vector2(100, 100)
```

## Manipulando Nodes

### Acessando Nodes

```gdscript
# Por nome
var player = get_node("Player")
# Ou forma abreviada
var player = $Player

# Acessando filho de filho
var sprite = $Player/Sprite2D

# Buscando por tipo
var all_sprites = get_tree().get_nodes_in_group("sprites")
```

### Modificando Propriedades

```gdscript
# Mudar posição
$Player.position = Vector2(200, 150)

# Mudar rotação (em radianos)
$Player.rotation = deg_to_rad(45)

# Mudar escala
$Player.scale = Vector2(2, 2)

# Tornar invisível
$Player.visible = false
```

## Removendo Nodes

```gdscript
# Remover um node
$Inimigo.queue_free()  # Remove no final do frame

# Remover imediatamente (cuidado!)
$Inimigo.free()
```

## Organizando com Grupos

```gdscript
# Adicionar a um grupo
$Inimigo.add_to_group("enemies")

# Verificar se está em um grupo
if $Personagem.is_in_group("player"):
    print("É o jogador!")

# Acessar todos de um grupo
var inimigos = get_tree().get_nodes_in_group("enemies")
for inimigo in inimigos:
    inimigo.queue_free()
```

> ⚠️ **Importante**: Use `queue_free()` em vez de `free()` para evitar erros!

## Exemplo Prático

Vamos criar um jogador simples:

```gdscript
extends Node2D

func _ready():
    # Criar sprite
    var sprite = Sprite2D.new()
    sprite.texture = preload("res://player.png")
    add_child(sprite)
    
    # Criar colisor
    var collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.size = Vector2(32, 32)
    collision.shape = shape
    add_child(collision)
    
    print("Jogador criado!")
```

No próximo capítulo, vamos aprender sobre **Scenes** e como salvar nossos Nodes!
