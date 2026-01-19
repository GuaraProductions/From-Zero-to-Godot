extends Node

func get_test_cases() -> Array[Dictionary]:
	return [
		{
			"class": "Cofrinho",
			"name": "💰 Construtor inicializa saldo e nome",
			"method": "",
			"constructor_params": ["Maria", 100.0],
			"input": [],
			"validate": "validar_construtor"
		},
		{
			"class": "Cofrinho",
			"name": "💵 adicionar() soma ao saldo",
			"method": "",
			"constructor_params": ["João", 50.0],
			"input": [],
			"validate": "validar_adicionar"
		},
		{
			"class": "Cofrinho",
			"name": "💸 sacar() com saldo suficiente retorna true",
			"method": "",
			"constructor_params": ["Ana", 100.0],
			"input": [],
			"validate": "validar_sacar_sucesso"
		},
		{
			"class": "Cofrinho",
			"name": "❌ sacar() sem saldo suficiente retorna false",
			"method": "",
			"constructor_params": ["Pedro", 50.0],
			"input": [],
			"validate": "validar_sacar_falha"
		},
		{
			"class": "Cofrinho",
			"name": "📊 get_saldo() retorna saldo atual",
			"method": "",
			"constructor_params": ["Carlos", 75.0],
			"input": [],
			"validate": "validar_get_saldo"
		},
		{
			"class": "Cofrinho",
			"name": "✏️ set_saldo() altera saldo",
			"method": "",
			"constructor_params": ["Lucia", 0.0],
			"input": [],
			"validate": "validar_set_saldo"
		},
		{
			"class": "Cofrinho",
			"name": "👤 get_nome() retorna nome",
			"method": "",
			"constructor_params": ["Roberto", 0.0],
			"input": [],
			"validate": "validar_get_nome"
		},
		{
			"class": "Cofrinho",
			"name": "✏️ set_nome() altera nome",
			"method": "",
			"constructor_params": ["Antônio", 0.0],
			"input": [],
			"validate": "validar_set_nome"
		},
		{
			"class": "Cofrinho",
			"name": "🔒 Saldo não pode ser acessado diretamente (encapsulamento)",
			"method": "",
			"constructor_params": ["Usuario", 0.0],
			"input": [],
			"validate": "validar_encapsulamento"
		},
		{
			"class": "Cofrinho",
			"name": "💰➕💸 Operações múltiplas (adicionar, adicionar, sacar)",
			"method": "",
			"constructor_params": ["Usuario", 0.0],
			"input": [],
			"validate": "validar_operacoes_multiplas"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_construtor(resultado, instancia) -> Dictionary:
	var nome = instancia.get_nome()
	var saldo = instancia.get_saldo()
	
	if nome != "Maria":
		return {
			"success": false,
			"error": "Nome não foi inicializado corretamente",
			"expected_output": "Maria",
			"actual_output": nome
		}
	
	if abs(saldo - 100.0) > 0.001:
		return {
			"success": false,
			"error": "Saldo não foi inicializado corretamente",
			"expected_output": 100.0,
			"actual_output": saldo
		}
	
	return {"success": true, "error": ""}

func validar_adicionar(resultado, instancia) -> Dictionary:
	if not instancia.has_method("adicionar"):
		return {
			"success": false,
			"error": "Cofrinho deve ter método adicionar()",
			"expected_output": "Método adicionar() existe",
			"actual_output": "Método não encontrado"
		}
	
	var saldo_inicial = instancia.get_saldo()
	instancia.adicionar(25.0)
	var saldo_final = instancia.get_saldo()
	
	var esperado = saldo_inicial + 25.0
	if abs(saldo_final - esperado) > 0.001:
		return {
			"success": false,
			"error": "adicionar() não soma corretamente ao saldo",
			"expected_output": esperado,
			"actual_output": saldo_final
		}
	
	return {"success": true, "error": ""}

func validar_sacar_sucesso(resultado, instancia) -> Dictionary:
	if not instancia.has_method("sacar"):
		return {
			"success": false,
			"error": "Cofrinho deve ter método sacar()",
			"expected_output": "Método sacar() existe",
			"actual_output": "Método não encontrado"
		}
	
	var saldo_inicial = instancia.get_saldo()
	var sucesso = instancia.sacar(30.0)
	
	if not sucesso is bool:
		return {
			"success": false,
			"error": "sacar() deve retornar bool",
			"expected_output": "bool",
			"actual_output": type_string(typeof(sucesso))
		}
	
	if not sucesso:
		return {
			"success": false,
			"error": "sacar() deve retornar true quando há saldo suficiente",
			"expected_output": true,
			"actual_output": false
		}
	
	var saldo_final = instancia.get_saldo()
	var esperado = saldo_inicial - 30.0
	
	if abs(saldo_final - esperado) > 0.001:
		return {
			"success": false,
			"error": "sacar() não subtrai corretamente do saldo",
			"expected_output": esperado,
			"actual_output": saldo_final
		}
	
	return {"success": true, "error": ""}

func validar_sacar_falha(resultado, instancia) -> Dictionary:
	var saldo_inicial = instancia.get_saldo()
	var sucesso = instancia.sacar(100.0)  # Tenta sacar mais que tem
	
	if sucesso:
		return {
			"success": false,
			"error": "sacar() deve retornar false quando não há saldo suficiente",
			"expected_output": false,
			"actual_output": true
		}
	
	var saldo_final = instancia.get_saldo()
	
	if abs(saldo_final - saldo_inicial) > 0.001:
		return {
			"success": false,
			"error": "Saldo não deve mudar quando saque falha",
			"expected_output": saldo_inicial,
			"actual_output": saldo_final
		}
	
	return {"success": true, "error": ""}

func validar_get_saldo(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_saldo"):
		return {
			"success": false,
			"error": "Cofrinho deve ter método get_saldo()",
			"expected_output": "Método get_saldo() existe",
			"actual_output": "Método não encontrado"
		}
	
	var saldo = instancia.get_saldo()
	
	if not saldo is float and not saldo is int:
		return {
			"success": false,
			"error": "get_saldo() deve retornar float ou int",
			"expected_output": "float",
			"actual_output": type_string(typeof(saldo))
		}
	
	if abs(saldo - 75.0) > 0.001:
		return {
			"success": false,
			"error": "get_saldo() não retorna valor correto",
			"expected_output": 75.0,
			"actual_output": saldo
		}
	
	return {"success": true, "error": ""}

func validar_set_saldo(resultado, instancia) -> Dictionary:
	if not instancia.has_method("set_saldo"):
		return {
			"success": false,
			"error": "Cofrinho deve ter método set_saldo()",
			"expected_output": "Método set_saldo() existe",
			"actual_output": "Método não encontrado"
		}
	
	instancia.set_saldo(200.0)
	var novo_saldo = instancia.get_saldo()
	
	if abs(novo_saldo - 200.0) > 0.001:
		return {
			"success": false,
			"error": "set_saldo() não altera o saldo corretamente",
			"expected_output": 200.0,
			"actual_output": novo_saldo
		}
	
	return {"success": true, "error": ""}

func validar_get_nome(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_nome"):
		return {
			"success": false,
			"error": "Cofrinho deve ter método get_nome()",
			"expected_output": "Método get_nome() existe",
			"actual_output": "Método não encontrado"
		}
	
	var nome = instancia.get_nome()
	
	if not nome is String:
		return {
			"success": false,
			"error": "get_nome() deve retornar String",
			"expected_output": "String",
			"actual_output": type_string(typeof(nome))
		}
	
	if nome != "Roberto":
		return {
			"success": false,
			"error": "get_nome() não retorna valor correto",
			"expected_output": "Roberto",
			"actual_output": nome
		}
	
	return {"success": true, "error": ""}

func validar_set_nome(resultado, instancia) -> Dictionary:
	if not instancia.has_method("set_nome"):
		return {
			"success": false,
			"error": "Cofrinho deve ter método set_nome()",
			"expected_output": "Método set_nome() existe",
			"actual_output": "Método não encontrado"
		}
	
	instancia.set_nome("Fernanda")
	var novo_nome = instancia.get_nome()
	
	if novo_nome != "Fernanda":
		return {
			"success": false,
			"error": "set_nome() não altera o nome corretamente",
			"expected_output": "Fernanda",
			"actual_output": novo_nome
		}
	
	return {"success": true, "error": ""}

func validar_encapsulamento(resultado, instancia) -> Dictionary:
	# Verifica se saldo é privado (não pode ser acessado diretamente)
	# Nota: GDScript permite acesso a propriedades públicas, mas a convenção
	# é usar _ para privado e métodos get/set
	
	# Testa se tem get e set
	if not instancia.has_method("get_saldo") or not instancia.has_method("set_saldo"):
		return {
			"success": false,
			"error": "Use get_saldo() e set_saldo() para acessar saldo",
			"expected_output": "Métodos get_saldo() e set_saldo()",
			"actual_output": "Métodos não encontrados"
		}
	
	return {"success": true, "error": ""}

func validar_operacoes_multiplas(resultado, instancia) -> Dictionary:
	# Adiciona 50
	instancia.adicionar(50.0)
	var saldo1 = instancia.get_saldo()
	
	if abs(saldo1 - 50.0) > 0.001:
		return {
			"success": false,
			"error": "Primeiro adicionar falhou",
			"expected_output": 50.0,
			"actual_output": saldo1
		}
	
	# Adiciona mais 30
	instancia.adicionar(30.0)
	var saldo2 = instancia.get_saldo()
	
	if abs(saldo2 - 80.0) > 0.001:
		return {
			"success": false,
			"error": "Segundo adicionar falhou",
			"expected_output": 80.0,
			"actual_output": saldo2
		}
	
	# Saca 25
	var sucesso = instancia.sacar(25.0)
	var saldo3 = instancia.get_saldo()
	
	if not sucesso or abs(saldo3 - 55.0) > 0.001:
		return {
			"success": false,
			"error": "Sacar falhou",
			"expected_output": 55.0,
			"actual_output": saldo3
		}
	
	return {"success": true, "error": ""}
