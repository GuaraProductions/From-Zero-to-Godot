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
	var f = calcular_fatorial(n)
	resultado.modulate = Color.WHITE
	resultado.text = "Fatorial: %d" % f

#endregion

func calcular_fatorial(n: int) -> int:
	# TODO: Calcule o fatorial de n
	return 1
