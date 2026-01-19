extends MarginContainer

#region JahImplementado

@onready var valor_entrada: LineEdit = %ValorEntrada
@onready var desconto_entrada: LineEdit = %DescontoEntrada
@onready var brinde_label: Label = %BrindeLabel

@onready var resultado: Label = %Resultado

func _eh_numero_valido(texto: String) -> bool:
	return texto.is_valid_int() or texto.is_valid_float()

func _on_calcular_pressed() -> void:
	if not _eh_numero_valido(valor_entrada.text):
		resultado.text = "Erro! O valor é invalído!\nColoque um número!"
		resultado.modulate = Color.RED
		return
	if not _eh_numero_valido(desconto_entrada.text):
		resultado.text = "Erro! O desconto é invalído!\nColoque um número!"
		resultado.modulate = Color.RED
		return
		
	var valor_compras : float = float(valor_entrada.text)
	var desconto : float = float(desconto_entrada.text)
		
	var valor_com_desconto := calcular_valor_com_desconto(valor_compras, desconto)
	var tem_brinde := calcular_se_cliente_brinde(valor_com_desconto)
	
	resultado.modulate = Color.WHITE
	resultado.text = "Valor com desconto: %s" % [str(valor_com_desconto).pad_decimals(2)]
	
	brinde_label.text = "Parabéns! Você ganhou um brinde!" if tem_brinde else ""

#endregion

func calcular_valor_com_desconto(valor_compras: float, 
								 desconto: float) -> float:
	#TODO: Implementar lógica
	return 0

func calcular_se_cliente_brinde(valor_com_desconto: float) -> bool:
	#TODO: Implementar lógica
	return true
