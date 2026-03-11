extends Node

func get_test_cases() -> Array[Dictionary]:
	return _build_test_cases()

func get_casos_teste() -> Array[Dictionary]:
	return _build_test_cases()

func _build_test_cases() -> Array[Dictionary]:
	return [
		_make_case("Estrutura da tabuada com n=3", "validar_hierarquia_n3"),
		_make_case("Textos da tabuada com n=3", "validar_textos_n3"),
		_make_case("Divisao agrupada corretamente com n=1", "validar_divisao_n1")
	]

func _make_case(nome_teste: String, nome_validacao: String) -> Dictionary:
	return {
		"name": nome_teste,
		"nome": nome_teste,
		"method": "",
		"metodo": "",
		"constructor_params": [],
		"construtor_params": [],
		"input": [],
		"entrada": [],
		"validate": nome_validacao,
		"validar": nome_validacao
	}

func validar_hierarquia_n3(resultado, instancia) -> Dictionary:
	var ambiente = _preparar_ambiente_teste(instancia)
	instancia.generate_times_table(3)

	var erros = []
	erros.append_array(_validar_hierarquia_container(ambiente.adicao, 3, "Adicao"))
	erros.append_array(_validar_hierarquia_container(ambiente.subtracao, 3, "Subtracao"))
	erros.append_array(_validar_hierarquia_container(ambiente.multiplicacao, 3, "Multiplicacao"))
	erros.append_array(_validar_hierarquia_container(ambiente.divisao, 3, "Divisao"))

	if not erros.is_empty():
		return _falha("A hierarquia dos containers nao corresponde a tabuada esperada.", "Triplets VSeparator/VBoxContainer/VSeparator por grupo", "\n".join(erros))

	return _sucesso("Hierarquia da scene tree organizada corretamente para n=3")

func validar_textos_n3(resultado, instancia) -> Dictionary:
	var ambiente = _preparar_ambiente_teste(instancia)
	instancia.generate_times_table(3)

	var erros = []
	erros.append_array(_validar_textos_container(ambiente.adicao, "+", 3, "Adicao"))
	erros.append_array(_validar_textos_container(ambiente.subtracao, "-", 3, "Subtracao"))
	erros.append_array(_validar_textos_container(ambiente.multiplicacao, "*", 3, "Multiplicacao"))
	erros.append_array(_validar_textos_container(ambiente.divisao, "/", 3, "Divisao"))

	if not erros.is_empty():
		return _falha("Os textos gerados pela tabuada nao correspondem ao esperado.", "Expressoes corretas de 1 a 10 para n=3", "\n".join(erros))

	return _sucesso("Textos da tabuada corretos para n=3")

func validar_divisao_n1(resultado, instancia) -> Dictionary:
	var ambiente = _preparar_ambiente_teste(instancia)
	instancia.generate_times_table(1)

	var erros = _validar_hierarquia_container(ambiente.divisao, 1, "Divisao")
	erros.append_array(_validar_textos_container(ambiente.divisao, "/", 1, "Divisao"))

	if not erros.is_empty():
		return _falha("A organizacao da divisao para n=1 esta incorreta.", "10 grupos de divisao com 1 label cada", "\n".join(erros))

	return _sucesso("Divisao agrupada corretamente para n=1")

func _preparar_ambiente_teste(instancia) -> Dictionary:
	var painel = PanelContainer.new()
	painel.name = "TabuadaPanel"

	var scroll = ScrollContainer.new()
	scroll.name = "Scroll"
	painel.add_child(scroll)

	var grid = VBoxContainer.new()
	grid.name = "TabuadaGrid"
	scroll.add_child(grid)

	var adicao = HFlowContainer.new()
	adicao.name = "AdicaoFlowContainer"
	var subtracao = HFlowContainer.new()
	subtracao.name = "SubtracaoFlowContainer"
	var multiplicacao = HFlowContainer.new()
	multiplicacao.name = "MultiplicacaoFlowContainer"
	var divisao = HFlowContainer.new()
	divisao.name = "DivisaoFlowContainer"

	grid.add_child(_criar_label_titulo("Adicao"))
	grid.add_child(adicao)
	grid.add_child(_criar_label_titulo("Subtracao"))
	grid.add_child(subtracao)
	grid.add_child(_criar_label_titulo("Multiplicacao"))
	grid.add_child(multiplicacao)
	grid.add_child(_criar_label_titulo("Divisao"))
	grid.add_child(divisao)

	instancia.add_child(painel)

	_atribuir_se_existir(instancia, "tabuada_panel", painel)
	_atribuir_se_existir(instancia, "times_table_panel", painel)
	_atribuir_se_existir(instancia, "tabuada", grid)
	_atribuir_se_existir(instancia, "times_table", grid)
	_atribuir_se_existir(instancia, "adicao_flow_container", adicao)
	_atribuir_se_existir(instancia, "addition_flow_container", adicao)
	_atribuir_se_existir(instancia, "subtracao_flow_container", subtracao)
	_atribuir_se_existir(instancia, "subtraction_flow_container", subtracao)
	_atribuir_se_existir(instancia, "multiplicacao_flow_container", multiplicacao)
	_atribuir_se_existir(instancia, "multiplication_flow_container", multiplicacao)
	_atribuir_se_existir(instancia, "divisao_flow_container", divisao)
	_atribuir_se_existir(instancia, "division_flow_container", divisao)

	return {
		"painel": painel,
		"grid": grid,
		"adicao": adicao,
		"subtracao": subtracao,
		"multiplicacao": multiplicacao,
		"divisao": divisao
	}

func _criar_label_titulo(texto: String) -> Label:
	var label = Label.new()
	label.text = texto
	return label

func _atribuir_se_existir(objeto: Object, propriedade: String, valor) -> void:
	for item in objeto.get_property_list():
		if item.name == propriedade:
			objeto.set(propriedade, valor)
			return

func _validar_hierarquia_container(container: HFlowContainer, n: int, nome_operacao: String) -> Array[String]:
	var erros: Array[String] = []
	var filhos = container.get_children()
	var total_esperado = 10 * 3

	if filhos.size() != total_esperado:
		erros.append("%s: esperado %d filhos no HFlowContainer, obtido %d" % [nome_operacao, total_esperado, filhos.size()])
		return erros

	for indice_grupo in range(10):
		var base = indice_grupo * 3
		var primeiro = filhos[base]
		var centro = filhos[base + 1]
		var ultimo = filhos[base + 2]
		var nome_grupo = str(indice_grupo + 1)

		if not primeiro is VSeparator:
			erros.append("%s grupo %s: primeiro filho deveria ser VSeparator" % [nome_operacao, nome_grupo])
		if not centro is VBoxContainer:
			erros.append("%s grupo %s: segundo filho deveria ser VBoxContainer" % [nome_operacao, nome_grupo])
		if not ultimo is VSeparator:
			erros.append("%s grupo %s: terceiro filho deveria ser VSeparator" % [nome_operacao, nome_grupo])

		if not centro is VBoxContainer:
			continue

		if centro.name != nome_grupo:
			erros.append("%s grupo %s: nome do VBoxContainer incorreto (%s)" % [nome_operacao, nome_grupo, centro.name])

		var labels = centro.get_children()
		if labels.size() != n:
			erros.append("%s grupo %s: esperado %d labels, obtido %d" % [nome_operacao, nome_grupo, n, labels.size()])
			continue

		for label in labels:
			if not label is Label:
				erros.append("%s grupo %s: todos os filhos do VBoxContainer devem ser Label" % [nome_operacao, nome_grupo])
				break

	return erros

func _validar_textos_container(container: HFlowContainer, operacao: String, n: int, nome_operacao: String) -> Array[String]:
	var erros: Array[String] = []

	for indice_grupo in range(10):
		var nome_grupo = str(indice_grupo + 1)
		var vbox = container.get_node_or_null(nome_grupo)
		if not vbox or not vbox is VBoxContainer:
			erros.append("%s: VBoxContainer %s nao encontrado" % [nome_operacao, nome_grupo])
			continue

		var textos_obtidos: Array[String] = []
		for child in vbox.get_children():
			if child is Label:
				textos_obtidos.append(child.text)

		var textos_esperados = _gerar_textos_esperados(indice_grupo + 1, operacao, n)
		if textos_obtidos != textos_esperados:
			erros.append("%s grupo %s: esperado %s, obtido %s" % [nome_operacao, nome_grupo, str(textos_esperados), str(textos_obtidos)])

	return erros

func _gerar_textos_esperados(grupo: int, operacao: String, n: int) -> Array[String]:
	var textos: Array[String] = []

	for j in range(1, n + 1):
		match operacao:
			"+":
				textos.append("%d + %d = %d" % [grupo, j, grupo + j])
			"-":
				textos.append("%d - %d = %d" % [grupo, j, grupo - j])
			"*":
				textos.append("%d * %d = %d" % [grupo, j, grupo * j])
			"/":
				textos.append("%d / %d = %d" % [grupo * j, grupo, j])

	return textos

func _sucesso(mensagem: String) -> Dictionary:
	return {
		"success": true,
		"error": "",
		"expected_output": mensagem,
		"actual_output": mensagem,
		"sucesso": true,
		"erro": "",
		"saida_esperada": mensagem,
		"saida_obtida": mensagem
	}

func _falha(mensagem: String, esperado, obtido) -> Dictionary:
	return {
		"success": false,
		"error": mensagem,
		"expected_output": esperado,
		"actual_output": obtido,
		"sucesso": false,
		"erro": mensagem,
		"saida_esperada": esperado,
		"saida_obtida": obtido
	}
