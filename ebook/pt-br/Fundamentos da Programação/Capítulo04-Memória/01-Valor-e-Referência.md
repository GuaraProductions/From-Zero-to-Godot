# Valor e Referência

Para fechar o nosso entendimento sobre como a Engine e o GDScript lidam com os dados, precisamos olhar para "debaixo do capô" e entender como as informações são guardadas na memória do computador. Existem duas formas principais de manipular dados: **por Valor** e **por Referência**.

## 1. Passagem por Valor (Tipos Primitivos)

Quando trabalhamos com tipos de dados simples, conhecidos como **primitivos** (como `int`, `float` e `bool`), o computador lida com eles **por valor**.

Imagine que você tem uma variável `A` e diz que `B = A`. No caso do valor, o computador cria uma **cópia idêntica** do dado em um novo lugar da memória. Se você passar um desses tipos como parâmetro para uma função e alterá-lo lá dentro, a variável original que estava fora da função **não sofrerá nenhuma alteração**, pois a função recebeu apenas uma cópia.

## 2. Passagem por Referência (Objetos e Estruturas)

Aqui é onde o conhecimento de POO e Estruturas de Dados se torna vital. Quando trabalhamos com **Objetos**, **Instâncias de classes**, **Arrays** ou **Dicionários**, o GDScript não copia o conteúdo inteiro, mas sim o **endereço** (a referência) de onde aquele dado está na memória.

Uma **referência** é como um "link". Se você passar um objeto para uma função, a função não recebe uma cópia, mas sim o acesso direto ao objeto original. Qualquer alteração feita dentro da função afetará o objeto em todo o jogo.

## Exemplo Prático: Passagem de Parâmetros

O uso de funções é a melhor forma de visualizar esse comportamento. Teste o código abaixo para ver a diferença:

```gdscript
func _ready():
	# TESTE POR VALOR
	var minha_vida = 100
	alterar_valor(minha_vida)
	print("Vida fora da função: ", minha_vida) # Continua 100 

	# TESTE POR REFERÊNCIA
	var meu_inventario = ["Espada"]
	alterar_referencia(meu_inventario)
	print("Inventário fora da função: ", meu_inventario) # Agora tem ["Espada", "Escudo"] 

# Recebe um Inteiro (Passagem por Valor)
func alterar_valor(vida_copiada):
	vida_copiada = 50 # Altera apenas a cópia local 
	print("Vida dentro da função: ", vida_copiada)

# Recebe um Array (Passagem por Referência)
func alterar_referencia(lista_original):
	lista_original.append("Escudo") # Altera o objeto original na memória 
	print("Inventário dentro da função: ", lista_original)
```

## O Gerenciamento de Memória na Godot

A Engine utiliza um sistema chamado **RefCounted** (Contagem de Referências) para gerenciar a vida desses objetos. Funciona assim:

1. O computador conta quantas variáveis estão "apontando" para um objeto
2. Enquanto houver pelo menos uma referência ativa, o objeto continua vivo
3. Quando a contagem chega a zero (ninguém mais aponta para ele), a Engine apaga o objeto automaticamente para liberar memória

## Por que isso é importante?

✅ **Performance**: Passar uma referência é instantâneo, enquanto copiar um Array com 10.000 itens a cada função deixaria o jogo lento

✅ **Consistência**: Garante que, ao dar um item para o jogador, todas as partes do sistema (HUD, Inventário, Loja) vejam o mesmo objeto atualizado