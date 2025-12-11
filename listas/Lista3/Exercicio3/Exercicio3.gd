extends MarginContainer

#region JahImplementado

@onready var entrada_potencia = %Entrada
@onready var btn_ligar = %Calcular
@onready var msg_licar_carro = %MsgLigarCarro
@onready var potencia_carro = %PotenciaDoCarro

func _eh_valido(texto: String) -> bool:
	return texto.is_valid_float() or texto.is_valid_int()

#endregion

func _on_ligar_pressed() -> void:
	var texto = entrada_potencia.text.strip_edges()
	if not _eh_valido(texto):
		msg_licar_carro.text = "Erro! Potência inválida! Coloque um número!"
		msg_licar_carro.modulate = Color.RED
		return

	var p = int(texto)
	
	#TODO
	#var carro: Carro = Carro.new(p)
	#var msg_ligar_carro = carro.ligar_carro()
	#var potencia = carro.acessar_potencia()
	
	msg_licar_carro.modulate = Color.WHITE
	#msg_licar_carro.text = msg_ligar_carro

	#potencia_carro.text = "Potencia do carro: %s" % [Numeros.formatar(potencia)]
	potencia_carro.modulate = Color.WHITE
# --- Definições das classes ---

class Motor:
	var potencia: int
	#TODO: Complete o resto da classe
	

class Carro:
	var motor: Motor
	#TODO: Complete o resto da classe
