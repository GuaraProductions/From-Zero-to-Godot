````markdown
# Abstraction

Continuing our studies on the pillars of OOP, we come to a concept that seems abstract by name, but that you apply every day in real life: **Abstraction**.

In programming, **to abstract** means to simplify. It's the ability to focus only on the essential aspects of an object for your game, ignoring details that don't matter at that moment. Imagine you're programming a car:

- For a **racing game**, the car "abstraction" needs to have **speed** and **direction**
- For a **mechanic simulator**, the abstraction would need to have **oil level** and **spark plug condition**

The object is the same, but the way we "abstract" it changes according to need.

## The Mold of Molds

Often, we create classes that serve only as a **general concept** and will never be used to create a direct object. For example, you never see a generic "Animal" on the street; you see a dog, a cat, or a parrot. In code, `Animal` would be an **abstract class**: a mold that serves as a base for other more specific molds.

## Abstraction in Godot

The Engine uses abstraction to allow you to treat different objects equally. If you have a function called `attack()`, it doesn't matter if the attacker is a "Warrior" or a "Mage"; as long as both inherit from an abstract class `Character`, the Engine can handle the command without needing to know the internal details of each.

## Syntax Composition (Abstraction Idea)

Abstraction doesn't have a single keyword, it's a design concept. See how we think about it:

```
  ABSTRACT CLASS: "Vehicle" (Just the idea)
  -----------------------------------------
  - move()
  - stop()

  REAL CLASS: "Car" (The implementation)
  -----------------------------------------
  - move(): Starts the engine and accelerates
  
  REAL CLASS: "Bicycle" (The implementation)
  -----------------------------------------
  - move(): Pedals and maintains balance
```

## Practical Example to Test

See how we can create a system where the main script doesn't need to know details of the children, only what they "abstract":

**File: Ability.gd (Our abstract base)**

```gdscript
class_name Ability
extends Node

func use():
	print("This ability does nothing on its own.")
```

**File: Fireball.gd**

```gdscript
extends Ability

func use():
	print("Launching an explosive fireball!")
```

**In your Main Script**

```gdscript
func _ready():
	# We abstract 'Fireball' as being just an 'Ability'
	var my_magic: Ability = Fireball.new()
	
	# The code below doesn't know it's fire, it just knows 
	# that abilities can be "used".
	my_magic.use()
```

## Advantages of Abstraction

✅ **Focus on the Essential**: Reduces confusion by hiding unnecessary technical details

✅ **Flexibility**: Allows creating generic systems that work with any object that follows the same logical "contract"

✅ **Organization**: Helps separate "what the object does" from "how it does it"
````
