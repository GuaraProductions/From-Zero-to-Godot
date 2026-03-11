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
	
	var funcoes = _obter_funcoes_para_executar()
	if funcoes.is_empty():
		push_error("Nenhuma função configurada no arquivo de testes")
		return
	
	var total = 0
	for function_config in funcoes:
		total += function_config.cases.size()
	
	var caso_atual = 0
	for function_config in funcoes:
		for caso in function_config.cases:
			caso_atual += 1
			teste_iniciado.emit(caso_atual, total)
			var resultado = _executar_caso(caso, function_config)
			resultados.append(resultado)
			teste_concluido.emit(resultado)
	
	var resumo = _gerar_resumo()
	todos_testes_concluidos.emit(resumo)

func _executar_caso(caso: TestCaseConfig, function_config: TestFunctionConfig) -> Dictionary:
	var nome_funcao = function_config.function_name
	var resultado = {
		"name": _build_result_name(caso, nome_funcao),
		"input": caso.input.duplicate(true),
		"expected_output": caso.expected_output,
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
		resultado.error = "Function '%s()' not found" % nome_funcao
		instancia.free()
		return resultado
	
	# Executa função com timeout
	var timeout_ms = test_config.timeout_ms
	var callable_func = Callable(instancia, nome_funcao)
	
	var entrada = resultado.input
	if not entrada is Array:
		entrada = [entrada]
	
	# Executa a função
	resultado.actual_output = callable_func.callv(entrada)
	
	# Compara resultado
	var modo_comparacao = function_config.comparison
	var tolerancia = function_config.tolerance
	
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
		resultado.error = "Timeout exceeded (%dms > %dms)" % [resultado.time_ms, timeout_ms]
	
	instancia.free()
	return resultado

func _obter_funcoes_para_executar() -> Array[TestFunctionConfig]:
	if test_config.type == TestConfigResource.TYPE_FUNCTION_GROUP:
		return test_config.functions

	var function_config = TestFunctionConfig.new()
	function_config.function_name = test_config.function_name
	function_config.comparison = test_config.comparison
	function_config.tolerance = test_config.tolerance
	function_config.cases = test_config.cases
	return [function_config]

func _build_result_name(caso: TestCaseConfig, nome_funcao: String) -> String:
	var base_name = caso.name if not caso.name.is_empty() else "Unnamed test"
	if test_config.type == TestConfigResource.TYPE_FUNCTION_GROUP:
		return "%s :: %s" % [nome_funcao, base_name]
	return base_name
