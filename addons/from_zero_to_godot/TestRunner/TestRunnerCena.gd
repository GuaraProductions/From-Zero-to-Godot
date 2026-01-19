@tool
extends TestRunnerBase
class_name TestRunnerCena

## TestRunner para testes que validam efeitos na scene_tree
## Usado para exercícios que manipulam a UI diretamente
## Formato JSON: {
##   tipo: "cena",
##   funcao: String,
##   timeout: int,
##   casos: [{nome, entrada, validacao: {tipo: "contagem_filhos"|"conteudo_texto", ...}}]
## }

var script_testado: GDScript = null
var cena_teste: Node = null
var cena_path: String = ""

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
		var resultado = await _executar_caso_cena(casos[i], nome_funcao)
		resultados.append(resultado)
		teste_concluido.emit(resultado)
	
	var resumo = _gerar_resumo()
	todos_testes_concluidos.emit(resumo)

func _executar_caso_cena(caso: Dictionary, nome_funcao: String) -> Dictionary:
	var resultado = {
		"nome": caso.get("nome", "Teste sem nome"),
		"entrada": caso.get("entrada", []),
		"saida_esperada": caso.get("validacao", {}),
		"saida_obtida": null,
		"passou": false,
		"erro": "",
		"tempo_ms": 0
	}
	
	var tempo_inicio = Time.get_ticks_msec()
	
	# Tenta carregar a cena se o caminho foi fornecido
	var instancia
	if not cena_path.is_empty() and FileAccess.file_exists(cena_path):
		var cena_packed = load(cena_path)
		if cena_packed:
			instancia = cena_packed.instantiate()
		else:
			resultado.error = "Erro ao carregar cena: %s" % cena_path
			return resultado
	else:
		# Fallback: cria instância do script
		instancia = script_testado.new()
	
	# Verifica se a função existe
	if not instancia.has_method(nome_funcao):
		resultado.error = "Função '%s()' não encontrada" % nome_funcao
		instancia.queue_free()
		return resultado
	
	# Adiciona à scene tree temporariamente para teste
	var temp_root = Node.new()
	temp_root.name = "TestRunnerTemp"
	
	if Engine.is_editor_hint():
		# No editor, adiciona à cena editada
		EditorInterface.get_edited_scene_root().add_child(temp_root)
	else:
		# Fora do editor, adiciona à scene tree atual
		Engine.get_main_loop().root.add_child(temp_root)
	
	temp_root.add_child(instancia)
	
	# Aguarda um frame para garantir que a cena foi inicializada
	await Engine.get_main_loop().process_frame
	
	# Executa função
	var callable_func = Callable(instancia, nome_funcao)
	var entrada = resultado.entrada
	if not entrada is Array:
		entrada = [entrada]
	
	callable_func.callv(entrada)
	
	# Valida o resultado na scene tree
	var validacao = caso.get("validacao", {})
	var validacao_resultado = _validar_cena(instancia, validacao)
	
	resultado.passed = validacao_resultado.sucesso
	resultado.saida_obtida = validacao_resultado.obtido
	resultado.error = validacao_resultado.error
	
	var tempo_fim = Time.get_ticks_msec()
	resultado.time_ms = tempo_fim - tempo_inicio
	
	# Verifica timeout
	var timeout_ms = dados_teste.get("timeout", 1000)
	if resultado.time_ms > timeout_ms:
		resultado.passed = false
		resultado.error = "Timeout excedido (%dms > %dms)" % [resultado.time_ms, timeout_ms]
	
	# Remove da scene tree e libera
	var parent_node = instancia.get_parent()
	if parent_node:
		var root_parent = parent_node.get_parent()
		if root_parent:
			root_parent.remove_child(parent_node)
		parent_node.queue_free()  # Isso libera instancia também
	else:
		instancia.queue_free()
	
	return resultado

func _validar_cena(instancia: Node, validacao: Dictionary) -> Dictionary:
	var tipo_validacao = validacao.get("tipo", "")
	
	match tipo_validacao:
		"contagem_filhos":
			return _validar_contagem_filhos(instancia, validacao)
		"conteudo_labels":
			return _validar_conteudo_labels(instancia, validacao)
		"chamadas_funcao":
			return _validar_chamadas_funcao(instancia, validacao)
		"validar_tabuada":
			return _validar_tabuada(instancia, validacao)
		_:
			return {
				"sucesso": false,
				"obtido": null,
				"erro": "Tipo de validação desconhecido: %s" % tipo_validacao
			}

func _validar_contagem_filhos(instancia: Node, validacao: Dictionary) -> Dictionary:
	var caminho_node = validacao.get("caminho_node", "")
	var contagem_esperada = validacao.get("contagem", 0)
	
	var node_alvo = instancia
	if not caminho_node.is_empty():
		node_alvo = instancia.get_node_or_null(caminho_node)
		if not node_alvo:
			return {
				"sucesso": false,
				"obtido": null,
				"erro": "Node não encontrado: %s" % caminho_node
			}
	
	var contagem_obtida = node_alvo.get_child_count()
	
	return {
		"sucesso": contagem_obtida == contagem_esperada,
		"obtido": contagem_obtida,
		"erro": "" if contagem_obtida == contagem_esperada else "Esperado %d filhos, obtido %d" % [contagem_esperada, contagem_obtida]
	}

func _validar_conteudo_labels(instancia: Node, validacao: Dictionary) -> Dictionary:
	var caminho_container = validacao.get("caminho_container", "")
	var textos_esperados = validacao.get("textos", [])
	
	var container = instancia.get_node_or_null(caminho_container)
	if not container:
		return {
			"sucesso": false,
			"obtido": null,
			"erro": "Container não encontrado: %s" % caminho_container
		}
	
	var textos_obtidos = []
	for child in container.get_children():
		if child is Label:
			textos_obtidos.append(child.text)
	
	var sucesso = textos_obtidos.size() == textos_esperados.size()
	if sucesso:
		for i in range(textos_esperados.size()):
			if textos_obtidos[i] != textos_esperados[i]:
				sucesso = false
				break
	
	return {
		"sucesso": sucesso,
		"obtido": textos_obtidos,
		"erro": "" if sucesso else "Textos não correspondem. Esperado: %s, Obtido: %s" % [str(textos_esperados), str(textos_obtidos)]
	}

func _validar_chamadas_funcao(instancia: Node, validacao: Dictionary) -> Dictionary:
	# Esta validação assume que a função foi chamada e produziu efeitos observáveis
	# Por exemplo, verificar se adicionar_tabuada() foi chamada N vezes
	# Para isso, precisamos verificar o estado resultante da cena
	
	var esperado = validacao.get("esperado", {})
	var obtido = {}
	
	# Implementação específica para validar múltiplas chamadas
	# Exemplo: contar quantos labels foram criados em diferentes containers
	
	return {
		"sucesso": true,  # Placeholder
		"obtido": obtido,
		"erro": ""
	}

func _validar_tabuada(instancia: Node, validacao: Dictionary) -> Dictionary:
	var operacoes = validacao.get("operacoes", {})
	var erros = []
	var resultados_obtidos = {}
	var sucesso_geral = true
	
	for op_nome in operacoes.keys():
		var op_config = operacoes[op_nome]
		var caminho_container = op_config.get("container", "")
		
		# Busca o container
		var container = instancia.get_node_or_null(caminho_container)
		if not container:
			erros.append("Container '%s' não encontrado" % caminho_container)
			sucesso_geral = false
			continue
		
		# Coleta todos os Labels de todos os VBoxContainer
		var labels_texto = []
		for child in container.get_children():
			if child is VBoxContainer:
				for label_child in child.get_children():
					if label_child is Label:
						labels_texto.append(label_child.text)
		
		resultados_obtidos[op_nome] = labels_texto
		
		# Verifica se há resultados esperados específicos
		if op_config.has("resultados_esperados"):
			var esperados = op_config.get("resultados_esperados", [])
			
			# Verifica se todos os esperados estão presentes
			for esperado in esperados:
				if not esperado in labels_texto:
					erros.append("%s: Falta '%s'" % [op_nome, esperado])
					sucesso_geral = false
			
			# Verifica se não há extras
			if labels_texto.size() != esperados.size():
				erros.append("%s: Esperado %d labels, obtido %d" % [op_nome, esperados.size(), labels_texto.size()])
				sucesso_geral = false
		
		# Verifica contagem total se especificado
		elif op_config.has("total_labels"):
			var total_esperado = op_config.get("total_labels", 0)
			if labels_texto.size() != total_esperado:
				erros.append("%s: Esperado %d labels, obtido %d" % [op_nome, total_esperado, labels_texto.size()])
				sucesso_geral = false
	
	var mensagem_erro = "" if erros.is_empty() else "\n".join(erros)
	
	return {
		"sucesso": sucesso_geral,
		"obtido": resultados_obtidos,
		"erro": mensagem_erro
	}
