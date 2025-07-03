@tool
extends EditorPlugin

const painel_editor_cena = preload("res://addons/do_zero_ao_gd_script/PainelEditor/PainelEditor.tscn")

var painel_editor_instancia : PanelContainer = null

func _enter_tree() -> void:
	
	painel_editor_instancia = painel_editor_cena.instantiate()

	EditorInterface.get_editor_main_screen().add_child(painel_editor_instancia)

	_make_visible(false)

func _exit_tree() -> void:
	if painel_editor_instancia:
		painel_editor_instancia.queue_free()
		painel_editor_instancia = null
		
func _has_main_screen() -> bool:
	return true
	
func _make_visible(visible: bool) -> void:
	if painel_editor_instancia:
		painel_editor_instancia.visible = visible
		
func _get_plugin_name() -> String:
	return "DoZeroAoGDScript"
