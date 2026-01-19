# 📘 **List 1 - Programming Fundamentals**

---

## **1️⃣ Question 1 - Temperature Converter**
[open_scene](Exercise1/Exercise1.tscn) 
[open_test](List1/Exercise1)

Complete a function that converts a temperature from Celsius to Fahrenheit.  
The conversion formula is:

$$
F=(C×1.8)+32
$$

### Example:
	
- Input: 0 → Expected output: 32.00
- Input: 100 → Expected output: 212.00
- Input: -40 → Expected output: -40.00

<details> <summary>Hint 1</b></font></summary> Remember to use the formula correctly. Multiply the Celsius value by 1.8 and then add 32. </details>

---
---

## **2️⃣ Question 2 - Simple Interest Calculator**
[open_scene](Exercise2/Exercise2.tscn) 
[open_test](List1/Exercise2)

Complete a function that receives three pieces of information from the user:

- Initial capital (in money)
- Interest rate (in percentage)
- Time (in months)

Calculate the final amount (M) using the Simple Interest formula:

$$
M=C×(1+(i×t))
$$

Where:

- C is the capital
- i is the interest rate
- t is the time

### Example

- Input: C=1000, i=5%, t=12 → Expected output: 1600.00
- Input: C=500, i=10%, t=6 → Expected output: 800.00
- Input: C=2000, i=2.5%, t=10 → Expected output: 2500.00

<details> <summary>Hint 1</b></font></summary>The interest rate needs to be converted to decimal form. For example, 5% should be converted to 0.05. </details>


<details> <summary>Hint 2</b></font></summary>The formula needs to be applied correctly to calculate the amount. Do the multiplication and add to the capital. </details>

---
---

## **3️⃣ Question 3 - Grade Average and School Status Calculator**
[open_scene](Exercise3/Exercise3.tscn) 
[open_test](List1/Exercise3)

Complete a function that receives 3 student grades and calculates the final average.  
With the average in hand, return from the function:

- `"Passed"` if the average is greater than or equal to 60
- `"Recovery"` if the average is between 40 and 59
- `"Failed"` if the average is less than 40

### Example

- Input: 60, 70, 80 → Expected output: Passed
- Input: 40, 55, 50 → Expected output: Recovery
- Input: 30, 20, 40 → Expected output: Failed

<details> <summary>Hint 1</b></font></summary>To calculate the average, add all the grades and divide by the number of grades. </details>


<details> <summary>Hint 2</b></font></summary>Use conditional structures (`if`, `elif`, `else`) to check the student's status.</details>

---
---

## **4️⃣ Question 4 - Shopping Discount Calculator**
[open_scene](Exercise4/Exercise4.tscn) 
[open_test](List1/Exercise4)

Calculate and display:

- The discount amount
- The final purchase value after applying the discount
- If the final value is greater than R$ 500.00, then the customer will receive a gift

### Example

- Input: value=1000, discount=10% → Expected output: Discount: 100.00, Final: 900.00 Message: gift

<details> <summary>Hint 1</b></font></summary>Convert the discount percentage to decimal form (10% = 0.10). </details>


<details> <summary>Hint 2</b></font></summary>Calculate the discount value by multiplying the original value by the discount rate. </details>


<details> <summary>Hint 3</b></font></summary>Subtract the discount from the original value to get the final value. </details>

---
---

## **5️⃣ Question 5 - Age Group Classifier**
[open_scene](Exercise5/Exercise5.tscn) 
[open_test](List1/Exercise5)

Complete a function that receives a person's age and returns a classification:

- `"Child"` for ages 0 to 12
- `"Teenager"` for ages 13 to 17
- `"Adult"` for ages 18 to 59
- `"Senior"` for ages 60 and above

### Example

- Input: 5 → Expected output: Child
- Input: 15 → Expected output: Teenager
- Input: 30 → Expected output: Adult
- Input: 65 → Expected output: Senior

<details> <summary>Hint 1</b></font></summary>Use conditional structures to check which range the age falls into. </details>


<details> <summary>Hint 2</b></font></summary>Check the conditions in order from smallest to largest to avoid logic errors. </details>
