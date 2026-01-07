# Object, RefCounted e Node

Para encerrarmos o nosso ebook, vamos entender como a Godot organiza tudo o que vimos até agora (Classes, Objetos, Herança e Memória) dentro da sua própria estrutura interna. Na Engine, quase tudo o que você toca segue uma **hierarquia de "nascimento"** que define como aquele objeto se comporta e como ele morre.

Abaixo, explicamos os três níveis principais dessa árvore genealógica:

## 1. Object (O Ancestral Comum)

O **Object** é a classe base de absolutamente tudo na Godot. Se algo existe na Engine, ele é, no fundo, um `Object`.

### O que ele faz

Ele fornece as funções mais básicas, como a capacidade de emitir **sinais** (Signals) e de saber qual é a sua classe.

### Memória

O Object puro **não se limpa sozinho**. Se você criar um Object manualmente via código, você precisa deletá-lo manualmente com a função `.free()`, ou ele causará um **vazamento de memória** (Memory Leak).

## 2. RefCounted (O Gerente de Memória)

A maioria das classes que não são "visíveis" na tela (como scripts de lógica pura) herda de **RefCounted**. Ele é um filho de `Object` que aprendeu a se gerenciar.

### O que ele faz

Como vimos no capítulo anterior, ele usa a **Contagem de Referências**. Ele conta quantos "links" apontam para ele; quando ninguém mais o chama, ele se deleta sozinho.

### Uso

É a base para **recursos** (Resources) e para a maioria das classes que você cria com `class_name`.

## 3. Node (O Bloco de Construção)

O **Node** é o filho mais famoso da família. Ele herda de `Object`, mas tem superpoderes para o desenvolvimento de jogos.

### A Árvore de Cenas

Diferente do `RefCounted`, o Node **não morre por contagem de referências**. Ele vive enquanto estiver "pendurado" na **Árvore de Cenas** (Scene Tree). Se você deletar um Node "Pai", todos os seus "Filhos" são deletados juntos.

### O que ele faz

Ele possui as funções de ciclo de vida que você já conhece, como `_ready()`, `_process()` e `_input()`.

## Composição da Sintaxe (A Hierarquia)

Veja como esses conceitos se empilham. Cada nível abaixo possui tudo o que o nível acima tem, e mais um pouco:

```
 [ Object ]      --> "Eu existo e emito sinais"
     ▲
     │
 [ RefCounted ]  --> "Eu existo e sei me deletar da memória sozinho"
     ▲
     │
 [  Node  ]      --> "Eu existo, estou na cena e recebo comandos do jogo"
```

## Exemplo Prático: Como eles "morrem"

No código abaixo, veja a diferença de comportamento entre um objeto que se limpa sozinho e um Node:

```gdscript
func _ready():
	# EXEMPLO COM REFCOUNTED
	var meu_dado = RefCounted.new()
	# Assim que esta função '_ready' terminar, a variável 'meu_dado' 
	# deixa de existir, a contagem vai a zero e ele se deleta sozinho.

	# EXEMPLO COM NODE
	var meu_sprite = Sprite2D.new()
	add_child(meu_sprite) 
	# O Sprite2D é um Node. Ele não morre ao fim da função porque 
	# agora ele é "filho" da cena. Ele só morrerá se usarmos:
	meu_sprite.queue_free() 
```

## Por que entender isso?

> ⚠️ **Importante**: Saber a diferença entre eles evita que seu jogo trave por falta de memória. 

- Se você precisa de algo para **processar cálculos matemáticos**, use um `RefCounted`
- Se você precisa de algo que **apareça na tela** ou interaja com o tempo do jogo, use um `Node`

---

🎉 **Parabéns!** Você concluiu o ebook "Fundamentos da Programação"! Agora você tem uma base sólida para criar jogos incríveis na Godot Engine!