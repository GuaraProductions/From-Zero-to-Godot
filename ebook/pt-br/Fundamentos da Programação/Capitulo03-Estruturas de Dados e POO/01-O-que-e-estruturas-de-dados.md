# O que são Estruturas de Dados?

Até agora, trabalhamos com informações isoladas, como um nome ou um número. Mas, conforme seu jogo cresce, gerenciar centenas de variáveis soltas torna-se impossível. Para entender como resolver isso, precisamos primeiro entender que nem toda "caixa" de dado é igual. Na programação, dividimos as ferramentas de armazenamento em dois grandes grupos: as **Primitivas** e as **Compostas**.

## 1. Estruturas de Dados Primitivas

As estruturas primitivas são os "átomos" da programação. Elas são os tipos de dados mais básicos que a linguagem oferece e que já vimos nos capítulos anteriores. Elas guardam apenas um único valor por vez:

- **Inteiros (int)**: Números sem casas decimais
- **Floats**: Números com casas decimais
- **Booleanos (bool)**: O estado de verdadeiro ou falso
- **Strings**: Cadeias de caracteres (texto)

Essas estruturas são fundamentais, mas são limitadas porque não conseguem agrupar informações relacionadas de forma automática.

## 2. O Papel da Tipagem (Static Typing)

No GDScript, você tem duas formas de criar as variáveis:

A. Tipagem Dinâmica: você cria uma variável sem dizer o que vai dentro.

```gdscript
var vida = 100    # O Godot entende que é um número
vida = "Mil"      # Em tipagem dinâmica, isso funciona, mas pode gerar erros no jogo!
```

B. Tipagem Estática: aqui, você define uma regra estrita. Se a variável é para guardar números inteiros, ela nunca aceitará texto. Isso evita bugs e ajuda o computador a ler seu código mais rápido.

```gdscript
var vida: int = 100
# vida = "Mil"   <-- O Godot vai te impedir de cometer esse erro antes mesmo de rodar o jogo.
```

## 3. O Operador Walrus := (O Atalho Inteligente)
Muitas vezes, escrever o tipo (: int, : String) pode ser repetitivo quando o valor já é óbvio. É aqui que entra o operador Walrus (:=).

Ele diz ao Godot: "Defina o tipo estático automaticamente baseado no valor inicial".

```gdscript
# Em vez de escrever tudo isso:
var nome_personagem: String = "Heroi"

# Você usa o Walrus para ser conciso e manter a segurança:
var nome_personagem := "Heroi" 

# O Godot viu que "Heroi" é String, então ele travou a variável como String.
# nome_personagem = 10  <-- Isso vai dar erro, igual à tipagem explícita!
```

💡 Dica : Use := sempre que iniciar uma variável com um valor conhecido. Isso deixa seu código mais limpo sem perder a segurança da tipagem estática.

## 4. Onde entram as Funções?
Se as estruturas de dados são as "caixas" que guardam a informação, as Funções são as máquinas que processam essas caixas.

Uma função bem escrita em GDScript também deve respeitar os tipos de dados que entram e saem dela:

```gdscript
# Esta função promete receber um inteiro e devolver um inteiro
func calcular_dano(forca: int) -> int:
    return forca * 2
```

- 💡 Dica : Em Estruturas de Dados, a tipagem é sua melhor amiga. Ela garante que a variável ou função que você criou seja previsível.

## 5. Estruturas de Dados Compostas (Não Primitivas)

É aqui que o jogo realmente começa. As estruturas compostas são formadas pela união de várias estruturas primitivas para criar algo mais complexo.

Existem diferentes tipos de estruturas compostas para necessidades diferentes:

### Coleções Sequenciais (Arrays)
Ótimas para quando você precisa de uma fila ou lista organizada por posição, como o inventário de um RPG.

```gdscript
# Criamos uma lista que aceita apenas Strings
func _ready() -> void:
	var inventario: Array[String] = ["Espada", "Poção", "Mapa"]

	# Acessamos pelo índice (posição), começando do 0
	print(inventario[0]) # Saída: "Espada"
	print(inventario[1]) # Saída: "Poção"
```

### Coleções Associativas (Dicionários)

Perfeitas para buscar dados através de um "nome" ou "chave", como uma ficha de personagem onde você busca por "Força" para achar o valor.

```gdscript
# O Walrus (:=) infere que isso é um Dicionário
var ficha_personagem := {
    "Nome": "Valeros",
    "Força": 18,
    "Velocidade": 12
}

# Buscamos o valor usando a chave (o nome do atributo)
print(ficha_personagem["Força"]) # Saída: 18
```
### Estruturas Personalizadas (POO)

É o que veremos nos capítulos de Programação Orientada a Objetos. Aqui, você cria sua própria estrutura (a Classe), que pode conter várias variáveis primitivas e até funções dentro dela.

```gdscript
# Exemplo de uma Classe (um molde para criar Inimigos)
class_name Inimigo

var nome: String = "Goblin"
var vida: int = 30

func atacar():
    print(nome, " causou dano!")
```

## Por que essa distinção é importante?

Entender que existem tipos diferentes de estruturas permite que você escolha a ferramenta certa para o problema certo. Veja a diferença na prática:

- Caso 1: Guardar apenas um dado isolado Se você quer apenas guardar a idade de um NPC, uma primitiva (int) basta. É leve e direto.

```gdscript
func _ready() -> void:
	var idade_npc := 45
```
- Caso 2: Guardar um grupo de dados Se você quer guardar a lista de todos os NPCs de uma fase, você precisará de uma composta (Array) e muito provavelmente, você irá querer uma classe personalizada. Tentar fazer isso com variáveis soltas seria uma bagunça.

```gdscript
# Em vez de criar var npc1, var npc2, var npc3...
# Usamos uma estrutura composta:
func _ready() -> void:
	var lista_npcs: Array[String] = [NPC.new("Guarda"), NPC.new("Ferreiro"), NPC.new("Cavaleiro")]
```