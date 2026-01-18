# Arrays

Nas aulas anteriores, definimos variáveis como espaços de memória para dados singulares. No entanto, o desenvolvimento de sistemas exige a manipulação de conjuntos de dados. A estrutura fundamental para isso é o **Array**.

Um **Array** é uma coleção ordenada de elementos. Diferente de variáveis isoladas, ele permite armazenar múltiplos valores sob um único identificador, acessíveis via índice numérico ou iteráveis sequencialmente.

## 1. Indexação e Acesso

A característica definidora de um Array é a sequencialidade. Cada elemento ocupa uma posição fixa, iniciando pelo índice 0.

Se um Array possui N elementos:

- O primeiro elemento está no índice `0`
- O último elemento está no índice `N - 1`

```gdscript
var lista = ["A", "B", "C"]
print(lista[0]) # Acesso direto ao primeiro elemento ("A")
```

## 2. Tipagem: Dinâmica vs. Estática

No GDScript, a definição do tipo de dados contido no Array impacta a segurança e a performance.

### A. Arrays Dinâmicos (Heterogêneos)

Não possuem restrição. Podem conter tipos mistos, o que reduz a otimização de memória e aumenta o risco de erros em tempo de execução.

```gdscript
var dados = [10, "Texto", true]
```

### B. Arrays Tipados (Homogêneos)

Definem estritamente o tipo permitido. O interpretador valida as inserções, garantindo integridade e maior velocidade de processamento.

```gdscript
# Sintaxe: var nome: Array[Tipo] = []
var valores: Array[int] = [10, 20, 30]
```

## 3. Manipulação de Dados (Métodos Essenciais)

Arrays são objetos que possuem métodos internos para gestão de conteúdo:

- **`append(valor)`**: Adiciona ao final da sequência
- **`insert(index, valor)`**: Insere em posição específica, deslocando os demais
- **`erase(valor)`**: Remove a primeira ocorrência do valor especificado
- **`remove_at(index)`**: Remove o elemento no índice especificado
- **`pick_random()`**: Retorna um elemento aleatório da coleção

## 4. Iteração (Percorrendo o Array)

Frequentemente, é necessário processar todos os elementos da lista sequencialmente. Para isso, utilizamos o laço de repetição `for`.

Visto que você já conhece a estrutura do `for`, focaremos na **Iteração Tipada**. Assim como tipamos a variável do Array, podemos (e devemos) tipar a variável iteradora dentro do laço. Isso instrui o compilador sobre o dado que está sendo processado, habilitando otimizações de baixo nível.

**Sintaxe:**

```gdscript
for variavel_temporaria: Tipo in nome_do_array:
    # Bloco de código
```

**Exemplo Prático:** Imagine um array de números inteiros. Ao tipar o iterador como `int`, garantimos ao sistema que `numero` será tratado matematicamente.

```gdscript
var pontuacoes: Array[int] = [10, 50, 100]

# "Para cada 'numero' (que é um inteiro) dentro de 'pontuacoes'..."
for numero: int in pontuacoes:
    print(numero * 2)
```

**Nota Técnica:** Se o Array for tipado (ex: `Array[int]`), o GDScript moderno muitas vezes infere o tipo automaticamente, mas explicitar `for i: int` é considerado uma boa prática para legibilidade e garantia de performance.

## 5. Exemplo Prático Integrado

Abaixo, aplicamos Tipagem Estática, Métodos e Iteração Tipada em um sistema de inventário.

```gdscript
extends Node

# 1. Declaração do Array Tipado
var inventario: Array[String] = ["Poção", "Mapa", "Elixir"]

func _ready():
    print("--- Processando Inventário ---")
    
    # Adicionamos um item novo antes de processar
    inventario.append("Espada")
    
    # 2. Iteração com Variável Tipada
    # Usamos ': String' pois sabemos que o array só contém textos.
    for item: String in inventario:
        
        # Verificamos cada item individualmente
        if item == "Mapa":
            print("Item de Quest encontrado: ", item)
        else:
            print("Item comum: ", item)
            
    # 3. Exibição do tamanho final
    print("Total de itens processados: ", inventario.size())
```