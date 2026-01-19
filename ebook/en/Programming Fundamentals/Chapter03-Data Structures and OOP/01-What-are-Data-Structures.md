````markdown
# What are Data Structures?

Until now, we've worked with isolated information, like a name or a number. But as your game grows, managing hundreds of loose variables becomes impossible. To understand how to solve this, we first need to understand that not every data "box" is the same. In programming, we divide storage tools into two large groups: the **Primitives** and the **Composites**.

## 1. Primitive Data Structures

Primitive structures are the "atoms" of programming. They are the most basic data types that the language offers and that we've already seen in previous chapters. They store only a single value at a time:

- **Integers (int)**: Numbers without decimal places
- **Floats**: Numbers with decimal places
- **Booleans (bool)**: The state of true or false
- **Strings**: Character chains (text)

These structures are fundamental, but they're limited because they can't group related information automatically.

## 2. The Role of Typing (Static Typing)

In GDScript, you have two ways to create variables:

A. Dynamic Typing: you create a variable without saying what goes inside.

```gdscript
var health = 100    # Godot understands it's a number
health = "Thousand"      # In dynamic typing, this works, but can generate errors in the game!
```

B. Static Typing: here, you define a strict rule. If the variable is to store integers, it will never accept text. This prevents bugs and helps the computer read your code faster.

```gdscript
var health: int = 100
# health = "Thousand"   <-- Godot will prevent you from making this mistake before even running the game.
```

## 3. The Walrus Operator := (The Smart Shortcut)
Often, writing the type (: int, : String) can be repetitive when the value is already obvious. This is where the Walrus operator (:=) comes in.

It tells Godot: "Define the static type automatically based on the initial value."

```gdscript
# Instead of writing all this:
var character_name: String = "Hero"

# You use Walrus to be concise and keep security:
var character_name := "Hero" 

# Godot saw that "Hero" is String, so it locked the variable as String.
# character_name = 10  <-- This will give an error, just like explicit typing!
```

💡 Tip: Use := whenever initializing a variable with a known value. This makes your code cleaner without losing static typing security.

## 4. Where do Functions fit in?
If data structures are the "boxes" that store information, Functions are the machines that process these boxes.

A well-written function in GDScript should also respect the types of data that enter and exit it:

```gdscript
# This function promises to receive an integer and return an integer
func calculate_damage(strength: int) -> int:
    return strength * 2
```

- 💡 Tip: In Data Structures, typing is your best friend. It ensures that the variable or function you created is predictable.

## 5. Composite Data Structures (Non-Primitive)

This is where the game really begins. Composite structures are formed by the union of several primitive structures to create something more complex.

There are different types of composite structures for different needs:

### Sequential Collections (Arrays)
Great for when you need a queue or list organized by position, like an RPG's inventory.

```gdscript
# We create a list that only accepts Strings
func _ready() -> void:
	var inventory: Array[String] = ["Sword", "Potion", "Map"]

	# We access by index (position), starting from 0
	print(inventory[0]) # Output: "Sword"
	print(inventory[1]) # Output: "Potion"
```

### Associative Collections (Dictionaries)

Perfect for searching data through a "name" or "key", like a character sheet where you search for "Strength" to find the value.

```gdscript
# Walrus (:=) infers this is a Dictionary
var character_sheet := {
    "Name": "Valeros",
    "Strength": 18,
    "Speed": 12
}

# We search for the value using the key (the attribute name)
print(character_sheet["Strength"]) # Output: 18
```
### Custom Structures (OOP)

This is what we'll see in the Object-Oriented Programming chapters. Here, you create your own structure (the Class), which can contain several primitive variables and even functions inside it.

```gdscript
# Example of a Class (a mold to create Enemies)
class_name Enemy

var name: String = "Goblin"
var health: int = 30

func attack():
    print(name, " dealt damage!")
```

## Why is this distinction important?

Understanding that there are different types of structures allows you to choose the right tool for the right problem. See the difference in practice:

- Case 1: Store only one isolated data If you just want to store an NPC's age, a primitive (int) suffices. It's light and direct.

```gdscript
func _ready() -> void:
	var npc_age := 45
```
- Case 2: Store a group of data If you want to store the list of all NPCs in a level, you'll need a composite (Array) and most likely, you'll want a custom class. Trying to do this with loose variables would be a mess.

```gdscript
# Instead of creating var npc1, var npc2, var npc3...
# We use a composite structure:
func _ready() -> void:
	var npc_list: Array[String] = [NPC.new("Guard"), NPC.new("Blacksmith"), NPC.new("Knight")]
```
````
