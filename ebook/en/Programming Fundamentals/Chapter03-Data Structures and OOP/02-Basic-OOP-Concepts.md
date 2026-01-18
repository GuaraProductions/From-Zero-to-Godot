````markdown
# What is Object-Oriented Programming (OOP)?

Imagine you're progressing in developing your game and suddenly need to manage hundreds of pieces of information at once: the position of 50 enemies, the attributes of 20 different items, and the state of all the dungeon doors.

In the old days, in what we call the **Procedural Paradigm**, programmers wrote a giant list of sequential instructions. If we tried to create a loose variable for each enemy (`var enemy_1_health`, `var enemy_2_health`...), the code would become a "tangle of wires" — the famous **Spaghetti Code** — impossible to read or fix.

**Object-Oriented Programming (OOP)** was born to solve this chaos. The revolutionary idea was: *"What if, instead of loose lists of data, we organized code into 'things' that imitate the real world?"*

## 1. The Central Concept: The Game "Sheet"

Fundamentally, OOP (which is the basis of Godot) is the art of creating your own **custom structures**. Think of it as creating an **RPG Character Sheet**.

When you create a sheet, you group two essential things:

- **What the character HAS** (Attributes/Variables): Health, Mana, Strength, Name
- **What the character DOES** (Methods/Functions): Attack, Jump, Use Potion

In programming, this "Sheet" gets the technical name of **Class**.

## 2. The Structure's Anatomy: Class, Instance, and Object

Although they seem like the same thing, in programming each of these names represents a different stage of an element's "life" in the game. Let's understand this journey:

### The Class (The Theoretical Mold)

The **Class** is just the concept. It's the code you write in the `.gd` file. It defines how something should be, but it doesn't occupy real space in the game's memory during play. It's like a cake recipe: you can read the recipe, but you can't eat it.

**Example in code:**

```gdscript
# File: Robot.gd
class_name Robot  # Here we define the TYPE

var color: String = "Gray"  # Default rule
var energy: int = 100

func speak():
    print("Hello, human.")
```

**Note:** This code alone doesn't create anything on screen. It's just the instruction manual.

### The Instance (The Unique Copy)

The **Instance** arises at the moment of creation. When we use the `.new()` command, the computer reads the class and creates an exclusive copy in memory. This is where "identity" is born. Even if two robots are identical, each is a different instance with its own "ID."

**Example in code:**

```gdscript
func _ready():
    # .new() creates the INSTANCE (the birth)
    var robot_alpha = Robot.new() 
    var robot_beta = Robot.new()  

    # Proof of identity: The Instance ID
    # The computer generates a unique number for each created instance
    print("Alpha's ID: ", robot_alpha.get_instance_id()) 
    print("Beta's ID:  ", robot_beta.get_instance_id())

    # If I paint Alpha, Beta remains Gray.
    # This proves they are separate instances.
    robot_alpha.color = "Golden"
```

### The Object (The Living Matter)

Here's a subtle difference that's important to understand.

While **Instance** refers to a specific version of our class, an **Object** refers to physical existence in memory. In Godot, everything that exists in memory is generically treated as an "Object."

Think of it this way: If you point to a Beetle on the street, you can say "That's a blue Beetle" (classifying the specific Instance) or you can say "That's a car/physical thing" (recognizing the Object).

**Example in code:**

```gdscript
var my_robot = Robot.new()

# Checking the INSTANCE (The Relationship)
# Question: "Were you created using the 'Robot' mold?"
if my_robot is Robot:
    print("Yes, I'm an instance of the Robot class!")

# Checking the OBJECT (The Matter)
# Question: "Are you a valid object in memory?"
# (Every item in Godot inherits from a universal base called 'Object')
var thing_in_memory: Object = my_robot

print(thing_in_memory) 
# The result will be something like <Object#34200>, showing the 'raw matter' of the code. 
# and 34200 is the instance's identifier in memory
```

### Quick Summary

- **Class:** The text file (The Plan)
- **Instance:** The "kinship" relationship with the plan (The Specific Copy)
- **Object:** The active entity occupying RAM (The Real Thing)

## 3. The static Keyword (Shared Memory)

Until now, we've learned that each object has its own data. If I create 10 enemies, each has its own health. If one takes damage, the others' health doesn't change. This is the default behavior.

But what if we need a variable that's **shared by all**?

This is where `static` comes in. When we define something as static, it stops belonging to the Object (individual notebook) and starts belonging to the Class (classroom bulletin board).

### Example 1: Counting Enemies (Static Variables)

Imagine you want to know how many zombies exist in the game. If you put `var quantity = 0` in the `Zombie` class, each Zombie will be born with the counter at 0 and they'll never know the total.

With `static`, all Zombies look at the same variable:

```gdscript
class_name Zombie

# Common Variable (Each has their own)
var health: int = 100 

# Static Variable (SHARED by all zombies)
static var total_quantity: int = 0

func _init():
    # Every time a zombie is born (.new), we increase the shared counter
    total_quantity += 1
```

**How to use in the game:**

```gdscript
func _ready():
    print(Zombie.total_quantity) # Output: 0
    
    var z1 = Zombie.new()
    var z2 = Zombie.new()
    var z3 = Zombie.new()
    
    # Note that we access through the CLASS NAME, not the z1 or z2 object
    print("Total Zombies: ", Zombie.total_quantity) # Output: 3
```

💡 **The Golden Rule:** Static variables are great for global counters, general settings, or lists of all objects of that type.

### Example 2: Utility Functions (Static Functions)

Sometimes, we want to use a script's function without the trouble of creating an object with `.new()`. We call these **Utility Functions**.

Think of a calculator. You don't need to "build" a new calculator every time you want to add 2 + 2. You just want the tool.

```gdscript
class_name MathUtil

# By using 'static func', we say this tool is available
# directly in the mold, without needing to create the object.
static func add(a: int, b: int) -> int:
    return a + b

static func calculate_damage(strength: int, armor: int) -> int:
    return strength - (armor / 2)
```

**How to use in the game:**

```gdscript
func _ready():
    # We don't need to do: var m = MathUtil.new()
    # We can call directly by the script name!
    
    var result = MathUtil.add(10, 5)
    print("Sum: ", result)
    
    var damage = MathUtil.calculate_damage(50, 10)
    print("Calculated damage: ", damage)
```

### ⚠️ The Great Danger of Static

There's an important limitation: **A static function doesn't know who `self` is.**

Since the static function belongs to the Class (the paper/mold) and not to a specific Object, it can't access normal variables like `health` or `color`.

```gdscript
class_name Hero

var health = 100 # Instance variable

static func try_heal():
    health = 200 # ERROR! The mold doesn't know which 'health' you're talking about.
    # The computer will say: "Instance member 'health' cannot be accessed from static."
```

**Summary:** Use `static` for general tools and global data. Use normal variables for everything that's individual to the character.
````
