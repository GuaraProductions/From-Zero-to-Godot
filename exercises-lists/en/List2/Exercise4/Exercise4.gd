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
	# TODO: Calculate the factorial of n
	return 1
