````markdown
# Conditional Structures

**Conditional structures** are the tools that allow your program to make decisions. Until now, we've seen code as a straight line, but with conditionals, we create "forks" where the software decides which path to follow depending on the data. If a condition is true, a block of code is executed; otherwise, the program can follow an alternative path or simply ignore that part.

## 1. The If, Elif, and Else Block

These keywords form the basis of decision logic in GDScript:

- **If**: It's the starting point that evaluates if an expression is true to execute the code right below it.
- **Elif (Else If)**: Serves to check a second or third condition if the first (the `if`) was false.
- **Else**: It's the "safe harbor"; if none of the previous conditions are met, the code inside the `else` will be executed mandatorily.

### Syntax Composition

In GDScript, **indentation** (the space at the beginning of the line) is mandatory to define what's inside the conditional.

```
  if  health  <=  0 :
  --  ------------- -
   |        |       |
Keyword  Logical   Colon (Indicates that the 
         Expression code block begins below)
```

## 2. The Match Structure

The **match** is a more organized alternative to `if` when you need to compare a single variable with several fixed values (known in other languages as `switch/case`). It checks the variable's content and jumps directly to the corresponding "case."

## Practical Example to Test

Copy this code to the `_ready()` function in your Godot to test how the program reacts to different values:

```gdscript
func _ready():
	var team_a_points = 50
	var team_b_points = 50

	# Example with If, Elif, and Else
	if team_a_points > team_b_points:
		print("Team A won!") 
	elif team_b_points > team_a_points:
		print("Team B won!") 
	else:
		print("It's a tie.")

	# Example with Match (evaluating only one variable)
	var player_state = "dead"
	
	match player_state:
		"healthy":
			print("The player is ready to fight!")
		"wounded":
			print("The player needs healing.")
		"dead":
			print("Game over.")
		_: # The "_" symbol works like the "else" of match (default case)
			print("Unknown state.") 
```

> 💡 **Tip**: Try changing the values of `team_a_points`, `team_b_points`, and `player_state` to see different results!
````
