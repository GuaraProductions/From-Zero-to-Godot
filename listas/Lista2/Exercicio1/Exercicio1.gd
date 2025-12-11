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
	var soma = somar_ate_n(n)
	resultado.modulate = Color.WHITE
	resultado.text = "Soma: %d" % soma

#endregion

func somar_ate_n(n: int) -> int:
	# TODO: Implemente a soma de 1 até n usando repetição
	return 0
