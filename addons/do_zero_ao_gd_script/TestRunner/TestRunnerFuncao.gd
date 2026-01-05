@tool
extends TestRunnerBase
class_name TestRunnerFuncao

## TestRunner para funções simples
## Formato JSON: {funcao: String, timeout: int, comparacao: String, tolerancia: float, casos: [{nome, entrada, saida_esperada}]}

var script_testado: GDScript = null

func executar_testes(script: GDScript, arquivo_testes: String) -> void:
	script_testado = script
	resultados.clear()
	
	if not _carregar_dados_teste(arquivo_testes):
		return
	
	var nome_funcao = dados_teste.get("funcao", "")
	if nome_funcao.is_empty():
		push_error("Nome da função não especificado no arquivo de testes")
		return
	
	var casos = dados_teste.get("casos", [])
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
		"nome": caso.get("nome", "Teste sem nome"),
		"entrada": caso.get("entrada", []),
		"saida_esperada": caso.get("saida_esperada"),
		"saida_obtida": null,
		"passou": false,
		"erro": "",
		"tempo_ms": 0
	}
	
	var tempo_inicio = Time.get_ticks_msec()
	
	# Cria instância do script
	var instancia = script_testado.new()
	
	# Verifica se a função existe
	if not instancia.has_method(nome_funcao):
		resultado.erro = "Função '%s()' não encontrada" % nome_funcao
		instancia.free()
		return resultado
	
	# Executa função com timeout
	var timeout_ms = dados_teste.get("timeout", 1000)
	var callable_func = Callable(instancia, nome_funcao)
	
	var entrada = resultado.entrada
	if not entrada is Array:
		entrada = [entrada]
	
	# Executa a função
	resultado.saida_obtida = callable_func.callv(entrada)
	
	# Compara resultado
	var modo_comparacao = dados_teste.get("comparacao", "exato")
	var tolerancia = dados_teste.get("tolerancia", 0.01)
	
	resultado.passou = _comparar_saidas(
		resultado.saida_obtida,
		resultado.saida_esperada,
		modo_comparacao,
		tolerancia
	)
	
	var tempo_fim = Time.get_ticks_msec()
	resultado.tempo_ms = tempo_fim - tempo_inicio
	
	# Verifica timeout
	if resultado.tempo_ms > timeout_ms:
		resultado.passou = false
		resultado.erro = "Timeout excedido (%dms > %dms)" % [resultado.tempo_ms, timeout_ms]
	
	instancia.free()
	return resultado
