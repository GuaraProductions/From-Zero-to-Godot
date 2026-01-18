# Paradigmas de Programação

Os **paradigmas de programação** podem parecer um nome complicado, mas eles são apenas diferentes estilos ou maneiras de organizar o seu raciocínio para resolver problemas usando código. Imagine que a programação é como a arte de construir algo: você pode usar diferentes métodos ou "estilos de arquitetura" para chegar ao mesmo resultado final. Como as linguagens evoluíram muito ao longo do tempo, foram criados esses conjuntos de regras e padrões que ajudam os programadores a decidir como os dados e as instruções devem ser estruturados dentro de um software.

## Paradigma Imperativo e Procedural

Um dos estilos mais comuns, e que você verá muito no início, é o **paradigma imperativo**, que funciona como uma lista de ordens diretas para o computador. Nesse modelo, você diz exatamente o que a máquina deve fazer passo a passo, e cada comando altera o estado interno do programa, como se você estivesse movendo peças em um tabuleiro.

## Exemplo de código que usa o paradigma imperativo

```
# Algoritmo: Calculadora de Soma

Início 
  Ler o primeiro valor e armazenar na variável A 
  Ler o segundo valor e armazenar na variável B 
  Calcular a soma de A mais B 
  Armazenar o resultado da soma na variável C 
  Exibir (imprimir) o valor de C na tela 
Fim
```

Junto a ele, temos o **paradigma procedural**, que ajuda a organizar a bagunça dividindo o código em blocos menores chamados de **funções** ou **procedimentos**. Em vez de ter um texto gigante e confuso, você separa as tarefas em partes específicas que podem ser repetidas sempre que necessário.

```
Função CalcularArea(b, h):
    Resultado = b * h
    Retornar Resultado

Início
    Exibir "Digite a base:"
    Ler valor_base
    
    Exibir "Digite a altura:"
    Ler valor_altura
    
    # O programa chama a função enviando os dados
    ÁreaFinal = CalcularArea(valor_base, valor_altura)
    
    Exibir "O resultado final é: " + ÁreaFinal
Fim
```

Existem diversos paradigmas no mundo da computação, e mostrar todos para vocês nesse momento não seria muito ideal. Mas para nós, tem mais um que é importante que vocês conheçam, o chamado **POO**.

## Programação Orientada a Objetos (POO)

O conceito mais avançado que as Engines e Linguagens de Programação modernas utilizam é a **Programação Orientada a Objetos (POO)**. Embora esse tema seja explorado mais a fundo quando falamos de Nodes na Godot, a ideia central da POO é organizar o programa em torno de "objetos" que possuem suas próprias características e comportamentos.

Entender esses diferentes estilos é muito importante porque a maioria das linguagens famosas, como **Java**, **Python** e **C++**, mistura esses conceitos para facilitar a vida do desenvolvedor. Assim, ao aprender os paradigmas que o GDScript utiliza, você não está apenas aprendendo a mexer na Godot, mas ganhando uma base que serve para quase todas as outras tecnologias do mercado.

```
# Algoritmo: Sistema de Geometria (POO)

Classe Retangulo:
  Atributos: base, altura
  
  Método CalcularArea():
    Retornar base * altura

Início
  # Criando uma instância do objeto
  Criar objeto "meuRetangulo" da Classe Retangulo
  
  Exibir "Defina a base:"
  Definir meuRetangulo.base = valor lido
  
  Exibir "Defina a altura:"
  Definir meuRetangulo.altura = valor lido
  
  # O objeto executa sua própria lógica
  Exibir "A área é: " + meuRetangulo.CalcularArea()
Fim
```