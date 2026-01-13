extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"classe": "Motor",
			"nome": "⚙️ Motor inicializa com potência",
			"metodo": "",
			"construtor_params": [100],
			"entrada": [],
			"validar": "validar_motor_construtor"
		},
		{
			"classe": "Motor",
			"nome": "🔌 Motor.ligar() muda estado para ligado",
			"metodo": "",
			"construtor_params": [150],
			"entrada": [],
			"validar": "validar_motor_ligar"
		},
		{
			"classe": "Motor",
			"nome": "📊 Motor.get_potencia() retorna potência",
			"metodo": "",
			"construtor_params": [200],
			"entrada": [],
			"validar": "validar_motor_get_potencia"
		},
		{
			"classe": "Carro",
			"nome": "🚗 Carro possui Motor (composição)",
			"metodo": "",
			"construtor_params": [120],
			"entrada": [],
			"validar": "validar_carro_tem_motor"
		},
		{
			"classe": "Carro",
			"nome": "🔑 Carro.ligar_carro() retorna mensagem",
			"metodo": "",
			"construtor_params": [100],
			"entrada": [],
			"validar": "validar_carro_ligar"
		},
		{
			"classe": "Carro",
			"nome": "🔑 Carro.ligar_carro() liga o motor interno",
			"metodo": "",
			"construtor_params": [150],
			"entrada": [],
			"validar": "validar_carro_liga_motor"
		},
		{
			"classe": "Carro",
			"nome": "📊 Carro.acessar_potencia() retorna potência do motor",
			"metodo": "",
			"construtor_params": [180],
			"entrada": [],
			"validar": "validar_carro_acessar_potencia"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_motor_construtor(resultado, instancia) -> Dictionary:
	if not "potencia" in instancia:
		return {
			"sucesso": false,
			"erro": "Motor deve ter propriedade 'potencia'",
			"saida_esperada": "Propriedade potencia existe",
			"saida_obtida": "Propriedade não encontrada"
		}
	
	if instancia.potencia != 100:
		return {
			"sucesso": false,
			"erro": "Motor não inicializa potência corretamente",
			"saida_esperada": 100,
			"saida_obtida": instancia.potencia
		}
	
	return {"sucesso": true, "erro": ""}

func validar_motor_ligar(resultado, instancia) -> Dictionary:
	if not instancia.has_method("ligar"):
		return {
			"sucesso": false,
			"erro": "Motor deve ter método ligar()",
			"saida_esperada": "Método ligar() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	# Verifica se tem propriedade ligado
	if not "ligado" in instancia:
		return {
			"sucesso": false,
			"erro": "Motor deve ter propriedade 'ligado' (bool)",
			"saida_esperada": "Propriedade ligado existe",
			"saida_obtida": "Propriedade não encontrada"
		}
	
	# Estado inicial deve ser desligado
	if instancia.ligado != false:
		return {
			"sucesso": false,
			"erro": "Motor deve iniciar desligado (ligado = false)",
			"saida_esperada": false,
			"saida_obtida": instancia.ligado
		}
	
	# Liga o motor
	instancia.ligar()
	
	if instancia.ligado != true:
		return {
			"sucesso": false,
			"erro": "Motor.ligar() deve mudar ligado para true",
			"saida_esperada": true,
			"saida_obtida": instancia.ligado
		}
	
	return {"sucesso": true, "erro": ""}

func validar_motor_get_potencia(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_potencia"):
		return {
			"sucesso": false,
			"erro": "Motor deve ter método get_potencia()",
			"saida_esperada": "Método get_potencia() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	var potencia = instancia.get_potencia()
	
	if not potencia is int:
		return {
			"sucesso": false,
			"erro": "get_potencia() deve retornar int",
			"saida_esperada": "int",
			"saida_obtida": type_string(typeof(potencia))
		}
	
	if potencia != 200:
		return {
			"sucesso": false,
			"erro": "get_potencia() não retorna valor correto",
			"saida_esperada": 200,
			"saida_obtida": potencia
		}
	
	return {"sucesso": true, "erro": ""}

func validar_carro_tem_motor(resultado, instancia) -> Dictionary:
	if not "motor" in instancia:
		return {
			"sucesso": false,
			"erro": "Carro deve ter propriedade 'motor' (Motor)",
			"saida_esperada": "Propriedade motor existe",
			"saida_obtida": "Propriedade não encontrada"
		}
	
	var script_exercicio = load("res://listas/Lista3/Exercicio3/Exercicio3.gd")
	var classe_motor = script_exercicio.Motor
	
	if not instancia.motor is classe_motor:
		return {
			"sucesso": false,
			"erro": "Carro.motor deve ser uma instância de Motor",
			"saida_esperada": "motor is Motor",
			"saida_obtida": "motor não é Motor"
		}
	
	return {"sucesso": true, "erro": ""}

func validar_carro_ligar(resultado, instancia) -> Dictionary:
	if not instancia.has_method("ligar_carro"):
		return {
			"sucesso": false,
			"erro": "Carro deve ter método ligar_carro()",
			"saida_esperada": "Método ligar_carro() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	var mensagem = instancia.ligar_carro()
	
	if not mensagem is String:
		return {
			"sucesso": false,
			"erro": "ligar_carro() deve retornar String",
			"saida_esperada": "String",
			"saida_obtida": type_string(typeof(mensagem))
		}
	
	# Verifica se a mensagem contém informação sobre ligar motor
	if not ("Motor" in mensagem or "motor" in mensagem or "ligado" in mensagem):
		return {
			"sucesso": false,
			"erro": "Mensagem deve indicar que o motor foi ligado",
			"saida_esperada": "Mensagem com 'motor' ou 'ligado'",
			"saida_obtida": mensagem
		}
	
	return {"sucesso": true, "erro": ""}

func validar_carro_liga_motor(resultado, instancia) -> Dictionary:
	# Verifica se motor está desligado antes
	if instancia.motor.ligado:
		return {
			"sucesso": false,
			"erro": "Motor deve iniciar desligado",
			"saida_esperada": false,
			"saida_obtida": true
		}
	
	# Liga o carro
	instancia.ligar_carro()
	
	# Verifica se o motor foi ligado
	if not instancia.motor.ligado:
		return {
			"sucesso": false,
			"erro": "ligar_carro() deve chamar motor.ligar()",
			"saida_esperada": "motor.ligado = true",
			"saida_obtida": "motor.ligado = false"
		}
	
	return {"sucesso": true, "erro": ""}

func validar_carro_acessar_potencia(resultado, instancia) -> Dictionary:
	if not instancia.has_method("acessar_potencia"):
		return {
			"sucesso": false,
			"erro": "Carro deve ter método acessar_potencia()",
			"saida_esperada": "Método acessar_potencia() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	var potencia = instancia.acessar_potencia()
	
	if not potencia is int:
		return {
			"sucesso": false,
			"erro": "acessar_potencia() deve retornar int",
			"saida_esperada": "int",
			"saida_obtida": type_string(typeof(potencia))
		}
	
	if potencia != 180:
		return {
			"sucesso": false,
			"erro": "acessar_potencia() deve retornar potência do motor",
			"saida_esperada": 180,
			"saida_obtida": potencia
		}
	
	return {"sucesso": true, "erro": ""}
