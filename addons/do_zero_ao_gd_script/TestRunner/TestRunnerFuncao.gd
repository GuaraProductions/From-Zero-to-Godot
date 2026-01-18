@tool
extends TestRunnerBase
class_name TestRunnerFuncao

## TestRunner for simple functions
## JSON Format: {function: String, timeout: int, comparison: String, tolerance: float, cases: [{name, input, expected_output}]}

var script_testado: GDScript = null

func executar_testes(script: GDScript, arquivo_testes: String) -> void:
	script_testado = script
	resultados.clear()
	
	if not _carregar_dados_teste(arquivo_testes):
		return
	
	var nome_funcao = dados_teste.get("function", "")
	if nome_funcao.is_empty():
		push_error("Nome da função não especificado no arquivo de testes")
		return
	
	var casos = dados_teste.get("cases", [])
	var total = casos.size()
	
	for i in range(total):
		teste_iniciado.emit(i + 1, total)
		var resultado = _executar_caso(casos[i], nome_funcao)
		resultados.append(resultado)
		teste_concluido.emit(resultado)
	
	var resumo = _gerar_resumo()
	todos_testes_concluidos.emit(resumo)

func _executar_caso(caso: Dictionary, nome_funcao: String) -> Dictionary:
	var resultado = {
		"name": caso.get("name", "Teste sem nome"),
		"input": caso.get("input", []),
		"expected_output": caso.get("expected_output"),
		"actual_output": null,
		"passed": false,
		"error": "",
		"time_ms": 0
	}
	
	var tempo_inicio = Time.get_ticks_msec()
	
	# Cria instância do script
	var instancia = script_testado.new()
	
	# Verifica se a função existe
	if not instancia.has_method(nome_funcao):
		resultado.errorr = "Função '%s()' não encontrada" % nome_funcao
		instancia.free()
		return resultado
	
	# Executa função com timeout
	var timeout_ms = dados_teste.get("timeout", 1000)
	var callable_func = Callable(instancia, nome_funcao)
	
	var entrada = resultado.input
	if not entrada is Array:
		entrada = [entrada]
	
	# Executa a função
	resultado.actual_output = callable_func.callv(entrada)
	
	# Compara resultado
	var modo_comparacao = dados_teste.get("comparison", "exact")
	var tolerancia = dados_teste.get("tolerance", 0.01)
	
	resultado.passed = _comparar_saidas(
		resultado.actual_output,
		resultado.expected_output,
		modo_comparacao,
		tolerancia
	)
	
	var tempo_fim = Time.get_ticks_msec()
	resultado.time_ms = tempo_fim - tempo_inicio
	
	# Verifica timeout
	if resultado.time_ms > timeout_ms:
		resultado.passed = false
		resultado.errorr = "Timeout excedido (%dms > %dms)\" % [resultado.time_ms, timeout_ms]
	
	instancia.free()
	return resultado
