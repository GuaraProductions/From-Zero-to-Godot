````markdown
# Variables, Assignment, and Declaration

Now that you understand what a language is and how logic works, it's time to learn to write your first commands. The most fundamental concept in programming is variables. You can imagine a variable as a small empty "box" inside the computer's memory, where you store information to use later. Without variables, the computer would have no way to store data during program execution.

## Declaration and Identifiers

To create this "box," we use a process called declaration. In GDScript, you notify the Engine that you want to create a new variable using the reserved word var. Next, you must choose a name for it, which we call an identifier. This name is arbitrary and can be anything that helps you identify the data, like pingo, vida, or pontuacao. Declaring is simply saying: "Hey, Engine, reserve a space in memory with this name."

## Assignment

After declaring the variable, you need to put a value inside it through assignment. We use the equals symbol (=) for this task. In programming, the = works as an order to "store the value on the right inside the variable that's on the left." You can also perform declaration and assignment on the same line, which makes the code more practical.

## Syntax Composition

See below how the variable structure is assembled. GDScript uses spaces and specific words so the computer understands what you're creating:

```
  var  variable_name  =  100
  ---  -------------  -  ---
   |         |        |   |
Keyword  Identi-    Sign Value/
         fier       of =  Expression
```

## Practical Example to Test

To test on your machine, open Godot, create an empty script, and insert the code below inside the _ready() function. When running the scene, the values will appear in the Output panel.

```gdscript
func _ready():
	# 1. Simple declaration (empty box)
	var player_health
	
	# 2. Assignment (putting value in the box)
	player_health = 100
	
	# 3. Declaration and Assignment on the same line
	var character_name = "Guará"
	var stamina = 55.5
	var full_mana = true
	
	# Displaying values in the Output panel
	print("Name: ", character_name)
	print("Health: ", player_health)
	print("Is mana full? ", full_mana)
```

## Basic Data Types

GDScript can automatically identify what you store in the variable, but it's important to know the main types:

- String: Used for text, always written in quotes (e.g., "Hello").
- Integer (int): Whole numbers, positive or negative (e.g., 550).
- Float: Numbers with decimal places (e.g., 15.5).
- Boolean (bool): Represents only two states, true or false, like a light switch.
````
