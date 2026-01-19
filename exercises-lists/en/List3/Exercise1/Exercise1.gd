extends MarginContainer

#region AlreadyImplemented

@onready var base_input = %BaseEntrada
@onready var height_input = %AlturaEntrada
@onready var result = %Resultado

func _is_valid(text: String) -> bool:
	return text.is_valid_float() or text.is_valid_int()

func calcular():
	var base_text = base_input.text.strip_edges()
	var height_text = height_input.text.strip_edges()

	if not _is_valid(base_text) or not _is_valid(height_text):
		result.text = "Error! Invalid values."
		result.modulate = Color.RED
		return

	var b = float(base_text)
	var h = float(height_text)
	
	var r : Rectangle = create_rectangle(b,h)

	result.modulate = Color.WHITE
	result.text = str(r)

#endregion

func create_rectangle(width: float, height: float) -> Rectangle:
	#TODO Create instance of Rectangle class and configure width and height
	return null

class Rectangle:
	var _width: float
	var _height: float

	func _init(p_width: float, p_height: float) -> void:
		# TODO
		pass

	func set_width(value: float) -> void:
		# TODO
		pass

	func set_height(value: float) -> void:
		# TODO
		pass
		
	func get_width() -> float:
		# TODO
		return 0.0

	func get_height() -> float:
		# TODO
		return 0.0

	func calculate_area() -> float:
		# TODO
		return 0.0

	func calculate_perimeter() -> float:
		# TODO
		return 0.0
		
	func _to_string() -> String:
		var area : String = Numeros.formatar(calculate_area())
		var perimeter : String = Numeros.formatar(calculate_perimeter())
		var height : String = Numeros.formatar(get_height())
		var width : String = Numeros.formatar(get_width())
		
		return "[Rectangle]:\nHeight = %s\nWidth = %s\nArea = %s\nPerimeter = %s" % \
		[height, width, area, perimeter]
