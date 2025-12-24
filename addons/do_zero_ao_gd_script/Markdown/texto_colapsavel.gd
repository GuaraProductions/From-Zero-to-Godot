@tool
extends VBoxContainer
class_name TextoColapsavel

enum Modo {
	Esconder,
	Mostrar
}

@onready var dica: Label = $Dica
@onready var mostrar_esconder: Button = $MostrarEsconder

var modo : Modo = Modo.Mostrar
var texto_original : String = ""

func _ready() -> void:
	dica.visible = false

func _on_mostrar_esconder_pressed(source: BaseButton) -> void:
	
	if modo == Modo.Esconder:
		source.text =  texto_original
		dica.visible = false
		modo = Modo.Mostrar
	elif modo == Modo.Mostrar:
		source.text = "Esconder dica"
		dica.visible = true
		modo = Modo.Esconder

func configurar_texto(titulo: String, conteudo: String) -> void:
	mostrar_esconder.text = titulo
	dica.text = conteudo
	texto_original = titulo
