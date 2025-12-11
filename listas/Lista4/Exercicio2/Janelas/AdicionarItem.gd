extends Window

signal operacao_concluida(nome, descricao, icone, quantidade)

@export_dir var diretorio_com_texturas : String = ""

@onready var nome_item_line_edit: LineEdit = %NomeItemLineEdit
@onready var descricao_text_edit: TextEdit = %DescricaoTextEdit
@onready var icone_option_button: OptionButton = %IconeOptionButton
@onready var quantidade_slider: HSlider = %QuantidadeSlider
@onready var quantidade_slider_label: Label = %QuantidadeSliderLabel

func _ready() -> void:
	quantidade_slider_label.text = Numeros.formatar(quantidade_slider.value)
	# Tenta abrir o diretório
	var dir = DirAccess.open(diretorio_com_texturas)
	if dir == null:
		printerr("Não foi possível abrir o diretório: %s" % diretorio_com_texturas)
		return

# Inicia a listagem
	dir.list_dir_begin()
	while true:
		var nome_arquivo = dir.get_next()
		if nome_arquivo == "":
			break  # Fim da listagem

	# Pula subpastas
		if dir.current_is_dir():
			continue

	# Filtra apenas .png
		if nome_arquivo.get_extension().to_lower() == "png":
			var caminho_completo = diretorio_com_texturas.path_join(nome_arquivo)
			var tex = load(caminho_completo) as Texture2D
			if not tex: continue

		# Se for ImageTexture, basta setar override de tamanho
			if tex is ImageTexture:
				tex.set_size_override(Vector2i(64, 64))  # :contentReference[oaicite:0]{index=0} :contentReference[oaicite:1]{index=1}
			else:
			# Para StreamTexture ou outros, converte via Image
				var img = tex.get_image().duplicate()
				img.resize(64, 64)
				tex = ImageTexture.create_from_image(img)

			icone_option_button.add_icon_item(tex, nome_arquivo.get_basename())

# Encerra a listagem e libera recursos
	dir.list_dir_end()

func _texto_valido(texto: String) -> bool:
	return not texto.is_empty()
	
func _on_quantidade_slider_value_changed(value: float) -> void:
	quantidade_slider_label.text = Numeros.formatar(value)

func _on_adicionar_item_pressed() -> void:
	var nome : String = nome_item_line_edit.text
	var descricao : String = descricao_text_edit.text
	var icone : Texture = _acessar_icone_selecionado()
	var quantidade : int = quantidade_slider.value
	
	if not _texto_valido(nome):
		OS.alert("Nome inserido não é válido", "Erro!")
		return
		
	if not _texto_valido(descricao):
		OS.alert("Descrição inserida não é válido", "Erro!")
		return
	
	if not icone:
		OS.alert("Textura selecionada não é válida", "Erro!")
		return
	
	operacao_concluida.emit(nome, descricao, icone, quantidade)
	close_requested.emit()
	
func _acessar_icone_selecionado() -> Texture:
	return icone_option_button.get_item_icon(icone_option_button.selected)

func _on_close_requested() -> void:
	nome_item_line_edit.clear()
	descricao_text_edit.clear()
	icone_option_button.select(0)
	quantidade_slider.value = 0
	hide()
