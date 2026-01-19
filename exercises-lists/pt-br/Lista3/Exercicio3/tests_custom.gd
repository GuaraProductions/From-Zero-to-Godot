extends Node

func get_test_cases() -> Array[Dictionary]:
	return [
		{
			"class": "Motor",
			"name": "⚙️ Motor inicializa com potência",
			"method": "",
			"constructor_params": [100],
			"input": [],
			"validate": "validar_motor_construtor"
		},
		{
			"class": "Motor",
			"name": "🔌 Motor.ligar() muda estado para ligado",
			"method": "",
			"constructor_params": [150],
			"input": [],
			"validate": "validar_motor_ligar"
		},
		{
			"class": "Motor",
			"name": "📊 Motor.get_potencia() retorna potência",
			"method": "",
			"constructor_params": [200],
			"input": [],
			"validate": "validar_motor_get_potencia"
		},
		{
			"class": "Carro",
			"name": "🚗 Carro possui Motor (composição)",
			"method": "",
			"constructor_params": [120],
			"input": [],
			"validate": "validar_carro_tem_motor"
		},
		{
			"class": "Carro",
			"name": "🔑 Carro.ligar_carro() retorna mensagem",
			"method": "",
			"constructor_params": [100],
			"input": [],
			"validate": "validar_carro_ligar"
		},
		{
			"class": "Carro",
			"name": "🔑 Carro.ligar_carro() liga o motor interno",
			"method": "",
			"constructor_params": [150],
			"input": [],
			"validate": "validar_carro_liga_motor"
		},
		{
			"class": "Carro",
			"name": "📊 Carro.acessar_potencia() retorna potência do motor",
			"method": "",
			"constructor_params": [180],
			"input": [],
			"validate": "validar_carro_acessar_potencia"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_motor_construtor(resultado, instancia) -> Dictionary:
	if not "potencia" in instancia:
		return {
			"success": false,
			"error": "Motor deve ter propriedade 'potencia'",
			"expected_output": "Propriedade potencia existe",
			"actual_output": "Propriedade não encontrada"
		}
	
	if instancia.potencia != 100:
		return {
			"success": false,
			"error": "Motor não inicializa potência corretamente",
			"expected_output": 100,
			"actual_output": instancia.potencia
		}
	
	return {"success": true, "error": ""}

func validar_motor_ligar(resultado, instancia) -> Dictionary:
	if not instancia.has_method("ligar"):
		return {
			"success": false,
			"error": "Motor deve ter método ligar()",
			"expected_output": "Método ligar() existe",
			"actual_output": "Método não encontrado"
		}
	
	# Verifica se tem propriedade ligado
	if not "ligado" in instancia:
		return {
			"success": false,
			"error": "Motor deve ter propriedade 'ligado' (bool)",
			"expected_output": "Propriedade ligado existe",
			"actual_output": "Propriedade não encontrada"
		}
	
	# Estado inicial deve ser desligado
	if instancia.ligado != false:
		return {
			"success": false,
			"error": "Motor deve iniciar desligado (ligado = false)",
			"expected_output": false,
			"actual_output": instancia.ligado
		}
	
	# Liga o motor
	instancia.ligar()
	
	if instancia.ligado != true:
		return {
			"success": false,
			"error": "Motor.ligar() deve mudar ligado para true",
			"expected_output": true,
			"actual_output": instancia.ligado
		}
	
	return {"success": true, "error": ""}

func validar_motor_get_potencia(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_potencia"):
		return {
			"success": false,
			"error": "Motor deve ter método get_potencia()",
			"expected_output": "Método get_potencia() existe",
			"actual_output": "Método não encontrado"
		}
	
	var potencia = instancia.get_potencia()
	
	if not potencia is int:
		return {
			"success": false,
			"error": "get_potencia() deve retornar int",
			"expected_output": "int",
			"actual_output": type_string(typeof(potencia))
		}
	
	if potencia != 200:
		return {
			"success": false,
			"error": "get_potencia() não retorna valor correto",
			"expected_output": 200,
			"actual_output": potencia
		}
	
	return {"success": true, "error": ""}

func validar_carro_tem_motor(resultado, instancia) -> Dictionary:
	if not "motor" in instancia:
		return {
			"success": false,
			"error": "Carro deve ter propriedade 'motor' (Motor)",
			"expected_output": "Propriedade motor existe",
			"actual_output": "Propriedade não encontrada"
		}
	
	var script_exercicio = load("res://listas/Lista3/Exercicio3/Exercicio3.gd")
	var classe_motor = script_exercicio.get("Motor")
	
	if not is_instance_of(instancia, classe_motor):
		return {
			"success": false,
			"error": "Carro.motor deve ser uma instância de Motor",
			"expected_output": "motor is Motor",
			"actual_output": "motor não é Motor"
		}
	
	return {"success": true, "error": ""}

func validar_carro_ligar(resultado, instancia) -> Dictionary:
	if not instancia.has_method("ligar_carro"):
		return {
			"success": false,
			"error": "Carro deve ter método ligar_carro()",
			"expected_output": "Método ligar_carro() existe",
			"actual_output": "Método não encontrado"
		}
	
	var mensagem = instancia.ligar_carro()
	
	if not mensagem is String:
		return {
			"success": false,
			"error": "ligar_carro() deve retornar String",
			"expected_output": "String",
			"actual_output": type_string(typeof(mensagem))
		}
	
	# Verifica se a mensagem contém informação sobre ligar motor
	if not ("Motor" in mensagem or "motor" in mensagem or "ligado" in mensagem):
		return {
			"success": false,
			"error": "Mensagem deve indicar que o motor foi ligado",
			"expected_output": "Mensagem com 'motor' ou 'ligado'",
			"actual_output": mensagem
		}
	
	return {"success": true, "error": ""}

func validar_carro_liga_motor(resultado, instancia) -> Dictionary:
	# Verifica se motor está desligado antes
	if instancia.motor.ligado:
		return {
			"success": false,
			"error": "Motor deve iniciar desligado",
			"expected_output": false,
			"actual_output": true
		}
	
	# Liga o carro
	instancia.ligar_carro()
	
	# Verifica se o motor foi ligado
	if not instancia.motor.ligado:
		return {
			"success": false,
			"error": "ligar_carro() deve chamar motor.ligar()",
			"expected_output": "motor.ligado = true",
			"actual_output": "motor.ligado = false"
		}
	
	return {"success": true, "error": ""}

func validar_carro_acessar_potencia(resultado, instancia) -> Dictionary:
	if not instancia.has_method("acessar_potencia"):
		return {
			"success": false,
			"error": "Carro deve ter método acessar_potencia()",
			"expected_output": "Método acessar_potencia() existe",
			"actual_output": "Método não encontrado"
		}
	
	var potencia = instancia.acessar_potencia()
	
	if not potencia is int:
		return {
			"success": false,
			"error": "acessar_potencia() deve retornar int",
			"expected_output": "int",
			"actual_output": type_string(typeof(potencia))
		}
	
	if potencia != 180:
		return {
			"success": false,
			"error": "acessar_potencia() deve retornar potência do motor",
			"expected_output": 180,
			"actual_output": potencia
		}
	
	return {"success": true, "error": ""}
