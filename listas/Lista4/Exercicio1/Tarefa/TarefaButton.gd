extends PanelContainer
class_name TarefaButton

signal concluir_tarefa(id)
signal deletar(id)

@onready var texto_rich_text: RichTextLabel = %Texto
@onready var concluir_button: Button = %ConcluirButton

var id: int = -1
var texto: String = ""

func configurar(p_texto: String, p_id : int) -> void:
	id = p_id
	texto = p_texto
	
func _ready() -> void:
	texto_rich_text.text = texto

func _on_concluir_button_pressed() -> void:

	concluir_button.disabled = true

	var texto_atual = texto_rich_text.text
	texto_rich_text.text = "--[s]%s[/s]--" % [texto_atual]
	texto_rich_text.modulate = Color.DIM_GRAY
	concluir_tarefa.emit(id)

func _on_deletar_button_pressed() -> void:
	deletar.emit(id)
