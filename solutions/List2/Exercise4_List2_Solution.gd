extends Node

#region AlreadyImplemented

@onready var input = %Entrada
@onready var result = %Resultado

func _is_valid_number(text: String) -> bool:
	return text.is_valid_int()

func calcular():
	var text = input.text

	if not _is_valid_number(text):
		result.text = "Error! Text input is invalid!\nEnter an integer number!"
		result.modulate = Color.RED
		return

	var n = int(text)
	var f = calculate_factorial(n)
	result.modulate = Color.WHITE
	result.text = "Factorial: %d" % f

#endregion

func calculate_factorial(n: int) -> int:
	# Calculate the factorial of n
	# Factorial of 0 is 1 by definition
	if n == 0:
		return 1
	
	var result = 1
	for i in range(1, n + 1):
		result *= i
	return result
