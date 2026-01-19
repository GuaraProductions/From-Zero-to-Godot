````markdown
# Functions and Scope

If variables are memory boxes and operators are tools, **functions** are the machines in your factory. A function is a block of code that groups several instructions to perform a specific task. Instead of writing all the logic to "jump" every time the player presses a button, you create a function called `jump()` and just call it when needed.

## 1. What is a Function?

In GDScript, we define a function using the keyword `func`. They help keep code organized, readable, and, mainly, **reusable**. A function can receive information (parameters) and return a result (return).

### Syntax Composition

```
  func  function_name ( parameter ) :
  ----  -------------   ---------   -
   |          |             |       |
Keyword   Action          Input    Colon
          Verb            Data     (Starts the block)
```

## 2. The Concept of Scope

**Scope** is the rule that defines where a variable "lives" and who can see it. Think of this as the difference between public information and a private conversation:

### Global Scope (Class Variables)

If you declare a variable at the top of the script, outside any function, it's **global** for that file. All functions can see and modify it.

### Local Scope

If you declare a variable inside a function, it only exists inside there. When the function finishes running, that variable is "destroyed" from memory.

## Practical Example to Test

Copy this example to understand how functions process data and how scope protects your variables:

```gdscript
# GLOBAL VARIABLE (Class Scope)
# Can be used anywhere in this script
var total_gold = 100

func _ready():
	# Calling our custom function
	add_gold(50)
	add_gold(25)
	
	print("Final balance in wallet: ", total_gold)
	
	# print(local_amount) -> This would give ERROR! 
	# The variable local_amount only exists inside the function below.

# Our custom function
func add_gold(local_amount):
	# local_amount is a variable with LOCAL SCOPE
	total_gold = total_gold + local_amount
	print("Added ", local_amount, " coins.")
```

## Why is this important?

✅ **Organization**: Functions divide big problems into smaller parts

✅ **Security**: Local scope prevents you from accidentally changing a variable that shouldn't be touched by another part of the program

✅ **Clarity**: It's much easier to read `play_explosion_sound()` than ten lines of mathematical calculations mixed in your main code

> 💡 **Tip**: Give descriptive names to your functions using action verbs: `calculate_damage()`, `move_character()`, `load_level()`
````
