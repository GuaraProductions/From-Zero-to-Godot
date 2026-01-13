extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"classe": "Circulo",
			"nome": "⭕ Circulo.area() calcula corretamente (r=5)",
			"metodo": "",
			"construtor_params": [5.0],
			"entrada": [],
			"validar": "validar_circulo_area_5"
		},
		{
			"classe": "Circulo",
			"nome": "⭕ Circulo.area() calcula corretamente (r=10)",
			"metodo": "",
			"construtor_params": [10.0],
			"entrada": [],
			"validar": "validar_circulo_area_10"
		},
		{
			"classe": "Quadrado",
			"nome": "⬛ Quadrado.area() calcula corretamente (l=4)",
			"metodo": "",
			"construtor_params": [4.0],
			"entrada": [],
			"validar": "validar_quadrado_area_4"
		},
		{
			"classe": "Quadrado",
			"nome": "⬛ Quadrado.area() calcula corretamente (l=8)",
			"metodo": "",
			"construtor_params": [8.0],
			"entrada": [],
			"validar": "validar_quadrado_area_8"
		},
		{
			"classe": "Triangulo",
			"nome": "🔺 Triangulo.area() calcula corretamente (b=6, h=3)",
			"metodo": "",
			"construtor_params": [6.0, 3.0],
			"entrada": [],
			"validar": "validar_triangulo_area_6_3"
		},
		{
			"classe": "Triangulo",
			"nome": "🔺 Triangulo.area() calcula corretamente (b=10, h=5)",
			"metodo": "",
			"construtor_params": [10.0, 5.0],
			"entrada": [],
			"validar": "validar_triangulo_area_10_5"
		},
		{
			"classe": "Circulo",
			"nome": "🔗 Circulo herda de Forma",
			"metodo": "",
			"construtor_params": [1.0],
			"entrada": [],
			"validar": "validar_circulo_heranca"
		},
		{
			"classe": "Quadrado",
			"nome": "🔗 Quadrado herda de Forma",
			"metodo": "",
			"construtor_params": [1.0],
			"entrada": [],
			"validar": "validar_quadrado_heranca"
		},
		{
			"classe": "Triangulo",
			"nome": "🔗 Triangulo herda de Forma",
			"metodo": "",
			"construtor_params": [1.0, 1.0],
			"entrada": [],
			"validar": "validar_triangulo_heranca"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_circulo_area_5(resultado, instancia) -> Dictionary:
	if not instancia.has_method("area"):
		return {
			"sucesso": false,
			"erro": "Circulo deve ter método area()",
			"saida_esperada": "Método area() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	var area = instancia.area()
	
	if not area is float and not area is int:
		return {
			"sucesso": false,
			"erro": "area() deve retornar float ou int",
			"saida_esperada": "float",
			"saida_obtida": type_string(typeof(area))
		}
	
	var esperado = PI * 5.0 * 5.0  # π * r²
	if abs(area - esperado) > 0.01:
		return {
			"sucesso": false,
			"erro": "Área do círculo incorreta (π × r²)",
			"saida_esperada": "~%.2f" % esperado,
			"saida_obtida": "%.2f" % area
		}
	
	return {"sucesso": true, "erro": ""}

func validar_circulo_area_10(resultado, instancia) -> Dictionary:
	var area = instancia.area()
	var esperado = PI * 10.0 * 10.0
	
	if abs(area - esperado) > 0.01:
		return {
			"sucesso": false,
			"erro": "Área do círculo incorreta (π × r²)",
			"saida_esperada": "~%.2f" % esperado,
			"saida_obtida": "%.2f" % area
		}
	
	return {"sucesso": true, "erro": ""}

func validar_quadrado_area_4(resultado, instancia) -> Dictionary:
	if not instancia.has_method("area"):
		return {
			"sucesso": false,
			"erro": "Quadrado deve ter método area()",
			"saida_esperada": "Método area() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	var area = instancia.area()
	
	if not area is float and not area is int:
		return {
			"sucesso": false,
			"erro": "area() deve retornar float ou int",
			"saida_esperada": "float",
			"saida_obtida": type_string(typeof(area))
		}
	
	if abs(area - 16.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Área do quadrado incorreta (lado²)",
			"saida_esperada": 16.0,
			"saida_obtida": area
		}
	
	return {"sucesso": true, "erro": ""}

func validar_quadrado_area_8(resultado, instancia) -> Dictionary:
	var area = instancia.area()
	
	if abs(area - 64.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Área do quadrado incorreta (lado²)",
			"saida_esperada": 64.0,
			"saida_obtida": area
		}
	
	return {"sucesso": true, "erro": ""}

func validar_triangulo_area_6_3(resultado, instancia) -> Dictionary:
	if not instancia.has_method("area"):
		return {
			"sucesso": false,
			"erro": "Triangulo deve ter método area()",
			"saida_esperada": "Método area() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	var area = instancia.area()
	
	if not area is float and not area is int:
		return {
			"sucesso": false,
			"erro": "area() deve retornar float ou int",
			"saida_esperada": "float",
			"saida_obtida": type_string(typeof(area))
		}
	
	var esperado = (6.0 * 3.0) / 2.0  # (base × altura) / 2
	if abs(area - esperado) > 0.001:
		return {
			"sucesso": false,
			"erro": "Área do triângulo incorreta ((base × altura) / 2)",
			"saida_esperada": esperado,
			"saida_obtida": area
		}
	
	return {"sucesso": true, "erro": ""}

func validar_triangulo_area_10_5(resultado, instancia) -> Dictionary:
	var area = instancia.area()
	var esperado = (10.0 * 5.0) / 2.0
	
	if abs(area - esperado) > 0.001:
		return {
			"sucesso": false,
			"erro": "Área do triângulo incorreta ((base × altura) / 2)",
			"saida_esperada": esperado,
			"saida_obtida": area
		}
	
	return {"sucesso": true, "erro": ""}

func validar_circulo_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio5/Exercicio5.gd")
	var classe_forma = script_exercicio.Forma
	
	if not instancia is classe_forma:
		return {
			"sucesso": false,
			"erro": "Circulo deve herdar de Forma (extends Forma)",
			"saida_esperada": "Circulo extends Forma",
			"saida_obtida": "Circulo não herda de Forma"
		}
	
	return {"sucesso": true, "erro": ""}

func validar_quadrado_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio5/Exercicio5.gd")
	var classe_forma = script_exercicio.Forma
	
	if not instancia is classe_forma:
		return {
			"sucesso": false,
			"erro": "Quadrado deve herdar de Forma (extends Forma)",
			"saida_esperada": "Quadrado extends Forma",
			"saida_obtida": "Quadrado não herda de Forma"
		}
	
	return {"sucesso": true, "erro": ""}

func validar_triangulo_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio5/Exercicio5.gd")
	var classe_forma = script_exercicio.Forma
	
	if not instancia is classe_forma:
		return {
			"sucesso": false,
			"erro": "Triangulo deve herdar de Forma (extends Forma)",
			"saida_esperada": "Triangulo extends Forma",
			"saida_obtida": "Triangulo não herda de Forma"
		}
	
	return {"sucesso": true, "erro": ""}
