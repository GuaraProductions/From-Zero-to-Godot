@tool
extends TestRunnerBase
class_name TestRunnerClasse

## TestRunner para classes com múltiplos métodos
## Formato JSON: {
##   tipo: "classe",
##   classe: String,
##   timeout: int,
##   metodos: [{
##     nome: String,
##     comparacao: String,
##     tolerancia: float,
##     casos: [{nome, construtor_params, entrada, saida_esperada, propriedades}]
##   }]
## }

var script_testado: GDScript = null
var nome_classe_testada: String = ""

func executar_testes(script: GDScript, arquivo_testes: String) -> void:
	script_testado = script
	resultados.clear()
	
	if not _carregar_dados_teste(arquivo_testes):
		return
	
	var nome_classe = test_config.name_class
	if nome_classe.is_empty():
		push_error("Nome da classe não especificado no arquivo de testes")
		return
	
	nome_classe_testada = nome_classe
	
	var metodos = test_config.methods
	var total_casos = 0
	
	# Conta total de casos
	for metodo in metodos:
		total_casos += metodo.cases.size()
	
	var caso_atual = 0
	
	# Executa testes para cada método
	for metodo in metodos:
		var casos = metodo.cases
		
		for caso in casos:
			caso_atual += 1
			teste_iniciado.emit(caso_atual, total_casos)
			var resultado = _executar_caso_metodo(caso, metodo)
			resultados.append(resultado)
			teste_concluido.emit(resultado)
	
	var resumo = _gerar_resumo()
	todos_testes_concluidos.emit(resumo)

func _executar_caso_metodo(caso: TestCaseConfig, config_metodo: TestMethodConfig) -> Dictionary:
	var nome_metodo = config_metodo.name
	var resultado = {
		"name": caso.name if not caso.name.is_empty() else "Unnamed test",
		"input": caso.input.duplicate(true),
		"expected_output": caso.expected_output,
		"actual_output": null,
		"passed": false,
		"error": "",
		"time_ms": 0
	}
	
	var tempo_inicio = Time.get_ticks_msec()
	
	# Obtém parâmetros do construtor
	var construtor_params = caso.constructor_params.duplicate(true)
	if not construtor_params is Array:
		construtor_params = [construtor_params]
	
	# Cria instância da classe (suporta inner classes)
	var instancia
	var nome_classe_caso = caso.name_class if not caso.name_class.is_empty() else nome_classe_testada
	var classe_alvo = _obter_classe_inner(script_testado, nome_classe_caso)
	
	if not classe_alvo:
		resultado.error = "Classe '%s' não encontrada no script" % nome_classe_caso
		return resultado

	var construtor_resolvido = _resolver_argumentos(construtor_params, script_testado, resultado)
	if construtor_resolvido == null and not resultado.error.is_empty():
		return resultado
	
	if construtor_resolvido.size() > 0:
		var callable_construtor = Callable(classe_alvo, "new")
		instancia = callable_construtor.callv(construtor_resolvido)
	else:
		instancia = classe_alvo.new()
	
	if not instancia:
		resultado.error = "Erro ao criar instância da classe '%s'" % nome_classe_caso
		return resultado

	if not _executar_setup_calls(instancia, caso, script_testado, resultado):
		_liberar_instancia(instancia)
		return resultado
	
	# Verifica se o método existe
	if not instancia.has_method(nome_metodo):
		resultado.error = "Método '%s()' não encontrado" % nome_metodo
		_liberar_instancia(instancia)
		return resultado
	
	# Executa método
	var entrada = resultado.input
	if not entrada is Array:
		entrada = [entrada]
	
	resultado.actual_output = instancia.callv(nome_metodo, entrada)
	
	# Verifica propriedades se especificado
	var propriedades_esperadas = caso.properties
	if not propriedades_esperadas.is_empty():
		var propriedades_obtidas = {}
		for prop_nome in propriedades_esperadas.keys():
			if prop_nome in instancia:
				propriedades_obtidas[prop_nome] = instancia.get(prop_nome)
		
		# Compara propriedades
		var modo_comparacao = config_metodo.comparison
		var tolerancia = config_metodo.tolerance
		
		var props_ok = _comparar_saidas(
			propriedades_obtidas,
			propriedades_esperadas,
			modo_comparacao,
			tolerancia
		)
		
		if not props_ok:
			resultado.error = "Propriedades não correspondem. Obtido: %s" % str(propriedades_obtidas)
			resultado.passed = false
		else:
			# Compara também o retorno se houver saida_esperada
			if resultado.expected_output != null:
				resultado.passed = _comparar_saidas(
					resultado.actual_output,
					resultado.expected_output,
					modo_comparacao,
					tolerancia
				)
			else:
				resultado.passed = true
	else:
		# Compara apenas o retorno
		var modo_comparacao = config_metodo.comparison
		var tolerancia = config_metodo.tolerance
		
		resultado.passed = _comparar_saidas(
			resultado.actual_output,
			resultado.expected_output,
			modo_comparacao,
			tolerancia
		)
	
	var tempo_fim = Time.get_ticks_msec()
	resultado.time_ms = tempo_fim - tempo_inicio
	
	# Verifica timeout
	var timeout_ms = test_config.timeout_ms
	if resultado.time_ms > timeout_ms:
		resultado.passed = false
		resultado.error = "Timeout excedido (%dms > %dms)" % [resultado.time_ms, timeout_ms]
	
	# Libera instância
	_liberar_instancia(instancia)
	
	return resultado

func _executar_setup_calls(instancia, caso: TestCaseConfig, script_testado: GDScript, resultado: Dictionary) -> bool:
	for raw_setup in caso.setup_calls:
		if not raw_setup is Dictionary:
			resultado.error = "Cada setup_call deve ser um Dictionary"
			return false

		var setup = TestConfigKeys.normalize_dictionary(raw_setup)
		var nome_metodo_setup := str(setup.get(TestConfigKeys.METHOD, ""))
		if nome_metodo_setup.is_empty():
			resultado.error = "setup_call sem método definido"
			return false

		if not instancia.has_method(nome_metodo_setup):
			resultado.error = "Método de setup '%s()' não encontrado" % nome_metodo_setup
			return false

		var argumentos_setup = setup.get(TestConfigKeys.INPUT, [])
		if not argumentos_setup is Array:
			argumentos_setup = [argumentos_setup]

		argumentos_setup = _resolver_argumentos(argumentos_setup, script_testado, resultado)
		if argumentos_setup == null and not resultado.error.is_empty():
			return false

		instancia.callv(nome_metodo_setup, argumentos_setup)

	return true

func _resolver_argumentos(argumentos: Array, script_testado: GDScript, resultado: Dictionary) -> Array:
	var resolvidos: Array = []
	for argumento in argumentos:
		var valor_resolvido = _resolver_valor(argumento, script_testado, resultado)
		if valor_resolvido == null and not resultado.error.is_empty():
			return []
		resolvidos.append(valor_resolvido)
	return resolvidos

func _resolver_valor(valor, script_testado: GDScript, resultado: Dictionary):
	if valor is Array:
		return _resolver_argumentos(valor, script_testado, resultado)

	if valor is Dictionary:
		if valor.has("__class__"):
			var nome_classe = str(valor.get("__class__", ""))
			if nome_classe.is_empty():
				resultado.error = "Especificação de classe sem '__class__' válido"
				return null

			var classe_alvo = _obter_classe_inner(script_testado, nome_classe)
			if not classe_alvo:
				resultado.error = "Classe auxiliar '%s' não encontrada no script" % nome_classe
				return null

			var parametros = valor.get(TestConfigKeys.CONSTRUCTOR_PARAMS, [])
			if not parametros is Array:
				parametros = [parametros]

			var parametros_resolvidos = _resolver_argumentos(parametros, script_testado, resultado)
			if parametros_resolvidos == null and not resultado.error.is_empty():
				return null

			return Callable(classe_alvo, "new").callv(parametros_resolvidos)

		var dicionario_resolvido := {}
		for chave in valor.keys():
			dicionario_resolvido[chave] = _resolver_valor(valor[chave], script_testado, resultado)
			if dicionario_resolvido[chave] == null and not resultado.error.is_empty():
				return null
		return dicionario_resolvido

	return valor

func _liberar_instancia(instancia) -> void:
	if instancia is RefCounted:
		return
	instancia.free()

func _obter_classe_inner(script: GDScript, nome_classe: String):
	# Tenta acessar inner class pelo nome
	# Em GDScript, inner classes são acessíveis como propriedades do script
	
	# Método 1: Acesso direto (funciona se a classe está definida no script)
	if nome_classe in script:
		return script.get(nome_classe)
	
	# Método 2: Através do mapa de constantes (para classes declaradas)
	var constants = script.get_script_constant_map()
	if nome_classe in constants:
		return constants[nome_classe]
	
	# Método 3: Tentar criar uma instância temporária do script principal
	# e acessar a classe através dela
	var instancia_temp = script.new()
	if instancia_temp:
		if nome_classe in instancia_temp:
			var classe = instancia_temp.get(nome_classe)
			if instancia_temp is RefCounted:
				pass  # RefCounted se libera automaticamente
			else:
				instancia_temp.free()
			return classe
		
		if instancia_temp is RefCounted:
			pass
		else:
			instancia_temp.free()
	
	return null
