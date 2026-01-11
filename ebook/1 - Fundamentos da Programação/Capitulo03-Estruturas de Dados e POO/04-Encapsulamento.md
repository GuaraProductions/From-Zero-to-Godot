# Encapsulamento

**Encapsular**, como o nome sugere, significa colocar algo dentro de uma "cápsula" para protegê-lo. Na programação, esse conceito serve para controlar como os dados de um objeto são acessados ou alterados, evitando que partes externas do código façam modificações indevidas ou perigosas.

## Por que proteger seus dados?

Imagine um sistema de banco: você tem uma variável chamada `saldo`. Se qualquer parte do código pudesse simplesmente escrever `saldo = 1000000`, o banco quebraria em minutos. O encapsulamento garante que o saldo só mude através de regras seguras, como uma função de `depositar()` que verifica se o valor é positivo.

## Encapsulamento no GDScript

Diferente de linguagens como **C#** ou **Java**, o GDScript não possui palavras-chaves rígidas para "trancar" uma variável (como o `private`). Em vez disso, usamos uma **convenção** entre programadores: colocamos um underline (`_`) antes do nome da variável, como `_saldo`. Isso avisa a outros desenvolvedores: "Ei, não mexa nesta variável diretamente de fora deste script!".

## Setters e Getters (Os porteiros do código)

Para permitir o acesso controlado a essas variáveis "privadas", utilizamos funções especiais chamadas **Setters** (para configurar um valor) e **Getters** (para ler um valor). No GDScript moderno, você pode vincular essas funções diretamente à variável.

- **Getter**: Uma função que "pega" o valor e o entrega, podendo realizar cálculos antes (ex: converter segundos em minutos)
- **Setter**: Uma função que "configura" o valor, permitindo validar se a informação que está entrando é correta

## Composição da Sintaxe

Veja como definimos uma variável que usa esse controle de acesso:

```
  var  nome_propriedade  get = funcao_leitura , set = funcao_escrita
  ---  ----------------  ----------------------   -----------------------
   |          |                    |                         |
Palavra    Identifi-         Define quem              Define quem
Chave      cador             entrega o dado           guarda o dado
```

## Exemplo Prático para Testar

Copie este código para entender como o Setter impede que o nome do personagem seja registrado vazio:

```gdscript
# No arquivo Personagem.gd
var _nome_interno = "Sem Nome"

# Definindo a variável com controle de acesso
var nome: String:
	get:
		print("Alguém tentou ler o nome!")
		return _nome_interno
	set(novo_valor):
		if novo_valor != "":
			_nome_interno = novo_valor
			print("Nome alterado com sucesso!")
		else:
			print("Erro: O nome não pode ser vazio!")

# ---------------------------------------------------------

func _ready():
	# Tentativa de acesso
	nome = "Lobo Guará" # Dispara o 'set' e altera com sucesso
	nome = ""           # Dispara o 'set' e mostra a mensagem de erro
	print("Personagem atual: ", nome) # Dispara o 'get'
```

## Exemplo Prático: Funções Separadas

Às vezes, a regra de validação é complexa demais para ficar "espremida" na declaração da variável. Nesses casos, podemos criar funções normais e apenas "avisar" a variável que ela deve usá-las.

Veja como isso deixa o topo do seu script mais limpo:

```gdscript
extends Node

# Variável interna (o "cofre" onde o valor real fica guardado)
var _vida: int = 100

# Aqui nós apenas LIGAMOS a variável às funções 'obter_vida' e 'definir_vida'
var vida: int : get = obter_vida, set = definir_vida

# --- Lógica dos Getters e Setters fica separada abaixo ---

# Função Getter (Leitura)
func obter_vida():
    print("O jogo pediu o valor da vida.")
    return _vida

# Função Setter (Escrita e Validação)
func definir_vida(novo_valor):
    print("Tentando alterar a vida para: ", novo_valor)
    
    if novo_valor < 0:
        print(" > Cuidado! Vida não pode ser negativa. Travando em 0.")
        _vida = 0
    elif novo_valor > 100:
        print(" > Cura excessiva! Limitando ao máximo de 100.")
        _vida = 100
    else:
        _vida = novo_valor # Valor válido, alteração permitida
        
# ---------------------------------------------------------

func _ready():
    # Testando o sistema
    vida = 50   # Funciona normalmente
    vida = -20  # O Setter vai impedir e travar em 0
    vida = 500  # O Setter vai impedir e travar em 100
    
    print("Vida final: ", vida) # O Getter busca o valor final
```

## Por que usar este método?

- Organização: Se a sua regra de validação tiver 20 linhas de código, ela não polui a lista de variáveis no topo do arquivo.
- Reutilização: Embora raro em propriedades, tecnicamente você poderia usar a mesma função de validação para duas variáveis diferentes.

## Vantagens do Encapsulamento

✅ **Segurança**: Protege informações sensíveis contra erros acidentais

✅ **Validação**: Garante que os dados do seu jogo (vida, munição, velocidade) estejam sempre dentro de limites aceitáveis

✅ **Facilidade de Manutenção**: Se você precisar mudar como um dado é calculado, muda apenas dentro do Getter ou Setter, e o restante do jogo continuará funcionando normalmente