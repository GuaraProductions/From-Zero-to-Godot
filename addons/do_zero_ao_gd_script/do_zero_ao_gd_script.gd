@tool
extends EditorPlugin
class_name DoZeroAoGDScript

## Nome da configuração no ProjectSettings para o caminho da pasta de listas
const SETTING_CAMINHO_LISTAS = "do_zero_ao_gd_script/caminho_listas"

## Caminho padrão da pasta de listas de exercícios
const CAMINHO_LISTAS_PADRAO = "res://listas"

## Nome da configuração no ProjectSettings para o caminho da pasta de ebooks
const SETTING_CAMINHO_EBOOKS = "do_zero_ao_gd_script/caminho_ebooks"

## Caminho padrão da pasta de ebooks
const CAMINHO_EBOOKS_PADRAO = "res://ebook"

const painel_editor_cena = preload("res://addons/do_zero_ao_gd_script/PainelEditor/PainelEditor.tscn")

var painel_editor_instancia : PanelContainer = null
var markdown_preprocessador : MarkdownPreProcessador = null
var painel_testes : PainelTestes = null
var file_dialog : EditorFileDialog = null

func _enter_tree() -> void:
	# Configura ProjectSettings
	_configurar_project_settings()

	painel_editor_instancia = painel_editor_cena.instantiate()

	EditorInterface.get_editor_main_screen().add_child(painel_editor_instancia)
	
	# Conecta o sinal do MarkdownPreProcessador após ele ser criado
	await get_tree().process_frame
	_conectar_markdown_preprocessador()
	_configurar_painel_testes()

	_make_visible(false)

func _exit_tree() -> void:
	if markdown_preprocessador and markdown_preprocessador.abrir_cena_solicitada.is_connected(_on_abrir_cena_solicitada):
		markdown_preprocessador.abrir_cena_solicitada.disconnect(_on_abrir_cena_solicitada)
	
	if file_dialog:
		file_dialog.queue_free()
		file_dialog = null
	
	if painel_editor_instancia:
		painel_editor_instancia.queue_free()
		painel_editor_instancia = null
		markdown_preprocessador = null
		painel_testes = null
	
	# Remove configuração do ProjectSettings
	_remover_project_settings()
		
func _has_main_screen() -> bool:
	return true
	
func _make_visible(visible: bool) -> void:
	if painel_editor_instancia:
		painel_editor_instancia.visible = visible
		
func _get_plugin_name() -> String:
	return "DoZeroAoGDScript"

func _get_plugin_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon("GodotMonochrome", "EditorIcons")

func _conectar_markdown_preprocessador() -> void:
	# Procura o MarkdownPreProcessador na árvore
	var preprocessadores = painel_editor_instancia.find_children("*", "MarkdownPreProcessador", true, false)
	if preprocessadores.size() > 0:
		markdown_preprocessador = preprocessadores[0]
		if not markdown_preprocessador.abrir_cena_solicitada.is_connected(_on_abrir_cena_solicitada):
			markdown_preprocessador.abrir_cena_solicitada.connect(_on_abrir_cena_solicitada)

func _configurar_painel_testes() -> void:
	# Procura o PainelTestes na árvore
	var paineis = painel_editor_instancia.find_children("*", "PainelTestes", true, false)
	if paineis.size() > 0:
		painel_testes = paineis[0]
		
		# Cria e configura o EditorFileDialog
		file_dialog = EditorFileDialog.new()
		EditorInterface.get_base_control().add_child(file_dialog)
		
		# Configura o file dialog no painel de testes
		painel_testes.configurar_file_dialog(file_dialog)

func _configurar_project_settings() -> void:
	# Adiciona a configuração de listas se não existir
	if not ProjectSettings.has_setting(SETTING_CAMINHO_LISTAS):
		ProjectSettings.set_setting(SETTING_CAMINHO_LISTAS, CAMINHO_LISTAS_PADRAO)
		
		# Define propriedades da configuração para aparecer no editor
		var property_info = {
			"name": SETTING_CAMINHO_LISTAS,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
			"hint_string": ""
		}
		ProjectSettings.add_property_info(property_info)
		
		# Marca como configuração básica (aparece na aba General)
		ProjectSettings.set_initial_value(SETTING_CAMINHO_LISTAS, CAMINHO_LISTAS_PADRAO)
		ProjectSettings.set_as_basic(SETTING_CAMINHO_LISTAS, true)
	
	# Adiciona a configuração de ebooks se não existir
	if not ProjectSettings.has_setting(SETTING_CAMINHO_EBOOKS):
		ProjectSettings.set_setting(SETTING_CAMINHO_EBOOKS, CAMINHO_EBOOKS_PADRAO)
		
		var property_info_ebooks = {
			"name": SETTING_CAMINHO_EBOOKS,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
			"hint_string": ""
		}
		ProjectSettings.add_property_info(property_info_ebooks)
		
		ProjectSettings.set_initial_value(SETTING_CAMINHO_EBOOKS, CAMINHO_EBOOKS_PADRAO)
		ProjectSettings.set_as_basic(SETTING_CAMINHO_EBOOKS, true)
	
	# Salva as configurações
	ProjectSettings.save()

func _remover_project_settings() -> void:
	# Remove as configurações quando o plugin é desativado
	if ProjectSettings.has_setting(SETTING_CAMINHO_LISTAS):
		ProjectSettings.clear(SETTING_CAMINHO_LISTAS)
	
	if ProjectSettings.has_setting(SETTING_CAMINHO_EBOOKS):
		ProjectSettings.clear(SETTING_CAMINHO_EBOOKS)
	
	ProjectSettings.save()

## Retorna o caminho da pasta de listas configurado no ProjectSettings
## Use esta função estática em outros scripts para acessar o caminho:
## var caminho = DoZeroAoGDScript.obter_caminho_listas()
static func obter_caminho_listas() -> String:
	return ProjectSettings.get_setting(SETTING_CAMINHO_LISTAS, CAMINHO_LISTAS_PADRAO)

## Retorna o caminho da pasta de ebooks configurado no ProjectSettings
## Use esta função estática em outros scripts para acessar o caminho:
## var caminho = DoZeroAoGDScript.obter_caminho_ebooks()
static func obter_caminho_ebooks() -> String:
	return ProjectSettings.get_setting(SETTING_CAMINHO_EBOOKS, CAMINHO_EBOOKS_PADRAO)

func _on_abrir_cena_solicitada(caminho_cena: String) -> void:
	print("Abrindo cena: %s" % caminho_cena)
	EditorInterface.open_scene_from_path(caminho_cena)
	
	await get_tree().create_timer(0.01).timeout
	
	EditorInterface.set_main_screen_editor("2D")
