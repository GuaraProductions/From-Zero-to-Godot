# 📘 **Lista 2 - Exercícios em GDScript com Interface e Repetição**

---

## **1️⃣ Somador com Repetição**

- Complete uma função que some todos números de 1 até N (incluso)

### Exemplo

- Entrada: 5 → Saída esperada: Soma: 15
- Entrada: 1 → Saída esperada: Soma: 1
- Entrada: 10 → Saída esperada: Soma: 55

<details> <summary>Dica 1</b></font></summary> Use `for i in range(1, N + 1):` para percorrer de 1 até N. </details>
<details> <summary>Dica 2</b></font></summary> Crie uma variável acumuladora (`var soma = 0`) e vá somando os valores dentro do loop. </details>
<details> <summary>Dica 3</b></font></summary> Vá somando de "i" com "soma" dentro do loop. </details>

---

#### **2️⃣ Tabuada de um Número**

- Complete uma função que calcule a tabuada dos números de 1 até 10, das operações que vão de 1 até n

Obs.: A função em si não retorna nada (já que é do tipo void), você precisa usar a função `adicionar_tabuada` para adicionar os resultados dos seus cálculos

### Exemplo de saída:

![exemplo](Exercicio2/Exemplo-saida.jpg)

<details> <summary>Dica 1</b></font></summary> Use `for i in range(1, 11):` para gerar de 1 a 10 </details>
<details> <summary>Dica 2</b></font></summary> Em cada iteração, calcule `i * N` </details>

---

#### **3️⃣ Contador de Múltiplos de 3**

- Complete uma função que retorne quantos números entre 1 e N são múltiplos de 3.

### Exemplo

- Entrada: 10 → Saída esperada: Múltiplos de 3: 3
- Entrada: 3 → Saída esperada: Múltiplos de 3: 1
- Entrada: 30 → Saída esperada: Múltiplos de 3: 10

<details> <summary>Dica 1</b></font></summary> Use `for i in range(1, N + 1):` </details>
<details> <summary>Dica 2</b></font></summary> Verifique `if i % 3 == 0` </details>
<details> <summary>Dica 3</b></font></summary> Use uma variável e uma estrutura condicional sempre que encontrar um múltiplo </details>

---

#### **4️⃣ Fatorial de um Número**

- Complete uma função que calcula o fatorial de `N`

### Exemplo

- Entrada: 3 → Saída esperada: Fatorial: 6
- Entrada: 5 → Saída esperada: Fatorial: 120
- Entrada: 0 → Saída esperada: Fatorial: 1

<details> <summary>Dica 1</b></font></summary> O fatorial é o produto de todos os inteiros positivos até N: `N * (N-1) * ... * 1` </details>
<details> <summary>Dica 2</b></font></summary> Use `for i in range(1, N + 1): resultado *= i` </details>
---

#### **5️⃣ Soma dos Pares entre 1 e N**

- Complete uma função que calcula a soma dos números pares entre 1 e N (incluso).

### Exemplo

- Entrada: 6 → Saída esperada: Soma dos pares: 12
- Entrada: 5 → Saída esperada: Soma dos pares: 6
- Entrada: 10 → Saída esperada: Soma dos pares: 30

<details> <summary>Dica 1</b></font></summary> Dentro do loop, use `if i % 2 == 0` para verificar se o número é par </details>
<details> <summary>Dica 2</b></font></summary> Some os valores pares em uma variável `soma` inicializada com 0 </details>

---
