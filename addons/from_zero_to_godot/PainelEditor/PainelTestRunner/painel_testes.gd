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

# FileDialog - can be EditorFileDialog (in editor) or FileDialog (outside editor)
var file_dialog: Window = null

# Data
var runner: RefCounted  # Will be TestRunnerFuncao, TestRunnerClasse or TestRunnerCena
var todos_exercicios: Array[Dictionary] = []  # {nome, caminho_tests, lista, exercicio, funcao, tipo}
var exercicios_filtrados: Array[Dictionary] = []
var exercicio_selecionado: Dictionary = {}
var script_carregado: GDScript = null

var diretorio_listas : String = ""

func _ready():
	diretorio_listas = FromZeroToGodot.get_localized_exercises_path()
	# Runner will be created dynamically based on test type
	runner = null
	
	# If not in editor, create native FileDialog
	if not Engine.is_editor_hint():
		_criar_file_dialog_nativo()
	
	# Connect UI signals
	if escolha_exercicio_button:
		escolha_exercicio_button.pressed.connect(_on_escolha_exercicio_pressed)
	if executar_teste_atual:
		executar_teste_atual.pressed.connect(_on_executar_teste_pressed)
	if lista_de_exercicios:
		lista_de_exercicios.item_selected.connect(_on_exercicio_item_selecionado)
	if achar_questao:
		achar_questao.text_changed.connect(_on_filtro_texto_mudado)
	
	# Update translations
	_atualizar_traducoes()
	
	# Load all exercises
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
	var locale = FromZeroToGodot.get_locale()

	# Check if directory exists
	if not DirAccess.dir_exists_absolute(diretorio_listas):
		push_warning(TranslationHelper.translate("Diretório de exercícios não disponível para este idioma: %s", locale) % diretorio_listas)
		_atualizar_lista_ui()
		return

	var dir = DirAccess.open(diretorio_listas)
	
	if not dir:
		push_error(TranslationHelper.translate("Não foi possível abrir o diretório: %s", locale) % diretorio_listas)
		return
	
	dir.list_dir_begin()
	var nome_pasta = dir.get_next()
	
	while nome_pasta != "":
		if dir.current_is_dir() and (nome_pasta.begins_with("List") or nome_pasta.begins_with("Lista")):
			_carregar_exercicios_da_lista(diretorio_listas.path_join(nome_pasta), nome_pasta)
		nome_pasta = dir.get_next()
	
	dir.list_dir_end()
	
	# Initialize filtered list
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
				var config = TestConfigFactory.load_from_json(caminho_usar)
				if config:
					var exercicio_info = {
						"nome": "%s - %s" % [nome_lista, nome_pasta],
						"caminho_config": caminho_usar,
						"caminho_tests": config.test_file if not config.test_file.is_empty() else caminho_usar,
						"lista": nome_lista,
						"exercicio": nome_pasta,
						"funcao": config.get_target_name(),
						"tipo": config.type
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
	_limpar_exercicio_escolhido()

func _atualizar_detalhes_exercicio() -> void:
	if not detalhes_exercicio_atual or exercicio_selecionado.is_empty():
		return
	
	var tipo_teste = exercicio_selecionado.get("tipo", TestConfigResource.TYPE_FUNCTION)
	var config = TestConfigFactory.load_from_json(exercicio_selecionado.get("caminho_config", exercicio_selecionado.caminho_tests))
	if not config:
		var locale = FromZeroToGodot.get_locale()
		detalhes_exercicio_atual.text = "[color=red]%s[/color]" % TranslationHelper.translate("Erro ao carregar configuração de testes", locale)
		return

	var custom_cases: Array[TestCaseConfig] = []
	if tipo_teste == TestConfigResource.TYPE_CLASS_CUSTOM:
		custom_cases = TestConfigFactory.load_custom_cases(exercicio_selecionado.caminho_tests)
	
	var locale = FromZeroToGodot.get_locale()
	
	# Format information
	var texto = "[b]%s[/b] %s\n\n" % [TranslationHelper.translate("Exercício:", locale), exercicio_selecionado.nome]
	
	# Display function or class name
	if tipo_teste == TestConfigResource.TYPE_CLASS:
		texto += "[b]%s[/b] %s\n\n" % [TranslationHelper.translate("Classe:", locale), config.name_class]
	elif tipo_teste == TestConfigResource.TYPE_CLASS_CUSTOM:
		texto += "[b]%s[/b] %s\n\n" % [TranslationHelper.translate("Tipo:", locale), TranslationHelper.translate("Testes customizados (por código)", locale)]
		texto += "[b]%s[/b] %s\n\n" % [TranslationHelper.translate("Arquivo de teste:", locale), exercicio_selecionado.caminho_tests]
		if not config.scene_path.is_empty():
			texto += "[b]%s[/b] %s\n\n" % [TranslationHelper.translate("Cena base:", locale), config.scene_path]
	elif tipo_teste == TestConfigResource.TYPE_FUNCTION_GROUP:
		texto += "[b]%s[/b] %s\n\n" % [TranslationHelper.translate("Funções:", locale), ", ".join(config.get_function_names())]
	else:
		texto += "[b]%s[/b] %s()\n\n" % [TranslationHelper.translate("Função:", locale), config.function_name]
	
	texto += "[b]%s[/b] %dms\n\n" % [TranslationHelper.translate("Timeout:", locale), config.timeout_ms]
	
	# Comparison information (if applicable)
	if not config.comparison.is_empty():
		var comparison_value = config.comparison
		texto += "[b]%s[/b] %s" % [TranslationHelper.translate("Comparação:", locale), comparison_value]
		if comparison_value == "approximate":
			texto += " (%s %.4f)" % [TranslationHelper.translate("tolerância:", locale), config.tolerance]
		texto += "\n\n"
	
	# Conta casos de teste baseado no tipo
	var total_casos = 0
	var casos_para_exibir = []
	
	if tipo_teste == TestConfigResource.TYPE_CLASS:
		# For class, sum cases from all methods
		for metodo in config.methods:
			total_casos += metodo.cases.size()
			for caso in metodo.cases:
				casos_para_exibir.append(caso.name if not caso.name.is_empty() else TranslationHelper.translate("Teste sem nome", locale))
	elif tipo_teste == TestConfigResource.TYPE_FUNCTION_GROUP:
		for function_config in config.functions:
			total_casos += function_config.cases.size()
			for caso in function_config.cases:
				var case_name = caso.name if not caso.name.is_empty() else TranslationHelper.translate("Teste sem nome", locale)
				casos_para_exibir.append("%s :: %s" % [function_config.function_name, case_name])
	elif tipo_teste == TestConfigResource.TYPE_CLASS_CUSTOM:
		total_casos = custom_cases.size()
		for caso in custom_cases:
			casos_para_exibir.append(caso.name if not caso.name.is_empty() else TranslationHelper.translate("Teste sem nome", locale))
	else:
		# For function and scene, direct cases
		total_casos = config.cases.size()
		for caso in config.cases:
			casos_para_exibir.append(caso.name if not caso.name.is_empty() else TranslationHelper.translate("Teste sem nome", locale))
	
	texto += "[b]%s[/b] %d\n\n" % [TranslationHelper.translate("Casos de teste:", locale), total_casos]
	
	# List some test cases
	var max_casos = min(3, casos_para_exibir.size())
	for i in range(max_casos):
		texto += "• %s\n" % casos_para_exibir[i]
	
	if casos_para_exibir.size() > max_casos:
		texto += "• %s\n" % (TranslationHelper.translate("... e mais %d casos", locale) % (casos_para_exibir.size() - max_casos))
	
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
	# Create FileDialog for use outside editor
	var dialog = FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.access = FileDialog.ACCESS_RESOURCES
	dialog.add_filter("*.gd", "GDScript")
	dialog.size = Vector2i(800, 600)
	dialog.file_selected.connect(_on_arquivo_selecionado)
	add_child(dialog)
	file_dialog = dialog

func _on_arquivo_selecionado(caminho: String) -> void:
	var locale = FromZeroToGodot.get_locale()
	if exercicio_selecionado.is_empty():
		push_error(TranslationHelper.translate("Nenhum exercício selecionado", locale))
		return

	var config = TestConfigFactory.load_from_json(exercicio_selecionado.get("caminho_config", exercicio_selecionado.caminho_tests))
	if not config:
		_exibir_erro(TranslationHelper.translate("Erro ao carregar configuração de testes", locale))
		return
	
	# Load the script
	var script = load(caminho)
	if not script or not script is GDScript:
		_exibir_erro(TranslationHelper.translate("O arquivo selecionado não é um GDScript válido", locale))
		return
	
	# Validate based on test type (support both English and Portuguese values)
	var tipo_teste = exercicio_selecionado.get("tipo", TestConfigResource.TYPE_FUNCTION)
	var nome_alvo = exercicio_selecionado.funcao
	
	if tipo_teste == TestConfigResource.TYPE_CLASS:
		# For class tests, verify if class exists
		var classe_encontrada = false
		
		# Try to access as direct class
		if script.has_method("new"):
			var instancia_temp = script.new()
			# Check if it's the class or has inner class
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
			_exibir_erro(TranslationHelper.translate("O script não contém a classe '%s'", locale) % nome_alvo)
			return
	elif tipo_teste == TestConfigResource.TYPE_FUNCTION or tipo_teste == TestConfigResource.TYPE_FUNCTION_GROUP:
		# For function tests, check if function exists
		var instancia_temp = script.new()
		var functions_to_validate: Array[String] = []
		if tipo_teste == TestConfigResource.TYPE_FUNCTION_GROUP:
			functions_to_validate = config.get_function_names()
		else:
			functions_to_validate = [nome_alvo]

		for function_name in functions_to_validate:
			if not instancia_temp.has_method(function_name):
				instancia_temp.free()
				_exibir_erro(TranslationHelper.translate("O script não contém a função '%s()'", locale) % function_name)
				return

		instancia_temp.free()
	# For "cena" and "classe_custom" types, we don't validate here
	
	# Valid script!
	script_carregado = script
	exercicio_escolhido_line_edit.text = caminho
	exercicio_escolhido_line_edit.add_theme_color_override("font_color", Color.GREEN)

func _limpar_exercicio_escolhido() -> void:
	exercicio_escolhido_line_edit.text = ""
	script_carregado = null

func _exibir_erro(mensagem: String) -> void:
	if exercicio_escolhido_line_edit:
		exercicio_escolhido_line_edit.text = mensagem
		exercicio_escolhido_line_edit.add_theme_color_override("font_color", Color.RED)
	push_error(mensagem)

func _on_executar_teste_pressed() -> void:
	var locale = FromZeroToGodot.get_locale()
	if exercicio_selecionado.is_empty():
		_exibir_resultado_erro(TranslationHelper.translate("Selecione um exercício primeiro", locale))
		return
	
	if not script_carregado:
		_exibir_resultado_erro(TranslationHelper.translate("Selecione primeiro um script válido", locale))
		return
	
	# Clear previous result
	_limpar_resultado()
	
	# Create appropriate runner based on test type
	var tipo_teste = exercicio_selecionado.get("tipo", TestConfigResource.TYPE_FUNCTION)
	
	# Free previous runner if it exists
	if runner:
		if runner.teste_iniciado.is_connected(_on_teste_iniciado):
			runner.teste_iniciado.disconnect(_on_teste_iniciado)
		if runner.teste_concluido.is_connected(_on_teste_concluido):
			runner.teste_concluido.disconnect(_on_teste_concluido)
		if runner.todos_testes_concluidos.is_connected(_on_todos_testes_concluidos):
			runner.todos_testes_concluidos.disconnect(_on_todos_testes_concluidos)
		runner = null
	
	runner = TestRunnerFactory.create_runner(tipo_teste)
	if not runner:
		_exibir_resultado_erro(TranslationHelper.translate("Tipo de teste desconhecido ou indisponível: %s", locale) % tipo_teste)
		return

	# For scene tests, try to load .tscn instead of script
	if tipo_teste == TestConfigResource.TYPE_SCENE and "cena_path" in runner:
		var caminho_cena = exercicio_escolhido_line_edit.text.replace(".gd", ".tscn")
		if FileAccess.file_exists(caminho_cena):
			runner.cena_path = caminho_cena
		
	
	# Connect signals
	runner.teste_iniciado.connect(_on_teste_iniciado)
	runner.teste_concluido.connect(_on_teste_concluido)
	runner.todos_testes_concluidos.connect(_on_todos_testes_concluidos)
	
	# Disable button during execution
	if executar_teste_atual:
		executar_teste_atual.disabled = true
	
	# Execute tests
	var caminho_execucao_testes = exercicio_selecionado.caminho_tests
	if tipo_teste == TestConfigResource.TYPE_CLASS_CUSTOM:
		caminho_execucao_testes = exercicio_selecionado.get("caminho_config", exercicio_selecionado.caminho_tests)

	runner.executar_testes(script_carregado, caminho_execucao_testes)

func _limpar_resultado() -> void:
	if resultado_teste:
		resultado_teste.text = ""
	if progresso_testes:
		progresso_testes.value = 0

func _exibir_resultado_erro(mensagem: String) -> void:
	if resultado_teste:
		resultado_teste.text = "[color=red][b]Error:[/b] %s[/color]" % mensagem

func _on_teste_iniciado(index: int, total: int) -> void:
	if progresso_testes:
		progresso_testes.max_value = total
		progresso_testes.value = index - 1

func _on_teste_concluido(resultado: Dictionary) -> void:
	_adicionar_resultado_ao_texto(resultado)
	
	if progresso_testes:
		progresso_testes.value += 1

func _on_todos_testes_concluidos(resumo: Dictionary) -> void:
	# Re-enable button
	if executar_teste_atual:
		executar_teste_atual.disabled = false
	# Add summary to result
	if resultado_teste:
		var cor = Color.GREEN if resumo.percentage >= 70 else Color.ORANGE if resumo.percentage >= 50 else Color.RED
		var cor_hex = cor.to_html(false)
		var locale = FromZeroToGodot.get_locale()
		
		resultado_teste.text += "\n[center][bgcolor=#%s][b]═══════════════════════════[/b][/bgcolor][/center]\n\n" % cor_hex
		resultado_teste.text += "[center][b]%s[/b][/center]\n\n" % TranslationHelper.translate("Resumo dos Testes", locale)
		resultado_teste.text += "[b]%s[/b] %d %s\n" % [TranslationHelper.translate("Total:", locale), resumo.total, TranslationHelper.translate("testes", locale)]
		resultado_teste.text += "[color=green][b]%s[/b] %d[/color]\n" % [TranslationHelper.translate("Aprovados:", locale), resumo.passed]
		resultado_teste.text += "[color=red][b]%s[/b] %d[/color]\n\n" % [TranslationHelper.translate("Falharam:", locale), resumo.failed]
		resultado_teste.text += "[b]%s[/b] [color=#%s]%.1f%%[/color]\n\n" % [TranslationHelper.translate("Percentual:", locale), cor_hex, resumo.percentage]
		resultado_teste.text += "[b]%s[/b] %dms\n" % [TranslationHelper.translate("Tempo total:", locale), resumo.total_time_ms]
		resultado_teste.text += "[b]%s[/b] %.1fms\n" % [TranslationHelper.translate("Tempo médio:", locale), resumo.average_time_ms]

func _adicionar_resultado_ao_texto(resultado: Dictionary) -> void:
	if not resultado_teste:
		return
	
	var cor = "green" if resultado.passed else "red"
	var icone = "✅" if resultado.passed else "❌"
	
	var locale = FromZeroToGodot.get_locale()
	
	resultado_teste.text += "[bgcolor=#333333]%s [b]%s[/b] (%dms)[/bgcolor]\n" % [icone, resultado.name, resultado.time_ms]
	resultado_teste.text += "[b]%s[/b] %s\n" % [TranslationHelper.translate("Entrada:", locale), str(resultado.input)]
	resultado_teste.text += "[b]%s[/b] %s\n" % [TranslationHelper.translate("Esperado:", locale), str(resultado.expected_output)]
	resultado_teste.text += "[b]%s[/b] [color=%s]%s[/color]\n" % [TranslationHelper.translate("Obtido:", locale), cor, str(resultado.actual_output)]
	
	if not resultado.error.is_empty():
		resultado_teste.text += "[color=orange][b]%s[/b] %s[/color]\n" % [TranslationHelper.translate("Erro:", locale), resultado.error]
	
	resultado_teste.text += "\n"

func selecionar_exercicio(lista: String, exercicio: String) -> void:
	# Search for corresponding exercise in filtered list
	var nome_busca = lista + " - " + exercicio
	
	for i in range(exercicios_filtrados.size()):
		var ex = exercicios_filtrados[i]
		if ex.nome == nome_busca:
			# Select item in ItemList
			if lista_de_exercicios:
				lista_de_exercicios.select(i)
				lista_de_exercicios.ensure_current_is_visible()
				_on_exercicio_item_selecionado(i)
			return
	
	print("Exercise not found: %s" % nome_busca)
