# Programação Orientada a Objetos em GDScript

Aprenda a criar classes e objetos reutilizáveis!

## O que são Classes?

Uma **classe** é um modelo para criar objetos com:
- **Atributos** (dados)
- **Métodos** (comportamentos)

## Criando uma Classe

### Forma 1: Script sem Nome

```gdscript
# enemy.gd
extends Node2D

var vida: int = 100
var velocidade: float = 5.0

func _ready():
    print("Inimigo criado!")

func receber_dano(quantidade: int):
    vida -= quantidade
    if vida <= 0:
        morrer()

func morrer():
    queue_free()
```

### Forma 2: Classe Nomeada

```gdscript
# enemy.gd
class_name Enemy
extends Node2D

var vida: int = 100
var velocidade: float = 5.0

func _ready():
    print("Inimigo criado!")

func receber_dano(quantidade: int):
    vida -= quantidade
    if vida <= 0:
        morrer()

func morrer():
    queue_free()
```

Agora pode usar `Enemy` em qualquer lugar do projeto!

## Propriedades (Atributos)

### Variáveis de Instância

```gdscript
class_name Jogador
extends CharacterBody2D

# Exportadas (aparecem no Inspector)
@export var velocidade_maxima: float = 300.0
@export var vida_maxima: int = 100
@export var cor: Color = Color.WHITE

# Privadas (convenção com _)
var _vida_atual: int = 100
var _mana_atual: int = 50

# Constantes
const PULO_FORCA = 500
```

### Propriedades com Get/Set

```gdscript
class_name Personagem

var _vida: int = 100

# Propriedade com getter e setter
var vida: int:
    get:
        return _vida
    set(valor):
        _vida = clamp(valor, 0, vida_maxima)
        if _vida <= 0:
            morrer()

var vida_maxima: int = 100
```

## Construtores

### _init()

```gdscript
class_name Arma

var nome: String
var dano: int

func _init(p_nome: String = "Espada", p_dano: int = 10):
    nome = p_nome
    dano = p_dano
    print("Arma criada: ", nome)

# Uso
var espada = Arma.new("Espada Longa", 25)
```

## Herança

```gdscript
# personagem.gd
class_name Personagem
extends CharacterBody2D

var vida: int = 100
var velocidade: float = 200.0

func receber_dano(quantidade: int):
    vida -= quantidade
    print("Vida: ", vida)

func mover(direcao: Vector2):
    velocity = direcao * velocidade
    move_and_slide()
```

```gdscript
# jogador.gd
class_name Jogador
extends Personagem

var mana: int = 50

func _ready():
    velocidade = 300.0  # Sobrescreve valor da classe pai

func usar_magia(custo: int):
    if mana >= custo:
        mana -= custo
        print("Magia usada!")
    else:
        print("Mana insuficiente!")

# Sobrescrevendo método
func receber_dano(quantidade: int):
    super(quantidade)  # Chama método da classe pai
    print("Ai!")
```

## Métodos Estáticos

```gdscript
class_name Matematica

static func distancia(a: Vector2, b: Vector2) -> float:
    return a.distance_to(b)

static func aleatorio_entre(min_val: float, max_val: float) -> float:
    return randf_range(min_val, max_val)

# Uso sem instanciar
var dist = Matematica.distancia(Vector2(0, 0), Vector2(10, 10))
```

## Classes Internas

```gdscript
class_name Inventario

class Item:
    var nome: String
    var quantidade: int
    
    func _init(p_nome: String, p_quantidade: int):
        nome = p_nome
        quantidade = p_quantidade

var itens: Array[Item] = []

func adicionar_item(nome: String, quantidade: int):
    var item = Item.new(nome, quantidade)
    itens.append(item)

func listar_itens():
    for item in itens:
        print(item.nome, ": ", item.quantidade)
```

## Enumerações

```gdscript
class_name Inimigo
extends CharacterBody2D

enum Estado {
    PATRULHANDO,
    PERSEGUINDO,
    ATACANDO,
    FUGINDO
}

var estado_atual: Estado = Estado.PATRULHANDO

func _process(_delta):
    match estado_atual:
        Estado.PATRULHANDO:
            patrulhar()
        Estado.PERSEGUINDO:
            perseguir_jogador()
        Estado.ATACANDO:
            atacar()
        Estado.FUGINDO:
            fugir()
```

## Sinais (Signals)

```gdscript
class_name Chefe
extends Enemy

signal vida_mudou(vida_atual, vida_maxima)
signal fase_mudou(nova_fase)
signal morreu

var fase_atual: int = 1

func receber_dano(quantidade: int):
    vida -= quantidade
    vida_mudou.emit(vida, vida_maxima)
    
    # Muda de fase em 50% de vida
    if vida <= vida_maxima / 2 and fase_atual == 1:
        fase_atual = 2
        fase_mudou.emit(2)
    
    if vida <= 0:
        morreu.emit()
        queue_free()
```

## Exemplo Completo

```gdscript
class_name RPGCharacter
extends CharacterBody2D

# Sinais
signal nivel_subiu(novo_nivel)
signal morreu

# Enums
enum Classe { GUERREIRO, MAGO, ARQUEIRO }

# Constantes
const EXP_POR_NIVEL = 100

# Propriedades exportadas
@export var classe: Classe = Classe.GUERREIRO
@export var nome: String = "Herói"

# Propriedades privadas
var _nivel: int = 1
var _experiencia: int = 0
var _vida: int = 100
var _mana: int = 50

# Propriedades com getter/setter
var nivel: int:
    get: return _nivel

var vida: int:
    get: return _vida
    set(valor):
        _vida = clamp(valor, 0, vida_maxima)
        if _vida <= 0:
            morreu.emit()

# Propriedades calculadas
var vida_maxima: int:
    get: return 100 + (_nivel * 10)

var mana_maxima: int:
    get: return 50 + (_nivel * 5)

# Construtor
func _init():
    pass

func _ready():
    print("Personagem %s criado!" % nome)

# Métodos
func ganhar_experiencia(quantidade: int):
    _experiencia += quantidade
    
    while _experiencia >= EXP_POR_NIVEL:
        _experiencia -= EXP_POR_NIVEL
        subir_nivel()

func subir_nivel():
    _nivel += 1
    _vida = vida_maxima
    _mana = mana_maxima
    nivel_subiu.emit(_nivel)
    print("%s subiu para nível %d!" % [nome, _nivel])

func atacar(alvo: RPGCharacter):
    var dano = 10 + (_nivel * 2)
    alvo.receber_dano(dano)

func receber_dano(quantidade: int):
    vida -= quantidade  # Usa o setter
```

> 💡 **Dica**: Use `class_name` para tornar suas classes acessíveis globalmente!

No próximo capítulo, vamos ver **padrões de design** em Godot!
