extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"classe": "Cachorro",
			"nome": "🐕 Cachorro.falar() retorna 'Au au!'",
			"metodo": "",
			"construtor_params": [null],
			"entrada": [],
			"validar": "validar_cachorro_falar"
		},
		{
			"classe": "Gato",
			"nome": "🐈 Gato.falar() retorna 'Miau!'",
			"metodo": "",
			"construtor_params": [null],
			"entrada": [],
			"validar": "validar_gato_falar"
		},
		{
			"classe": "Ovelha",
			"nome": "🐑 Ovelha.falar() retorna 'Beehhh!'",
			"metodo": "",
			"construtor_params": [null],
			"entrada": [],
			"validar": "validar_ovelha_falar"
		},
		{
			"classe": "Cachorro",
			"nome": "🔗 Cachorro herda de Animal",
			"metodo": "",
			"construtor_params": [null],
			"entrada": [],
			"validar": "validar_cachorro_heranca"
		},
		{
			"classe": "Gato",
			"nome": "🔗 Gato herda de Animal",
			"metodo": "",
			"construtor_params": [null],
			"entrada": [],
			"validar": "validar_gato_heranca"
		},
		{
			"classe": "Ovelha",
			"nome": "🔗 Ovelha herda de Animal",
			"metodo": "",
			"construtor_params": [null],
			"entrada": [],
			"validar": "validar_ovelha_heranca"
		},
		{
			"classe": "Cachorro",
			"nome": "🎵 Cachorro armazena efeito_sonoro",
			"metodo": "",
			"construtor_params": [null],
			"entrada": [],
			"validar": "validar_cachorro_efeito_sonoro"
		},
		{
			"classe": "Gato",
			"nome": "🎵 Gato armazena efeito_sonoro",
			"metodo": "",
			"construtor_params": [null],
			"entrada": [],
			"validar": "validar_gato_efeito_sonoro"
		},
		{
			"classe": "Ovelha",
			"nome": "🎵 Ovelha armazena efeito_sonoro",
			"metodo": "",
			"construtor_params": [null],
			"entrada": [],
			"validar": "validar_ovelha_efeito_sonoro"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_cachorro_falar(resultado, instancia) -> Dictionary:
	var fala = instancia.falar()
	
	if not fala is String:
		return {
			"sucesso": false,
			"erro": "falar() deve retornar String",
			"saida_esperada": "String",
			"saida_obtida": type_string(typeof(fala))
		}
	
	if fala != "Au au!":
		return {
			"sucesso": false,
			"erro": "Cachorro deve falar 'Au au!'",
			"saida_esperada": "Au au!",
			"saida_obtida": fala
		}
	
	return {"sucesso": true, "erro": ""}

func validar_gato_falar(resultado, instancia) -> Dictionary:
	var fala = instancia.falar()
	
	if not fala is String:
		return {
			"sucesso": false,
			"erro": "falar() deve retornar String",
			"saida_esperada": "String",
			"saida_obtida": type_string(typeof(fala))
		}
	
	if fala != "Miau!":
		return {
			"sucesso": false,
			"erro": "Gato deve falar 'Miau!'",
			"saida_esperada": "Miau!",
			"saida_obtida": fala
		}
	
	return {"sucesso": true, "erro": ""}

func validar_ovelha_falar(resultado, instancia) -> Dictionary:
	var fala = instancia.falar()
	
	if not fala is String:
		return {
			"sucesso": false,
			"erro": "falar() deve retornar String",
			"saida_esperada": "String",
			"saida_obtida": type_string(typeof(fala))
		}
	
	if fala != "Beehhh!":
		return {
			"sucesso": false,
			"erro": "Ovelha deve falar 'Beehhh!'",
			"saida_esperada": "Beehhh!",
			"saida_obtida": fala
		}
	
	return {"sucesso": true, "erro": ""}

func validar_cachorro_heranca(resultado, instancia) -> Dictionary:
	# Carrega a classe Animal do script
	var script_exercicio = load("res://listas/Lista3/Exercicio2/Exercicio2.gd")
	var classe_animal = script_exercicio.Animal
	
	if not instancia is classe_animal:
		return {
			"sucesso": false,
			"erro": "Cachorro deve herdar de Animal (extends Animal)",
			"saida_esperada": "Cachorro extends Animal",
			"saida_obtida": "Cachorro não herda de Animal"
		}
	
	return {"sucesso": true, "erro": ""}

func validar_gato_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio2/Exercicio2.gd")
	var classe_animal = script_exercicio.Animal
	
	if not instancia is classe_animal:
		return {
			"sucesso": false,
			"erro": "Gato deve herdar de Animal (extends Animal)",
			"saida_esperada": "Gato extends Animal",
			"saida_obtida": "Gato não herda de Animal"
		}
	
	return {"sucesso": true, "erro": ""}

func validar_ovelha_heranca(resultado, instancia) -> Dictionary:
	var script_exercicio = load("res://listas/Lista3/Exercicio2/Exercicio2.gd")
	var classe_animal = script_exercicio.Animal
	
	if not instancia is classe_animal:
		return {
			"sucesso": false,
			"erro": "Ovelha deve herdar de Animal (extends Animal)",
			"saida_esperada": "Ovelha extends Animal",
			"saida_obtida": "Ovelha não herda de Animal"
		}
	
	return {"sucesso": true, "erro": ""}

func validar_cachorro_efeito_sonoro(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_efeito_sonoro"):
		return {
			"sucesso": false,
			"erro": "Cachorro deve ter método get_efeito_sonoro() (herdado de Animal)",
			"saida_esperada": "Método get_efeito_sonoro() disponível",
			"saida_obtida": "Método não encontrado"
		}
	
	var efeito = instancia.get_efeito_sonoro()
	
	# efeito_sonoro foi passado no construtor
	if efeito == null:
		return {
			"sucesso": false,
			"erro": "efeito_sonoro deve ser atribuído no construtor",
			"saida_esperada": "AudioStreamOggVorbis atribuído",
			"saida_obtida": "null"
		}
	
	return {"sucesso": true, "erro": ""}

func validar_gato_efeito_sonoro(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_efeito_sonoro"):
		return {
			"sucesso": false,
			"erro": "Gato deve ter método get_efeito_sonoro() (herdado de Animal)",
			"saida_esperada": "Método get_efeito_sonoro() disponível",
			"saida_obtida": "Método não encontrado"
		}
	
	var efeito = instancia.get_efeito_sonoro()
	
	if efeito == null:
		return {
			"sucesso": false,
			"erro": "efeito_sonoro deve ser atribuído no construtor",
			"saida_esperada": "AudioStreamOggVorbis atribuído",
			"saida_obtida": "null"
		}
	
	return {"sucesso": true, "erro": ""}

func validar_ovelha_efeito_sonoro(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_efeito_sonoro"):
		return {
			"sucesso": false,
			"erro": "Ovelha deve ter método get_efeito_sonoro() (herdado de Animal)",
			"saida_esperada": "Método get_efeito_sonoro() disponível",
			"saida_obtida": "Método não encontrado"
		}
	
	var efeito = instancia.get_efeito_sonoro()
	
	if efeito == null:
		return {
			"sucesso": false,
			"erro": "efeito_sonoro deve ser atribuído no construtor",
			"saida_esperada": "AudioStreamOggVorbis atribuído",
			"saida_obtida": "null"
		}
	
	return {"sucesso": true, "erro": ""}
