````markdown
# Composition

After exploring **Inheritance**, it's essential to know its inseparable "partner" in the Engine: **Composition**. While inheritance defines **what an object is** (a Lobo Guará **is** an Animal), composition defines **what an object has** (a Character **has** an Inventory, **has** a Health Bar).

In Godot, composition is the **heart of the workflow**. Instead of creating a giant class with thousands of lines of code, we divide functionalities into small pieces (Nodes) and join them together to form something bigger.

## Inheritance vs. Composition

Many beginner programmers try to solve everything with inheritance, creating complex family trees that become difficult to maintain. The golden rule in Godot is: **"Prefer composition over inheritance"** whenever possible.

### Inheritance

Creates a **rigid** relationship. If you change the "Parent", all "Children" change, which can cause cascading bugs.

### Composition

Creates a **flexible** relationship. You can add or remove functionalities (like a "Fire Effect" component) without breaking the character's base logic.

## Composition in Godot's Interface

The Engine's interface is the perfect visual example of composition. When you look at the **Scene** tab, the structure of "Nodes" is composition in action:

- The **Main Node** (e.g., `CharacterBody2D`) is the body
- The **Child Nodes** (e.g., `Sprite2D` for visual, `CollisionShape2D` for physics) are the components that give abilities to this body

## Composition via Code
In GDScript, composition happens when a class stores a reference to another class inside a variable.

```gdscript
# In the Inventory.gd file
class_name Inventory
var items = []

func add_item(item):
    items.append(item)
```

```gdscript
# In the Player.gd file
extends Node2D

# The Player IS NOT an Inventory, he HAS an Inventory.
var backpack = Inventory.new() # Composition happening here!

func _ready():
    backpack.add_item("Healing Potion")
```

## Composition with Nodes (Scenes)
Another powerful form of composition is using get_node() or the $ shortcut to access components you assembled in the interface.

```gdscript
func _ready():
    # Accessing the animation component (Node Composition)
    $AnimationPlayer.play("walk")
```

## Advantages of Composition

✅ **Flexibility**: You can create an "Enemy" and a "Player" using the same "Health" component.

✅ **Easy Maintenance**: If the "Inventory" component gives an error, you only need to fix one file, without fear of breaking the entire game's inheritance hierarchy.

✅ **Modularity**: You build your game as if you were assembling LEGO blocks. You only add the components that a class needs.
````
