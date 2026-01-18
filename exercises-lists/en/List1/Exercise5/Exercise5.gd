extends MarginContainer

#region AlreadyImplemented

@onready var input : LineEdit = %Entrada
@onready var result : Label = %Resultado

func _is_valid_year(text: String) -> bool:
	return text.is_valid_int()

func _on_converter_pressed() -> void:
	var year_text : String = input.text
	
	if not _is_valid_year(year_text):
		result.text = "Error! The year entered is invalid!\nEnter a number!"
		result.modulate = Color.RED
		return
		
	var year : int = int(year_text)
		
	var is_leap := is_leap_year(year)

	result.modulate = Color.WHITE
	
	result.text = "The year %d " % [year]
	result.text += "is a leap year" if is_leap else "is not a leap year"

#endregion

func is_leap_year(year: int) -> bool:
	#TODO: Implement logic
	return year
