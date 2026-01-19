extends MarginContainer

#region AlreadyImplemented

@onready var input : LineEdit = %Entrada
@onready var result : Label = %Resultado

func _is_valid_number(text: String) -> bool:
	return text.is_valid_int() or text.is_valid_float()

func _on_converter_pressed() -> void:
	var text : String = input.text
	
	if not _is_valid_number(text):
		result.text = "Error! Text input is invalid!\nEnter a number!"
		result.modulate = Color.RED
		return
		
	var number : float = float(text)
		
	var fahrenheit := celsius_to_fahrenheit(number)
	
	result.modulate = Color.WHITE
	result.text = "Result: %s" % [str(fahrenheit).pad_decimals(2)]

#endregion

func celsius_to_fahrenheit(number: float) -> float:
	#TODO: Implement logic
	return number
