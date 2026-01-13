extends MarginContainer

#region JahImplementado

@onready var entrada : LineEdit = %Entrada
@onready var resultado : Label = %Resultado

func _eh_ano_valido(texto: String) -> bool:
	return texto.is_valid_int()

func _on_converter_pressed() -> void:
	var ano_texto : String = entrada.text
	
	if not _eh_ano_valido(ano_texto):
		resultado.text = "Erro! O ano informado é invalído!\nColoque um número!"
		resultado.modulate = Color.RED
		return
		
	var ano : int = int(ano_texto)
		
	var eh_bissexto := ano_eh_bissexto(ano)

	resultado.modulate = Color.WHITE
	
	resultado.text = "O ano de %d " % [ano]
	resultado.text += "é bissexto" if eh_bissexto else "não é bissexto"

#endregion

func ano_eh_bissexto(ano: int) -> bool:
	#TODO: Implementar lógica
	return ano
