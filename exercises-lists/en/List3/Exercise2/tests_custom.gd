extends Node

func get_test_cases() -> Array[Dictionary]:
	return [
		{
			"class": "Dog",
			"name": "🐕 Dog.speak() retorna 'Au au!'",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validate_cachorro_speak"
		},
		{
			"class": "Cat",
			"name": "🐈 Cat.speak() retorna 'Miau!'",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validate_gato_speak"
		},
		{
			"class": "Sheep",
			"name": "🐑 Sheep.speak() retorna 'Beehhh!'",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validate_ovelha_speak"
		},
		{
			"class": "Dog",
			"name": "🔗 Dog herda de Animal",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validate_cachorro_heranca"
		},
		{
			"class": "Cat",
			"name": "🔗 Cat herda de Animal",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validate_gato_heranca"
		},
		{
			"class": "Sheep",
			"name": "🔗 Sheep herda de Animal",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validate_ovelha_heranca"
		},
		{
			"class": "Dog",
			"name": "🎵 Dog armazena efeito_sonoro",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validate_cachorro_efeito_sonoro"
		},
		{
			"class": "Cat",
			"name": "🎵 Cat armazena efeito_sonoro",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validate_gato_efeito_sonoro"
		},
		{
			"class": "Sheep",
			"name": "🎵 Sheep armazena efeito_sonoro",
			"method": "",
			"constructor_params": [null],
			"input": [],
			"validate": "validate_ovelha_efeito_sonoro"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validate_cachorro_speak(resultado, instancia) -> Dictionary:
	var fala = instancia.speak()
	
	if not fala is String:
		return {
			"success": false,
			"error": "speak() must return a String",
			"expected_output": "String",
			"actual_output": type_string(typeof(fala))
		}
	
	if fala != "Au au!":
		return {
			"success": false,
			"error": "Dog deve speak 'Au au!'",
			"expected_output": "Au au!",
			"actual_output": fala
		}
	
	return {"success": true, "error": ""}

func validate_gato_speak(resultado, instancia) -> Dictionary:
	var fala = instancia.speak()
	
	if not fala is String:
		return {
			"success": false,
			"error": "speak() must return a String",
			"expected_output": "String",
			"actual_output": type_string(typeof(fala))
		}
	
	if fala != "Miau!":
		return {
			"success": false,
			"error": "Cat deve speak 'Miau!'",
			"expected_output": "Miau!",
			"actual_output": fala
		}
	
	return {"success": true, "error": ""}

func validate_ovelha_speak(resultado, instancia) -> Dictionary:
	var fala = instancia.speak()
	
	if not fala is String:
		return {
			"success": false,
			"error": "speak() must return a String",
			"expected_output": "String",
			"actual_output": type_string(typeof(fala))
		}
	
	if fala != "Beehhh!":
		return {
			"success": false,
			"error": "Sheep deve speak 'Beehhh!'",
			"expected_output": "Beehhh!",
			"actual_output": fala
		}
	
	return {"success": true, "error": ""}

func validate_cachorro_heranca(resultado, instancia) -> Dictionary:
	# Carrega a classe Animal do script
	var script_exercicio = load("res://listas/Lista3/Exercicio2/Exercicio2.gd")
	var classe_animal = script_exercicio.get("Animal")
	
	if not is_instance_of(instancia, classe_animal):
		return {
			"success": false,
			"error": "Dog deve herdar de Animal (extends Animal)",
			"expected_output": "Dog extends Animal",
			"actual_output": "Dog não herda de Animal"
		}
	
	return {"success": true, "error": ""}

func validate_gato_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio2/Exercicio2.gd")
	var classe_animal = script_exercicio.Animal
	
	if not is_instance_of(instancia, classe_animal):
		return {
			"success": false,
			"error": "Cat deve herdar de Animal (extends Animal)",
			"expected_output": "Cat extends Animal",
			"actual_output": "Cat não herda de Animal"
		}
	
	return {"success": true, "error": ""}

func validate_ovelha_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio2/Exercicio2.gd")
	var classe_animal = script_exercicio.Animal
	
	if not is_instance_of(instancia, classe_animal):
		return {
			"success": false,
			"error": "Sheep deve herdar de Animal (extends Animal)",
			"expected_output": "Sheep extends Animal",
			"actual_output": "Sheep não herda de Animal"
		}
	
	return {"success": true, "error": ""}

func validate_cachorro_efeito_sonoro(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_efeito_sonoro"):
		return {
			"success": false,
			"error": "Dog deve ter método get_efeito_sonoro() (herdado de Animal)",
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

func validate_gato_efeito_sonoro(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_efeito_sonoro"):
		return {
			"success": false,
			"error": "Cat deve ter método get_efeito_sonoro() (herdado de Animal)",
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

func validate_ovelha_efeito_sonoro(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_efeito_sonoro"):
		return {
			"success": false,
			"error": "Sheep deve ter método get_efeito_sonoro() (herdado de Animal)",
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
