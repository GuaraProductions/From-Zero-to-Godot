extends MarginContainer

#region AlreadyImplemented

@onready var grade_1_input: LineEdit = %Nota1Entrada
@onready var grade_2_input: LineEdit = %Nota2Entrada
@onready var grade_3_input: LineEdit = %Nota3Entrada

@onready var result: Label = %Resultado

func _is_valid_number(text: String) -> bool:
	return text.is_valid_int() or text.is_valid_float()

func _on_calcular_pressed() -> void:
	if not _is_valid_number(grade_1_input.text):
		result.text = "Error! Grade 1 is invalid!\nEnter a number!"
		result.modulate = Color.RED
		return
	if not _is_valid_number(grade_3_input.text):
		result.text = "Error! Grade 2 is invalid!\nEnter a number!"
		result.modulate = Color.RED
		return
	if not _is_valid_number(grade_3_input.text):
		result.text = "Error! Grade 3 is invalid!\nEnter a number!"
		result.modulate = Color.RED
		return
		
	var grade_1 : float = float(grade_1_input.text)
	var grade_2 : float = float(grade_2_input.text)
	var grade_3 : float = float(grade_3_input.text)
		
	var school_status := calculate_school_status(grade_1, grade_2, grade_3)
	
	result.modulate = Color.WHITE
	result.text = "Result: %s" % [school_status]

#endregion

func calculate_school_status(grade_1: float, 
							  grade_2: float, 
							  grade_3: float ) -> String:
	# Calculate average
	var average = (grade_1 + grade_2 + grade_3) / 3.0
	
	# Return status based on average
	if average >= 60:
		return "Passed"
	elif average >= 40:
		return "Recovery"
	else:
		return "Failed"
