````markdown
# Programming Paradigms

**Programming paradigms** may seem like a complicated name, but they are just different styles or ways of organizing your reasoning to solve problems using code. Imagine that programming is like the art of building something: you can use different methods or "architecture styles" to reach the same final result. As languages have evolved a lot over time, these sets of rules and patterns were created to help programmers decide how data and instructions should be structured within software.

## Imperative and Procedural Paradigm

One of the most common styles, which you'll see a lot at the beginning, is the **imperative paradigm**, which works like a list of direct orders to the computer. In this model, you say exactly what the machine should do step by step, and each command changes the program's internal state, as if you were moving pieces on a board.

## Example of code using the imperative paradigm

```
# Algorithm: Addition Calculator

Start 
  Read the first value and store it in variable A 
  Read the second value and store it in variable B 
  Calculate the sum of A plus B 
  Store the sum result in variable C 
  Display (print) the value of C on the screen 
End
```

Along with it, we have the **procedural paradigm**, which helps organize the mess by dividing the code into smaller blocks called **functions** or **procedures**. Instead of having a giant and confusing text, you separate tasks into specific parts that can be repeated whenever necessary.

```
Function CalculateArea(b, h):
    Result = b * h
    Return Result

Start
    Display "Enter the base:"
    Read base_value
    
    Display "Enter the height:"
    Read height_value
    
    # The program calls the function sending the data
    FinalArea = CalculateArea(base_value, height_value)
    
    Display "The final result is: " + FinalArea
End
```

There are several paradigms in the computing world, and showing all of them to you at this moment wouldn't be very ideal. But for us, there's one more that's important for you to know, the so-called **OOP**.

## Object-Oriented Programming (OOP)

The most advanced concept that modern Engines and Programming Languages use is **Object-Oriented Programming (OOP)**. Although this topic is explored more deeply when we talk about Nodes in Godot, the central idea of OOP is to organize the program around "objects" that have their own characteristics and behaviors.

Understanding these different styles is very important because most famous languages, like **Java**, **Python**, and **C++**, mix these concepts to make the developer's life easier. So, by learning the paradigms that GDScript uses, you're not just learning to work with Godot, but gaining a foundation that works for almost all other technologies on the market.

```
# Algorithm: Geometry System (OOP)

Class Rectangle:
  Attributes: base, height
  
  Method CalculateArea():
    Return base * height

Start
  # Creating an object instance
  Create object "myRectangle" from Class Rectangle
  
  Display "Define the base:"
  Set myRectangle.base = value read
  
  Display "Define the height:"
  Set myRectangle.height = value read
  
  # The object executes its own logic
  Display "The area is: " + myRectangle.CalculateArea()
End
```
````
