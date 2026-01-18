# 📘 **List 2 - GDScript Exercises with Interface and Loops**

---

## **1️⃣ Adder with Loops**
[open_scene](Exercise1/Exercise1.tscn) 
[open_test](List2/Exercise1)

Complete a function that sums all numbers from 1 to N (inclusive).

### Example

- Input: 5 → Expected output: Sum: 15
- Input: 1 → Expected output: Sum: 1
- Input: 10 → Expected output: Sum: 55

<details> <summary>Hint 1</b></font></summary> Use `for i in range(1, N + 1):` to iterate from 1 to N. </details>
<details> <summary>Hint 2</b></font></summary> Create an accumulator variable (`var sum = 0`) and add values inside the loop. </details>
<details> <summary>Hint 3</b></font></summary> Keep adding "i" to "sum" inside the loop. </details>

---
---

## **2️⃣ Multiplication Table of a Number**
[open_scene](Exercise2/Exercise2.tscn) 
[open_test](List2/Exercise2)

Complete a function that calculates the multiplication table for numbers from 1 to 10, for operations from 1 to n.

**Note:** The function itself returns nothing (since it's void type), you need to use the `add_multiplication_table` function to add the results of your calculations.

### Output example:

![example](Exercise2/Exemplo-saida.jpg)

<details> <summary>Hint 1</b></font></summary> Use `for i in range(1, 11):` to generate from 1 to 10 </details>
<details> <summary>Hint 2</b></font></summary> In each iteration, calculate `i * N` </details>

---
---

## **3️⃣ Counter of Multiples of 3**
[open_scene](Exercise3/Exercise3.tscn) 
[open_test](List2/Exercise3)

Complete a function that returns how many numbers between 1 and N are multiples of 3.

### Example

- Input: 10 → Expected output: Multiples of 3: 3
- Input: 3 → Expected output: Multiples of 3: 1
- Input: 30 → Expected output: Multiples of 3: 10

<details> <summary>Hint 1</b></font></summary> Use `for i in range(1, N + 1):` </details>
<details> <summary>Hint 2</b></font></summary> Check `if i % 3 == 0` </details>
<details> <summary>Hint 3</b></font></summary> Use a variable and a conditional structure whenever you find a multiple </details>

---
---

## **4️⃣ Factorial of a Number**
[open_scene](Exercise4/Exercise4.tscn) 
[open_test](List2/Exercise4)

Complete a function that calculates the factorial of `N`.

### Example

- Input: 3 → Expected output: Factorial: 6
- Input: 5 → Expected output: Factorial: 120
- Input: 0 → Expected output: Factorial: 1

<details> <summary>Hint 1</b></font></summary> The factorial is the product of all positive integers up to N: `N * (N-1) * ... * 1` </details>
<details> <summary>Hint 2</b></font></summary> Use `for i in range(1, N + 1): result *= i` </details>

---
---

## **5️⃣ Sum of Even Numbers between 1 and N**
[open_scene](Exercise5/Exercise5.tscn) 
[open_test](List2/Exercise5)

Complete a function that calculates the sum of even numbers between 1 and N (inclusive).

### Example

- Input: 6 → Expected output: Sum of evens: 12
- Input: 5 → Expected output: Sum of evens: 6
- Input: 10 → Expected output: Sum of evens: 30

<details> <summary>Hint 1</b></font></summary> Inside the loop, use `if i % 2 == 0` to check if the number is even </details>
<details> <summary>Hint 2</b></font></summary> Add the even values to a `sum` variable initialized with 0 </details>

---
