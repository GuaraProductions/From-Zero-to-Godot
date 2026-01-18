````markdown
# Dictionaries

While Arrays organize data sequentially through numerical indices (0, 1, 2...), there are scenarios where accessing data by "position" is inefficient or illogical. For these cases, we use the **Dictionary** (`Dictionary`).

A **Dictionary** is a non-ordered collection of data structured in the **Key-Value** format (Key-Value Pair). Instead of a number, you use a unique key (usually a String) to store and retrieve a value.

## 1. The Mapping Concept

The main characteristic of the Dictionary is **direct association**. You don't ask "what's at position 0?", you ask "what is the value associated with the 'Strength' key?".

- **Key**: The unique identifier (the "label")
- **Value**: The stored data

**Visual Comparison:**

- **Array:** `[10, 20, 30]` (Access via index: 0, 1, 2)
- **Dictionary:** `{"Health": 10, "Mana": 20}` (Access via key: "Health", "Mana")

## 2. Typing: Dynamic vs. Static

Just like in Arrays, modern GDScript allows and encourages strict typing of Dictionaries to ensure data integrity.

### A. Dynamic Dictionaries

Accept any type of key and any type of value.

```gdscript
var data = {"Name": "Hero", 1: "Level"} # Mixed keys (String and Int)
```

### B. Typed Dictionaries

In Godot 4, we can explicitly define the Key type and Value type.

**Syntax:** `var name: Dictionary[KeyType, ValueType] = {}`

```gdscript
# A dictionary where the Key is String and the Value is Integer
var attributes: Dictionary[String, int] = {
    "Strength": 18,
    "Dexterity": 14
}

# attributes["Intelligence"] = "High" # ERROR: The value must be int, not String.
```

## 3. Data Manipulation

Dictionary manipulation differs from Arrays, as we don't use methods like `append`. Insertion and editing are done directly by key.

### Insertion and Modification

If the key doesn't exist, it's created. If it already exists, the value is overwritten.

```gdscript
var sheet: Dictionary[String, int] = {}

# Inserting
sheet["Health"] = 100 

# Modifying
sheet["Health"] = 90
```

### Removal

- **`erase(key)`**: Removes the key-value pair from the dictionary

```gdscript
sheet.erase("Health")
```

- **`clear()`**: Removes all records
- **`make_read_only()`**: Locks the dictionary, preventing future modifications

### Existence Check (Critical)

Trying to access a key that doesn't exist can generate errors or unexpected behaviors. Always check first.

- **`has(key)`**: Returns `true` if the key exists

```gdscript
if sheet.has("Mana"):
    print(sheet["Mana"])
```

## 4. Iteration (Traversing the Dictionary)

When using the `for` loop in a dictionary, GDScript's default is to iterate over the **Keys**.

To maintain security and performance, we use typed iteration, declaring the type of variable that will receive the key.

**Syntax:**

```gdscript
for key: KeyType in dictionary:
    var value = dictionary[key]
```

**Example:**

```gdscript
var prices: Dictionary[String, int] = {"Sword": 100, "Shield": 50}

# The 'item' variable will assume the keys ("Sword", "Shield")
for item: String in prices:
    var value: int = prices[item]
    print("The item ", item, " costs ", value)
```

## 5. Integrated Practical Example

Below, we simulate a simple "Character Sheet". Note how the `Dictionary[String, int]` structure is ideal for managing named numerical attributes.

```gdscript
extends Node

# Declaration: Keys are Names (String), Values are Levels (int)
var skills: Dictionary[String, int] = {
    "Strength": 10,
    "Agility": 12,
    "Intelligence": 8
}

func _ready():
    print("--- Initial Sheet ---")
    
    # 1. Adding a new attribute dynamically
    skills["Luck"] = 5
    print("Luck attribute learned.")
    
    # 2. Modifying an existing value (Level Up)
    if skills.has("Strength"):
        skills["Strength"] += 5 # Increases from 10 to 15
        
    # 3. Typed Iteration to list everything
    print("\n--- Updated Status ---")
    
    # 'attribute' will be the key (String)
    for attribute: String in skills:
        var value: int = skills[attribute]
        
        # Conditional logic based on value
        if value >= 15:
            print(attribute, ": ", value, " (Master)")
        else:
            print(attribute, ": ", value)

    # 4. Removal
    # Let's remove Intelligence to simulate a curse
    skills.erase("Intelligence")
    print("\nTotal remaining attributes: ", skills.size())
```
````
