# Dicionários

Enquanto os Arrays organizam dados sequencialmente através de índices numéricos (0, 1, 2...), existem cenários onde acessar dados por "posição" é ineficiente ou ilógico. Para esses casos, utilizamos o **Dicionário** (`Dictionary`).

Um **Dicionário** é uma coleção não-ordenada de dados estruturada no formato **Chave-Valor** (Key-Value Pair). Em vez de um número, você utiliza uma chave única (geralmente uma String) para armazenar e recuperar um valor.

## 1. O Conceito de Mapeamento

A principal característica do Dicionário é a **associação direta**. Você não pergunta "o que está na posição 0?", você pergunta "qual é o valor associado à chave 'Força'?".

- **Chave (Key)**: O identificador único (o "rótulo")
- **Valor (Value)**: O dado armazenado

**Comparativo Visual:**

- **Array:** `[10, 20, 30]` (Acesso via índice: 0, 1, 2)
- **Dicionário:** `{"Vida": 10, "Mana": 20}` (Acesso via chave: "Vida", "Mana")

## 2. Tipagem: Dinâmica vs. Estática

Assim como nos Arrays, o GDScript moderno permite e encoraja a tipagem estrita de Dicionários para garantir a integridade dos dados.

### A. Dicionários Dinâmicos

Aceitam qualquer tipo de chave e qualquer tipo de valor.

```gdscript
var dados = {"Nome": "Heroi", 1: "Nível"} # Chaves mistas (String e Int)
```

### B. Dicionários Tipados

No Godot 4, podemos definir explicitamente o tipo da Chave e o tipo do Valor.

**Sintaxe:** `var nome: Dictionary[TipoChave, TipoValor] = {}`

```gdscript
# Um dicionário onde a Chave é String e o Valor é Inteiro
var atributos: Dictionary[String, int] = {
    "Força": 18,
    "Destreza": 14
}

# atributos["Inteligência"] = "Alta" # ERRO: O valor deve ser int, não String.
```

## 3. Manipulação de Dados

A manipulação de dicionários difere dos Arrays, pois não usamos métodos como `append`. A inserção e a edição são feitas diretamente pela chave.

### Inserção e Modificação

Se a chave não existe, ela é criada. Se já existe, o valor é sobrescrito.

```gdscript
var ficha: Dictionary[String, int] = {}

# Inserindo
ficha["Vida"] = 100 

# Modificando
ficha["Vida"] = 90
```

### Remoção

- **`erase(chave)`**: Remove o par chave-valor do dicionário

```gdscript
ficha.erase("Vida")
```

- **`clear()`**: Remove todos os registros
- **`make_read_only()`**: Trava o dicionário, impedindo modificações futuras

### Verificação de Existência (Crítico)

Tentar acessar uma chave que não existe pode gerar erros ou comportamentos inesperados. Sempre verifique antes.

- **`has(chave)`**: Retorna `true` se a chave existe

```gdscript
if ficha.has("Mana"):
    print(ficha["Mana"])
```

## 4. Iteração (Percorrendo o Dicionário)

Ao utilizar o laço `for` em um dicionário, o padrão do GDScript é iterar sobre as **Chaves**.

Para manter a segurança e a performance, utilizamos a iteração tipada, declarando o tipo da variável que receberá a chave.

**Sintaxe:**

```gdscript
for chave: TipoChave in dicionario:
    var valor = dicionario[chave]
```

**Exemplo:**

```gdscript
var precos: Dictionary[String, int] = {"Espada": 100, "Escudo": 50}

# A variável 'item' assumirá as chaves ("Espada", "Escudo")
for item: String in precos:
    var valor: int = precos[item]
    print("O item ", item, " custa ", valor)
```

## 5. Exemplo Prático Integrado

Abaixo, simulamos uma "Ficha de Personagem" simples. Note como a estrutura `Dictionary[String, int]` é ideal para gerenciar atributos numéricos nomeados.

```gdscript
extends Node

# Declaração: Chaves são Nomes (String), Valores são Níveis (int)
var habilidades: Dictionary[String, int] = {
    "Força": 10,
    "Agilidade": 12,
    "Inteligência": 8
}

func _ready():
    print("--- Ficha Inicial ---")
    
    # 1. Adicionando um novo atributo dinamicamente
    habilidades["Sorte"] = 5
    print("Atributo Sorte aprendido.")
    
    # 2. Modificando um valor existente (Level Up)
    if habilidades.has("Força"):
        habilidades["Força"] += 5 # Aumenta de 10 para 15
        
    # 3. Iteração Tipada para listar tudo
    print("\n--- Status Atualizados ---")
    
    # 'atributo' será a chave (String)
    for atributo: String in habilidades:
        var valor: int = habilidades[atributo]
        
        # Lógica condicional baseada no valor
        if valor >= 15:
            print(atributo, ": ", valor, " (Mestre)")
        else:
            print(atributo, ": ", valor)

    # 4. Remoção
    # Vamos remover Inteligência para simular uma maldição
    habilidades.erase("Inteligência")
    print("\nTotal de atributos restantes: ", habilidades.size())
```