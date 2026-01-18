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
	var total = count_multiples_of_3(n)
	result.modulate = Color.WHITE
	result.text = "Multiples of 3: %d" % total

#endregion

func count_multiples_of_3(n: int) -> int:
	# TODO: Count how many numbers from 1 to n are multiples of 3
	return 0
