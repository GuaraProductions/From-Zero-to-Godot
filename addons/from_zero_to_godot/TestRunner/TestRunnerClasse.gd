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
	
	var nome_classe = dados_teste.get("classe", "")
	if nome_classe.is_empty():
		push_error("Nome da classe não especificado no arquivo de testes")
		return
	
	nome_classe_testada = nome_classe
	
	var metodos = dados_teste.get("metodos", [])
	var total_casos = 0
	
	# Conta total de casos
	for metodo in metodos:
		total_casos += metodo.get("casos", []).size()
	
	var caso_atual = 0
	
	# Executa testes para cada método
	for metodo in metodos:
		var nome_metodo = metodo.get("nome", "")
		var casos = metodo.get("casos", [])
		
		for caso in casos:
			caso_atual += 1
			teste_iniciado.emit(caso_atual, total_casos)
			var resultado = _executar_caso_metodo(caso, nome_metodo, metodo)
			resultados.append(resultado)
			teste_concluido.emit(resultado)
	
	var resumo = _gerar_resumo()
	todos_testes_concluidos.emit(resumo)

func _executar_caso_metodo(caso: Dictionary, nome_metodo: String, config_metodo: Dictionary) -> Dictionary:
	var resultado = {
		"nome": caso.get("nome", "Teste sem nome"),
		"entrada": caso.get("entrada", []),
		"saida_esperada": caso.get("saida_esperada"),
		"saida_obtida": null,
		"passou": false,
		"erro": "",
		"tempo_ms": 0
	}
	
	var tempo_inicio = Time.get_ticks_msec()
	
	# Obtém parâmetros do construtor
	var construtor_params = caso.get("construtor_params", [])
	if not construtor_params is Array:
		construtor_params = [construtor_params]
	
	# Cria instância da classe (suporta inner classes)
	var instancia
	var classe_alvo = _obter_classe_inner(script_testado, nome_classe_testada)
	
	if not classe_alvo:
		resultado.error = "Classe '%s' não encontrada no script" % nome_classe_testada
		return resultado
	
	if construtor_params.size() > 0:
		var callable_construtor = Callable(classe_alvo, "new")
		instancia = callable_construtor.callv(construtor_params)
	else:
		instancia = classe_alvo.new()
	
	if not instancia:
		resultado.error = "Erro ao criar instância da classe '%s'" % nome_classe_testada
		return resultado
	
	# Verifica se o método existe
	if not instancia.has_method(nome_metodo):
		resultado.error = "Método '%s()' não encontrado" % nome_metodo
		if instancia is RefCounted:
			pass  # RefCounted se libera automaticamente
		else:
			instancia.free()
		return resultado
	
	# Executa método
	var entrada = resultado.entrada
	if not entrada is Array:
		entrada = [entrada]
	
	resultado.saida_obtida = instancia.callv(nome_metodo, entrada)
	
	# Verifica propriedades se especificado
	var propriedades_esperadas = caso.get("propriedades", {})
	if not propriedades_esperadas.is_empty():
		var propriedades_obtidas = {}
		for prop_nome in propriedades_esperadas.keys():
			if prop_nome in instancia:
				propriedades_obtidas[prop_nome] = instancia.get(prop_nome)
		
		# Compara propriedades
		var modo_comparacao = config_metodo.get("comparacao", "exato")
		var tolerancia = config_metodo.get("tolerancia", 0.01)
		
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
			if resultado.saida_esperada != null:
				resultado.passed = _comparar_saidas(
					resultado.saida_obtida,
					resultado.saida_esperada,
					modo_comparacao,
					tolerancia
				)
			else:
				resultado.passed = true
	else:
		# Compara apenas o retorno
		var modo_comparacao = config_metodo.get("comparacao", "exato")
		var tolerancia = config_metodo.get("tolerancia", 0.01)
		
		resultado.passed = _comparar_saidas(
			resultado.saida_obtida,
			resultado.saida_esperada,
			modo_comparacao,
			tolerancia
		)
	
	var tempo_fim = Time.get_ticks_msec()
	resultado.time_ms = tempo_fim - tempo_inicio
	
	# Verifica timeout
	var timeout_ms = dados_teste.get("timeout", 1000)
	if resultado.time_ms > timeout_ms:
		resultado.passed = false
		resultado.error = "Timeout excedido (%dms > %dms)" % [resultado.time_ms, timeout_ms]
	
	# Libera instância
	if instancia is RefCounted:
		pass  # RefCounted se libera automaticamente
	else:
		instancia.free()
	
	return resultado

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
