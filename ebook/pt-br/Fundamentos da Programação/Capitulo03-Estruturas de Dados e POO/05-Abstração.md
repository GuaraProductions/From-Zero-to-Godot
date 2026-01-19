# Abstração

Dando continuidade aos nossos estudos sobre os pilares da POO, chegamos a um conceito que parece abstrato pelo nome, mas que você aplica todos os dias na vida real: a **Abstração**.

Na programação, **abstrair** significa simplificar. É a capacidade de focar apenas nos aspetos essenciais de um objeto para o seu jogo, ignorando detalhes que não importam para aquele momento. Imagine que você está a programar um carro:

- Para um **jogo de corrida**, a "abstração" de carro precisa ter **velocidade** e **direção**
- Para um **simulador de mecânico**, a abstração precisaria ter o **nível de óleo** e o **estado das velas**

O objeto é o mesmo, mas a forma como o "abstraímos" muda conforme a necessidade.

## O Molde dos Moldes

Muitas vezes, criamos classes que servem apenas como um **conceito geral** e nunca serão usadas para criar um objeto direto. Por exemplo, você nunca vê um "Animal" genérico na rua; você vê um cão, um gato ou um papagaio. No código, o `Animal` seria uma **classe abstrata**: um molde que serve de base para outros moldes mais específicos.

## Abstração na Godot

A Engine utiliza a abstração para permitir que você trate objetos diferentes de forma igual. Se você tiver uma função chamada `atacar()`, não importa se quem está a atacar é um "Guerreiro" ou um "Mago"; desde que ambos herdem de uma classe abstrata `Personagem`, a Engine consegue lidar com o comando sem precisar saber os detalhes internos de cada um.

## Composição da Sintaxe (Ideia de Abstração)

A abstração não tem uma palavra-chave única, ela é um conceito de design. Veja como pensamos nela:

```
  CLASSE ABSTRATA: "Veiculo" (Apenas a ideia)
  -----------------------------------------
  - mover()
  - parar()

  CLASSE REAL: "Carro" (A implementação)
  -----------------------------------------
  - mover(): Liga o motor e acelera
  
  CLASSE REAL: "Bicicleta" (A implementação)
  -----------------------------------------
  - mover(): Pedala e mantém o equilíbrio
```

## Exemplo Prático para Testar

Veja como podemos criar um sistema onde o script principal não precisa saber detalhes dos filhos, apenas o que eles "abstraem":

**Arquivo: Habilidade.gd (Nossa base abstrata)**

```gdscript
class_name Habilidade
extends Node

func usar():
	print("Esta habilidade não faz nada sozinha.")
```

**Arquivo: BolaDeFogo.gd**

```gdscript
extends Habilidade

func usar():
	print("Lançando uma bola de fogo explosiva!")
```

**No seu Script Principal**

```gdscript
func _ready():
	# Abstraímos 'BolaDeFogo' como sendo apenas uma 'Habilidade'
	var minha_magia: Habilidade = BolaDeFogo.new()
	
	# O código abaixo não sabe que é fogo, ele apenas sabe 
	# que habilidades podem ser "usadas".
	minha_magia.usar()
```

## Vantagens da Abstração

✅ **Foco no Essencial**: Reduz a confusão ao esconder detalhes técnicos desnecessários

✅ **Flexibilidade**: Permite criar sistemas genéricos que funcionam com qualquer objeto que siga o mesmo "contrato" lógico

✅ **Organização**: Ajuda a separar o "o quê o objeto faz" do "como ele faz"