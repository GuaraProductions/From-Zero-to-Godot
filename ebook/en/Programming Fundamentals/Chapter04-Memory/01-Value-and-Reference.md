````markdown
# Value and Reference

To close our understanding of how the Engine and GDScript deal with data, we need to look "under the hood" and understand how information is stored in the computer's memory. There are two main ways to manipulate data: **by Value** and **by Reference**.

## 1. Pass by Value (Primitive Types)

When we work with simple data types, known as **primitives** (like `int`, `float`, and `bool`), the computer deals with them **by value**.

Imagine you have a variable `A` and say that `B = A`. In the case of value, the computer creates an **identical copy** of the data in a new place in memory. If you pass one of these types as a parameter to a function and change it inside, the original variable that was outside the function **will suffer no change**, because the function received only a copy.

## 2. Pass by Reference (Objects and Structures)

This is where knowledge of OOP and Data Structures becomes vital. When we work with **Objects**, **Class Instances**, **Arrays**, or **Dictionaries**, GDScript doesn't copy the entire content, but rather the **address** (the reference) of where that data is in memory.

A **reference** is like a "link". If you pass an object to a function, the function doesn't receive a copy, but direct access to the original object. Any change made inside the function will affect the object throughout the game.

## Practical Example: Parameter Passing

The use of functions is the best way to visualize this behavior. Test the code below to see the difference:

```gdscript
func _ready():
	# TEST BY VALUE
	var my_health = 100
	change_value(my_health)
	print("Health outside function: ", my_health) # Remains 100 

	# TEST BY REFERENCE
	var my_inventory = ["Sword"]
	change_reference(my_inventory)
	print("Inventory outside function: ", my_inventory) # Now has ["Sword", "Shield"] 

# Receives an Integer (Pass by Value)
func change_value(copied_health):
	copied_health = 50 # Only changes the local copy 
	print("Health inside function: ", copied_health)

# Receives an Array (Pass by Reference)
func change_reference(original_list):
	original_list.append("Shield") # Changes the original object in memory 
	print("Inventory inside function: ", original_list)
```

## Memory Management in Godot

The Engine uses a system called **RefCounted** (Reference Counting) to manage the life of these objects. It works like this:

1. The computer counts how many variables are "pointing" to an object
2. While there is at least one active reference, the object continues to live
3. When the count reaches zero (no one points to it anymore), the Engine automatically deletes the object to free memory

## Why is this important?

✅ **Performance**: Passing a reference is instantaneous, while copying an Array with 10,000 items at each function would make the game slow

✅ **Consistency**: Ensures that when giving an item to the player, all parts of the system (HUD, Inventory, Shop) see the same updated object
````
