@tool
extends EditorPlugin

const painel_editor_cena = preload("res://addons/do_zero_ao_gd_script/PainelEditor/PainelEditor.tscn")

var painel_editor_instancia : PanelContainer = null
var markdown_preprocessador : MarkdownPreProcessador = null
var painel_testes : PainelTestes = null
var file_dialog : EditorFileDialog = null

func _enter_tree() -> void:
	
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
		
func _has_main_screen() -> bool:
	return true
	
func _make_visible(visible: bool) -> void:
	if painel_editor_instancia:
		painel_editor_instancia.visible = visible
		
func _get_plugin_name() -> String:
	return "DoZeroAoGDScript"

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

func _on_abrir_cena_solicitada(caminho_cena: String) -> void:
	print("Abrindo cena: %s" % caminho_cena)
	EditorInterface.open_scene_from_path(caminho_cena)
	
	await get_tree().create_timer(0.01).timeout
	
	EditorInterface.set_main_screen_editor("2D")
