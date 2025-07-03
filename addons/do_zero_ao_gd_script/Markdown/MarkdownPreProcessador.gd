extends Control

# --- Propriedades exportadas para personalização ---
@export_range(10,60) var title_font_size: int = 36
@export_range(8,48) var subtitle_font_size: int = 24
@export_range(6,36) var normal_font_size: int = 14
@export_color_no_alpha var title_color: Color = Color(1, 1, 1)
@export_color_no_alpha var text_color: Color = Color(0.9, 0.9, 0.9)
@export_range(1,50) var table_cell_padding: int = 4

func parse_markdown_to_scene(md_path: String) -> Control:
	# Carrega o arquivo markdown
	var file = FileAccess.open(md_path, FileAccess.READ)
	if not file:
		push_error("Arquivo não encontrado: %s" % md_path)
		return null

	var text = file.get_as_text()
	file.close()

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
	while i < lines.size():
		var line : String = lines[i].strip_edges()
		
		# Imagem: ![alt](path)
		if line.begins_with("!"):
			var img_data = line.substr(2, line.find(")") - 2)  # remove ![
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
			i += 1
			continue
		
		# Tabelas: linhas com pipes |
		if line.find("|") != -1 and i + 1 < lines.size() and lines[i + 1].strip_edges().find("-") != -1:
			# Coleta cabeçalho e as linhas
			var header = line.split("|")
			header = header.slice(1, header.size()-2) # remove bordas
			var content_lines = []
			i += 2 # pula header e separador
			while i < lines.size() and lines[i].find("|") != -1:
				content_lines.append(lines[i].split("|").slice(1, header.size()+1))
				i += 1
			
			var cols = header.size()
			var grid = GridContainer.new()
			grid.columns = cols
			grid.add_theme_constant_override("hseparation", table_cell_padding)
			grid.add_theme_constant_override("vseparation", table_cell_padding)
			
			# Células do cabeçalho
			for h in header:
				var lbl = Label.new()
				lbl.text = h.strip_edges()
				lbl.add_theme_color_override("font_color", title_color)
				lbl.add_theme_font_size_override("font_size", subtitle_font_size)
				grid.add_child(lbl)
			
			# Conteúdo
			for row in content_lines:
				for cell in row:
					var c = Label.new()
					c.text = cell.strip_edges()
					c.add_theme_color_override("font_color", text_color)
					c.add_theme_font_size_override("font_size", normal_font_size)
					grid.add_child(c)
			
			root.add_child(grid)
			continue
		
		# Títulos #, ##, ### ...
		var hashes = line.find("#")
		if hashes != -1 and line.begins_with("#"):
			var lvl = line.get_slice(" ", 0).length()
			var text_content = line.substr(lvl + 1, line.length())
			var lbl : Label = Label.new()
			lbl.text = text_content
			lbl.add_theme_color_override("font_color", title_color if lvl == 1 else text_color)
			var size_lbl
			match lvl:
				1: size_lbl = title_font_size
				2: size_lbl = subtitle_font_size
				_: size_lbl = normal_font_size
			lbl.add_theme_font_size_override("font_size", size_lbl)
			root.add_child(lbl)
			i += 1
			continue
		
		# Parágrafos / texto simples
		if line != "":
			var rt = RichTextLabel.new()
			rt.bbcode_enabled = true
			rt.bbcode_text = line
			rt.add_theme_color_override("default_color", text_color)
			rt.add_theme_font_size_override("font_size", normal_font_size)
			rt.set_v_size_flags(Control.SIZE_SHRINK_END)
			root.add_child(rt)
		i += 1

	add_child(scroll)

	return scroll
