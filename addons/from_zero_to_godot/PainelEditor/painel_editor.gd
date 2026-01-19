@tool
extends PanelContainer

@onready var seja_bem_vindo: VBoxContainer = %"Seja Bem Vindo"
@onready var listas_de_exercicios: VBoxContainer = %"Listas De Exercicios"
@onready var exercicios: PainelTestes = %"Testador de Exercicios"
@onready var ebook: MarginContainer = %Ebook
@onready var tela_inicial: MarkdownPreProcessador = %TelaInicial
@onready var tab_container: TabContainer = $TabContainer

func _ready() -> void:
	# Conecta sinal de abrir teste da lista de exercícios
	if listas_de_exercicios.has_signal("abrir_teste_exercicio"):
		listas_de_exercicios.abrir_teste_exercicio.connect(_on_abrir_teste_exercicio)
	
	# Atualiza nomes das abas
	_atualizar_nomes_abas()
	
	# Carrega o markdown de introdução
	_carregar_introducao()
	
	seja_bem_vindo.visible = true

func _atualizar_nomes_abas() -> void:
	"""Atualiza os nomes das abas baseado no locale atual"""
	if not tab_container:
		return
	
	var locale = FromZeroToGodot.get_locale()
	
	# Translate tab names using TranslationHelper
	tab_container.set_tab_title(0, TranslationHelper.translate("Seja Bem Vindo", locale))
	tab_container.set_tab_title(1, TranslationHelper.translate("Ebook", locale))
	tab_container.set_tab_title(2, TranslationHelper.translate("Listas De Exercicios", locale))
	tab_container.set_tab_title(3, TranslationHelper.translate("Testador de Exercicios", locale))

func conectar_signal_locale(plugin: FromZeroToGodot) -> void:
	"""Conecta ao signal de mudança de locale do plugin e propaga para componentes"""
	if plugin and not plugin.locale_changed.is_connected(_on_locale_changed):
		plugin.locale_changed.connect(_on_locale_changed)
	
	# Conecta signal aos componentes filhos
	if ebook and ebook.has_method("conectar_signal_locale"):
		ebook.conectar_signal_locale(plugin)
	
	if listas_de_exercicios and listas_de_exercicios.has_method("conectar_signal_locale"):
		listas_de_exercicios.conectar_signal_locale(plugin)
	
	if exercicios and exercicios.has_method("conectar_signal_locale"):
		exercicios.conectar_signal_locale(plugin)

func _on_locale_changed(new_locale: String) -> void:
	"""Chamado quando o locale muda"""
	_atualizar_nomes_abas()
	_recarregar_conteudo_localizado()

func _carregar_introducao() -> void:
	"""Carrega o arquivo README.md da pasta introduction localizada"""
	if not tela_inicial:
		return
	
	var caminho_readme = FromZeroToGodot.get_localized_readme_path()
	
	if not FileAccess.file_exists(caminho_readme):
		push_warning("README.md não encontrado em: %s" % caminho_readme)
		return
	
	# Limpa conteúdo anterior
	for child in tela_inicial.get_children():
		child.queue_free()
	
	# Carrega o novo markdown
	tela_inicial.parse_markdown_to_scene(caminho_readme)

func _recarregar_conteudo_localizado() -> void:
	"""Recarrega todo o conteúdo que depende do locale"""
	# Recarrega introdução
	_carregar_introducao()
	
	# Recarrega ebook se estiver visível
	if ebook and ebook.has_method("recarregar_ebooks"):
		ebook.recarregar_ebooks()
	
	# Recarrega lista de exercícios se estiver visível
	if listas_de_exercicios and listas_de_exercicios.has_method("recarregar_listas"):
		listas_de_exercicios.recarregar_listas()
	
	# Recarrega painel de testes se necessário
	if exercicios and exercicios.has_method("recarregar_todos_exercicios"):
		exercicios.recarregar_todos_exercicios()

func _on_abrir_teste_exercicio(lista: String, exercicio: String) -> void:
	# Muda para a aba de exercícios
	seja_bem_vindo.visible = false
	listas_de_exercicios.visible = false
	exercicios.visible = true
	ebook.visible = false
	
	# Chama função do painel de testes para selecionar o exercício
	exercicios.selecionar_exercicio(lista, exercicio)
