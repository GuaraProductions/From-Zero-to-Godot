# Funções em GDScript

Funções são blocos de código reutilizáveis que executam tarefas específicas.

## Estrutura Básica

```gdscript
func nome_da_funcao():
    print("Executando função!")
```

## Funções com Parâmetros

```gdscript
func saudar(nome):
    print("Olá, " + nome + "!")

# Chamando
saudar("Maria")  # Olá, Maria!
```

### Parâmetros com Tipo

```gdscript
func calcular_dano(ataque: int, defesa: int) -> int:
    var dano = ataque - defesa
    return max(dano, 0)

# Uso
var dano_causado = calcular_dano(50, 20)  # 30
```

## Valores Padrão

```gdscript
func criar_inimigo(vida: int = 100, velocidade: float = 5.0):
    print("Inimigo criado: Vida=%d, Velocidade=%.1f" % [vida, velocidade])

# Chamadas
criar_inimigo()              # Usa valores padrão
criar_inimigo(150)           # Vida=150, Velocidade=5.0
criar_inimigo(150, 10.0)     # Vida=150, Velocidade=10.0
```

## Retorno de Valores

```gdscript
func somar(a: int, b: int) -> int:
    return a + b

func dividir(a: float, b: float) -> float:
    if b == 0:
        push_error("Divisão por zero!")
        return 0.0
    return a / b

func obter_nome_e_nivel() -> Array:
    return ["Herói", 10]
```

## Funções Lambda (Anônimas)

```gdscript
# Função lambda simples
var quadrado = func(x): return x * x
print(quadrado.call(5))  # 25

# Usando em callbacks
var botao = Button.new()
botao.pressed.connect(func(): print("Clicou!"))

# Com múltiplas linhas
var processar = func(valor):
    var resultado = valor * 2
    resultado += 10
    return resultado
```

## Funções Especiais do Godot

### _ready()

```gdscript
func _ready():
    # Executado quando o node entra na cena
    print("Node inicializado!")
```

### _process(delta)

```gdscript
func _process(delta: float):
    # Executado todo frame
    position.x += 100 * delta
```

### _physics_process(delta)

```gdscript
func _physics_process(delta: float):
    # Executado a cada frame de física (60 FPS)
    velocity.y += GRAVIDADE * delta
```

### _input(event)

```gdscript
func _input(event: InputEvent):
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_SPACE:
            pular()
```

## Funções Estáticas

```gdscript
class_name Utils

static func calcular_distancia(a: Vector2, b: Vector2) -> float:
    return a.distance_to(b)

# Uso sem instanciar
var dist = Utils.calcular_distancia(Vector2(0, 0), Vector2(10, 10))
```

## Parâmetros Variadic (Múltiplos)

```gdscript
func somar_todos(valores: Array) -> int:
    var total = 0
    for valor in valores:
        total += valor
    return total

# Uso
var resultado = somar_todos([1, 2, 3, 4, 5])  # 15
```

## Callbacks e Sinais

```gdscript
# Definir um sinal
signal jogador_morreu
signal pontuacao_mudou(nova_pontuacao)

func _ready():
    # Conectar a uma função
    jogador_morreu.connect(_on_jogador_morreu)
    pontuacao_mudou.connect(_on_pontuacao_mudou)

func receber_dano(quantidade: int):
    vida -= quantidade
    if vida <= 0:
        jogador_morreu.emit()

func adicionar_pontos(pontos: int):
    pontuacao += pontos
    pontuacao_mudou.emit(pontuacao)

func _on_jogador_morreu():
    print("Game Over!")

func _on_pontuacao_mudou(nova_pontuacao: int):
    print("Pontuação: ", nova_pontuacao)
```

## Recursão

```gdscript
func fatorial(n: int) -> int:
    if n <= 1:
        return 1
    return n * fatorial(n - 1)

# Uso
print(fatorial(5))  # 120
```

## Boas Práticas

✅ **Nomes descritivos**: `calcular_dano()` é melhor que `cd()`
✅ **Uma responsabilidade**: Cada função faz uma coisa
✅ **Parâmetros tipados**: Ajuda a evitar erros
✅ **Comentários**: Documente funções complexas
✅ **Funções pequenas**: Mais fáceis de testar e manter

```gdscript
## Calcula o dano final após aplicar defesa
## @param ataque: Valor de ataque bruto
## @param defesa: Valor de defesa do alvo
## @return: Dano final (mínimo 1)
func calcular_dano(ataque: int, defesa: int) -> int:
    var dano = ataque - defesa
    return max(dano, 1)
```

No próximo arquivo, vamos aprender sobre **estruturas de controle**!
