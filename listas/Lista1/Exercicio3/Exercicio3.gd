extends MarginContainer

#region JahImplementado

@onready var nota_1_entrada: LineEdit = %Nota1Entrada
@onready var nota_2_entrada: LineEdit = %Nota2Entrada
@onready var nota_3_entrada: LineEdit = %Nota3Entrada

@onready var resultado: Label = %Resultado

func _eh_numero_valido(texto: String) -> bool:
	return texto.is_valid_int() or texto.is_valid_float()

func _on_calcular_pressed() -> void:
	if not _eh_numero_valido(nota_1_entrada.text):
		resultado.text = "Erro! A nota 1 é invalída!\nColoque um número!"
		resultado.modulate = Color.RED
		return
	if not _eh_numero_valido(nota_3_entrada.text):
		resultado.text = "Erro! A nota 2 é invalída!\nColoque um número!"
		resultado.modulate = Color.RED
		return
	if not _eh_numero_valido(nota_3_entrada.text):
		resultado.text = "Erro! A nota 3 é invalída!\nColoque um número!"
		resultado.modulate = Color.RED
		return
		
	var nota_1 : float = float(nota_1_entrada.text)
	var nota_2 : float = float(nota_2_entrada.text)
	var nota_3 : float = float(nota_3_entrada.text)
		
	var situacao_escolar := calcular_situaçao_escolar(nota_1, nota_2, nota_3)
	
	resultado.modulate = Color.WHITE
	resultado.text = "Resultado: %s" % [situacao_escolar]

#endregion

func calcular_situaçao_escolar(nota_1: float, 
							  nota_2: float, 
							  nota_3: float ) -> String:
	#TODO: Implementar lógica
	return "Reprovado"
