extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"class": "Rectangle",
			"name": "📐 Construtor inicializa base e altura",
			"method": "",
			"constructor_params": [10.0, 5.0],
			"input": [],
			"validate": "validar_construtor"
		},
		{
			"class": "Rectangle",
			"name": "📏 get_width() retorna base correta",
			"method": "",
			"constructor_params": [8.0, 4.0],
			"input": [],
			"validate": "validar_get_width"
		},
		{
			"class": "Rectangle",
			"name": "📏 get_height() retorna altura correta",
			"method": "",
			"constructor_params": [8.0, 4.0],
			"input": [],
			"validate": "validar_get_height"
		},
		{
			"class": "Rectangle",
			"name": "✏️ set_width() altera base",
			"method": "",
			"constructor_params": [5.0, 3.0],
			"input": [],
			"validate": "validar_set_width"
		},
		{
			"class": "Rectangle",
			"name": "✏️ set_height() altera altura",
			"method": "",
			"constructor_params": [5.0, 3.0],
			"input": [],
			"validate": "validar_set_height"
		},
		{
			"class": "Rectangle",
			"name": "📦 calculate_area() calcula corretamente (10x5=50)",
			"method": "",
			"constructor_params": [10.0, 5.0],
			"input": [],
			"validate": "validar_calculate_area"
		},
		{
			"class": "Rectangle",
			"name": "📦 calculate_area() calcula corretamente (7x3=21)",
			"method": "",
			"constructor_params": [7.0, 3.0],
			"input": [],
			"validate": "validar_calculate_area_caso2"
		},
		{
			"class": "Rectangle",
			"name": "🔲 calculate_perimeter() calcula corretamente (10x5=30)",
			"method": "",
			"constructor_params": [10.0, 5.0],
			"input": [],
			"validate": "validar_calculate_perimeter"
		},
		{
			"class": "Rectangle",
			"name": "🔲 calculate_perimeter() calcula corretamente (7x3=20)",
			"method": "",
			"constructor_params": [7.0, 3.0],
			"input": [],
			"validate": "validar_calculate_perimeter_caso2"
		},
		{
			"class": "Rectangle",
			"name": "🔒 Atributos _width e _height são privados",
			"method": "",
			"constructor_params": [6.0, 4.0],
			"input": [],
			"validate": "validar_encapsulamento"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_construtor(resultado, instancia) -> Dictionary:
	var base = instancia.get_width()
	var altura = instancia.get_height()
	
	if not base is float and not base is int:
		return {
			"success": false,
			"error": "get_width() deve retornar float ou int",
			"expected_output": 10.0,
			"actual_output": type_string(typeof(base))
		}
	
	if abs(base - 10.0) > 0.001:
		return {
			"success": false,
			"error": "Base não foi inicializada corretamente",
			"expected_output": 10.0,
			"actual_output": base
		}
	
	if abs(altura - 5.0) > 0.001:
		return {
			"success": false,
			"error": "Altura não foi inicializada corretamente",
			"expected_output": 5.0,
			"actual_output": altura
		}
	
	return {"success": true, "error": ""}

func validar_get_width(resultado, instancia) -> Dictionary:
	var base = instancia.get_width()
	
	if not base is float and not base is int:
		return {
			"success": false,
			"error": "get_width() deve retornar float ou int",
			"expected_output": "float",
			"actual_output": type_string(typeof(base))
		}
	
	if abs(base - 8.0) > 0.001:
		return {
			"success": false,
			"error": "get_width() não retorna valor correto",
			"expected_output": 8.0,
			"actual_output": base
		}
	
	return {"success": true, "error": ""}

func validar_get_height(resultado, instancia) -> Dictionary:
	var altura = instancia.get_height()
	
	if not altura is float and not altura is int:
		return {
			"success": false,
			"error": "get_height() deve retornar float ou int",
			"expected_output": "float",
			"actual_output": type_string(typeof(altura))
		}
	
	if abs(altura - 4.0) > 0.001:
		return {
			"success": false,
			"error": "get_height() não retorna valor correto",
			"expected_output": 4.0,
			"actual_output": altura
		}
	
	return {"success": true, "error": ""}

func validar_set_width(resultado, instancia) -> Dictionary:
	instancia.set_width(15.0)
	var nova_width = instancia.get_width()
	
	if abs(nova_width - 15.0) > 0.001:
		return {
			"success": false,
			"error": "set_width() não altera o valor corretamente",
			"expected_output": 15.0,
			"actual_output": nova_width
		}
	
	return {"success": true, "error": ""}

func validar_set_height(resultado, instancia) -> Dictionary:
	instancia.set_height(12.0)
	var nova_height = instancia.get_height()
	
	if abs(nova_height - 12.0) > 0.001:
		return {
			"success": false,
			"error": "set_height() não altera o valor corretamente",
			"expected_output": 12.0,
			"actual_output": nova_height
		}
	
	return {"success": true, "error": ""}

func validar_calculate_area(resultado, instancia) -> Dictionary:
	var area = instancia.calculate_area()
	
	if not area is float and not area is int:
		return {
			"success": false,
			"error": "calculate_area() deve retornar float ou int",
			"expected_output": "float",
			"actual_output": type_string(typeof(area))
		}
	
	if abs(area - 50.0) > 0.001:
		return {
			"success": false,
			"error": "Área calculada incorretamente (base × altura)",
			"expected_output": 50.0,
			"actual_output": area
		}
	
	return {"success": true, "error": ""}

func validar_calculate_area_caso2(resultado, instancia) -> Dictionary:
	var area = instancia.calculate_area()
	
	if abs(area - 21.0) > 0.001:
		return {
			"success": false,
			"error": "Área calculada incorretamente (7 × 3 = 21)",
			"expected_output": 21.0,
			"actual_output": area
		}
	
	return {"success": true, "error": ""}

func validar_calculate_perimeter(resultado, instancia) -> Dictionary:
	var perimetro = instancia.calculate_perimeter()
	
	if not perimetro is float and not perimetro is int:
		return {
			"success": false,
			"error": "calculate_perimeter() deve retornar float ou int",
			"expected_output": "float",
			"actual_output": type_string(typeof(perimetro))
		}
	
	if abs(perimetro - 30.0) > 0.001:
		return {
			"success": false,
			"error": "Perímetro calculado incorretamente (2 × (base + altura))",
			"expected_output": 30.0,
			"actual_output": perimetro
		}
	
	return {"success": true, "error": ""}

func validar_calculate_perimeter_caso2(resultado, instancia) -> Dictionary:
	var perimetro = instancia.calculate_perimeter()
	
	if abs(perimetro - 20.0) > 0.001:
		return {
			"success": false,
			"error": "Perímetro calculado incorretamente (2 × (7 + 3) = 20)",
			"expected_output": 20.0,
			"actual_output": perimetro
		}
	
	return {"success": true, "error": ""}

func validar_encapsulamento(resultado, instancia) -> Dictionary:
	# Verifica se tem propriedades privadas _width e _height
	var tem_width_publica = "base" in instancia
	var tem_height_publica = "altura" in instancia
	
	if tem_width_publica or tem_height_publica:
		return {
			"success": false,
			"error": "Use atributos privados (_width, _height), não públicos",
			"expected_output": "Atributos privados com underscore",
			"actual_output": "Atributos públicos encontrados"
		}
	
	return {"success": true, "error": ""}
