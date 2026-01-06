# Variáveis e Tipos de Dados

Domine os fundamentos de GDScript para escrever código eficiente!

## Declaração de Variáveis

### Forma Básica

```gdscript
var nome = "João"
var idade = 25
var altura = 1.75
var ativo = true
```

### Com Tipagem Estática

```gdscript
var nome: String = "João"
var idade: int = 25
var altura: float = 1.75
var ativo: bool = true
```

### Inferência de Tipo

```gdscript
var nome := "João"  # String inferido
var idade := 25     # int inferido
var altura := 1.75  # float inferido
```

## Tipos de Dados Básicos

### Números

```gdscript
var inteiro: int = 42
var decimal: float = 3.14
var negativo: int = -100

# Operações
var soma = 10 + 5      # 15
var divisao = 10 / 3   # 3.333...
var resto = 10 % 3     # 1
var potencia = 2 ** 3  # 8
```

### Texto (String)

```gdscript
var nome = "Godot"
var frase = 'Engine de jogos'
var multilinhas = """
Texto com
várias linhas
"""

# Concatenação
var completo = nome + " " + frase

# Formatação
var texto = "Olá, %s!" % nome
var numeros = "Valor: %d, Float: %.2f" % [42, 3.14159]
```

### Booleanos

```gdscript
var ligado = true
var desligado = false

# Operações lógicas
var resultado = true and false  # false
var ou = true or false          # true
var nao = not true              # false
```

## Tipos Complexos

### Vector2 (Posição 2D)

```gdscript
var posicao = Vector2(100, 200)
var velocidade = Vector2(5, -10)

# Operações
posicao += velocidade
var distancia = posicao.length()
var normalizado = velocidade.normalized()
```

### Vector3 (Posição 3D)

```gdscript
var pos3d = Vector3(10, 5, 20)
var direcao = Vector3.FORWARD  # (0, 0, -1)
```

### Color (Cores)

```gdscript
var vermelho = Color(1, 0, 0)
var verde = Color.GREEN
var transparente = Color(1, 1, 1, 0.5)

# Com hex
var azul = Color("#0000FF")
```

## Arrays (Listas)

```gdscript
var frutas = ["maçã", "banana", "laranja"]
var numeros = [1, 2, 3, 4, 5]
var misto = [1, "texto", true, Vector2(0, 0)]

# Acessar elementos
var primeira = frutas[0]  # "maçã"
var ultima = frutas[-1]   # "laranja"

# Adicionar
frutas.append("uva")
frutas.push_back("melancia")

# Remover
frutas.remove_at(0)
frutas.erase("banana")

# Tamanho
var quantidade = frutas.size()
```

## Dicionários

```gdscript
var player = {
    "nome": "Herói",
    "vida": 100,
    "mana": 50,
    "posicao": Vector2(0, 0)
}

# Acessar
var vida = player["vida"]
var nome = player.nome  # Também funciona

# Adicionar/Modificar
player["nivel"] = 5
player.experiencia = 1000

# Verificar se existe
if "nome" in player:
    print(player.nome)

# Iterar
for chave in player:
    print(chave, " = ", player[chave])
```

## Constantes

```gdscript
const VELOCIDADE_MAXIMA = 500
const GRAVIDADE = 980
const PI_PERSONALIZADO = 3.14159

# Não pode ser alterado
# VELOCIDADE_MAXIMA = 600  # ERRO!
```

## Enums (Enumerações)

```gdscript
enum Estado {
    IDLE,
    ANDANDO,
    CORRENDO,
    PULANDO
}

var estado_atual = Estado.IDLE

# Com valores personalizados
enum Direcao {
    NORTE = 0,
    SUL = 1,
    LESTE = 2,
    OESTE = 3
}
```

> 💡 **Dica**: Use tipagem estática para evitar bugs e melhorar performance!

## Conversão de Tipos

```gdscript
# Para String
var texto = str(42)        # "42"
var float_texto = str(3.14)  # "3.14"

# Para Inteiro
var numero = int("42")     # 42
var float_int = int(3.14)  # 3

# Para Float
var decimal = float("3.14")  # 3.14
var int_float = float(10)    # 10.0
```

No próximo arquivo, vamos aprender sobre **funções e métodos**!
