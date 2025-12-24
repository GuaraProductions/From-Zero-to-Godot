@tool
extends Control
class_name MarkdownPreProcessador

# --- Propriedades exportadas para personalização ---
@export_range(10,60) var title_font_size: int = 36
@export_range(8,48) var subtitle_font_size: int = 24
@export_range(6,36) var normal_font_size: int = 14
@export_range(8,36) var formula_font_size: int = 18
@export_color_no_alpha var title_color: Color = Color(1, 1, 1)
@export_color_no_alpha var text_color: Color = Color(0.9, 0.9, 0.9)
@export_range(1,50) var table_cell_padding: int = 4
@export var debug_mode: bool = false

const TextoColapasavelScene = preload("res://addons/do_zero_ao_gd_script/Markdown/TextoColapsavel.tscn")

func _debug_print(mensagem: String) -> void:
	if debug_mode:
		print(mensagem)

func parse_markdown_to_scene(md_path: String) -> Control:
	# Carrega o arquivo markdown
	var file = FileAccess.open(md_path, FileAccess.READ)
	if not file:
		push_error("Arquivo não encontrado: %s" % md_path)
		return null

	var text = file.get_as_text()
	file.close()

	_debug_print("=== INICIANDO PARSE DO MARKDOWN ===")
	_debug_print("Arquivo: " + md_path)

	# Cria o container principal da "cena"
	var scroll = ScrollContainer.new()
	scroll.name = "Scroll"
	scroll.anchor_right = 1
	scroll.anchor_bottom = 1
	scroll.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	scroll.set_v_size_flags(Control.SIZE_EXPAND_FILL)

	# Cria o container principal da "cena"
	var root = VBoxContainer.new()
	root.name = "MarkdownScene"
	root.anchor_right = 1
	root.anchor_bottom = 1
	root.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	root.set_v_size_flags(Control.SIZE_EXPAND_FILL)

	scroll.add_child(root)

	# Percorre linha por linha
	var lines = text.split("\n")
	var i = 0
	var em_bloco_matematico = false
	var conteudo_matematico = ""
	var linha_count = 0
	
	_debug_print("Total de linhas no arquivo: " + str(lines.size()))
	
	while i < lines.size():
		var line : String = lines[i]
		var line_stripped = line.strip_edges()
		
		linha_count += 1
		
		# Ignora linhas vazias
		if line_stripped == "":
			_debug_print("[Linha %d] VAZIA - pulando" % linha_count)
			i += 1
			continue
		
		# Detecta blocos matemáticos $$
		if line_stripped.begins_with("$$"):
			em_bloco_matematico = !em_bloco_matematico
			_debug_print("[Linha %d] BLOCO MATEMÁTICO %s: %s" % [linha_count, "INICIADO" if em_bloco_matematico else "FINALIZADO", line_stripped])
			
			# Se está finalizando, cria o componente visual
			if not em_bloco_matematico and conteudo_matematico != "":
				_adicionar_formula_matematica(root, conteudo_matematico)
				conteudo_matematico = ""
			
			i += 1
			continue
		
		# Coleta conteúdo dentro de blocos matemáticos
		if em_bloco_matematico:
			_debug_print("[Linha %d] DENTRO DE BLOCO MATEMÁTICO - coletando: %s" % [linha_count, line_stripped])
			conteudo_matematico += line_stripped + "\n"
			i += 1
			continue
		
		# Detecta e processa tags <details> inline (mesma linha)
		if line_stripped.begins_with("<details>"):
			# Verifica se a tag fecha na mesma linha
			if line_stripped.find("</details>") != -1:
				_debug_print("[Linha %d] BLOCO DETAILS INLINE (mesma linha) - processando: %s" % [linha_count, line_stripped])
				_adicionar_details_colapsavel(root, line_stripped)
				i += 1
				continue
		
		# Ignora linhas de separação ---
		if line_stripped.begins_with("---"):
			_debug_print("[Linha %d] SEPARADOR --- - pulando" % linha_count)
			i += 1
			continue
		
		# Imagem: ![alt](path)
		if line_stripped.begins_with("!"):
			_debug_print("[Linha %d] IMAGEM detectada: %s" % [linha_count, line_stripped])
			var img_data = line_stripped.substr(2, line_stripped.find(")") - 2)  # remove ![
			var parts = img_data.split("](")
			if parts.size() == 2:
				var path = parts[1].strip_edges()
				var tex = load(path) 
				if tex:
					var img = TextureRect.new()
					img.texture = tex
					img.custom_minimum_size = Vector2(200, 200)
					img.expand_mode = TextureRect.EXPAND_KEEP_SIZE
					img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
					root.add_child(img)
					_debug_print("  -> Imagem adicionada com sucesso")
				else:
					_debug_print("  -> ERRO: Não foi possível carregar a imagem: " + path)
			i += 1
			continue
		
		# Tabelas: linhas com pipes |
		if line_stripped.find("|") != -1 and i + 1 < lines.size() and lines[i + 1].strip_edges().find("-") != -1:
			_debug_print("[Linha %d] TABELA detectada" % linha_count)
			# Coleta cabeçalho e as linhas
			var header = line_stripped.split("|")
			header = header.slice(1, header.size()-1) # remove bordas (primeiro e último vazios)
			var content_lines = []
			i += 2 # pula header e separador
			linha_count += 2
			while i < lines.size() and lines[i].strip_edges().find("|") != -1:
				var row_data = lines[i].split("|")
				row_data = row_data.slice(1, row_data.size()-1) # remove bordas
				content_lines.append(row_data)
				i += 1
				linha_count += 1
			
			var cols = header.size()
			var grid = GridContainer.new()
			grid.columns = cols
			grid.add_theme_constant_override("hseparation", table_cell_padding)
			grid.add_theme_constant_override("vseparation", table_cell_padding)
			grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			
			# Células do cabeçalho
			for h in header:
				var texto_header = h.strip_edges()
				texto_header = _converter_markdown_para_bbcode(texto_header)
				
				var rt = RichTextLabel.new()
				rt.bbcode_enabled = true
				rt.fit_content = true
				rt.scroll_active = false
				rt.custom_minimum_size = Vector2(100, 20)
				rt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				rt.bbcode_text = "[b]%s[/b]" % texto_header
				rt.add_theme_color_override("default_color", title_color)
				rt.add_theme_font_size_override("normal_font_size", subtitle_font_size)
				#rt.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
				grid.add_child(rt)
			
			# Conteúdo
			for row in content_lines:
				for cell in row:
					var texto_cell = cell.strip_edges()
					texto_cell = _converter_markdown_para_bbcode(texto_cell)
					
					var rt = RichTextLabel.new()
					rt.bbcode_enabled = true
					rt.fit_content = true
					rt.scroll_active = false
					rt.custom_minimum_size = Vector2(100, 20)
					rt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
					rt.bbcode_text = texto_cell
					rt.add_theme_color_override("default_color", text_color)
					rt.add_theme_font_size_override("normal_font_size", normal_font_size)
					#rt.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
					grid.add_child(rt)
			
			root.add_child(grid)
			_debug_print("  -> Tabela adicionada com %d linhas e %d colunas" % [content_lines.size(), cols])
			continue
		
		# Títulos #, ##, ### ...
		if line_stripped.begins_with("#"):
			var lvl = 0
			for c in line_stripped:
				if c == '#':
					lvl += 1
				else:
					break
			var text_content = line_stripped.substr(lvl).strip_edges()
			_debug_print("[Linha %d] TÍTULO nível %d: %s" % [linha_count, lvl, text_content])
			text_content = _converter_markdown_para_bbcode(text_content)
			
			# Determina o tamanho da fonte baseado no nível
			var size_lbl
			var cor_titulo
			match lvl:
				1: 
					size_lbl = title_font_size
					cor_titulo = title_color
				2, 3: 
					size_lbl = subtitle_font_size
					cor_titulo = text_color
				_: 
					size_lbl = normal_font_size
					cor_titulo = text_color
			
			var rt = RichTextLabel.new()
			rt.bbcode_enabled = true
			rt.fit_content = true
			rt.scroll_active = false
			rt.bbcode_text = "[font_size=%d]%s[/font_size]" % [size_lbl, text_content]
			rt.add_theme_color_override("default_color", cor_titulo)
			rt.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
			root.add_child(rt)
			_debug_print("  -> Título adicionado, nível %d, tamanho fonte: %d" % [lvl, size_lbl])
			i += 1
			continue
		
		# Parágrafos / texto simples (preserva indentação para listas)
		_debug_print("[Linha %d] TEXTO: %s" % [linha_count, line_stripped])
		var texto_convertido = _converter_markdown_para_bbcode(line_stripped)
		var rt = RichTextLabel.new()
		rt.bbcode_enabled = true
		rt.fit_content = true
		rt.scroll_active = false
		rt.bbcode_text = texto_convertido
		rt.add_theme_color_override("default_color", text_color)
		rt.add_theme_font_size_override("normal_font_size", normal_font_size)
		rt.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
		root.add_child(rt)
		_debug_print("  -> Texto adicionado (BBCode: %s)" % texto_convertido)
		i += 1

	add_child(scroll)
	_debug_print("=== PARSE FINALIZADO - %d elementos adicionados ===" % root.get_child_count())

	return scroll

func _converter_markdown_para_bbcode(texto: String) -> String:
	# Converte negrito **texto** para [b]texto[/b]
	var regex_negrito = RegEx.new()
	regex_negrito.compile("\\*\\*([^*]+)\\*\\*")
	texto = regex_negrito.sub(texto, "[b]$1[/b]", true)
	
	# Converte itálico *texto* para [i]texto[/i]
	var regex_italico = RegEx.new()
	regex_italico.compile("\\*([^*]+)\\*")
	texto = regex_italico.sub(texto, "[i]$1[/i]", true)
	
	# Converte código `texto` para [code]texto[/code]
	var regex_codigo = RegEx.new()
	regex_codigo.compile("`([^`]+)`")
	texto = regex_codigo.sub(texto, "[code]$1[/code]", true)
	
	# Remove emojis e outros caracteres especiais que podem causar problemas
	texto = texto.replace("️", "")
	
	return texto

func _adicionar_formula_matematica(container: VBoxContainer, formula: String) -> void:
	_debug_print("  -> Adicionando fórmula matemática: %s" % formula)
	
	# Formata a fórmula para melhor visualização
	var formula_formatada = formula.strip_edges()
	
	# Substitui caracteres especiais por equivalentes mais seguros
	formula_formatada = formula_formatada.replace("×", "*")
	formula_formatada = formula_formatada.replace("\n", "")
	# Cria um painel para destacar a fórmula
	var panel = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.custom_minimum_size = Vector2(0, 50)  # Define altura mínima
	
	var rt = RichTextLabel.new()
	rt.bbcode_enabled = true
	rt.fit_content = true
	rt.scroll_active = false
	rt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rt.custom_minimum_size = Vector2(0, 40)  # Define altura mínima para o texto
	rt.bbcode_text = "[center][font_size=%d][i]%s[/i][/font_size][/center]" % [formula_font_size, formula_formatada]
	rt.add_theme_color_override("default_color", Color(0.8, 0.9, 1.0))  # Cor azulada para fórmulas
	rt.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	
	panel.add_child(rt)
	container.add_child(panel)
	_debug_print("  -> Fórmula adicionada ao container (tamanho: %d)" % formula_font_size)

func _adicionar_details_colapsavel(container: VBoxContainer, linha_details: String) -> void:
	# Extrai o summary e o conteúdo do details
	var regex_summary = RegEx.new()
	regex_summary.compile("<summary>(.+?)</summary>")
	var match_summary = regex_summary.search(linha_details)
	
	var regex_content = RegEx.new()
	regex_content.compile("</summary>\\s*(.+?)\\s*</details>")
	var match_content = regex_content.search(linha_details)
	
	if match_summary and match_content:
		var titulo = match_summary.get_string(1).strip_edges()
		var conteudo = match_content.get_string(1).strip_edges()
		
		# Remove tags HTML extras do título
		titulo = titulo.replace("<b>", "").replace("</b>", "").replace("</font>", "")
		
		# Instancia a cena TextoColapsavel
		var texto_colapsavel : TextoColapsavel = TextoColapasavelScene.instantiate()
		
		container.add_child(texto_colapsavel)
		
		# Configura o botão e o texto
		texto_colapsavel.configurar_texto.call_deferred(titulo, conteudo)
		_debug_print("  -> Details colapsável adicionado: %s" % titulo)
	else:
		_debug_print("  -> ERRO ao processar details: não foi possível extrair summary/content")
