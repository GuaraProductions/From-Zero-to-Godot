extends Node

func get_test_cases() -> Array[Dictionary]:
	return [
		{
			"class": "Circulo",
			"name": "⭕ Circulo.area() calcula corretamente (r=5)",
			"method": "",
			"constructor_params": [5.0],
			"input": [],
			"validate": "validar_circulo_area_5"
		},
		{
			"class": "Circulo",
			"name": "⭕ Circulo.area() calcula corretamente (r=10)",
			"method": "",
			"constructor_params": [10.0],
			"input": [],
			"validate": "validar_circulo_area_10"
		},
		{
			"class": "Quadrado",
			"name": "⬛ Quadrado.area() calcula corretamente (l=4)",
			"method": "",
			"constructor_params": [4.0],
			"input": [],
			"validate": "validar_quadrado_area_4"
		},
		{
			"class": "Quadrado",
			"name": "⬛ Quadrado.area() calcula corretamente (l=8)",
			"method": "",
			"constructor_params": [8.0],
			"input": [],
			"validate": "validar_quadrado_area_8"
		},
		{
			"class": "Triangulo",
			"name": "🔺 Triangulo.area() calcula corretamente (b=6, h=3)",
			"method": "",
			"constructor_params": [6.0, 3.0],
			"input": [],
			"validate": "validar_triangulo_area_6_3"
		},
		{
			"class": "Triangulo",
			"name": "🔺 Triangulo.area() calcula corretamente (b=10, h=5)",
			"method": "",
			"constructor_params": [10.0, 5.0],
			"input": [],
			"validate": "validar_triangulo_area_10_5"
		},
		{
			"class": "Circulo",
			"name": "🔗 Circulo herda de Forma",
			"method": "",
			"constructor_params": [1.0],
			"input": [],
			"validate": "validar_circulo_heranca"
		},
		{
			"class": "Quadrado",
			"name": "🔗 Quadrado herda de Forma",
			"method": "",
			"constructor_params": [1.0],
			"input": [],
			"validate": "validar_quadrado_heranca"
		},
		{
			"class": "Triangulo",
			"name": "🔗 Triangulo herda de Forma",
			"method": "",
			"constructor_params": [1.0, 1.0],
			"input": [],
			"validate": "validar_triangulo_heranca"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_circulo_area_5(resultado, instancia) -> Dictionary:
	if not instancia.has_method("area"):
		return {
			"success": false,
			"error": "Circulo deve ter método area()",
			"expected_output": "Método area() existe",
			"actual_output": "Método não encontrado"
		}
	
	var area = instancia.area()
	
	if not area is float and not area is int:
		return {
			"success": false,
			"error": "area() deve retornar float ou int",
			"expected_output": "float",
			"actual_output": type_string(typeof(area))
		}
	
	var esperado = PI * 5.0 * 5.0  # π * r²
	if abs(area - esperado) > 0.01:
		return {
			"success": false,
			"error": "Área do círculo incorreta (π × r²)",
			"expected_output": "~%.2f" % esperado,
			"actual_output": "%.2f" % area
		}
	
	return {"success": true, "error": ""}

func validar_circulo_area_10(resultado, instancia) -> Dictionary:
	var area = instancia.area()
	var esperado = PI * 10.0 * 10.0
	
	if abs(area - esperado) > 0.01:
		return {
			"success": false,
			"error": "Área do círculo incorreta (π × r²)",
			"expected_output": "~%.2f" % esperado,
			"actual_output": "%.2f" % area
		}
	
	return {"success": true, "error": ""}

func validar_quadrado_area_4(resultado, instancia) -> Dictionary:
	if not instancia.has_method("area"):
		return {
			"success": false,
			"error": "Quadrado deve ter método area()",
			"expected_output": "Método area() existe",
			"actual_output": "Método não encontrado"
		}
	
	var area = instancia.area()
	
	if not area is float and not area is int:
		return {
			"success": false,
			"error": "area() deve retornar float ou int",
			"expected_output": "float",
			"actual_output": type_string(typeof(area))
		}
	
	if abs(area - 16.0) > 0.001:
		return {
			"success": false,
			"error": "Área do quadrado incorreta (lado²)",
			"expected_output": 16.0,
			"actual_output": area
		}
	
	return {"success": true, "error": ""}

func validar_quadrado_area_8(resultado, instancia) -> Dictionary:
	var area = instancia.area()
	
	if abs(area - 64.0) > 0.001:
		return {
			"success": false,
			"error": "Área do quadrado incorreta (lado²)",
			"expected_output": 64.0,
			"actual_output": area
		}
	
	return {"success": true, "error": ""}

func validar_triangulo_area_6_3(resultado, instancia) -> Dictionary:
	if not instancia.has_method("area"):
		return {
			"success": false,
			"error": "Triangulo deve ter método area()",
			"expected_output": "Método area() existe",
			"actual_output": "Método não encontrado"
		}
	
	var area = instancia.area()
	
	if not area is float and not area is int:
		return {
			"success": false,
			"error": "area() deve retornar float ou int",
			"expected_output": "float",
			"actual_output": type_string(typeof(area))
		}
	
	var esperado = (6.0 * 3.0) / 2.0  # (base × altura) / 2
	if abs(area - esperado) > 0.001:
		return {
			"success": false,
			"error": "Área do triângulo incorreta ((base × altura) / 2)",
			"expected_output": esperado,
			"actual_output": area
		}
	
	return {"success": true, "error": ""}

func validar_triangulo_area_10_5(resultado, instancia) -> Dictionary:
	var area = instancia.area()
	var esperado = (10.0 * 5.0) / 2.0
	
	if abs(area - esperado) > 0.001:
		return {
			"success": false,
			"error": "Área do triângulo incorreta ((base × altura) / 2)",
			"expected_output": esperado,
			"actual_output": area
		}
	
	return {"success": true, "error": ""}

func validar_circulo_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio5/Exercicio5.gd")
	var classe_forma = script_exercicio.get("Forma")
	
	if not is_instance_of(instancia, classe_forma):
		return {
			"success": false,
			"error": "Circulo deve herdar de Forma (extends Forma)",
			"expected_output": "Circulo extends Forma",
			"actual_output": "Circulo não herda de Forma"
		}
	
	return {"success": true, "error": ""}

func validar_quadrado_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio5/Exercicio5.gd")
	var classe_forma = script_exercicio.Forma
	
	if not is_instance_of(instancia, classe_forma):
		return {
			"success": false,
			"error": "Quadrado deve herdar de Forma (extends Forma)",
			"expected_output": "Quadrado extends Forma",
			"actual_output": "Quadrado não herda de Forma"
		}
	
	return {"success": true, "error": ""}

func validar_triangulo_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio5/Exercicio5.gd")
	var classe_forma = script_exercicio.Forma
	
	if not is_instance_of(instancia, classe_forma):
		return {
			"success": false,
			"error": "Triangulo deve herdar de Forma (extends Forma)",
			"expected_output": "Triangulo extends Forma",
			"actual_output": "Triangulo não herda de Forma"
		}
	
	return {"success": true, "error": ""}
