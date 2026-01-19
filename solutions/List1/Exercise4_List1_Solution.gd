extends MarginContainer

#region AlreadyImplemented

@onready var value_input: LineEdit = %ValorEntrada
@onready var discount_input: LineEdit = %DescontoEntrada
@onready var gift_label: Label = %BrindeLabel

@onready var result: Label = %Resultado

func _is_valid_number(text: String) -> bool:
	return text.is_valid_int() or text.is_valid_float()

func _on_calcular_pressed() -> void:
	if not _is_valid_number(value_input.text):
		result.text = "Error! Value is invalid!\nEnter a number!"
		result.modulate = Color.RED
		return
	if not _is_valid_number(discount_input.text):
		result.text = "Error! Discount is invalid!\nEnter a number!"
		result.modulate = Color.RED
		return
		
	var purchase_value : float = float(value_input.text)
	var discount : float = float(discount_input.text)
		
	var discounted_value := calculate_discounted_value(purchase_value, discount)
	var has_gift := calculate_if_customer_gets_gift(discounted_value)
	
	result.modulate = Color.WHITE
	result.text = "Discounted value: %s" % [str(discounted_value).pad_decimals(2)]
	
	gift_label.text = "Congratulations! You earned a gift!" if has_gift else ""

#endregion

func calculate_discounted_value(purchase_value: float, 
								 discount: float) -> float:
	# Convert percentage to decimal: 10% = 0.10
	var discount_decimal = discount / 100.0
	# Calculate discount amount
	var discount_amount = purchase_value * discount_decimal
	# Return final value after discount
	return purchase_value - discount_amount

func calculate_if_customer_gets_gift(discounted_value: float) -> bool:
	# Customer gets gift if final value is greater than $500.00
	return discounted_value > 500.0
