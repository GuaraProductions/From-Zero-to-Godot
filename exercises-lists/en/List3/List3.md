# 📘 **List 3 - Object-Oriented Programming with GDScript**

---

## **1️⃣ Rectangle Class - Abstraction and Encapsulation**
[open_scene](Exercise1/Exercise1.tscn) 
[open_test](List3/Exercise1)

### Examples:

* Input: width=10, height=5 → Expected output: Area: 50, Perimeter: 30
* Input: width=7, height=3 → Expected output: Area: 21, Perimeter: 20

### Task:

Complete the `Rectangle` class with private attributes `_width` and `_height`. Create public methods:

* `calculate_area()` → returns width × height
* `calculate_perimeter()` → returns 2 × (width + height)

Use `set_width()` and `set_height()` methods to change values and `get_width()` / `get_height()` to access them.

Finally, complete the `create_rectangle` function that returns an instance of the `Rectangle` class so its information
can be displayed on screen

---
---

## **2️⃣ Animal Class - Inheritance**
[open_scene](Exercise2/Exercise2.tscn) 
[open_test](List3/Exercise2)

### Examples:

* Dog.speak() → "Woof woof!"
* Cat.speak() → "Meow!"
* Sheep.speak() → "Baaah!"

### Task:

Create a base `Animal` class with the `speak()` method. Then, create `Dog`, `Cat`, and `Sheep` subclasses, 
overriding the `speak()` method with the appropriate sound.

The script should demonstrate the use of inheritance with polymorphism (calling `animal.speak()` regardless of type).

**Challenge:** Try to make the sound effects play correctly when pressing the corresponding "Speak" button.

<details> <summary>Hint 1</b></font></summary> Use `extends` to inherit from another class. </details>
<details> <summary>Hint 2</b></font></summary> The `speak()` method must be overridden in each subclass. </details>
<details> <summary>Hint 3</b></font></summary> Inheritance allows sharing common behavior and specializing what's necessary. </details>

---
---

## **3️⃣ Car with Engine Composition**
[open_scene](Exercise3/Exercise3.tscn) 
[open_test](List3/Exercise3)

### Examples:

* Input: engine power = 100 → Output: "Engine started! Power: 100"
* Input: engine power = 200 → Output: "Engine started! Power: 200"

### Task:

Implement an `Engine` class with `power` and `running` attributes and must include the `start()` method. 

Create the `Car` class that **has** an `Engine` object. The `start_car()` method of `Car` should call the engine's `start()`.

This exercise illustrates **composition**: `Car` depends on an `Engine`, but can be instantiated separately.

<details> <summary>Hint 1</b></font></summary> Create the `Engine` outside of `Car` and pass its instance as a parameter to the Car constructor </details>

---
---

## **4️⃣ Piggy Bank - Encapsulation**
[open_scene](Exercise4/Exercise4.tscn) 
[open_test](List3/Exercise4)

### Examples:

* Add 50 → Balance: 50
* Add 25, then 30 → Balance: 55
* Try to withdraw 100 with balance 50 → Fails

### Task:

Complete the `PiggyBank` class with private `_balance` attribute.

Implement the following methods:

* Method `add(amount)` adds to the balance.
* Method `withdraw(amount)` only subtracts if there's enough balance. Return "true" if the operation is successful and "false" if the user doesn't have enough balance to withdraw
* Method `set_balance()` sets a new balance. (`balance` setter)
* Method `get_balance()` returns the current balance. (`balance` getter)
* Method `set_name(name)` sets a new name. (`name` setter)
* Method `get_name(name)` returns the current name. (`name` getter)

Don't allow direct access to the `balance` attribute. Use the `set` and `get` functionality to protect the data.

<details> <summary>Hint 1</b></font></summary> Validate input in the `withdraw()` method to avoid negative balance. </details>
<details> <summary>Hint 2</b></font></summary> Encapsulation prevents values from being changed directly. </details>
<details> <summary>Hint 3</b></font></summary> Keep `_balance` private and use `get_` and `set_` with internal control. </details>

---
---

## **5️⃣ Shape - Polymorphism and Inheritance**
[open_scene](Exercise5/Exercise5.tscn) 
[open_test](List3/Exercise5)

### Examples:

* Circle(radius=5).area() → 78.54
* Square(side=4).area() → 16
* Triangle(base=6, height=3).area() → 9

### Task:

Create a base `Shape` class with `area()` method.

Create `Circle`, `Square` and `Triangle` subclasses, each implementing `area()` differently.

Demonstrate **polymorphism** by calling `shape.area()` with different shape instances.

<details> <summary>Hint 1</b></font></summary> The `area()` method should be declared in the superclass and overridden in subclasses. </details>
<details> <summary>Hint 2</b></font></summary> Use `Shape` as the base type and replace with subclass behavior. </details>
<details> <summary>Hint 3</b></font></summary> Polymorphism allows treating different objects uniformly. </details>

---
