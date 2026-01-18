extends MarginContainer

#region AlreadyImplemented

@onready var circle_line_edit: LineEdit = $Center/GridContainer/CirculoLineEdit
@onready var square_line_edit: LineEdit = $Center/GridContainer/QuadradoLineEdit
@onready var triangle_height_line_edit: LineEdit = $Center/GridContainer/VBoxContainer/TrianguloAlturaLineEdit
@onready var triangle_base_line_edit: LineEdit = $Center/GridContainer/VBoxContainer/TrianguloBaseLineEdit

@onready var circle_result: Label = $Center/GridContainer/CirculoResultado
@onready var square_result: Label = $Center/GridContainer/QuadradoResultado
@onready var triangle_result: Label = $Center/GridContainer/TrianguloResultado

func _is_valid(text: String) -> bool:
	return text.is_valid_float() and float(text) > 0

#endregion

func _on_circulo_pressed() -> void:
	var text = circle_line_edit.text
	if not _is_valid(text):
		circle_result.text = "Error! Invalid radius."
		circle_result.modulate = Color.RED
		return
	var r = float(text)
	var area : float = 0
	
	#TODO
	#var shape: Shape = Circle.new(r)
	#area = shape.area()
	
	circle_result.modulate = Color.WHITE
	circle_result.text = "Circle Area: %s" % Numeros.formatar(area)

func _on_quadrado_pressed() -> void:
	var text = square_line_edit.text
	if not _is_valid(text):
		square_result.text = "Error! Invalid side."
		square_result.modulate = Color.RED
		return
	var l = float(text)
	var area : float = 0
	
	#TODO
	#var shape: Shape = Square.new(l)
	#var area = shape.area()
	
	square_result.modulate = Color.WHITE
	square_result.text = "Square Area: %s" % Numeros.formatar(area)

func _on_triangulo_pressed() -> void:
	var text_b = triangle_base_line_edit.text
	var text_h = triangle_height_line_edit.text
	if not _is_valid(text_b) or not _is_valid(text_h):
		triangle_result.text = "Error! Invalid base or height."
		triangle_result.modulate = Color.RED
		return
	var b = float(text_b)
	var h = float(text_h)
	var area : float = 0
	
	#TODO
	#var shape: Shape = Triangle.new(b, h)
	#var area = shape.area()
	
	triangle_result.modulate = Color.WHITE
	triangle_result.text = "Triangle Area: %s" % Numeros.formatar(area)
