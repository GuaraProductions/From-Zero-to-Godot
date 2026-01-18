````markdown
# Encapsulation

**Encapsulate**, as the name suggests, means putting something inside a "capsule" to protect it. In programming, this concept serves to control how an object's data is accessed or modified, preventing external parts of the code from making improper or dangerous modifications.

## Why protect your data?

Imagine a banking system: you have a variable called `balance`. If any part of the code could simply write `balance = 1000000`, the bank would go broke in minutes. Encapsulation ensures that the balance only changes through safe rules, like a `deposit()` function that checks if the value is positive.

## Encapsulation in GDScript

Unlike languages like **C#** or **Java**, GDScript doesn't have rigid keywords to "lock" a variable (like `private`). Instead, we use a **convention** among programmers: we put an underline (`_`) before the variable name, like `_balance`. This warns other developers: "Hey, don't touch this variable directly from outside this script!".

## Setters and Getters (The code gatekeepers)

To allow controlled access to these "private" variables, we use special functions called **Setters** (to set a value) and **Getters** (to read a value). In modern GDScript, you can link these functions directly to the variable.

- **Getter**: A function that "gets" the value and delivers it, and can perform calculations before (e.g., convert seconds to minutes)
- **Setter**: A function that "sets" the value, allowing you to validate if the incoming information is correct

## Syntax Composition

See how we define a variable that uses this access control:

```
  var  property_name  get = read_function , set = write_function
  ---  -------------  --------------------   ---------------------
   |          |                |                       |
Keyword   Identi-         Defines who             Defines who
          fier            delivers the data       stores the data
```

## Practical Example to Test

Copy this code to understand how the Setter prevents the character's name from being registered empty:

```gdscript
# In the Character.gd file
var _internal_name = "No Name"

# Defining the variable with access control
var name: String:
	get:
		print("Someone tried to read the name!")
		return _internal_name
	set(new_value):
		if new_value != "":
			_internal_name = new_value
			print("Name changed successfully!")
		else:
			print("Error: Name cannot be empty!")

# ---------------------------------------------------------

func _ready():
	# Access attempt
	name = "Lobo Guará" # Triggers 'set' and changes successfully
	name = ""           # Triggers 'set' and shows error message
	print("Current character: ", name) # Triggers 'get'
```

## Practical Example: Separate Functions

Sometimes, the validation rule is too complex to be "squeezed" into the variable declaration. In these cases, we can create normal functions and just "notify" the variable that it should use them.

See how this makes the top of your script cleaner:

```gdscript
extends Node

# Internal variable (the "vault" where the real value is stored)
var _health: int = 100

# Here we just LINK the variable to the 'get_health' and 'set_health' functions
var health: int : get = get_health, set = set_health

# --- Getter and Setter logic is separated below ---

# Getter Function (Read)
func get_health():
    print("The game requested the health value.")
    return _health

# Setter Function (Write and Validation)
func set_health(new_value):
    print("Trying to change health to: ", new_value)
    
    if new_value < 0:
        print(" > Warning! Health cannot be negative. Locking at 0.")
        _health = 0
    elif new_value > 100:
        print(" > Excessive healing! Limiting to maximum of 100.")
        _health = 100
    else:
        _health = new_value # Valid value, change allowed
        
# ---------------------------------------------------------

func _ready():
    # Testing the system
    health = 50   # Works normally
    health = -20  # Setter will prevent and lock at 0
    health = 500  # Setter will prevent and lock at 100
    
    print("Final health: ", health) # Getter fetches the final value
```

## Why use this method?

- Organization: If your validation rule has 20 lines of code, it doesn't pollute the variable list at the top of the file.
- Reusability: Although rare in properties, technically you could use the same validation function for two different variables.

## Advantages of Encapsulation

✅ **Security**: Protects sensitive information against accidental errors

✅ **Validation**: Ensures that your game data (health, ammunition, speed) is always within acceptable limits

✅ **Ease of Maintenance**: If you need to change how data is calculated, you only change inside the Getter or Setter, and the rest of the game will continue working normally
````
