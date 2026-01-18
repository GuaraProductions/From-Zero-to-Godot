extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"class": "Cachorro",
			"name": "🐕 Cachorro.falar() retorna 'Au au!'",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validar_cachorro_falar"
		},
		{
			"class": "Gato",
			"name": "🐈 Gato.falar() retorna 'Miau!'",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validar_gato_falar"
		},
		{
			"class": "Ovelha",
			"name": "🐑 Ovelha.falar() retorna 'Beehhh!'",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validar_ovelha_falar"
		},
		{
			"class": "Cachorro",
			"name": "🔗 Cachorro herda de Animal",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validar_cachorro_heranca"
		},
		{
			"class": "Gato",
			"name": "🔗 Gato herda de Animal",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validar_gato_heranca"
		},
		{
			"class": "Ovelha",
			"name": "🔗 Ovelha herda de Animal",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validar_ovelha_heranca"
		},
		{
			"class": "Cachorro",
			"name": "🎵 Cachorro armazena efeito_sonoro",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validar_cachorro_efeito_sonoro"
		},
		{
			"class": "Gato",
			"name": "🎵 Gato armazena efeito_sonoro",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validar_gato_efeito_sonoro"
		},
		{
			"class": "Ovelha",
			"name": "🎵 Ovelha armazena efeito_sonoro",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validar_ovelha_efeito_sonoro"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_cachorro_falar(resultado, instancia) -> Dictionary:
	var fala = instancia.falar()
	
	if not fala is String:
		return {
			"success": false,
			"error": "falar() deve retornar String",
			"expected_output": "String",
			"actual_output": type_string(typeof(fala))
		}
	
	if fala != "Au au!":
		return {
			"success": false,
			"error": "Cachorro deve falar 'Au au!'",
			"expected_output": "Au au!",
			"actual_output": fala
		}
	
	return {"success": true, "error": ""}

func validar_gato_falar(resultado, instancia) -> Dictionary:
	var fala = instancia.falar()
	
	if not fala is String:
		return {
			"success": false,
			"error": "falar() deve retornar String",
			"expected_output": "String",
			"actual_output": type_string(typeof(fala))
		}
	
	if fala != "Miau!":
		return {
			"success": false,
			"error": "Gato deve falar 'Miau!'",
			"expected_output": "Miau!",
			"actual_output": fala
		}
	
	return {"success": true, "error": ""}

func validar_ovelha_falar(resultado, instancia) -> Dictionary:
	var fala = instancia.falar()
	
	if not fala is String:
		return {
			"success": false,
			"error": "falar() deve retornar String",
			"expected_output": "String",
			"actual_output": type_string(typeof(fala))
		}
	
	if fala != "Beehhh!":
		return {
			"success": false,
			"error": "Ovelha deve falar 'Beehhh!'",
			"expected_output": "Beehhh!",
			"actual_output": fala
		}
	
	return {"success": true, "error": ""}

func validar_cachorro_heranca(resultado, instancia) -> Dictionary:
	# Carrega a classe Animal do script
	var script_exercicio = load("res://listas/Lista3/Exercicio2/Exercicio2.gd")
	var classe_animal = script_exercicio.get("Animal")
	
	if not is_instance_of(instancia, classe_animal):
		return {
			"success": false,
			"error": "Cachorro deve herdar de Animal (extends Animal)",
			"expected_output": "Cachorro extends Animal",
			"actual_output": "Cachorro não herda de Animal"
		}
	
	return {"success": true, "error": ""}

func validar_gato_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio2/Exercicio2.gd")
	var classe_animal = script_exercicio.Animal
	
	if not is_instance_of(instancia, classe_animal):
		return {
			"success": false,
			"error": "Gato deve herdar de Animal (extends Animal)",
			"expected_output": "Gato extends Animal",
			"actual_output": "Gato não herda de Animal"
		}
	
	return {"success": true, "error": ""}

func validar_ovelha_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio2/Exercicio2.gd")
	var classe_animal = script_exercicio.Animal
	
	if not is_instance_of(instancia, classe_animal):
		return {
			"success": false,
			"error": "Ovelha deve herdar de Animal (extends Animal)",
			"expected_output": "Ovelha extends Animal",
			"actual_output": "Ovelha não herda de Animal"
		}
	
	return {"success": true, "error": ""}

func validar_cachorro_efeito_sonoro(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_efeito_sonoro"):
		return {
			"success": false,
			"error": "Cachorro deve ter método get_efeito_sonoro() (herdado de Animal)",
			"expected_output": "Método get_efeito_sonoro() disponível",
			"actual_output": "Método não encontrado"
		}
	
	var efeito = instancia.get_efeito_sonoro()
	
	# efeito_sonoro foi passado no construtor
	if efeito == null:
		return {
			"success": false,
			"error": "efeito_sonoro deve ser atribuído no construtor",
			"expected_output": "AudioStreamOggVorbis atribuído",
			"actual_output": "null"
		}
	
	return {"success": true, "error": ""}

func validar_gato_efeito_sonoro(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_efeito_sonoro"):
		return {
			"success": false,
			"error": "Gato deve ter método get_efeito_sonoro() (herdado de Animal)",
			"expected_output": "Método get_efeito_sonoro() disponível",
			"actual_output": "Método não encontrado"
		}
	
	var efeito = instancia.get_efeito_sonoro()
	
	if efeito == null:
		return {
			"success": false,
			"error": "efeito_sonoro deve ser atribuído no construtor",
			"expected_output": "AudioStreamOggVorbis atribuído",
			"actual_output": "null"
		}
	
	return {"success": true, "error": ""}

func validar_ovelha_efeito_sonoro(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_efeito_sonoro"):
		return {
			"success": false,
			"error": "Ovelha deve ter método get_efeito_sonoro() (herdado de Animal)",
			"expected_output": "Método get_efeito_sonoro() disponível",
			"actual_output": "Método não encontrado"
		}
	
	var efeito = instancia.get_efeito_sonoro()
	
	if efeito == null:
		return {
			"success": false,
			"error": "efeito_sonoro deve ser atribuído no construtor",
			"expected_output": "AudioStreamOggVorbis atribuído",
			"actual_output": "null"
		}
	
	return {"success": true, "error": ""}
