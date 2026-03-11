@tool
extends TestRunnerBase
class_name TestRunnerClasseCustom

## TestRunner para testes customizados baseados em script.
## O JSON apenas aponta para um arquivo .gd com get_test_cases()/get_casos_teste().
## O script do aluno é instanciado dentro de um stub oculto temporário para que
## chamadas como add_child() não interfiram na interface de testes.

var arquivo_testes_custom: String = ""
var script_testado: GDScript = null
var instancia_testes: Node = null
var casos_custom: Array[TestCaseConfig] = []

func executar_testes(script: GDScript, arquivo_testes: String) -> void:
	script_testado = script
	resultados.clear()
	arquivo_testes_custom = arquivo_testes

	var caminho_script_testes = arquivo_testes
	if arquivo_testes.ends_with(".json"):
		if not _carregar_dados_teste(arquivo_testes):
			return
		caminho_script_testes = test_config.test_file
		if caminho_script_testes.is_empty():
			push_error("Configuração classe_custom precisa definir test_file")
			return
	
	# Carrega o arquivo de testes customizado
	var script_testes = load(caminho_script_testes)
	if not script_testes:
		push_error("Não foi possível carregar arquivo de testes: %s" % caminho_script_testes)
		return
	
	instancia_testes = script_testes.new()
	if not instancia_testes.has_method("get_casos_teste") and not instancia_testes.has_method("get_test_cases"):
		push_error("Arquivo de testes não tem método get_casos_teste() nem get_test_cases()")
		instancia_testes.free()
		instancia_testes = null
		return
	
	casos_custom = TestConfigFactory.load_custom_cases(caminho_script_testes)
	
	if casos_custom.is_empty():
		push_error("Nenhum caso de teste encontrado")
		instancia_testes.free()
		instancia_testes = null
		return
	
	var total = casos_custom.size()
	
	for i in range(total):
		teste_iniciado.emit(i + 1, total)
		var resultado = _executar_caso_custom(casos_custom[i])
		resultados.append(resultado)
		teste_concluido.emit(resultado)
	
	# Libera instância de testes após concluir
	if instancia_testes:
		instancia_testes.free()
		instancia_testes = null
	
	var resumo = _gerar_resumo()
	todos_testes_concluidos.emit(resumo)

func _executar_caso_custom(caso: TestCaseConfig) -> Dictionary:
	var resultado = {
		"name": caso.name if not caso.name.is_empty() else "Unnamed test",
		"input": caso.input.duplicate(true),
		"expected_output": "Custom validation",
		"actual_output": null,
		"passed": false,
		"error": "",
		"time_ms": 0
	}
	
	var tempo_inicio = Time.get_ticks_msec()
	var contexto = _criar_contexto_teste()
	if not contexto.success:
		resultado.error = contexto.error
		return resultado

	var stub = contexto.stub
	var instancia = contexto.instance
	
	# Executa o método se especificado
	var nome_metodo = caso.method
	var retorno_metodo = null
	
	if not nome_metodo.is_empty():
		if not instancia.has_method(nome_metodo):
			resultado.error = "Método '%s()' não encontrado" % nome_metodo
			_limpar_contexto_teste(stub)
			return resultado
		
		var callable_metodo = Callable(instancia, nome_metodo)
		var entrada = resultado.input
		if not entrada is Array:
			entrada = [entrada]
		
		retorno_metodo = callable_metodo.callv(entrada)
	
	resultado.actual_output = retorno_metodo
	
	# Executa validação customizada
	var funcao_validar = caso.validate
	if funcao_validar and instancia_testes:
		var resultado_validacao
		
		# Se for Callable, tenta chamar direto
		if funcao_validar is Callable:
			resultado_validacao = funcao_validar.call(retorno_metodo, instancia)
		# Se for String, chama pelo nome
		elif funcao_validar is String:
			if instancia_testes.has_method(funcao_validar):
				resultado_validacao = instancia_testes.callv(funcao_validar, [retorno_metodo, instancia])
			else:
				resultado.error = "Função de validação '%s' não encontrada" % funcao_validar
		
		if resultado_validacao:
			if resultado_validacao is Dictionary:
				resultado.passed = resultado_validacao.get("success", resultado_validacao.get("sucesso", false))
				resultado.error = resultado_validacao.get("error", resultado_validacao.get("erro", ""))
				if resultado_validacao.has("expected_output"):
					resultado.expected_output = resultado_validacao.expected_output
				elif resultado_validacao.has("saida_esperada"):
					resultado.expected_output = resultado_validacao.saida_esperada
				if resultado_validacao.has("actual_output"):
					resultado.actual_output = resultado_validacao.actual_output
				elif resultado_validacao.has("saida_obtida"):
					resultado.actual_output = resultado_validacao.saida_obtida
			else:
				resultado.passed = resultado_validacao == true
	else:
		resultado.error = "Função de validação não fornecida"
	
	var tempo_fim = Time.get_ticks_msec()
	resultado.time_ms = tempo_fim - tempo_inicio
	_limpar_contexto_teste(stub)
	
	return resultado

func _criar_contexto_teste() -> Dictionary:
	if not script_testado:
		return {
			"success": false,
			"error": "Script do aluno não foi carregado",
			"stub": null,
			"instance": null
		}

	var instancia = script_testado.new()
	if test_config and not test_config.scene_path.is_empty():
		return _criar_contexto_teste_com_cena()
	if not instancia:
		return {
			"success": false,
			"error": "Erro ao criar instância do script do aluno",
			"stub": null,
			"instance": null
		}

	if not instancia is Node:
		_free_if_needed(instancia)
		return {
			"success": false,
			"error": "Testes customizados exigem que o script do aluno herde de Node",
			"stub": null,
			"instance": null
		}

	var stub = Control.new()
	stub.name = "CustomTestStub"
	stub.visible = false
	stub.process_mode = Node.PROCESS_MODE_DISABLED

	var tree = Engine.get_main_loop()
	if not tree is SceneTree:
		_free_if_needed(instancia)
		stub.free()
		return {
			"success": false,
			"error": "SceneTree indisponível para executar stub de teste",
			"stub": null,
			"instance": null
		}

	tree.root.add_child(stub)
	stub.add_child(instancia)

	return {
		"success": true,
		"error": "",
		"stub": stub,
		"instance": instancia
	}

func _criar_contexto_teste_com_cena() -> Dictionary:
	if not FileAccess.file_exists(test_config.scene_path):
		return {
			"success": false,
			"error": "Cena de teste não encontrada: %s" % test_config.scene_path,
			"stub": null,
			"instance": null
		}

	var packed_scene = load(test_config.scene_path)
	if not packed_scene or not packed_scene is PackedScene:
		return {
			"success": false,
			"error": "Falha ao carregar cena de teste: %s" % test_config.scene_path,
			"stub": null,
			"instance": null
		}

	var instancia = packed_scene.instantiate()
	if not instancia or not instancia is Node:
		return {
			"success": false,
			"error": "Cena de teste não gerou um Node válido",
			"stub": null,
			"instance": null
		}

	instancia.set_script(script_testado)
	if instancia.get_script() != script_testado:
		_free_if_needed(instancia)
		return {
			"success": false,
			"error": "Não foi possível substituir o script da cena pelo script do aluno",
			"stub": null,
			"instance": null
		}

	var stub = Control.new()
	stub.name = "CustomTestStub"
	stub.visible = false
	stub.process_mode = Node.PROCESS_MODE_DISABLED

	var tree = Engine.get_main_loop()
	if not tree is SceneTree:
		_free_if_needed(instancia)
		stub.free()
		return {
			"success": false,
			"error": "SceneTree indisponível para executar stub de teste",
			"stub": null,
			"instance": null
		}

	tree.root.add_child(stub)
	stub.add_child(instancia)

	return {
		"success": true,
		"error": "",
		"stub": stub,
		"instance": instancia
	}

func _limpar_contexto_teste(stub: Node) -> void:
	if stub == null:
		return
	if is_instance_valid(stub) and stub.get_parent():
		stub.get_parent().remove_child(stub)
	if is_instance_valid(stub):
		stub.queue_free()

func _free_if_needed(instancia) -> void:
	if instancia == null:
		return
	if instancia is RefCounted:
		return
	instancia.free()
