````markdown
# Object, RefCounted, and Node

To finish our ebook, let's understand how Godot organizes everything we've seen so far (Classes, Objects, Inheritance, and Memory) within its own internal structure. In the Engine, almost everything you touch follows a **"birth" hierarchy** that defines how that object behaves and how it dies.

Below, we explain the three main levels of this family tree:

## 1. Object (The Common Ancestor)

**Object** is the base class of absolutely everything in Godot. If something exists in the Engine, it is, fundamentally, an `Object`.

### What it does

It provides the most basic functions, like the ability to emit **signals** and to know what its class is.

### Memory

The pure Object **doesn't clean itself up**. If you create an Object manually via code, you need to delete it manually with the `.free()` function, or it will cause a **memory leak**.

## 2. RefCounted (The Memory Manager)

Most classes that aren't "visible" on screen (like pure logic scripts) inherit from **RefCounted**. It's a child of `Object` that learned to manage itself.

### What it does

As we saw in the previous chapter, it uses **Reference Counting**. It counts how many "links" point to it; when no one calls it anymore, it deletes itself.

### Use

It's the base for **resources** (Resources) and for most classes you create with `class_name`.

## 3. Node (The Building Block)

**Node** is the most famous child of the family. It inherits from `Object`, but has superpowers for game development.

### The Scene Tree

Unlike `RefCounted`, the Node **doesn't die by reference counting**. It lives as long as it's "hanging" on the **Scene Tree**. If you delete a "Parent" Node, all its "Children" are deleted together.

### What it does

It has the lifecycle functions you already know, like `_ready()`, `_process()`, and `_input()`.

## Syntax Composition (The Hierarchy)

See how these concepts stack up. Each level below has everything the level above has, plus a bit more:

```
 [ Object ]      --> "I exist and emit signals"
     ▲
     │
 [ RefCounted ]  --> "I exist and know how to delete myself from memory"
     ▲
     │
 [  Node  ]      --> "I exist, I'm in the scene and receive game commands"
```

## Practical Example: How they "die"

In the code below, see the difference in behavior between an object that cleans itself up and a Node:

```gdscript
func _ready():
	# EXAMPLE WITH REFCOUNTED
	var my_data = RefCounted.new()
	# As soon as this '_ready' function finishes, the variable 'my_data' 
	# ceases to exist, the count goes to zero and it deletes itself.

	# EXAMPLE WITH NODE
	var my_sprite = Sprite2D.new()
	add_child(my_sprite) 
	# Sprite2D is a Node. It doesn't die at the end of the function because 
	# now it's a "child" of the scene. It will only die if we use:
	my_sprite.queue_free() 
```

## Why understand this?

> ⚠️ **Important**: Knowing the difference between them prevents your game from crashing due to lack of memory. 

- If you need something to **process mathematical calculations**, use a `RefCounted`
- If you need something that **appears on screen** or interacts with game time, use a `Node`
````
