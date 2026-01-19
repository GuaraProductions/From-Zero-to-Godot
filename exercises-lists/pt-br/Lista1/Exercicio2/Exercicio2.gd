extends MarginContainer

#region JahImplementado

@onready var capital_entrada: LineEdit = %CapitalEntrada
@onready var taxa_de_juros_entrada: LineEdit = %TaxaDeJurosEntrada
@onready var tempo_entrada: LineEdit = %TempoEntrada
@onready var resultado: Label = %Resultado

func _eh_numero_valido(texto: String) -> bool:
	return texto.is_valid_int() or texto.is_valid_float()

func _on_calcular_pressed() -> void:
	if not _eh_numero_valido(capital_entrada.text):
		resultado.text = "Erro! O Capital inicial é invalído!\nColoque um número!"
		resultado.modulate = Color.RED
		return
	if not _eh_numero_valido(taxa_de_juros_entrada.text):
		resultado.text = "Erro! A taxa de juros é invalída!\nColoque um número!"
		resultado.modulate = Color.RED
		return
	if not _eh_numero_valido(tempo_entrada.text):
		resultado.text = "Erro! O tempo colocado é invalído!\nColoque um número!"
		resultado.modulate = Color.RED
		return
		
	var capital : float = float(capital_entrada.text)
	var taxa_juros : float = float(taxa_de_juros_entrada.text)
	var tempo : float = float(tempo_entrada.text)
		
	var montante := calcular_montante(capital, taxa_juros, tempo)
	
	resultado.modulate = Color.WHITE
	resultado.text = "Resultado: R$%s" % [str(montante).pad_decimals(2)]

#endregion

func calcular_montante(capital_inicial: float, 
					   taxa_de_juros: float, 
					   tempo:float ) -> float:

	#TODO: Implementar lógica
	return 0
