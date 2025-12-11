extends Node

#region JahImplementado

@onready var entrada = %Entrada
@onready var resultado = %Resultado

func _eh_numero_valido(texto: String) -> bool:
	return texto.is_valid_int()

func calcular():
	var texto = entrada.text
	
	if not _eh_numero_valido(texto):
		resultado.text = "Erro! A entrada de texto é inválida!\nColoque um número inteiro!"
		resultado.modulate = Color.RED
		return

	var n = int(texto)
	var total = contar_multiplos_de_3(n)
	resultado.modulate = Color.WHITE
	resultado.text = "Múltiplos de 3: %d" % total

#endregion

func contar_multiplos_de_3(n: int) -> int:
	# TODO: Conte quantos números de 1 até n são múltiplos de 3
	return 0
