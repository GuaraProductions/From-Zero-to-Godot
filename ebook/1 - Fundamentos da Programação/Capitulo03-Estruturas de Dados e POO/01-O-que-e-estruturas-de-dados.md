# O que são Estruturas de Dados?

Até agora, trabalhamos com informações isoladas, como um nome ou um número. Mas, conforme seu jogo cresce, gerenciar centenas de variáveis soltas torna-se impossível. Para entender como resolver isso, precisamos primeiro entender que nem toda "caixa" de dado é igual. Na programação, dividimos as ferramentas de armazenamento em dois grandes grupos: as **Primitivas** e as **Compostas**.

## 1. Estruturas de Dados Primitivas

As estruturas primitivas são os "átomos" da programação. Elas são os tipos de dados mais básicos que a linguagem oferece e que já vimos nos capítulos anteriores. Elas guardam apenas um único valor por vez:

- **Inteiros (int)**: Números sem casas decimais
- **Floats**: Números com casas decimais
- **Booleanos (bool)**: O estado de verdadeiro ou falso
- **Strings**: Cadeias de caracteres (texto)

Essas estruturas são fundamentais, mas são limitadas porque não conseguem agrupar informações relacionadas de forma automática.

## 2. Estruturas de Dados Compostas (Não Primitivas)

É aqui que o jogo realmente começa. As estruturas compostas são formadas pela união de várias estruturas primitivas para criar algo mais complexo. Elas funcionam como "estantes" ou "contêineres".

Existem diferentes tipos de estruturas compostas para necessidades diferentes:

### Coleções Sequenciais (Arrays)

Ótimas para quando você precisa de uma fila ou lista organizada por posição, como o inventário de um RPG.

### Coleções Associativas (Dicionários)

Perfeitas para buscar dados através de um "nome" ou "chave", como uma ficha de personagem onde você busca por "Força" para achar o valor.

### Estruturas Personalizadas (POO)

É o que veremos nos capítulos de Programação Orientada a Objetos. Aqui, você cria sua própria estrutura (a Classe), que pode conter várias variáveis primitivas e até funções dentro dela.

## Por que essa distinção é importante?

Entender que existem tipos diferentes de estruturas permite que você escolha a ferramenta certa para o problema certo:

- Se você quer apenas guardar a **idade de um NPC**, uma primitiva (`int`) basta
- Se você quer guardar a **lista de todos os NPCs** da cidade, você precisará de uma composta (`Array`)

## Exemplo Prático de Contextualização

Veja como as primitivas se unem para formar uma estrutura composta no seu código:

```gdscript
func _ready():
	# ESTRUTURAS PRIMITIVAS (Dados isolados)
	var item_nome = "Espada"    # String
	var item_dano = 15          # Int
	var item_raro = false       # Bool
	
	# ESTRUTURA COMPOSTA (Agrupando primitivas em um Array)
	# Aqui, uma única "estante" guarda várias primitivas
	var mochila = ["Espada", "Escudo", "Poção"]
	
	print("Você pegou seu primeiro item: ", mochila[0]) 
```

> 💡 **Importante**: Com essa visão clara de que existem ferramentas básicas (primitivas) e ferramentas de organização (compostas), estamos prontos para explorar a fundo a lista mais comum de todas: os Arrays.