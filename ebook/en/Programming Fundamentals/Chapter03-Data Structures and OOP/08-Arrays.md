````markdown
# Arrays

In previous lessons, we defined variables as memory spaces for singular data. However, developing systems requires manipulating data sets. The fundamental structure for this is the **Array**.

An **Array** is an ordered collection of elements. Unlike isolated variables, it allows storing multiple values under a single identifier, accessible via numerical index or sequentially iterable.

## 1. Indexing and Access

The defining characteristic of an Array is sequentiality. Each element occupies a fixed position, starting at index 0.

If an Array has N elements:

- The first element is at index `0`
- The last element is at index `N - 1`

```gdscript
var list = ["A", "B", "C"]
print(list[0]) # Direct access to the first element ("A")
```

## 2. Typing: Dynamic vs. Static

In GDScript, defining the type of data contained in the Array impacts security and performance.

### A. Dynamic Arrays (Heterogeneous)

Have no restrictions. Can contain mixed types, which reduces memory optimization and increases the risk of runtime errors.

```gdscript
var data = [10, "Text", true]
```

### B. Typed Arrays (Homogeneous)

Strictly define the allowed type. The interpreter validates insertions, ensuring integrity and greater processing speed.

```gdscript
# Syntax: var name: Array[Type] = []
var values: Array[int] = [10, 20, 30]
```

## 3. Data Manipulation (Essential Methods)

Arrays are objects that have internal methods for content management:

- **`append(value)`**: Adds to the end of the sequence
- **`insert(index, value)`**: Inserts at a specific position, shifting the others
- **`erase(value)`**: Removes the first occurrence of the specified value
- **`remove_at(index)`**: Removes the element at the specified index
- **`pick_random()`**: Returns a random element from the collection

## 4. Iteration (Traversing the Array)

Frequently, it's necessary to process all elements of the list sequentially. For this, we use the `for` loop.

Since you already know the `for` structure, we'll focus on **Typed Iteration**. Just as we type the Array variable, we can (and should) type the iterator variable inside the loop. This instructs the compiler about the data being processed, enabling low-level optimizations.

**Syntax:**

```gdscript
for temporary_variable: Type in array_name:
    # Code block
```

**Practical Example:** Imagine an array of integers. By typing the iterator as `int`, we ensure the system that `number` will be treated mathematically.

```gdscript
var scores: Array[int] = [10, 50, 100]

# "For each 'number' (which is an integer) inside 'scores'..."
for number: int in scores:
    print(number * 2)
```

**Technical Note:** If the Array is typed (e.g., `Array[int]`), modern GDScript often infers the type automatically, but making explicit `for i: int` is considered a best practice for readability and performance guarantee.

## 5. Integrated Practical Example

Below, we apply Static Typing, Methods, and Typed Iteration in an inventory system.

```gdscript
extends Node

# 1. Typed Array Declaration
var inventory: Array[String] = ["Potion", "Map", "Elixir"]

func _ready():
    print("--- Processing Inventory ---")
    
    # We add a new item before processing
    inventory.append("Sword")
    
    # 2. Iteration with Typed Variable
    # We use ': String' because we know the array only contains text.
    for item: String in inventory:
        
        # We check each item individually
        if item == "Map":
            print("Quest item found: ", item)
        else:
            print("Common item: ", item)
            
    # 3. Display final size
    print("Total items processed: ", inventory.size())
```
````
