@tool
extends EditorPlugin
class_name FromZeroToGodot

## Emitted when the locale setting changes
signal locale_changed(new_locale: String)

## Project settings key for the exercises folder path
const SETTING_EXERCISES_PATH = "from_zero_to_godot/exercises_path"

## Default path for exercises folder
const EXERCISES_PATH_DEFAULT = "res://exercises-lists"

## Project settings key for the ebook folder path
const SETTING_EBOOK_PATH = "from_zero_to_godot/ebook_path"

## Default path for ebook folder
const EBOOK_PATH_DEFAULT = "res://ebook"

## Project settings key for introduction folder path
const SETTING_INTRODUCTION_PATH = "from_zero_to_godot/introduction_path"

## Default path for introduction folder
const INTRODUCTION_PATH_DEFAULT = "res://introduction"

const painel_editor_cena = preload("res://addons/do_zero_ao_gd_script/PainelEditor/PainelEditor.tscn")

var painel_editor_instancia : PanelContainer = null
var markdown_preprocessador : MarkdownPreProcessador = null
var painel_testes : PainelTestes = null
var file_dialog : EditorFileDialog = null
var locale_atual : String = ""
var plugin_tab_name: String = "Do Zero ao Godot"

func _enter_tree() -> void:
	
	auto_translate_mode = Node.AUTO_TRANSLATE_MODE_ALWAYS
	
	# Load translations
	_load_translations()
	
	# Configura ProjectSettings
	_configurar_project_settings()

	painel_editor_instancia = painel_editor_cena.instantiate()

	EditorInterface.get_editor_main_screen().add_child(painel_editor_instancia)
	
	# Conecta o sinal do MarkdownPreProcessador após ele ser criado
	await get_tree().process_frame
	
	# Conecta signal de mudança de locale ao painel (após aguardar inicialização)
	if painel_editor_instancia.has_method("conectar_signal_locale"):
		painel_editor_instancia.conectar_signal_locale(self)
	
	_conectar_markdown_preprocessador()
	_configurar_painel_testes()
	
	# Monitora mudanças no idioma do editor
	locale_atual = get_locale()
	var editor_settings = EditorInterface.get_editor_settings()
	if editor_settings and editor_settings.settings_changed.is_connected(_verificar_mudanca_locale) == false:
		editor_settings.settings_changed.connect(_verificar_mudanca_locale)
	
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
	var locale = get_locale()
	return TranslationHelper.translate(plugin_tab_name, locale)

func _get_plugin_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon("GodotMonochrome", "EditorIcons")

func _conectar_markdown_preprocessador() -> void:
	# Procura o MarkdownPreProcessador na árvore
	var preprocessadores = painel_editor_instancia.find_children("*", "MarkdownPreProcessador", true, false)
	if preprocessadores.size() > 0:
		markdown_preprocessador = preprocessadores[0]
		if not markdown_preprocessador.abrir_cena_solicitada.is_connected(_on_abrir_cena_solicitada):
			markdown_preprocessador.abrir_cena_solicitada.connect(_on_abrir_cena_solicitada)

func _verificar_mudanca_locale() -> void:
	"""Verifica se o locale mudou e emite signal"""
	var novo_locale = get_locale()
	if novo_locale != locale_atual:
		locale_atual = novo_locale
		# Force UI update by hiding and showing
		if painel_editor_instancia:
			painel_editor_instancia.name = TranslationHelper.translate(plugin_tab_name, novo_locale)
			var was_visible = painel_editor_instancia.visible
			_make_visible(false)
			await get_tree().process_frame
			_make_visible(was_visible)
		locale_changed.emit(novo_locale)

func _load_translations() -> void:
	"""Carrega arquivos de tradução no TranslationServer"""
	# Try to load .translation files (compiled from .po)
	var en_translation = load("res://translations/en.translation") if ResourceLoader.exists("res://translations/en.translation") else null
	if en_translation:
		TranslationServer.add_translation(en_translation)
	
	var pt_translation = load("res://translations/pt_BR.translation") if ResourceLoader.exists("res://translations/pt_BR.translation") else null
	if pt_translation:
		TranslationServer.add_translation(pt_translation)
	
	# If .translation files don't exist, try loading .po files directly
	if not en_translation or not pt_translation:
		var en_po = load("res://translations/en.po") if ResourceLoader.exists("res://translations/en.po") else null
		if en_po and en_po is Translation:
			TranslationServer.add_translation(en_po)
		
		var pt_po = load("res://translations/pt_BR.po") if ResourceLoader.exists("res://translations/pt_BR.po") else null
		if pt_po and pt_po is Translation:
			TranslationServer.add_translation(pt_po)
	
	print("[From Zero to Godot] Translations loaded")

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
	# Add exercises path setting if it doesn't exist
	if not ProjectSettings.has_setting(SETTING_EXERCISES_PATH):
		ProjectSettings.set_setting(SETTING_EXERCISES_PATH, EXERCISES_PATH_DEFAULT)
		
		# Define property info for editor display
		var property_info = {
			"name": SETTING_EXERCISES_PATH,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
			"hint_string": ""
		}
		ProjectSettings.add_property_info(property_info)
		
		# Mark as basic setting (appears in General tab)
		ProjectSettings.set_initial_value(SETTING_EXERCISES_PATH, EXERCISES_PATH_DEFAULT)
		ProjectSettings.set_as_basic(SETTING_EXERCISES_PATH, true)
	
	# Add ebook path setting if it doesn't exist
	if not ProjectSettings.has_setting(SETTING_EBOOK_PATH):
		ProjectSettings.set_setting(SETTING_EBOOK_PATH, EBOOK_PATH_DEFAULT)
		
		var property_info_ebooks = {
			"name": SETTING_EBOOK_PATH,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
			"hint_string": ""
		}
		ProjectSettings.add_property_info(property_info_ebooks)
		
		ProjectSettings.set_initial_value(SETTING_EBOOK_PATH, EBOOK_PATH_DEFAULT)
		ProjectSettings.set_as_basic(SETTING_EBOOK_PATH, true)
		# Add introduction path setting if it doesn't exist
	if not ProjectSettings.has_setting(SETTING_INTRODUCTION_PATH):
		ProjectSettings.set_setting(SETTING_INTRODUCTION_PATH, INTRODUCTION_PATH_DEFAULT)
		
		var property_info_intro = {
			"name": SETTING_INTRODUCTION_PATH,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
			"hint_string": ""
		}
		ProjectSettings.add_property_info(property_info_intro)
		
		ProjectSettings.set_initial_value(SETTING_INTRODUCTION_PATH, INTRODUCTION_PATH_DEFAULT)
		ProjectSettings.set_as_basic(SETTING_INTRODUCTION_PATH, true)
	
	# Save settings
	ProjectSettings.save()

func _remover_project_settings() -> void:
	# Remove settings when plugin is disabled
	if ProjectSettings.has_setting(SETTING_EXERCISES_PATH):
		ProjectSettings.clear(SETTING_EXERCISES_PATH)
	
	if ProjectSettings.has_setting(SETTING_EBOOK_PATH):
		ProjectSettings.clear(SETTING_EBOOK_PATH)
	
	if ProjectSettings.has_setting(SETTING_INTRODUCTION_PATH):
		ProjectSettings.clear(SETTING_INTRODUCTION_PATH)
	
	ProjectSettings.save()

## Returns the editor locale from Godot's Editor Language setting
## Returns the locale code (e.g.: "pt-br", "en", "es")
static func get_locale() -> String:
	# Try to get editor language setting
	var editor_settings = EditorInterface.get_editor_settings()
	if editor_settings:
		var editor_locale = editor_settings.get_setting("interface/editor/editor_language")
		if editor_locale and not editor_locale.is_empty():
			# Map Godot's locale codes to our folder names
			if editor_locale.begins_with("pt"):
				return "pt-br"
			elif editor_locale.begins_with("en"):
				return "en"
			elif editor_locale.begins_with("es"):
				return "es"
			elif editor_locale.begins_with("fr"):
				return "fr"
			elif editor_locale.begins_with("de"):
				return "de"
			elif editor_locale.begins_with("it"):
				return "it"
			elif editor_locale.begins_with("ja"):
				return "ja"
			elif editor_locale.begins_with("zh"):
				return "zh"
			elif editor_locale.begins_with("ru"):
				return "ru"
	
	# Fallback to OS locale
	var os_locale = OS.get_locale().to_lower()
	if os_locale.begins_with("pt"):
		return "pt-br"
	elif os_locale.begins_with("en"):
		return "en"
	
	# Default fallback
	return "pt-br"

## Returns the exercises folder path configured in ProjectSettings
## Use this static function in other scripts to access the path:
## var path = FromZeroToGodot.get_exercises_path()
static func get_exercises_path() -> String:
	return ProjectSettings.get_setting(SETTING_EXERCISES_PATH, EXERCISES_PATH_DEFAULT)

## Returns the ebook folder path configured in ProjectSettings
## Use this static function in other scripts to access the path:
## var path = FromZeroToGodot.get_ebook_path()
static func get_ebook_path() -> String:
	return ProjectSettings.get_setting(SETTING_EBOOK_PATH, EBOOK_PATH_DEFAULT)

## Returns the full exercises path including locale
## Example: "res://exercises-lists/pt-br"
static func get_localized_exercises_path() -> String:
	var base = get_exercises_path()
	var locale = get_locale()
	return base.path_join(locale)

## Returns the full ebook path including locale
## Example: "res://ebook/pt-br"
static func get_localized_ebook_path() -> String:
	var base = get_ebook_path()
	var locale = get_locale()
	return base.path_join(locale)

## Returns the introduction folder path configured in ProjectSettings
## Use this static function in other scripts to access the path:
## var path = FromZeroToGodot.get_introduction_path()
static func get_introduction_path() -> String:
	return ProjectSettings.get_setting(SETTING_INTRODUCTION_PATH, INTRODUCTION_PATH_DEFAULT)

## Returns the full introduction path including locale
## Example: "res://introduction/pt-br"
static func get_localized_introduction_path() -> String:
	var base = get_introduction_path()
	var locale = get_locale()
	return base.path_join(locale)

## Returns the full path to the README.md file in the localized introduction folder
## Example: "res://introduction/pt-br/README.md"
static func get_localized_readme_path() -> String:
	return get_localized_introduction_path().path_join("README.md")

func _on_abrir_cena_solicitada(caminho_cena: String) -> void:
	EditorInterface.open_scene_from_path(caminho_cena)
	
	await get_tree().create_timer(0.01).timeout
	
	EditorInterface.set_main_screen_editor("2D")
