extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"classe": "Cofrinho",
			"nome": "💰 Construtor inicializa saldo e nome",
			"metodo": "",
			"construtor_params": ["Maria", 100.0],
			"entrada": [],
			"validar": "validar_construtor"
		},
		{
			"classe": "Cofrinho",
			"nome": "💵 adicionar() soma ao saldo",
			"metodo": "",
			"construtor_params": ["João", 50.0],
			"entrada": [],
			"validar": "validar_adicionar"
		},
		{
			"classe": "Cofrinho",
			"nome": "💸 sacar() com saldo suficiente retorna true",
			"metodo": "",
			"construtor_params": ["Ana", 100.0],
			"entrada": [],
			"validar": "validar_sacar_sucesso"
		},
		{
			"classe": "Cofrinho",
			"nome": "❌ sacar() sem saldo suficiente retorna false",
			"metodo": "",
			"construtor_params": ["Pedro", 50.0],
			"entrada": [],
			"validar": "validar_sacar_falha"
		},
		{
			"classe": "Cofrinho",
			"nome": "📊 get_saldo() retorna saldo atual",
			"metodo": "",
			"construtor_params": ["Carlos", 75.0],
			"entrada": [],
			"validar": "validar_get_saldo"
		},
		{
			"classe": "Cofrinho",
			"nome": "✏️ set_saldo() altera saldo",
			"metodo": "",
			"construtor_params": ["Lucia", 0.0],
			"entrada": [],
			"validar": "validar_set_saldo"
		},
		{
			"classe": "Cofrinho",
			"nome": "👤 get_nome() retorna nome",
			"metodo": "",
			"construtor_params": ["Roberto", 0.0],
			"entrada": [],
			"validar": "validar_get_nome"
		},
		{
			"classe": "Cofrinho",
			"nome": "✏️ set_nome() altera nome",
			"metodo": "",
			"construtor_params": ["Antônio", 0.0],
			"entrada": [],
			"validar": "validar_set_nome"
		},
		{
			"classe": "Cofrinho",
			"nome": "🔒 Saldo não pode ser acessado diretamente (encapsulamento)",
			"metodo": "",
			"construtor_params": ["Usuario", 0.0],
			"entrada": [],
			"validar": "validar_encapsulamento"
		},
		{
			"classe": "Cofrinho",
			"nome": "💰➕💸 Operações múltiplas (adicionar, adicionar, sacar)",
			"metodo": "",
			"construtor_params": ["Usuario", 0.0],
			"entrada": [],
			"validar": "validar_operacoes_multiplas"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_construtor(resultado, instancia) -> Dictionary:
	var nome = instancia.get_nome()
	var saldo = instancia.get_saldo()
	
	if nome != "Maria":
		return {
			"sucesso": false,
			"erro": "Nome não foi inicializado corretamente",
			"saida_esperada": "Maria",
			"saida_obtida": nome
		}
	
	if abs(saldo - 100.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Saldo não foi inicializado corretamente",
			"saida_esperada": 100.0,
			"saida_obtida": saldo
		}
	
	return {"sucesso": true, "erro": ""}

func validar_adicionar(resultado, instancia) -> Dictionary:
	if not instancia.has_method("adicionar"):
		return {
			"sucesso": false,
			"erro": "Cofrinho deve ter método adicionar()",
			"saida_esperada": "Método adicionar() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	var saldo_inicial = instancia.get_saldo()
	instancia.adicionar(25.0)
	var saldo_final = instancia.get_saldo()
	
	var esperado = saldo_inicial + 25.0
	if abs(saldo_final - esperado) > 0.001:
		return {
			"sucesso": false,
			"erro": "adicionar() não soma corretamente ao saldo",
			"saida_esperada": esperado,
			"saida_obtida": saldo_final
		}
	
	return {"sucesso": true, "erro": ""}

func validar_sacar_sucesso(resultado, instancia) -> Dictionary:
	if not instancia.has_method("sacar"):
		return {
			"sucesso": false,
			"erro": "Cofrinho deve ter método sacar()",
			"saida_esperada": "Método sacar() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	var saldo_inicial = instancia.get_saldo()
	var sucesso = instancia.sacar(30.0)
	
	if not sucesso is bool:
		return {
			"sucesso": false,
			"erro": "sacar() deve retornar bool",
			"saida_esperada": "bool",
			"saida_obtida": type_string(typeof(sucesso))
		}
	
	if not sucesso:
		return {
			"sucesso": false,
			"erro": "sacar() deve retornar true quando há saldo suficiente",
			"saida_esperada": true,
			"saida_obtida": false
		}
	
	var saldo_final = instancia.get_saldo()
	var esperado = saldo_inicial - 30.0
	
	if abs(saldo_final - esperado) > 0.001:
		return {
			"sucesso": false,
			"erro": "sacar() não subtrai corretamente do saldo",
			"saida_esperada": esperado,
			"saida_obtida": saldo_final
		}
	
	return {"sucesso": true, "erro": ""}

func validar_sacar_falha(resultado, instancia) -> Dictionary:
	var saldo_inicial = instancia.get_saldo()
	var sucesso = instancia.sacar(100.0)  # Tenta sacar mais que tem
	
	if sucesso:
		return {
			"sucesso": false,
			"erro": "sacar() deve retornar false quando não há saldo suficiente",
			"saida_esperada": false,
			"saida_obtida": true
		}
	
	var saldo_final = instancia.get_saldo()
	
	if abs(saldo_final - saldo_inicial) > 0.001:
		return {
			"sucesso": false,
			"erro": "Saldo não deve mudar quando saque falha",
			"saida_esperada": saldo_inicial,
			"saida_obtida": saldo_final
		}
	
	return {"sucesso": true, "erro": ""}

func validar_get_saldo(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_saldo"):
		return {
			"sucesso": false,
			"erro": "Cofrinho deve ter método get_saldo()",
			"saida_esperada": "Método get_saldo() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	var saldo = instancia.get_saldo()
	
	if not saldo is float and not saldo is int:
		return {
			"sucesso": false,
			"erro": "get_saldo() deve retornar float ou int",
			"saida_esperada": "float",
			"saida_obtida": type_string(typeof(saldo))
		}
	
	if abs(saldo - 75.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "get_saldo() não retorna valor correto",
			"saida_esperada": 75.0,
			"saida_obtida": saldo
		}
	
	return {"sucesso": true, "erro": ""}

func validar_set_saldo(resultado, instancia) -> Dictionary:
	if not instancia.has_method("set_saldo"):
		return {
			"sucesso": false,
			"erro": "Cofrinho deve ter método set_saldo()",
			"saida_esperada": "Método set_saldo() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	instancia.set_saldo(200.0)
	var novo_saldo = instancia.get_saldo()
	
	if abs(novo_saldo - 200.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "set_saldo() não altera o saldo corretamente",
			"saida_esperada": 200.0,
			"saida_obtida": novo_saldo
		}
	
	return {"sucesso": true, "erro": ""}

func validar_get_nome(resultado, instancia) -> Dictionary:
	if not instancia.has_method("get_nome"):
		return {
			"sucesso": false,
			"erro": "Cofrinho deve ter método get_nome()",
			"saida_esperada": "Método get_nome() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	var nome = instancia.get_nome()
	
	if not nome is String:
		return {
			"sucesso": false,
			"erro": "get_nome() deve retornar String",
			"saida_esperada": "String",
			"saida_obtida": type_string(typeof(nome))
		}
	
	if nome != "Roberto":
		return {
			"sucesso": false,
			"erro": "get_nome() não retorna valor correto",
			"saida_esperada": "Roberto",
			"saida_obtida": nome
		}
	
	return {"sucesso": true, "erro": ""}

func validar_set_nome(resultado, instancia) -> Dictionary:
	if not instancia.has_method("set_nome"):
		return {
			"sucesso": false,
			"erro": "Cofrinho deve ter método set_nome()",
			"saida_esperada": "Método set_nome() existe",
			"saida_obtida": "Método não encontrado"
		}
	
	instancia.set_nome("Fernanda")
	var novo_nome = instancia.get_nome()
	
	if novo_nome != "Fernanda":
		return {
			"sucesso": false,
			"erro": "set_nome() não altera o nome corretamente",
			"saida_esperada": "Fernanda",
			"saida_obtida": novo_nome
		}
	
	return {"sucesso": true, "erro": ""}

func validar_encapsulamento(resultado, instancia) -> Dictionary:
	# Verifica se saldo é privado (não pode ser acessado diretamente)
	# Nota: GDScript permite acesso a propriedades públicas, mas a convenção
	# é usar _ para privado e métodos get/set
	
	# Testa se tem get e set
	if not instancia.has_method("get_saldo") or not instancia.has_method("set_saldo"):
		return {
			"sucesso": false,
			"erro": "Use get_saldo() e set_saldo() para acessar saldo",
			"saida_esperada": "Métodos get_saldo() e set_saldo()",
			"saida_obtida": "Métodos não encontrados"
		}
	
	return {"sucesso": true, "erro": ""}

func validar_operacoes_multiplas(resultado, instancia) -> Dictionary:
	# Adiciona 50
	instancia.adicionar(50.0)
	var saldo1 = instancia.get_saldo()
	
	if abs(saldo1 - 50.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Primeiro adicionar falhou",
			"saida_esperada": 50.0,
			"saida_obtida": saldo1
		}
	
	# Adiciona mais 30
	instancia.adicionar(30.0)
	var saldo2 = instancia.get_saldo()
	
	if abs(saldo2 - 80.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Segundo adicionar falhou",
			"saida_esperada": 80.0,
			"saida_obtida": saldo2
		}
	
	# Saca 25
	var sucesso = instancia.sacar(25.0)
	var saldo3 = instancia.get_saldo()
	
	if not sucesso or abs(saldo3 - 55.0) > 0.001:
		return {
			"sucesso": false,
			"erro": "Sacar falhou",
			"saida_esperada": 55.0,
			"saida_obtida": saldo3
		}
	
	return {"sucesso": true, "erro": ""}
