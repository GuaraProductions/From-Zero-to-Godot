````markdown
# Operators

In game development, you'll spend a good part of your time performing calculations and comparisons, like decreasing an enemy's health, checking if the player has enough coins, or deciding if a level has been completed. For this, GDScript offers three main types of operators.

1. Arithmetic Operators
Arithmetic operators are used to perform mathematical calculations with numerical values. They follow the logic of traditional mathematics we learned in school.

- **Addition (+)**: Adds two values.
- **Subtraction (-)**: Subtracts one value from another.
- **Multiplication (*)**: Multiplies two values.
- **Division (/)**: Divides one value by another.
- **Modulo (%)**: Returns the remainder of an integer division. For example, 11 % 2 results in 1, because 11 divided by 2 gives 5 with a remainder of 1.

### Order of Precedence
The computer follows an order of priority: multiplications, divisions, and modulos are resolved before additions and subtractions. To change this order, we use parentheses ().

```
  var  calculation  =  ( 10  +  2 )  * 5
  ---  -----------  -  -------------------
   |        |       |          |
Keyword Identi-    =    Expression with 
        fier             Parentheses
```

2. Relational Operators
These operators serve to establish the relationship between two values, comparing them and always returning a Boolean result (true or false).

- **Greater than (>)** and **Less than (<)**: Compare if one value is greater or less than another.
- **Greater or equal (>=)** and **Less or equal (<=)**: Compare including equality.
- **Equal to (==)**: Checks if two values are identical. Attention: We use two equals signs to differentiate from simple assignment.
- **Not equal to (!=)**: Checks if values are different.

3. Logical Operators
Logical operators are used to combine multiple Boolean conditions.

- **And (and)**: The expression is only true if all individual conditions are true.
- **Or (or)**: The expression is true if at least one condition is true.

## Practical Example to Test
Copy the code below to your script's _ready() function to see the operators in action in the Output panel:

```gdscript
func _ready():
	# Arithmetic Operators
	var health = 100
	health = (health - 20) + 5 # 80 + 5 = 85 
	var remainder = 11 % 2 # Result: 1 
	
	# Relational Operators
	var team_a_points = 50
	var team_b_points = 30 
	var team_a_victory = team_a_points > team_b_points # Result: true
	
	# Logical Operators
	var has_key = true
	var door_unlocked = false
	var can_pass = has_key and door_unlocked # Result: false
	
	print("Health: ", health)
	print("Victory? ", team_a_victory)
	print("Can pass? ", can_pass)
```
````
