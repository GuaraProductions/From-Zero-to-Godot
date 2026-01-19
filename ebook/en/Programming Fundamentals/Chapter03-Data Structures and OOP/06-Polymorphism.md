````markdown
# Polymorphism

We've reached the last of the four pillars of Object-Oriented Programming: **Polymorphism**. The name comes from Greek and means "many forms." In programming, this concept allows different objects to respond to the same function call in different ways, according to their own nature.

Imagine you have a game with several animals. You can create a general command called `make_sound()`. Although the command is the same, the "Dog" will respond by barking, while the "Cat" will respond by meowing. The code that sends the order doesn't need to know which specific animal it is; it just trusts that any animal knows how to make a sound.

## Function Overriding (Override)

In GDScript, the most common way to apply polymorphism is through **overriding**. This happens when a child class inherits a function from the parent class, but decides to change what that function does to adjust to its needs.

In the Godot Engine, you already use polymorphism all the time without realizing it! Functions like `_ready()` or `_process()` already exist at the Engine's base, but you "override" them in your script to give your own customized behavior to your object.

## Syntax Composition

For polymorphism to work via inheritance, the child class must use the same function name defined in the parent class:

```
  # In Parent Class:
  func act(): 
      print("Generic action")

  # In Child Class:
  func act():  <-- The same name as the original function
      print("Specialized action!") <-- A new behavior
```

## Practical Example to Test

See how we can treat different types of characters as if they were just a "Fighter", but each acting in a unique way:

**File: Fighter.gd (Parent Class)**

```gdscript
class_name Fighter
extends Node

func attack():
	print("The fighter attacks in a basic way.")
```

**File: Archer.gd (Child Class)**

```gdscript
extends Fighter

func attack():
	print("The archer shoots a precise arrow!")
```

**File: Warrior.gd (Child Class)**

```gdscript
extends Fighter

func attack():
	print("The warrior strikes with his sword!")
```

**In your Main Script**

```gdscript
func _ready():
	# We create a list (Array) of different fighters
	var team = [Archer.new(), Warrior.new()]
	
	for member in team:
		# POLYMORPHISM: We call the same 'attack' function, 
		# but each responds in their own way!
		member.attack()
```

## Advantages of Polymorphism

✅ **Flexibility**: You can add new types of characters or enemies to the game without needing to change the code that makes them attack

✅ **Organization**: Allows treating groups of different objects uniformly

✅ **Clean Code**: Avoids excessive use of "ifs" to check what type of object it is before performing a common action
````
