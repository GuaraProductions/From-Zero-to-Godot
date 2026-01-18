````markdown
# Inheritance

In the previous chapter, we saw that **Classes** work as molds to create objects. Now, imagine you're creating a game with several types of enemies: an **Orc**, a **Skeleton**, and a **Dragon**. They all have things in common, like health, position on the map, and the ability to take damage. It would be very tiring to write the same "health" code for each of them, right?

This is where **Inheritance** comes in. In programming, inheritance allows a "child" class to automatically inherit all the characteristics and behaviors of a "parent" class. It's like in biology: you inherit traits from your parents, but you continue to be a unique person with your own characteristics.

## The Hierarchy in the Engine

The Godot Engine is entirely built on this concept. When you create a script and see at the top the line `extends Sprite2D`, you're telling the computer: "This script of mine is a child of Sprite2D; it already knows how to display images, but I'm going to add something new to it."

- **Parent Class (Superclass)**: It's the base that contains what's common to all (e.g., the `Enemy` class)
- **Child Class (Subclass)**: It's the specialized version that receives everything from the parent and adds its own details (e.g., the `Dragon`, which inherits from `Enemy`, but adds the `breathe_fire()` function)

## Syntax Composition

In GDScript, the keyword that activates inheritance is `extends`. It defines who your script was "born" from.

```
  extends  Enemy  <-- Your script now has everything the Enemy has
  -------  -----
     |        |
  Keyword  Parent
           Class Name
```

## Practical Example to Test

Let's see how this works in practice. Imagine we have a base script for all living beings in the game:

**File: LIVING_BEING.GD (The Parent)**

```gdscript
class_name LivingBeing
extends Node

var health = 100

func take_damage(amount):
	health -= amount
	print("Current health: ", health)
```

**File: PLAYER.GD (The Child)**

```gdscript
extends LivingBeing # Here inheritance happens!

func _ready():
	# Note that we didn't create the 'health' variable here, 
	# but we have access to it because we inherited from LivingBeing.
	take_damage(20)
	print("The player still has ", health, " health.")
```

## Why use Inheritance?

✅ **Reusability**: Write the code once and use it in ten different places

✅ **Organization**: If you need to change how damage is calculated in the entire game, you only need to modify the parent class, and all children will be automatically updated

✅ **Standardization**: Ensures that all your enemies behave similarly, avoiding unexpected errors
````
