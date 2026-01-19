extends Window

signal operacao_concluida(item, quantidade)

@onready var item_option_button : OptionButton = %ItemNome
@onready var item_quant_slider: HSlider = %ItemQuantSlider
@onready var quantidade_slider_label_2: Label = %QuantidadeSliderLabel2

var inventario : Lista5Exercicio1.Inventario

func _on_about_to_popup() -> void:
	item_option_button.clear()
	
	var items = inventario.get_itens()
	
	for chave in items:
		var item = items[chave]
		item_option_button.add_icon_item(item.textura, item.nome, item.id)
		
	if item_option_button.item_count > 0:
		item_option_button.select(0)
		_on_item_nome_item_selected(0)

func _on_remover_item_pressed() -> void:

	var id : int = item_option_button.get_item_id(item_option_button.selected)
	var quantidade : int = item_quant_slider.value

	operacao_concluida.emit(id, quantidade)
	close_requested.emit()

func _on_item_nome_item_selected(index: int) -> void:
	
	var inventario_id = item_option_button.get_item_id(index)
	
	var quantidade = inventario.get_item_quantidade(inventario_id)
	
	item_quant_slider.visible = quantidade > 1
	item_quant_slider.max_value = quantidade


func _on_item_quant_slider_value_changed(value: float) -> void:
	quantidade_slider_label_2.text = Numeros.formatar(value)

func _on_close_requested() -> void:
	hide()
