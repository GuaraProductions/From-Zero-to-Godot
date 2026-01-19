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
	var sum = sum_up_to_n(n)
	result.modulate = Color.WHITE
	result.text = "Sum: %d" % sum

#endregion

func sum_up_to_n(n: int) -> int:
	# Sum all numbers from 1 to n
	var sum = 0
	for i in range(1, n + 1):
		sum += i
	return sum
