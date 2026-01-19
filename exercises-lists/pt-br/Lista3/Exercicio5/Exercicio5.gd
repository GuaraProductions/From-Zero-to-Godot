extends MarginContainer

#region JahImplementado

@onready var circulo_line_edit: LineEdit = $Center/GridContainer/CirculoLineEdit
@onready var quadrado_line_edit: LineEdit = $Center/GridContainer/QuadradoLineEdit
@onready var triangulo_altura_line_edit: LineEdit = $Center/GridContainer/VBoxContainer/TrianguloAlturaLineEdit
@onready var triangulo_base_line_edit: LineEdit = $Center/GridContainer/VBoxContainer/TrianguloBaseLineEdit

@onready var circulo_resultado: Label = $Center/GridContainer/CirculoResultado
@onready var quadrado_resultado: Label = $Center/GridContainer/QuadradoResultado
@onready var triangulo_resultado: Label = $Center/GridContainer/TrianguloResultado

func _eh_valido(texto: String) -> bool:
	return texto.is_valid_float() and float(texto) > 0

#endregion

func _on_circulo_pressed() -> void:
	var texto = circulo_line_edit.text
	if not _eh_valido(texto):
		circulo_resultado.text = "Erro! Raio inválido."
		circulo_resultado.modulate = Color.RED
		return
	var r = float(texto)
	var area : float = 0
	
	#TODO
	#var forma: Forma = Circulo.new(r)
	#area = forma.area()
	
	circulo_resultado.modulate = Color.WHITE
	circulo_resultado.text = "Área do Círculo: %s" % Numeros.formatar(area)

func _on_quadrado_pressed() -> void:
	var texto = quadrado_line_edit.text
	if not _eh_valido(texto):
		quadrado_resultado.text = "Erro! Lado inválido."
		quadrado_resultado.modulate = Color.RED
		return
	var l = float(texto)
	var area : float = 0
	
	#TODO
	#var forma: Forma = Quadrado.new(l)
	#var area = forma.area()
	
	quadrado_resultado.modulate = Color.WHITE
	quadrado_resultado.text = "Área do Quadrado: %s" % Numeros.formatar(area)

func _on_triangulo_pressed() -> void:
	var texto_b = triangulo_base_line_edit.text
	var texto_h = triangulo_altura_line_edit.text
	if not _eh_valido(texto_b) or not _eh_valido(texto_h):
		triangulo_resultado.text = "Erro! Base ou altura inválida."
		triangulo_resultado.modulate = Color.RED
		return
	var b = float(texto_b)
	var h = float(texto_h)
	var area : float = 0
	
	#TODO
	#var forma: Forma = Triangulo.new(b, h)
	#var area = forma.area()
	
	triangulo_resultado.modulate = Color.WHITE
	triangulo_resultado.text = "Área do Triângulo: %s" % Numeros.formatar(area)
