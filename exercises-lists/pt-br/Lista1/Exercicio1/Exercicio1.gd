extends MarginContainer

#region JahImplementado

@onready var entrada : LineEdit = %Entrada
@onready var resultado : Label = %Resultado

func _eh_numero_valido(texto: String) -> bool:
	return texto.is_valid_int() or texto.is_valid_float()

func _on_converter_pressed() -> void:
	var texto : String = entrada.text
	
	if not _eh_numero_valido(texto):
		resultado.text = "Erro! A entrada de texto é invalída!\nColoque um número!"
		resultado.modulate = Color.RED
		return
		
	var numero : float = float(texto)
		
	var farenheit := celsius_para_farenheit(numero)
	
	resultado.modulate = Color.WHITE
	resultado.text = "Resultado: %s" % [str(farenheit).pad_decimals(2)]

#endregion

func celsius_para_farenheit(numero: float) -> float:
	#TODO: Implementar lógica
	return numero
