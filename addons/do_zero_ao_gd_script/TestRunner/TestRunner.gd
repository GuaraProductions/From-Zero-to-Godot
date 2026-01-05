class_name TestRunner
extends RefCounted

signal teste_iniciado(index: int, total: int)
signal teste_concluido(resultado: Dictionary)
signal todos_testes_concluidos(resumo: Dictionary)

func executar_testes(
	script_aluno: Script,
	arquivo_testes: String
) -> Array[Dictionary]:
	var resultados := []
	
	# Carrega arquivo de testes
	var dados_testes = _carregar_json(arquivo_testes)
	if dados_testes.is_empty():
		push_error("Erro ao carregar arquivo de testes: %s" % arquivo_testes)
		return resultados
	
	var casos: Array = dados_testes.get("casos", [])
	var funcao: String = dados_testes.get("funcao", "")
	var comparacao: String = dados_testes.get("comparacao", "exato")
	var tolerancia: float = dados_testes.get("tolerancia", 0.01)
	var timeout: int = dados_testes.get("timeout", 5)
	
	# Executa cada caso de teste
	for i in range(casos.size()):
		teste_iniciado.emit(i + 1, casos.size())
		
		var caso = casos[i]
		var resultado = _executar_caso(
			script_aluno,
			funcao,
			caso,
			comparacao,
			tolerancia,
			timeout
		)
		
		resultados.append(resultado)
		teste_concluido.emit(resultado)
	
	var resumo = _gerar_resumo(resultados)
	todos_testes_concluidos.emit(resumo)
	return resultados

func _executar_caso(
	script: Script,
	funcao: String,
	caso: Dictionary,
	tipo_comparacao: String,
	tolerancia: float,
	timeout: int
) -> Dictionary:
	var resultado := {
		"nome": caso.get("nome", "Teste sem nome"),
		"passou": false,
		"tempo_ms": 0,
		"entrada": caso.get("entrada", []),
		"saida_esperada": caso.get("saida_esperada"),
		"saida_obtida": null,
		"erro": ""
	}
	
	# Cria instância
	var instancia = script.new()
	
	if not instancia.has_method(funcao):
		resultado.erro = "Função '%s' não encontrada no script" % funcao
		instancia.free()
		return resultado
	
	# Executa com medição de tempo
	var inicio = Time.get_ticks_msec()
	var callable_func = Callable(instancia, funcao)
	
	var saida = callable_func.callv(resultado.entrada)
	
	resultado.tempo_ms = Time.get_ticks_msec() - inicio
	resultado.saida_obtida = saida
	
	# Verifica timeout
	if resultado.tempo_ms > timeout * 1000:
		resultado.erro = "Timeout: teste levou %dms (limite: %ds)" % [resultado.tempo_ms, timeout]
		instancia.free()
		return resultado
	
	# Compara resultado
	resultado.passou = _comparar_saidas(
		resultado.saida_esperada,
		resultado.saida_obtida,
		tipo_comparacao,
		tolerancia
	)
	
	if not resultado.passou and resultado.erro.is_empty():
		resultado.erro = "Saída diferente da esperada"
	
	instancia.free()
	return resultado

func _comparar_saidas(esperado, obtido, tipo: String, tolerancia: float) -> bool:
	if esperado == null:
		return obtido == null
	
	match tipo:
		"aproximado":
			if typeof(esperado) == TYPE_FLOAT or typeof(esperado) == TYPE_INT:
				return absf(float(esperado) - float(obtido)) <= tolerancia
			elif typeof(esperado) == TYPE_DICTIONARY:
				return _comparar_dicts_aproximado(esperado, obtido, tolerancia)
			elif typeof(esperado) == TYPE_ARRAY:
				return _comparar_arrays_aproximado(esperado, obtido, tolerancia)
		"exato":
			return esperado == obtido
		_:
			return esperado == obtido
	
	return false

func _comparar_dicts_aproximado(esperado: Dictionary, obtido: Dictionary, tolerancia: float) -> bool:
	if esperado.keys().size() != obtido.keys().size():
		return false
	
	for key in esperado.keys():
		if not obtido.has(key):
			return false
		
		var val_esperado = esperado[key]
		var val_obtido = obtido[key]
		
		if typeof(val_esperado) == TYPE_FLOAT or typeof(val_esperado) == TYPE_INT:
			if absf(float(val_esperado) - float(val_obtido)) > tolerancia:
				return false
		else:
			if val_esperado != val_obtido:
				return false
	
	return true

func _comparar_arrays_aproximado(esperado: Array, obtido: Array, tolerancia: float) -> bool:
	if esperado.size() != obtido.size():
		return false
	
	for i in range(esperado.size()):
		var val_esperado = esperado[i]
		var val_obtido = obtido[i]
		
		if typeof(val_esperado) == TYPE_FLOAT or typeof(val_esperado) == TYPE_INT:
			if absf(float(val_esperado) - float(val_obtido)) > tolerancia:
				return false
		else:
			if val_esperado != val_obtido:
				return false
	
	return true

func _carregar_json(caminho: String) -> Dictionary:
	var file = FileAccess.open(caminho, FileAccess.READ)
	if not file:
		push_error("Arquivo não encontrado: %s" % caminho)
		return {}
	
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_text)
	
	if error != OK:
		push_error("Erro ao parsear JSON: %s" % json.get_error_message())
		return {}
	
	return json.data

func _gerar_resumo(resultados: Array[Dictionary]) -> Dictionary:
	var passou_count = 0
	var tempo_total = 0
	
	for r in resultados:
		if r.passou:
			passou_count += 1
		tempo_total += r.tempo_ms
	
	return {
		"total": resultados.size(),
		"passou": passou_count,
		"falhou": resultados.size() - passou_count,
		"tempo_total_ms": tempo_total,
		"tempo_medio_ms": float(tempo_total) / resultados.size() if resultados.size() > 0 else 0.0,
		"percentual": (float(passou_count) / resultados.size()) * 100.0 if resultados.size() > 0 else 0.0
	}
