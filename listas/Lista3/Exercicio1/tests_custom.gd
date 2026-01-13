extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"classe": "Retangulo",
			"nome": "📐 Construtor inicializa base e altura",
			"metodo": "",
			"construtor_params": [10.0, 5.0],
			"entrada": [],
			"validar": "validar_construtor"
		},
		{
			"classe": "Retangulo",
			"nome": "📏 get_base() retorna base correta",
			"metodo": "",
			"construtor_params": [8.0, 4.0],
			"entrada": [],
			"validar": "validar_get_base"
		},
		{
			"classe": "Retangulo",
			"nome": "📏 get_altura() retorna altura correta",
			"metodo": "",
			"construtor_params": [8.0, 4.0],
			"entrada": [],
			"validar": "validar_get_altura"
		},
		{
			"classe": "Retangulo",
			"nome": "✏️ set_base() altera base",
			"metodo": "",
			"construtor_params": [5.0, 3.0],
			"entrada": [],
			"validar": "validar_set_base"
		},
		{
			"classe": "Retangulo",
			"nome": "✏️ set_altura() altera altura",
			"metodo": "",
			"construtor_params": [5.0, 3.0],
			"entrada": [],
			"validar": "validar_set_altura"
		},
		{
			"classe": "Retangulo",
			"nome": "📦 calcular_area() calcula corretamente (10x5=50)",
			"metodo": "",
			"construtor_params": [10.0, 5.0],
			"entrada": [],
			"validar": "validar_calcular_area"
		},
		{
			"classe": "Retangulo",
			"nome": "📦 calcular_area() calcula corretamente (7x3=21)",
			"metodo": "",
			"construtor_params": [7.0, 3.0],
			"entrada": [],
			"validar": "validar_calcular_area_caso2"
		},
		{
			"classe": "Retangulo",
			"nome": "🔲 calcular_perimetro() calcula corretamente (10x5=30)",
			"metodo": "",
			"construtor_params": [10.0, 5.0],
			"entrada": [],
			"validar": "validar_calcular_perimetro"
		},
		{
			"classe": "Retangulo",
			"nome": "🔲 calcular_perimetro() calcula corretamente (7x3=20)",
			"metodo": "",
			"construtor_params": [7.0, 3.0],
			"entrada": [],
			"validar": "validar_calcular_perimetro_caso2"
		},
		{
			"classe": "Retangulo",
			"nome": "🔒 Atributos _base e _altura são privados",
			"metodo": "",
			"construtor_params": [6.0, 4.0],
			"entrada": [],
			"validar": "validar_encapsulamento"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_construtor(resultado, instancia) -> Dictionary:
	var base = instancia.get_base()
	var altura = instancia.get_altura()
	
	if not base is float and not base is int:
		return {
			"sucesso": false,
			"erro": "get_base() deve retornar float ou int",
			"saida_esperada": 10.0,
			"saida_obtida": type_string(typeof(base))
		}
	
	if abs(base - 10.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Base não foi inicializada corretamente",
			"saida_esperada": 10.0,
			"saida_obtida": base
		}
	
	if abs(altura - 5.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Altura não foi inicializada corretamente",
			"saida_esperada": 5.0,
			"saida_obtida": altura
		}
	
	return {"sucesso": true, "erro": ""}

func validar_get_base(resultado, instancia) -> Dictionary:
	var base = instancia.get_base()
	
	if not base is float and not base is int:
		return {
			"sucesso": false,
			"erro": "get_base() deve retornar float ou int",
			"saida_esperada": "float",
			"saida_obtida": type_string(typeof(base))
		}
	
	if abs(base - 8.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "get_base() não retorna valor correto",
			"saida_esperada": 8.0,
			"saida_obtida": base
		}
	
	return {"sucesso": true, "erro": ""}

func validar_get_altura(resultado, instancia) -> Dictionary:
	var altura = instancia.get_altura()
	
	if not altura is float and not altura is int:
		return {
			"sucesso": false,
			"erro": "get_altura() deve retornar float ou int",
			"saida_esperada": "float",
			"saida_obtida": type_string(typeof(altura))
		}
	
	if abs(altura - 4.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "get_altura() não retorna valor correto",
			"saida_esperada": 4.0,
			"saida_obtida": altura
		}
	
	return {"sucesso": true, "erro": ""}

func validar_set_base(resultado, instancia) -> Dictionary:
	instancia.set_base(15.0)
	var nova_base = instancia.get_base()
	
	if abs(nova_base - 15.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "set_base() não altera o valor corretamente",
			"saida_esperada": 15.0,
			"saida_obtida": nova_base
		}
	
	return {"sucesso": true, "erro": ""}

func validar_set_altura(resultado, instancia) -> Dictionary:
	instancia.set_altura(12.0)
	var nova_altura = instancia.get_altura()
	
	if abs(nova_altura - 12.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "set_altura() não altera o valor corretamente",
			"saida_esperada": 12.0,
			"saida_obtida": nova_altura
		}
	
	return {"sucesso": true, "erro": ""}

func validar_calcular_area(resultado, instancia) -> Dictionary:
	var area = instancia.calcular_area()
	
	if not area is float and not area is int:
		return {
			"sucesso": false,
			"erro": "calcular_area() deve retornar float ou int",
			"saida_esperada": "float",
			"saida_obtida": type_string(typeof(area))
		}
	
	if abs(area - 50.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Área calculada incorretamente (base × altura)",
			"saida_esperada": 50.0,
			"saida_obtida": area
		}
	
	return {"sucesso": true, "erro": ""}

func validar_calcular_area_caso2(resultado, instancia) -> Dictionary:
	var area = instancia.calcular_area()
	
	if abs(area - 21.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Área calculada incorretamente (7 × 3 = 21)",
			"saida_esperada": 21.0,
			"saida_obtida": area
		}
	
	return {"sucesso": true, "erro": ""}

func validar_calcular_perimetro(resultado, instancia) -> Dictionary:
	var perimetro = instancia.calcular_perimetro()
	
	if not perimetro is float and not perimetro is int:
		return {
			"sucesso": false,
			"erro": "calcular_perimetro() deve retornar float ou int",
			"saida_esperada": "float",
			"saida_obtida": type_string(typeof(perimetro))
		}
	
	if abs(perimetro - 30.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Perímetro calculado incorretamente (2 × (base + altura))",
			"saida_esperada": 30.0,
			"saida_obtida": perimetro
		}
	
	return {"sucesso": true, "erro": ""}

func validar_calcular_perimetro_caso2(resultado, instancia) -> Dictionary:
	var perimetro = instancia.calcular_perimetro()
	
	if abs(perimetro - 20.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Perímetro calculado incorretamente (2 × (7 + 3) = 20)",
			"saida_esperada": 20.0,
			"saida_obtida": perimetro
		}
	
	return {"sucesso": true, "erro": ""}

func validar_encapsulamento(resultado, instancia) -> Dictionary:
	# Verifica se tem propriedades privadas _base e _altura
	var tem_base_publica = "base" in instancia
	var tem_altura_publica = "altura" in instancia
	
	if tem_base_publica or tem_altura_publica:
		return {
			"sucesso": false,
			"erro": "Use atributos privados (_base, _altura), não públicos",
			"saida_esperada": "Atributos privados com underscore",
			"saida_obtida": "Atributos públicos encontrados"
		}
	
	return {"sucesso": true, "erro": ""}
