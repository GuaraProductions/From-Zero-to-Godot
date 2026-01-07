@tool
extends MarginContainer

@onready var ebooks_disponiveis: VBoxContainer = %EbooksDisponiveis
@onready var pre_visualizacao_ebook: MarkdownPreProcessador = %PreVisualizacaoEbook

var diretorio_ebooks: String = ""
var ebook_selecionado: String = ""
var capitulo_selecionado: String = ""

func _ready() -> void:
	if Engine.is_editor_hint():
		diretorio_ebooks = DoZeroAoGDScript.obter_caminho_ebooks()
	else:
		diretorio_ebooks = "res://ebook/"
	_carregar_ebooks()

## Carrega todos os ebooks disponíveis e cria a interface de navegação
func _carregar_ebooks() -> void:
	if diretorio_ebooks.is_empty():
		push_warning("Diretório de ebooks não configurado")
		return
	
	# Limpa interface existente
	for child in ebooks_disponiveis.get_children():
		child.queue_free()
	
	# Verifica se o diretório existe
	var dir = DirAccess.open(diretorio_ebooks)
	if not dir:
		push_error("Não foi possível abrir o diretório: %s" % diretorio_ebooks)
		return
	
	# Lista todos os ebooks (pastas)
	dir.list_dir_begin()
	var nome_pasta = dir.get_next()
	
	while nome_pasta != "":
		if dir.current_is_dir() and not nome_pasta.begins_with("."):
			_criar_botao_ebook(nome_pasta)
		nome_pasta = dir.get_next()
	
	dir.list_dir_end()

## Cria um botão para o ebook e seus capítulos
func _criar_botao_ebook(nome_ebook: String) -> void:
	var container_ebook = VBoxContainer.new()
	container_ebook.name = nome_ebook
	
	# Botão principal do ebook
	var botao_ebook = Button.new()
	botao_ebook.text = nome_ebook
	botao_ebook.alignment = HORIZONTAL_ALIGNMENT_LEFT
	botao_ebook.toggle_mode = true
	botao_ebook.toggled.connect(_on_ebook_toggled.bind(nome_ebook, container_ebook))
	# Cor azul para ebooks
	botao_ebook.add_theme_color_override("font_color", Color("#4A9EFF"))
	botao_ebook.add_theme_color_override("font_pressed_color", Color("#2E7FD9"))
	botao_ebook.add_theme_color_override("font_hover_color", Color("#6BB5FF"))
	container_ebook.add_child(botao_ebook)
	
	# Container para os capítulos (inicialmente escondido)
	var container_capitulos = VBoxContainer.new()
	container_capitulos.name = "Capitulos"
	container_capitulos.visible = false
	container_ebook.add_child(container_capitulos)
	
	ebooks_disponiveis.add_child(container_ebook)

## Chamado quando um botão de ebook é expandido/colapsado
func _on_ebook_toggled(expandido: bool, nome_ebook: String, container_ebook: VBoxContainer) -> void:
	var container_capitulos = container_ebook.get_node("Capitulos")
	container_capitulos.visible = expandido
	
	if expandido:
		ebook_selecionado = nome_ebook
		_carregar_capitulos(nome_ebook, container_capitulos)

## Carrega todos os capítulos de um ebook
func _carregar_capitulos(nome_ebook: String, container_capitulos: VBoxContainer) -> void:
	# Limpa capítulos existentes
	for child in container_capitulos.get_children():
		child.queue_free()
	
	var caminho_ebook = diretorio_ebooks.path_join(nome_ebook)
	var dir = DirAccess.open(caminho_ebook)
	
	if not dir:
		push_error("Não foi possível abrir o diretório do ebook: %s" % caminho_ebook)
		return
	
	# Lista todos os capítulos (subpastas)
	dir.list_dir_begin()
	var nome_pasta = dir.get_next()
	
	while nome_pasta != "":
		if dir.current_is_dir() and not nome_pasta.begins_with("."):
			_criar_botao_capitulo(nome_ebook, nome_pasta, container_capitulos)
		nome_pasta = dir.get_next()
	
	dir.list_dir_end()

## Cria um botão para o capítulo e seus arquivos markdown
func _criar_botao_capitulo(nome_ebook: String, nome_capitulo: String, container_capitulos: VBoxContainer) -> void:
	var container_capitulo = VBoxContainer.new()
	container_capitulo.name = nome_capitulo
	
	# Botão do capítulo com indentação
	var botao_capitulo = Button.new()
	botao_capitulo.text = "  → " + nome_capitulo
	botao_capitulo.alignment = HORIZONTAL_ALIGNMENT_LEFT
	botao_capitulo.toggle_mode = true
	botao_capitulo.toggled.connect(_on_capitulo_toggled.bind(nome_ebook, nome_capitulo, container_capitulo))
	# Cor verde para capítulos
	botao_capitulo.add_theme_color_override("font_color", Color("#5FB878"))
	botao_capitulo.add_theme_color_override("font_pressed_color", Color("#4A9E61"))
	botao_capitulo.add_theme_color_override("font_hover_color", Color("#7BC995"))
	container_capitulo.add_child(botao_capitulo)
	
	# Container para os arquivos markdown (inicialmente escondido)
	var container_arquivos = VBoxContainer.new()
	container_arquivos.name = "Arquivos"
	container_arquivos.visible = false
	container_capitulo.add_child(container_arquivos)
	
	container_capitulos.add_child(container_capitulo)

## Chamado quando um botão de capítulo é expandido/colapsado
func _on_capitulo_toggled(expandido: bool, nome_ebook: String, nome_capitulo: String, container_capitulo: VBoxContainer) -> void:
	var container_arquivos = container_capitulo.get_node("Arquivos")
	container_arquivos.visible = expandido
	
	if expandido:
		capitulo_selecionado = nome_capitulo
		_carregar_arquivos_markdown(nome_ebook, nome_capitulo, container_arquivos)

## Carrega todos os arquivos markdown de um capítulo
func _carregar_arquivos_markdown(nome_ebook: String, nome_capitulo: String, container_arquivos: VBoxContainer) -> void:
	# Limpa arquivos existentes
	for child in container_arquivos.get_children():
		child.queue_free()
	
	var caminho_capitulo = diretorio_ebooks.path_join(nome_ebook).path_join(nome_capitulo)
	var dir = DirAccess.open(caminho_capitulo)
	
	if not dir:
		push_error("Não foi possível abrir o diretório do capítulo: %s" % caminho_capitulo)
		return
	
	# Lista todos os arquivos markdown
	dir.list_dir_begin()
	var nome_arquivo = dir.get_next()
	
	while nome_arquivo != "":
		if not dir.current_is_dir() and nome_arquivo.ends_with(".md"):
			_criar_botao_arquivo(nome_ebook, nome_capitulo, nome_arquivo, container_arquivos)
		nome_arquivo = dir.get_next()
	
	dir.list_dir_end()

## Cria um botão para um arquivo markdown
func _criar_botao_arquivo(nome_ebook: String, nome_capitulo: String, nome_arquivo: String, container_arquivos: VBoxContainer) -> void:
	var botao_arquivo = Button.new()
	# Remove a extensão .md e adiciona indentação
	var nome_exibicao = nome_arquivo.trim_suffix(".md")
	botao_arquivo.text = "    • " + nome_exibicao
	botao_arquivo.alignment = HORIZONTAL_ALIGNMENT_LEFT
	botao_arquivo.pressed.connect(_carregar_markdown.bind(nome_ebook, nome_capitulo, nome_arquivo))
	# Cor laranja/âmbar para arquivos
	botao_arquivo.add_theme_color_override("font_color", Color("#FFA726"))
	botao_arquivo.add_theme_color_override("font_pressed_color", Color("#F57C00"))
	botao_arquivo.add_theme_color_override("font_hover_color", Color("#FFB74D"))
	container_arquivos.add_child(botao_arquivo)

## Carrega e exibe um arquivo markdown no pré-visualizador
func _carregar_markdown(nome_ebook: String, nome_capitulo: String, nome_arquivo: String) -> void:
	var caminho_md = diretorio_ebooks.path_join(nome_ebook).path_join(nome_capitulo).path_join(nome_arquivo)
	
	if not FileAccess.file_exists(caminho_md):
		push_error("Arquivo não encontrado: %s" % caminho_md)
		return
	
	# Limpa conteúdo anterior
	for child in pre_visualizacao_ebook.get_children():
		child.queue_free()
	
	# Carrega o novo markdown
	pre_visualizacao_ebook.parse_markdown_to_scene(caminho_md)
