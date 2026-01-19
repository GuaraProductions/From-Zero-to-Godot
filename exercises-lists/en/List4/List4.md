# 📘 **List 4 – Arrays and Dictionaries**

---

## **1️⃣ Task Manager (TODO Application)**
[open_scene](Exercise1/Exercise1.tscn) 
[open_test](List4/Exercise1)

### Task:

Complete the `TaskOrganizer` and `Task` classes:

**TaskOrganizer Class:**

| Method | Description |
|--------|-----------|
| `add_task(desc: String)` | Instantiates `Task` and adds to `_tasks` |
| `complete_task(index: int)` | Marks `completed = true` if index is valid |
| `delete_task(index: int)` | Deletes the task if index is valid |
| `get_tasks(): Array` | Returns copy of `_tasks` |

**Task Class:**

| Method | Description |
|--------|-----------||
| `_init(p_id, p_description)` | Constructs the Task class instance |
| `mark_completed()` | Sets the `completed` property to true |

<details><summary>Hint</summary>Use `tasks.duplicate()` or iterate to create a new `Array` before returning.</details>

---
---

## **2️⃣ Inventory**
[open_scene](Exercise2/Exercise2.tscn) 
[open_test](List4/Exercise2)

### Task:

The `Inventory` class already comes with the `_items: Dictionary = {}` property. 

**Inventory Class:**

| Method | Description |
|--------|-----------|
| `is_empty() -> bool` | Returns copy of `_items` |
| `add_item(name: String, qty: int)` | Creates an `Item` instance and adds to `_items` |
| `remove_item(name: String, qty: int)` | Removes a `qty` number of `Item`. If there are no more items left, removes it from `_items` |
| `get_items(): Dictionary` | Returns copy of `_items` |
| `get_item_name(id: int) -> String` | Returns the name corresponding to the item with index `id`, if it doesn't exist, returns an empty String |
| `get_item_description(id: int) -> String` | Returns the description corresponding to the item with index `id`, if it doesn't exist, returns an empty String |
| `get_item_quantity(id: int) -> int` | Returns the quantity of the item with index `id`, if the item doesn't exist, returns -1 |
| `get_item_name_with_quantity(id: int) -> String` | Returns the name corresponding to the item with index `id`, along with the quantity of that item, if it doesn't exist, returns an empty String |

**Item Class:**

| Method | Description |
|--------|-----------|
| `_init(p_id, p_description, p_name, p_description, p_texture)` | Constructs the Item class instance |
| `to_dict()` | Returns the current instance in dictionary format |

<details><summary>Hint</summary>The dictionary keys from the `Item`'s `to_dict()` need to have the same names as its properties.</details>
---
