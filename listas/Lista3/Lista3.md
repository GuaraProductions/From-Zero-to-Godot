### 📘 **Lista 3 - Programação Orientada a Objetos com GDScript**

**Objetivo:**
Esta lista de exercícios introduz os pilares da Programação Orientada a Objetos (POO) utilizando GDScript. 
Cada questão trabalha um ou mais pilares: **Abstração**, **Encapsulamento**, **Herança**, **Composição** e **Polimorfismo**.

Cada cena conterá classes parcialmente construídas (exceto a questão 5) e o aluno deverá completar ou criar novas classes conforme solicitado.

---

#### **1️⃣ Classe Retângulo - Abstração e Encapsulamento**

**Exemplos:**

* Entrada: base=10, altura=5 → Saída esperada: Área: 50, Perímetro: 30
* Entrada: base=7, altura=3 → Saída esperada: Área: 21, Perímetro: 20

**Tarefa:**
Complete a classe `Retangulo` com atributos privados `_base` e `_altura`. Crie métodos públicos:

* `calcular_area()` → retorna base × altura
* `calcular_perimetro()` → retorna 2 × (base + altura)

Utilize métodos `set_base()` e `set_altura()` para alterar os valores e `get_base()` / `get_altura()` para acessá-los.

Ao final, complete a função `criar_retangulo` que retorna uma instância da classe `Retangulo` para que suas informações
sejam exibidas na tela
---

#### **2️⃣ Classe Animal - Herança**

**Exemplos:**

* Cachorro.falar() → "Au au!"
* Gato.falar() → "Miau!"
* Ovelha.falar() → "Beehhh!"

**Tarefa:**
Crie uma classe base `Animal` com o método `falar()`. Em seguida, crie subclasses `Cachorro`, `Gato`, e `Ovelha`, 
sobrescrevendo o método `falar()` com a fala apropriada.

O script deve demonstrar o uso da herança com polimorfismo (chamar `animal.falar()` independentemente do tipo).

- DESAFIO: Tente fazer com que os efeitos sonoros sejam corretamente tocados no momento de pressionar
o botão "Falar" correspondente.

<details> <summary>Dica 1</b></font></summary> Use `extends` para herdar de outra classe. </details>
<details> <summary>Dica 2</b></font></summary> O método `falar()` deve ser sobrescrito em cada subclasse. </details>
<details> <summary>Dica 3</b></font></summary> A herança permite compartilhar comportamento comum e especializar o necessário. </details>

---

#### **3️⃣ Carro com Composição de Motor**

**Exemplos:**

* Entrada: potência do motor = 100 → Saída: "Motor ligado! Potência: 100"
* Entrada: potência do motor = 200 → Saída: "Motor ligado! Potência: 200"

**Tarefa:**
Implemente uma classe `Motor` com atributo `potencia` e `ligado` e deve incluir o método `ligar()`. 

Crie a classe `Carro` que **possui** um objeto `Motor`. O método `ligar_carro()` do `Carro` deve chamar `ligar()` do motor.

Esse exercício ilustra **composição**: `Carro` depende de um `Motor`, mas pode ser instanciado separadamente.

<details> <summary>Dica 1</b></font></summary> Crie o `Motor` fora do `Carro` e passe a sua instância como parâmetro do construtor do Carro </details>

---

#### **4️⃣ Cofrinho - Encapsulamento**

**Exemplos:**

* Adicionar 50 → Saldo: 50
* Adicionar 25, depois 30 → Saldo: 55
* Tentar sacar 100 com saldo 50 → Falha

**Tarefa:**
Complete a classe `Cofrinho` com atributo privado `_saldo`.

Implemente os seguintes métodos:

* Método `adicionar(valor)` soma ao saldo.
* Método `sacar(valor)` só subtrai se houver saldo suficiente. Retorne "true" se a operação for um sucesso e "false" caso o usuário não tenha saldo o suficiente para sacar
* Método `set_saldo()` configura um novo saldo . (`saldo` setter)
* Método `get_saldo()` retorna o saldo atual. (`saldo` getter)
* Método `set_nome(nome)` configura um novo nome. (`nome` setter)
* Método `get_nome(nome)` retorna o nome atual. (`nome` getter)

Não permita acesso direto ao atributo `saldo`. Use a funcionalidade do `set` e `get` para proteger os dados.

<details> <summary>Dica 1</b></font></summary> Valide a entrada no método `sacar()` para evitar saldo negativo. </details>
<details> <summary>Dica 2</b></font></summary> O encapsulamento evita que valores sejam alterados diretamente. </details>
<details> <summary>Dica 3</b></font></summary> Mantenha o `_saldo` como privado e use `get_` e `set_` com controle interno. </details>

---

#### **5️⃣ Forma - Polimorfismo e Herança**

**Exemplos:**

* Circulo(raio=5).area() → 78.54
* Quadrado(lado=4).area() → 16
* Triangulo(base=6, altura=3).area() → 9

**Tarefa:**
Crie uma classe base `Forma` com método `area()`.

Crie subclasses `Circulo`, `Quadrado` e `Triangulo`, cada uma implementando `area()` de maneira diferente.

Demonstre **polimorfismo** chamando `forma.area()` com diferentes instâncias de forma.

<details> <summary>Dica 1</b></font></summary> O método `area()` deve ser declarado na superclasse e sobrescrito nas subclasses. </details>
<details> <summary>Dica 2</b></font></summary> Use `Forma` como tipo base e substitua pelo comportamento da subclasse. </details>
<details> <summary>Dica 3</b></font></summary> O polimorfismo permite tratar diferentes objetos de forma uniforme. </details>

---
