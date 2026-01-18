extends MarginContainer

#region AlreadyImplemented

@onready var capital_input: LineEdit = %CapitalEntrada
@onready var interest_rate_input: LineEdit = %TaxaDeJurosEntrada
@onready var time_input: LineEdit = %TempoEntrada
@onready var result: Label = %Resultado

func _is_valid_number(text: String) -> bool:
	return text.is_valid_int() or text.is_valid_float()

func _on_calcular_pressed() -> void:
	if not _is_valid_number(capital_input.text):
		result.text = "Error! Initial capital is invalid!\nEnter a number!"
		result.modulate = Color.RED
		return
	if not _is_valid_number(interest_rate_input.text):
		result.text = "Error! Interest rate is invalid!\nEnter a number!"
		result.modulate = Color.RED
		return
	if not _is_valid_number(time_input.text):
		result.text = "Error! Time entered is invalid!\nEnter a number!"
		result.modulate = Color.RED
		return
		
	var capital : float = float(capital_input.text)
	var interest_rate : float = float(interest_rate_input.text)
	var time : float = float(time_input.text)
		
	var amount := calculate_amount(capital, interest_rate, time)
	
	result.modulate = Color.WHITE
	result.text = "Result: $%s" % [str(amount).pad_decimals(2)]

#endregion

func calculate_amount(initial_capital: float, 
					   interest_rate: float, 
					   time:float ) -> float:

	#TODO: Implement logic
	return 0
