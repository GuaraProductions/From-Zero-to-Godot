@tool
extends VBoxContainer

signal abrir_teste_exercicio(lista: String, exercicio: String)

@onready var listas: VBoxContainer = %Listas
@onready var markdown_pre_processador: Control = %MarkdownPreProcessador

var diretorio_listas : String = ""


func _ready():
	if Engine.is_editor_hint():
		diretorio_listas = ProjectSettings.get_setting(DoZeroAoGDScript.SETTING_CAMINHO_LISTAS)
	else:
		diretorio_listas = "res://listas/"
	_criar_botoes_listas()

func _criar_botoes_listas():
	if diretorio_listas.is_empty():
		push_warning("Diretório de listas não configurado")
		return
	
	# Limpa botões existentes
	for child in listas.get_children():
		child.queue_free()

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
