extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"class": "PiggyBank",
			"name": "💰 Construtor inicializa saldo e nome",
			"method": "",
			"constructor_params": ["Maria", 100.0],
			"input": [],
			"validate": "validar_construtor"
		},
		{
			"class": "PiggyBank",
			"name": "💵 add() soma ao saldo",
			"method": "",
			"constructor_params": ["João", 50.0],
			"input": [],
			"validate": "validar_add"
		},
		{
			"class": "PiggyBank",
			"name": "💸 withdraw() com saldo suficiente retorna true",
			"method": "",
			"constructor_params": ["Ana", 100.0],
			"input": [],
			"validate": "validar_withdraw_sucesso"
		},
		{
			"class": "PiggyBank",
			"name": "❌ withdraw() sem saldo suficiente retorna false",
			"method": "",
			"constructor_params": ["Pedro", 50.0],
			"input": [],
			"validate": "validar_withdraw_falha"
		},
		{
			"class": "PiggyBank",
			"name": "📊 get_balance() retorna saldo atual",
			"method": "",
			"constructor_params": ["Carlos", 75.0],
			"input": [],
			"validate": "validar_get_balance"
		},
		{
			"class": "PiggyBank",
			"name": "✏️ set_balance() altera saldo",
			"method": "",
			"constructor_params": ["Lucia", 0.0],
			"input": [],
			"validate": "validar_set_balance"
		},
		{
			"class": "PiggyBank",
			"name": "👤 get_nome() retorna nome",
			"method": "",
			"constructor_params": ["Roberto", 0.0],
			"input": [],
			"validate": "validar_get_nome"
		},
		{
			"class": "PiggyBank",
			"name": "✏️ set_nome() altera nome",
			"method": "",
			"constructor_params": ["Antônio", 0.0],
			"input": [],
			"validate": "validar_set_nome"
		},
		{
			"class": "PiggyBank",
			"name": "🔒 Saldo não pode ser acessado diretamente (encapsulamento)",
			"method": "",
			"constructor_params": ["Usuario", 0.0],
			"input": [],
			"validate": "validar_encapsulamento"
		},
		{
			"class": "PiggyBank",
			"name": "💰➕💸 Operações múltiplas (add, add, withdraw)",
			"method": "",
			"constructor_params": ["Usuario", 0.0],
			"input": [],
			"validate": "validar_operacoes_multiplas"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_construtor(resultado, instancia) -> Dictionary:
	var nome = instancia.get_nome()
	var saldo = instancia.get_balance()
	
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

func validar_add(resultado, instancia) -> Dictionary:
	if not instancia.has_method("add"):
		return {
			"success": false,
			"error": "PiggyBank deve ter método add()",
			"expected_output": "Método add() existe",
			"actual_output": "Método não encontrado"
		}
	
	var saldo_inicial = instancia.get_balance()
	instancia.add(25.0)
	var saldo_final = instancia.get_balance()
	
	var esperado = saldo_inicial + 25.0
	if abs(saldo_final - esperado) > 0.001:
		return {
			"success": false,
			"error": "add() não soma corretamente ao saldo",
			"expected_output": esperado,
			"actual_output": saldo_final
		}
	
	return {"success": true, "error": ""}

func validar_withdraw_sucesso(resultado, instancia) -> Dictionary:
	if not instancia.has_method("withdraw"):
		return {
			"success": false,
			"error": "PiggyBank deve ter método withdraw()",
			"expected_output": "Método withdraw() existe",
			"actual_output": "Método não encontrado"
		}
	
	var saldo_inicial = instancia.get_balance()
	var sucesso = instancia.withdraw(30.0)
	
	if not sucesso is bool:
		return {
			"success": false,
			"error": "withdraw() deve retornar bool",
			"expected_output": "bool",
			"actual_output": type_string(typeof(sucesso))
		}
	
	if not sucesso:
		return {
			"success": false,
			"error": "withdraw() deve retornar true quando há saldo suficiente",
			"expected_output": true,
			"actual_output": false
		}
	
	var saldo_final = instancia.get_balance()
	var esperado = saldo_inicial - 30.0
	
	if abs(saldo_final - esperado) > 0.001:
		return {
			"success": false,
			"error": "withdraw() não subtrai corretamente do saldo",
			"expected_output": esperado,
			"actual_output": saldo_final
		}
	
	return {"success": true, "error": ""}

func validar_withdraw_falha(resultado, instancia) -> Dictionary:
	var saldo_inicial = instancia.get_balance()
	var sucesso = instancia.withdraw(100.0)  # Tenta withdraw mais que tem
	
	if sucesso:
		return {
			"success": false,
			"error": "withdraw() deve retornar false quando não há saldo suficiente",
			"expected_output": false,
			"actual_output": true
		}
	
	var saldo_final = instancia.get_balance()
	
	if abs(saldo_final - saldo_inicial) > 0.001:
		return {
			"success": false,
			"error": "Saldo não deve mudar quando saque falha",
			"expected_output": saldo_inicial,
			"actual_output": saldo_final
		}
	
	return {"success": true, "error": ""}

func validar_get_balance(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_balance"):
		return {
			"success": false,
			"error": "PiggyBank deve ter método get_balance()",
			"expected_output": "Método get_balance() existe",
			"actual_output": "Método não encontrado"
		}
	
	var saldo = instancia.get_balance()
	
	if not saldo is float and not saldo is int:
		return {
			"success": false,
			"error": "get_balance() deve retornar float ou int",
			"expected_output": "float",
			"actual_output": type_string(typeof(saldo))
		}
	
	if abs(saldo - 75.0) > 0.001:
		return {
			"success": false,
			"error": "get_balance() não retorna valor correto",
			"expected_output": 75.0,
			"actual_output": saldo
		}
	
	return {"success": true, "error": ""}

func validar_set_balance(resultado, instancia) -> Dictionary:
	if not instancia.has_method("set_balance"):
		return {
			"success": false,
			"error": "PiggyBank deve ter método set_balance()",
			"expected_output": "Método set_balance() existe",
			"actual_output": "Método não encontrado"
		}
	
	instancia.set_balance(200.0)
	var novo_balance = instancia.get_balance()
	
	if abs(novo_balance - 200.0) > 0.001:
		return {
			"success": false,
			"error": "set_balance() não altera o saldo corretamente",
			"expected_output": 200.0,
			"actual_output": novo_balance
		}
	
	return {"success": true, "error": ""}

func validar_get_nome(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_nome"):
		return {
			"success": false,
			"error": "PiggyBank deve ter método get_nome()",
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
			"error": "PiggyBank deve ter método set_nome()",
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
	if not instancia.has_method("get_balance") or not instancia.has_method("set_balance"):
		return {
			"success": false,
			"error": "Use get_balance() e set_balance() para acessar saldo",
			"expected_output": "Métodos get_balance() e set_balance()",
			"actual_output": "Métodos não encontrados"
		}
	
	return {"success": true, "error": ""}

func validar_operacoes_multiplas(resultado, instancia) -> Dictionary:
	# Adiciona 50
	instancia.add(50.0)
	var saldo1 = instancia.get_balance()
	
	if abs(saldo1 - 50.0) > 0.001:
		return {
			"success": false,
			"error": "Primeiro add falhou",
			"expected_output": 50.0,
			"actual_output": saldo1
		}
	
	# Adiciona mais 30
	instancia.add(30.0)
	var saldo2 = instancia.get_balance()
	
	if abs(saldo2 - 80.0) > 0.001:
		return {
			"success": false,
			"error": "Segundo add falhou",
			"expected_output": 80.0,
			"actual_output": saldo2
		}
	
	# Saca 25
	var sucesso = instancia.withdraw(25.0)
	var saldo3 = instancia.get_balance()
	
	if not sucesso or abs(saldo3 - 55.0) > 0.001:
		return {
			"success": false,
			"error": "Sacar falhou",
			"expected_output": 55.0,
			"actual_output": saldo3
		}
	
	return {"success": true, "error": ""}
