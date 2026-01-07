# Funções e Escopo

Se as variáveis são as caixas de memória e os operadores são as ferramentas, as **funções** são as máquinas da sua fábrica. Uma função é um bloco de código que agrupa várias instruções para realizar uma tarefa específica. Em vez de escrever toda a lógica de "pular" toda vez que o jogador apertar um botão, você cria uma função chamada `pular()` e apenas a chama quando precisar.

## 1. O que é uma Função?

No GDScript, definimos uma função usando a palavra-chave `func`. Elas ajudam a manter o código organizado, legível e, principalmente, **reutilizável**. Uma função pode receber informações (parâmetros) e devolver um resultado (retorno).

### Composição da Sintaxe

```
  func  nome_da_funcao ( parametro ) :
  ----  --------------   ---------   -
   |          |             |        |
Palavra    Verbo de       Dados de  Dois-pontos
Chave      Ação           Entrada   (Inicia o bloco)
```

## 2. O Conceito de Escopo

O **escopo** é a regra que define onde uma variável "vive" e quem pode vê-la. Pense nisso como a diferença entre uma informação pública e uma conversa privada:

### Escopo Global (Variáveis de Classe)

Se você declara uma variável no topo do script, fora de qualquer função, ela é **global** para aquele arquivo. Todas as funções podem vê-la e alterá-la.

### Escopo Local

Se você declara uma variável dentro de uma função, ela só existe ali dentro. Quando a função termina de rodar, essa variável é "destruída" da memória.

## Exemplo Prático para Testar

Copie este exemplo para entender como as funções processam dados e como o escopo protege suas variáveis:

```gdscript
# VARIÁVEL GLOBAL (Escopo de Classe)
# Pode ser usada em qualquer lugar deste script
var ouro_total = 100

func _ready():
	# Chamando a nossa função personalizada
	adicionar_ouro(50)
	adicionar_ouro(25)
	
	print("Saldo final na carteira: ", ouro_total)
	
	# print(quantidade_local) -> Isso daria ERRO! 
	# A variável quantidade_local só existe dentro da função abaixo.

# Nossa função personalizada
func adicionar_ouro(quantidade_local):
	# quantidade_local é uma variável de ESCOPO LOCAL
	ouro_total = ouro_total + quantidade_local
	print("Foram adicionadas ", quantidade_local, " moedas.")
```

## Por que isso é importante?

✅ **Organização**: Funções dividem problemas grandes em partes menores

✅ **Segurança**: O escopo local evita que você altere sem querer uma variável que não deveria ser mexida por outra parte do programa

✅ **Clareza**: É muito mais fácil ler `tocar_som_explosao()` do que dez linhas de cálculos matemáticos misturadas no seu código principal

> 💡 **Dica**: Dê nomes descritivos às suas funções usando verbos de ação: `calcular_dano()`, `mover_personagem()`, `carregar_nivel()`