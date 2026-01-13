@tool
extends VBoxContainer

signal abrir_teste_exercicio(lista: String, exercicio: String)

@onready var listas: VBoxContainer = %Listas
@onready var markdown_pre_processador: Control = %MarkdownPreProcessador
@onready var titulo_label: Label = $Titulo

var diretorio_listas : String = ""
var plugin_reference: FromZeroToGodot = null


func _ready():
	if Engine.is_editor_hint():
		diretorio_listas = FromZeroToGodot.get_localized_exercises_path()
	else:
		diretorio_listas = FromZeroToGodot.get_localized_exercises_path()
	
	# Atualiza traduções
	_atualizar_traducoes()
	
	_criar_botoes_listas()

func conectar_signal_locale(plugin: FromZeroToGodot) -> void:
	"""Conecta ao signal de mudança de locale"""
	plugin_reference = plugin
	if plugin and not plugin.locale_changed.is_connected(_on_locale_changed):
		plugin.locale_changed.connect(_on_locale_changed)

func _on_locale_changed(new_locale: String) -> void:
	"""Atualiza UI quando locale muda"""
	_atualizar_traducoes()
	recarregar_listas()

func _atualizar_traducoes() -> void:
	"""Atualiza textos da interface"""
	var locale = FromZeroToGodot.get_locale()
	
	if titulo_label:
		titulo_label.text = TranslationHelper.translate("Escolha uma lista", locale)

func recarregar_listas() -> void:
	"""Recarrega listas após mudança de locale"""
	diretorio_listas = FromZeroToGodot.get_localized_exercises_path()
	_criar_botoes_listas()

func _criar_botoes_listas():
	if diretorio_listas.is_empty():
		push_warning("Diretório de listas não configurado")
		return
	
	# Limpa botões existentes
	for child in listas.get_children():
		child.queue_free()

	# Verifica se o diretório existe
	if not DirAccess.dir_exists_absolute(diretorio_listas):
		var label = Label.new()
		label.text = "Exercise lists not available for this language yet.\nDirectory: %s" % diretorio_listas
		label.add_theme_color_override("font_color", Color.ORANGE)
		listas.add_child(label)
		return

	# Lê as pastas do diretório
	var dir = DirAccess.open(diretorio_listas)
	if not dir:
		push_error("Não foi possível abrir o diretório: %s" % diretorio_listas)
		return
	
	dir.list_dir_begin()
	var nome_pasta = dir.get_next()
	
	while nome_pasta != "":
		if dir.current_is_dir() and not nome_pasta.begins_with("."):
			_criar_botao_para_lista(nome_pasta)
		nome_pasta = dir.get_next()
	
	dir.list_dir_end()

func _criar_botao_para_lista(nome_pasta: String):
	var botao = Button.new()
	botao.text = nome_pasta
	botao.pressed.connect(_carregar_markdown.bind(nome_pasta))
	listas.add_child(botao)

func _carregar_markdown(nome_pasta: String):
	var caminho_md = diretorio_listas.path_join(nome_pasta).path_join(nome_pasta + ".md")
	
	if not FileAccess.file_exists(caminho_md):
		push_error("Arquivo não encontrado: %s" % caminho_md)
		return
	
	# Limpa conteúdo anterior do markdown_pre_processador
	for child in markdown_pre_processador.get_children():
		child.queue_free()
	
	# Carrega o novo markdown
	var markdown_instance = markdown_pre_processador.parse_markdown_to_scene(caminho_md)
	
	# Conecta o sinal de abrir teste se ainda não estiver conectado
	if markdown_instance and markdown_pre_processador.has_signal("abrir_teste_solicitado"):
		if not markdown_pre_processador.abrir_teste_solicitado.is_connected(_on_abrir_teste_solicitado):
			markdown_pre_processador.abrir_teste_solicitado.connect(_on_abrir_teste_solicitado)

func _on_abrir_teste_solicitado(lista: String, exercicio: String) -> void:
	abrir_teste_exercicio.emit(lista, exercicio)
