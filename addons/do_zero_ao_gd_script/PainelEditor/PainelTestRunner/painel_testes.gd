@tool
class_name PainelTestes
extends Control

@onready var lista_de_exercicios: ItemList = %ListaDeExercicios
@onready var escolha_exercicio_button: Button = %EscolhaExercicioButton
@onready var exercicio_escolhido_line_edit: LineEdit = %ExercicioEscolhidoLineEdit
@onready var detalhes_exercicio_atual: RichTextLabel = %DetalhesExercicioAtual
@onready var resultado_teste: RichTextLabel = %ResultadoTeste
@onready var progresso_testes: ProgressBar = %ProgressoTestes
@onready var achar_questao: LineEdit = %AcharQuestao
@onready var executar_teste_atual: Button = %ExecutarTesteAtual
@onready var resultado_label: Label = %ResultadosTestes

var plugin_reference: FromZeroToGodot = null

# FileDialog - pode ser EditorFileDialog (no editor) ou FileDialog (fora do editor)
var file_dialog: Window = null

# Dados
var runner: RefCounted  # Será TestRunnerFuncao, TestRunnerClasse ou TestRunnerCena
var todos_exercicios: Array[Dictionary] = []  # {nome, caminho_tests, lista, exercicio, funcao, tipo}
var exercicios_filtrados: Array[Dictionary] = []
var exercicio_selecionado: Dictionary = {}
var script_carregado: GDScript = null

var diretorio_listas : String = ""

func _ready():
	diretorio_listas = FromZeroToGodot.get_localized_exercises_path()
	# Runner será criado dinamicamente baseado no tipo do teste
	runner = null
	
	# Se não estiver no editor, cria FileDialog nativo
	if not Engine.is_editor_hint():
		_criar_file_dialog_nativo()
	
	# Conecta sinais da UI
	if escolha_exercicio_button:
		escolha_exercicio_button.pressed.connect(_on_escolha_exercicio_pressed)
	if executar_teste_atual:
		executar_teste_atual.pressed.connect(_on_executar_teste_pressed)
	if lista_de_exercicios:
		lista_de_exercicios.item_selected.connect(_on_exercicio_item_selecionado)
	if achar_questao:
		achar_questao.text_changed.connect(_on_filtro_texto_mudado)
	
	# Atualiza traduções
	_atualizar_traducoes()
	
	# Carrega todos os exercícios
	_carregar_todos_exercicios()

func conectar_signal_locale(plugin: FromZeroToGodot) -> void:
	"""Conecta ao signal de mudança de locale"""
	plugin_reference = plugin
	if plugin and not plugin.locale_changed.is_connected(_on_locale_changed):
		plugin.locale_changed.connect(_on_locale_changed)

func _on_locale_changed(new_locale: String) -> void:
	"""Atualiza UI quando locale muda"""
	_atualizar_traducoes()
	recarregar_todos_exercicios()

func _atualizar_traducoes() -> void:
	"""Atualiza todos os textos da interface"""
	var locale = FromZeroToGodot.get_locale()
	
	if achar_questao:
		achar_questao.placeholder_text = TranslationHelper.translate("Digite qual questão você quer testar", locale)
	
	if escolha_exercicio_button:
		escolha_exercicio_button.text = TranslationHelper.translate("Escolha o script", locale)
	
	if executar_teste_atual:
		executar_teste_atual.text = TranslationHelper.translate("Executar testes", locale)
	
	if resultado_label:
		resultado_label.text = TranslationHelper.translate("Resultado dos Testes", locale)

func recarregar_todos_exercicios() -> void:
	"""Recarrega todos exercícios após mudança de locale"""
	diretorio_listas = FromZeroToGodot.get_localized_exercises_path()
	_carregar_todos_exercicios()

func _carregar_todos_exercicios() -> void:
	todos_exercicios.clear()

	# Verifica se o diretório existe
	if not DirAccess.dir_exists_absolute(diretorio_listas):
		push_warning("Exercises directory not available for this language: %s" % diretorio_listas)
		_atualizar_lista_ui()
		return

	var dir = DirAccess.open(diretorio_listas)
	
	if not dir:
		push_error("Could not open directory: %s" % diretorio_listas)
		return
	
	dir.list_dir_begin()
	var nome_pasta = dir.get_next()
	
	while nome_pasta != "":
		if dir.current_is_dir() and (nome_pasta.begins_with("List") or nome_pasta.begins_with("Lista")):
			_carregar_exercicios_da_lista(diretorio_listas.path_join(nome_pasta), nome_pasta)
		nome_pasta = dir.get_next()
	
	dir.list_dir_end()
	
	# Inicializa lista filtrada
	exercicios_filtrados = todos_exercicios.duplicate()
	_atualizar_lista_ui()

func _carregar_exercicios_da_lista(caminho_lista: String, nome_lista: String) -> void:
	var dir = DirAccess.open(caminho_lista)
	if not dir:
		return
	
	dir.list_dir_begin()
	var nome_pasta = dir.get_next()
	
	while nome_pasta != "":
		if dir.current_is_dir() and (nome_pasta.begins_with("Exercise") or nome_pasta.begins_with("Exercicio")):
			# Prefer tests_config.json if it exists, otherwise use tests.json
			var caminho_config = caminho_lista.path_join(nome_pasta).path_join("tests_config.json")
			var caminho_tests = caminho_lista.path_join(nome_pasta).path_join("tests.json")
			var caminho_usar = caminho_config if FileAccess.file_exists(caminho_config) else caminho_tests
			
			if FileAccess.file_exists(caminho_usar):
				# Lê o arquivo de configuração
				var file = FileAccess.open(caminho_usar, FileAccess.READ)
				if file:
					var json_string = file.get_as_text()
					file.close()
					
					var json = JSON.new()
					var parse_result = json.parse(json_string)
					
					if parse_result == OK:
						var dados = json.data
					var nome_funcao = dados.get("function", dados.get("class", "unknown"))
					var tipo_teste = dados.get("type", "function")  # Default: function
					var arquivo_testes_custom = dados.get("test_file", "")
							"nome": "%s - %s" % [nome_lista, nome_pasta],
							"caminho_tests": arquivo_testes_custom if not arquivo_testes_custom.is_empty() else caminho_usar,
							"lista": nome_lista,
							"exercicio": nome_pasta,
							"funcao": nome_funcao,
							"tipo": tipo_teste
						}
						todos_exercicios.append(exercicio_info)
		
		nome_pasta = dir.get_next()
	
	dir.list_dir_end()

func _atualizar_lista_ui() -> void:
	if not lista_de_exercicios:
		return
	
	lista_de_exercicios.clear()
	
	for ex in exercicios_filtrados:
		lista_de_exercicios.add_item(ex.nome)

func _on_filtro_texto_mudado(texto: String) -> void:
	if texto.is_empty():
		exercicios_filtrados = todos_exercicios.duplicate()
	else:
		exercicios_filtrados.clear()
		var texto_lower = texto.to_lower()
		
		for ex in todos_exercicios:
			if texto_lower in ex.nome.to_lower():
				exercicios_filtrados.append(ex)
	
	_atualizar_lista_ui()

func _on_exercicio_item_selecionado(index: int) -> void:
	if index < 0 or index >= exercicios_filtrados.size():
		return
	
	exercicio_selecionado = exercicios_filtrados[index]
	_atualizar_detalhes_exercicio()
	_limpar_resultado()

func _atualizar_detalhes_exercicio() -> void:
	if not detalhes_exercicio_atual or exercicio_selecionado.is_empty():
		return
	
	var tipo_teste = exercicio_selecionado.get("tipo", "funcao")
	var dados
	
	# Para classe_custom, carrega o script e obtém casos
	if tipo_teste == "classe_custom":
		var script_testes = load(exercicio_selecionado.caminho_tests)
		if not script_testes:
			detalhes_exercicio_atual.text = "[color=red]Error loading test script[/color]"
			return
		
		var instancia_testes = script_testes.new()
		if not instancia_testes.has_method("get_test_cases"):
			detalhes_exercicio_atual.text = "[color=red]Script does not have method get_test_cases()[/color]"
			instancia_testes.free()
			return
		
		var casos = instancia_testes.get_test_cases()
		instancia_testes.free()
		
		# Monta dados no formato esperado
		dados = {
			"tipo": "classe_custom",
			"classe": exercicio_selecionado.funcao,
			"timeout": 1000,
			"casos": casos
		}
	else:
		# Para outros tipos, lê JSON normalmente
		var file = FileAccess.open(exercicio_selecionado.caminho_tests, FileAccess.READ)
		if not file:
			detalhes_exercicio_atual.text = "[color=red]Error reading test file[/color]"
			return
		
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result != OK:
			detalhes_exercicio_atual.text = "[color=red]Error parsing JSON[/color]"
			return
		
		dados = json.data
	
	var locale = FromZeroToGodot.get_locale()
	
	# Formata informações
	var texto = "[b]%s[/b] %s\n\n" % [TranslationHelper.translate("Exercício:", locale), exercicio_selecionado.nome]
	
	# Exibe nome da função ou classe
	if tipo_teste == "classe" or tipo_teste == "classe_custom":
		texto += "[b]%s[/b] %s\n\n" % [TranslationHelper.translate("Classe:", locale), dados.get("class", "?")]
		if tipo_teste == "classe_custom":
			texto += "[b]%s[/b] %s\n\n" % [TranslationHelper.translate("Tipo:", locale), TranslationHelper.translate("Testes customizados (por código)", locale)]
	else:
		texto += "[b]%s[/b] %s()\n\n" % [TranslationHelper.translate("Função:", locale), dados.get("function", "?")]
	
	texto += "[b]%s[/b] %dms\n\n" % [TranslationHelper.translate("Timeout:", locale), dados.get("timeout", 1000)]
	
	# Comparison information (if applicable)
	if dados.has("comparison"):
		texto += "[b]Comparação:[/b] %s" % dados.get("comparison", "exact")
		if dados.get("comparison", "") == "approximate":
			texto += " (tolerância: %.4f)" % dados.get("tolerance", 0.01)
		texto += "\n\n"
	
	# Conta casos de teste baseado no tipo
	var total_casos = 0
	var casos_para_exibir = []
	
	if tipo_teste == "classe":
		# For class, sum cases from all methods
		var metodos = dados.get("methods", [])
		for metodo in metodos:
			var casos = metodo.get("cases", [])
			total_casos += casos.size()
			for caso in casos:
				casos_para_exibir.append(caso.get("name", "Test without name"))
	else:
		# For function and scene, direct cases
		var casos = dados.get("cases", [])
		total_casos = casos.size()
		for caso in casos:
			casos_para_exibir.append(caso.get("name", "Test without name"))
	
	texto += "[b]Casos de teste:[/b] %d\n\n" % total_casos
	
	# Lista alguns casos
	var max_casos = min(3, casos_para_exibir.size())
	for i in range(max_casos):
		texto += "• %s\n" % casos_para_exibir[i]
	
	if casos_para_exibir.size() > max_casos:
		texto += "• ... e mais %d casos\n" % (casos_para_exibir.size() - max_casos)
	
	detalhes_exercicio_atual.text = texto

func _on_escolha_exercicio_pressed() -> void:
	if file_dialog:
		file_dialog.popup_centered(Vector2i(800, 600))

func configurar_file_dialog(dialog: EditorFileDialog) -> void:
	file_dialog = dialog
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	file_dialog.add_filter("*.gd", "GDScript")
	file_dialog.file_selected.connect(_on_arquivo_selecionado)

func _criar_file_dialog_nativo() -> void:
	# Cria FileDialog para uso fora do editor
	var dialog = FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.access = FileDialog.ACCESS_RESOURCES
	dialog.add_filter("*.gd", "GDScript")
	dialog.size = Vector2i(800, 600)
	dialog.file_selected.connect(_on_arquivo_selecionado)
	add_child(dialog)
	file_dialog = dialog

func _on_arquivo_selecionado(caminho: String) -> void:
	if exercicio_selecionado.is_empty():
		push_error("No exercise selected")
		return
	
	# Carrega o script
	var script = load(caminho)
	if not script or not script is GDScript:
		_exibir_erro("Selected file is not a valid GDScript")
		return
	
	# Valida baseado no tipo de teste
	var tipo_teste = exercicio_selecionado.get("tipo", "funcao")
	var nome_alvo = exercicio_selecionado.funcao
	
	if tipo_teste == "classe":
		# Para testes de classe, verifica se a classe existe
		var classe_encontrada = false
		
		# Tenta acessar como classe direta
		if script.has_method("new"):
			var instancia_temp = script.new()
			# Verifica se é a classe ou se tem a classe interna
			if instancia_temp.get_class() == nome_alvo:
				classe_encontrada = true
			elif nome_alvo in script:
				classe_encontrada = true
			elif instancia_temp.get(nome_alvo) != null:
				classe_encontrada = true
			elif nome_alvo in script.get_script_constant_map():
				classe_encontrada = true
			instancia_temp.free()
		
		if not classe_encontrada:
			_exibir_erro("Script does not contain class '%s'" % nome_alvo)
			return
	elif tipo_teste == "funcao":
		# For function tests, check if function exists
		var instancia_temp = script.new()
		if not instancia_temp.has_method(nome_alvo):
			instancia_temp.free()
			_exibir_erro("Script does not contain function '%s()'" % nome_alvo)
			return
		instancia_temp.free()
	# Para tipo "cena" e "classe_custom", não validamos aqui
	
	# Script válido!
	script_carregado = script
	exercicio_escolhido_line_edit.text = caminho
	exercicio_escolhido_line_edit.add_theme_color_override("font_color", Color.GREEN)

func _limpar_exercicio_escolhido() -> void:
	exercicio_escolhido_line_edit.text = ""

func _exibir_erro(mensagem: String) -> void:
	if exercicio_escolhido_line_edit:
		exercicio_escolhido_line_edit.text = mensagem
		exercicio_escolhido_line_edit.add_theme_color_override("font_color", Color.RED)
	push_error(mensagem)

func _on_executar_teste_pressed() -> void:
	if exercicio_selecionado.is_empty():
		_exibir_resultado_erro("Select an exercise first")
		return
	
	if not script_carregado:
		_exibir_resultado_erro("Select a valid script first")
		return
	
	# Limpa resultado anterior
	_limpar_resultado()
	
	# Cria o runner apropriado baseado no tipo do teste
	var tipo_teste = exercicio_selecionado.get("tipo", "funcao")
	
	# Libera runner anterior se existir
	if runner:
		if runner.teste_iniciado.is_connected(_on_teste_iniciado):
			runner.teste_iniciado.disconnect(_on_teste_iniciado)
		if runner.teste_concluido.is_connected(_on_teste_concluido):
			runner.teste_concluido.disconnect(_on_teste_concluido)
		if runner.todos_testes_concluidos.is_connected(_on_todos_testes_concluidos):
			runner.todos_testes_concluidos.disconnect(_on_todos_testes_concluidos)
		runner = null
	
	# Cria novo runner do tipo apropriado
	match tipo_teste:
		"funcao":
			var script_runner = load("res://addons/do_zero_ao_gd_script/TestRunner/TestRunnerFuncao.gd")
			runner = script_runner.new()
		"classe":
			var script_runner = load("res://addons/do_zero_ao_gd_script/TestRunner/TestRunnerClasse.gd")
			runner = script_runner.new()
		"classe_custom":
			var script_runner = load("res://addons/do_zero_ao_gd_script/TestRunner/TestRunnerClasseCustom.gd")
			runner = script_runner.new()
		"cena":
			var script_runner = load("res://addons/do_zero_ao_gd_script/TestRunner/TestRunnerCena.gd")
			runner = script_runner.new()
			# Para testes de cena, tenta carregar a .tscn em vez do script
			var caminho_cena = exercicio_escolhido_line_edit.text.replace(".gd", ".tscn")
			if FileAccess.file_exists(caminho_cena):
				runner.cena_path = caminho_cena
		_:
			_exibir_resultado_erro("Unknown test type: %s" % tipo_teste)
			return
	
	# Conecta sinais
	runner.teste_iniciado.connect(_on_teste_iniciado)
	runner.teste_concluido.connect(_on_teste_concluido)
	runner.todos_testes_concluidos.connect(_on_todos_testes_concluidos)
	
	# Desabilita botão durante execução
	if executar_teste_atual:
		executar_teste_atual.disabled = true
	
	# Executa testes
	runner.executar_testes(script_carregado, exercicio_selecionado.caminho_tests)

func _limpar_resultado() -> void:
	if resultado_teste:
		resultado_teste.text = ""
	if progresso_testes:
		progresso_testes.value = 0
	_limpar_exercicio_escolhido()

func _exibir_resultado_erro(mensagem: String) -> void:
	if resultado_teste:
		resultado_teste.text = "[color=red][b]Erro:[/b] %s[/color]" % mensagem

func _on_teste_iniciado(index: int, total: int) -> void:
	if progresso_testes:
		progresso_testes.max_value = total
		progresso_testes.value = index - 1

func _on_teste_concluido(resultado: Dictionary) -> void:
	_adicionar_resultado_ao_texto(resultado)
	
	if progresso_testes:
		progresso_testes.value += 1

func _on_todos_testes_concluidos(resumo: Dictionary) -> void:
	# Reabilita botão
	if executar_teste_atual:
		executar_teste_atual.disabled = false
	
	# Adiciona resumo ao resultado
	if resultado_teste:
		var cor = Color.GREEN if resumo.percentual >= 70 else Color.ORANGE if resumo.percentual >= 50 else Color.RED
		var cor_hex = cor.to_html(false)
		
		resultado_teste.text += "\n[center][bgcolor=#%s][b]═══════════════════════════[/b][/bgcolor][/center]\n\n" % cor_hex
		resultado_teste.text += "[center][b]RESUMO DOS TESTES[/b][/center]\n\n"
		resultado_teste.text += "[b]Total:[/b] %d testes\n" % resumo.total
		resultado_teste.text += "[color=green][b]Passou:[/b] %d[/color]\n" % resumo.passou
		resultado_teste.text += "[color=red][b]Falhou:[/b] %d[/color]\n\n" % resumo.falhou
		resultado_teste.text += "[b]Percentual:[/b] [color=#%s]%.1f%%[/color]\n\n" % [cor_hex, resumo.percentual]
		resultado_teste.text += "[b]Tempo total:[/b] %dms\n" % resumo.tempo_total_ms
		resultado_teste.text += "[b]Tempo médio:[/b] %.1fms\n" % resumo.tempo_medio_ms

func _adicionar_resultado_ao_texto(resultado: Dictionary) -> void:
	if not resultado_teste:
		return
	
	var cor = "green" if resultado.passou else "red"
	var icone = "✅" if resultado.passou else "❌"
	
	var locale = FromZeroToGodot.get_locale()
	
	resultado_teste.text += "[bgcolor=#333333]%s [b]%s[/b] (%dms)[/bgcolor]\n" % [icone, resultado.nome, resultado.tempo_ms]
	resultado_teste.text += "[b]%s[/b] %s\n" % [TranslationHelper.translate("Entrada:", locale), str(resultado.entrada)]
	resultado_teste.text += "[b]%s[/b] %s\n" % [TranslationHelper.translate("Esperado:", locale), str(resultado.saida_esperada)]
	resultado_teste.text += "[b]%s[/b] [color=%s]%s[/color]\n" % [TranslationHelper.translate("Obtido:", locale), cor, str(resultado.saida_obtida)]
	
	if not resultado.erro.is_empty():
		resultado_teste.text += "[color=orange][b]Erro:[/b] %s[/color]\n" % resultado.erro
	
	resultado_teste.text += "\n"

func selecionar_exercicio(lista: String, exercicio: String) -> void:
	# Busca o exercício correspondente na lista filtrada
	var nome_busca = lista + " - " + exercicio
	
	for i in range(exercicios_filtrados.size()):
		var ex = exercicios_filtrados[i]
		if ex.nome == nome_busca:
			# Seleciona o item no ItemList
			if lista_de_exercicios:
				lista_de_exercicios.select(i)
				lista_de_exercicios.ensure_current_is_visible()
				_on_exercicio_item_selecionado(i)
			return
	
	print("Exercise not found: %s" % nome_busca)
