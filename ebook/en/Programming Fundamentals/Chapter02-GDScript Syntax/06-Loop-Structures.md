````markdown
# Loop Structures (Loops)

**Loop structures**, also known as **loops**, are essential when we need the computer to execute the same block of code multiple times without us having to write it repeatedly. Imagine you want to create 10 enemies in a level or sum all items in an inventory; without loops, you'd have to write 10 manual lines, but with them, you write just one instruction that repeats.

In GDScript, the two main forms of repetition are **for** and **while**.

## 1. The For Loop

The `for` is generally used when we know exactly how many times we want to repeat something or when we want to traverse a list of items. It works like a "traverser": it takes one item at a time from a sequence and executes the code for each of them.

### Syntax Composition

To repeat a specific number of times, we use the `range()` function, which creates a sequence of numbers.

```
  for  i  in  range(10):
  ---  -  --  ---------
   |   |  |       |
Keyword Aux. Keyword Sequence from 0 to 9
        Var.         (10 repetitions)
```

## 2. The While Loop

The **while** (which means "while") is more flexible and dangerous. It executes the code while a logical condition is true. If the condition never becomes false, the program enters an **infinite loop**, which causes the computer to freeze or close the game.

> ⚠️ **Attention**: Always ensure that the `while` condition eventually becomes false!

## Practical Example to Test

Copy the code below to your Godot to see the difference between the two. Note that in `while` we need to manually update the counter so it doesn't run forever.

```gdscript
func _ready():
	print("--- Testing FOR ---")
	# range(5) goes from 0 to 4 (5 numbers in total)
	for i in range(5):
		print("For repetition number: ", i)
	
	print("\n--- Testing WHILE ---")
	var counter = 0
	# While the counter is less than 5, the code runs
	while counter < 5:
		print("While repetition number: ", counter)
		# VERY IMPORTANT: Increase the counter for the loop to have an end
		counter += 1 
```

## What did you learn here?

- **For**: Great for defined tasks (like "send 10 enemies to the screen")
- **While**: Used for situations that depend on an external condition (like "while the player is alive, continue the game")
- **Infinite Loop**: Happens in `while` if you forget to update the stop condition

> 💡 **Tip**: When possible, prefer `for` because it's safer and harder to create infinite loops!
````
