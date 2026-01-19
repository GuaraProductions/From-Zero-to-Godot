@tool
extends TestRunnerClasse
class_name TestRunnerClasseCustom

## TestRunner para testes de classes com validação customizada por código
## Em vez de usar JSON, carrega um arquivo .gd que define os testes
## O arquivo deve ter a estrutura:
##
## extends Node
## 
## func get_casos_teste() -> Array[Dictionary]:
##     return [
##         {
##             "nome": "Nome do teste",
##             "metodo": "nome_do_metodo",
##             "construtor_params": [],
##             "entrada": [...],
##             "validar": func(resultado, instancia): 
##                 # Retorna {sucesso: bool, erro: String}
##                 if resultado == null:
##                     return {"sucesso": false, "erro": "Resultado é null"}
##                 if not resultado is MinhaClasse:
##                     return {"sucesso": false, "erro": "Tipo incorreto"}
##                 if resultado.propriedade != valor_esperado:
##                     return {"sucesso": false, "erro": "Valor incorreto"}
##                 return {"sucesso": true, "erro": ""}
##         }
##     ]

var arquivo_testes_custom: String = ""
var instancia_testes: Node = null  # Mantém referência para chamar funções de validação

func executar_testes(script: GDScript, arquivo_testes: String) -> void:
	script_testado = script
	resultados.clear()
	arquivo_testes_custom = arquivo_testes
	
	# Carrega o arquivo de testes customizado
	var script_testes = load(arquivo_testes)
	if not script_testes:
		push_error("Não foi possível carregar arquivo de testes: %s" % arquivo_testes)
		return
	
	instancia_testes = script_testes.new()
	if not instancia_testes.has_method("get_casos_teste"):
		push_error("Arquivo de testes não tem método get_casos_teste()")
		instancia_testes.free()
		instancia_testes = null
		return
	
	var casos = instancia_testes.get_casos_teste()
	
	if not casos or casos.is_empty():
		push_error("Nenhum caso de teste encontrado")
		instancia_testes.free()
		instancia_testes = null
		return
	
	# Detecta nome da classe testada do primeiro caso
	if not casos.is_empty():
		var primeiro_caso = casos[0]
		if primeiro_caso.has("classe"):
			nome_classe_testada = primeiro_caso.classe
	
	var total = casos.size()
	
	for i in range(total):
		teste_iniciado.emit(i + 1, total)
		var resultado = _executar_caso_custom(casos[i])
		resultados.append(resultado)
		teste_concluido.emit(resultado)
	
	# Libera instância de testes após concluir
	if instancia_testes:
		instancia_testes.free()
		instancia_testes = null
	
	var resumo = _gerar_resumo()
	todos_testes_concluidos.emit(resumo)

func _executar_caso_custom(caso: Dictionary) -> Dictionary:
	var resultado = {
		"nome": caso.get("nome", "Teste sem nome"),
		"entrada": caso.get("entrada", []),
		"saida_esperada": "Validação customizada",
		"saida_obtida": null,
		"passou": false,
		"erro": "",
		"tempo_ms": 0
	}
	
	var tempo_inicio = Time.get_ticks_msec()
	
	# Obtém a classe alvo
	var nome_classe = caso.get("classe", nome_classe_testada)
	var classe_alvo = _obter_classe_inner(script_testado, nome_classe)
	
	if not classe_alvo:
		resultado.error = "Classe '%s' não encontrada no script" % nome_classe
		return resultado
	
	# Cria instância
	var construtor_params = caso.get("construtor_params", [])
	var instancia
	
	if construtor_params.is_empty():
		instancia = classe_alvo.new()
	else:
		var callable_construtor = Callable(classe_alvo, "new")
		instancia = callable_construtor.callv(construtor_params)
	
	if not instancia:
		resultado.error = "Erro ao criar instância da classe"
		return resultado
	
	# Executa o método se especificado
	var nome_metodo = caso.get("metodo", "")
	var retorno_metodo = null
	
	if not nome_metodo.is_empty():
		if not instancia.has_method(nome_metodo):
			resultado.error = "Método '%s()' não encontrado" % nome_metodo
			instancia.free()
			return resultado
		
		var callable_metodo = Callable(instancia, nome_metodo)
		var entrada = resultado.entrada
		if not entrada is Array:
			entrada = [entrada]
		
		retorno_metodo = callable_metodo.callv(entrada)
	
	resultado.saida_obtida = retorno_metodo
	
	# Executa validação customizada
	var funcao_validar = caso.get("validar")
	if funcao_validar and instancia_testes:
		var resultado_validacao
		
		# Se for Callable, tenta chamar direto
		if funcao_validar is Callable:
			# Callable precisa ser chamado na instância de testes
			var nome_funcao = str(funcao_validar).split("::")[1].split(" ")[0]
			if instancia_testes.has_method(nome_funcao):
				resultado_validacao = instancia_testes.callv(nome_funcao, [retorno_metodo, instancia])
			else:
				resultado.error = "Função de validação '%s' não encontrada" % nome_funcao
		# Se for String, chama pelo nome
		elif funcao_validar is String:
			if instancia_testes.has_method(funcao_validar):
				resultado_validacao = instancia_testes.callv(funcao_validar, [retorno_metodo, instancia])
			else:
				resultado.error = "Função de validação '%s' não encontrada" % funcao_validar
		
		if resultado_validacao:
			if resultado_validacao is Dictionary:
				resultado.passed = resultado_validacao.get("sucesso", false)
				resultado.error = resultado_validacao.get("erro", "")
				if resultado_validacao.has("saida_esperada"):
					resultado.saida_esperada = resultado_validacao.saida_esperada
				if resultado_validacao.has("saida_obtida"):
					resultado.saida_obtida = resultado_validacao.saida_obtida
			else:
				resultado.passed = resultado_validacao == true
	else:
		resultado.error = "Função de validação não fornecida"
	
	var tempo_fim = Time.get_ticks_msec()
	resultado.time_ms = tempo_fim - tempo_inicio
	
	return resultado
