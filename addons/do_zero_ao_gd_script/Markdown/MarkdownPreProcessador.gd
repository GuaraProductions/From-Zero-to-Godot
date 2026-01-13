@icon("res://addons/do_zero_ao_gd_script/icons/markdown.svg")
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
@export_range(0,50) var paragraph_spacing: int = 10
@export_range(0,30) var line_spacing: int = 2
@export var syntax_highlighters: Dictionary[String, CodeHighlighter] = {}  
@export var debug_mode: bool = false

# Sinal para solicitar abertura de cenas no editor
signal abrir_cena_solicitada(caminho_cena: String)
signal abrir_teste_solicitado(lista: String, exercicio: String)

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
	
	# Extrai o diretório base do arquivo markdown para resolver caminhos relativos
	var base_dir = md_path.get_base_dir()
	_debug_print("=== INICIANDO PARSE DO MARKDOWN ===")
	_debug_print("Arquivo: " + md_path)
	_debug_print("Diretório base: " + base_dir)

	# Cria o container principal da "cena"
	var scroll = ScrollContainer.new()
	scroll.name = "Scroll"
	scroll.anchor_right = 1
	scroll.anchor_bottom = 1
	scroll.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	scroll.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED

	# Cria o container principal da "cena"
	var root = VBoxContainer.new()
	root.name = "MarkdownScene"
	root.anchor_right = 1
	root.anchor_bottom = 1
	root.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	root.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	# Adiciona espaçamento entre elementos
	root.add_theme_constant_override("separation", paragraph_spacing)

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
		
		# Detecta blocos de código ```
		if line_stripped.begins_with("```"):
			_debug_print("[Linha %d] BLOCO DE CÓDIGO detectado" % linha_count)
			
			# Extrai a linguagem (se especificada)
			var linguagem = line_stripped.substr(3).strip_edges()
			if linguagem.is_empty():
				linguagem = "text"
			_debug_print("  -> Linguagem: %s" % linguagem)
			
			# Coleta o conteúdo do bloco
			var codigo_conteudo = ""
			i += 1
			linha_count += 1
			
			while i < lines.size():
				var code_line = lines[i]
				if code_line.strip_edges().begins_with("```"):
					_debug_print("  -> Fim do bloco de código na linha %d" % linha_count)
					break
				codigo_conteudo += code_line + "\n"
				i += 1
				linha_count += 1
			
			# Adiciona o bloco de código
			_adicionar_bloco_codigo(root, codigo_conteudo, linguagem)
			i += 1
			continue
		
		# Desenha linhas de separação ---
		if line_stripped.begins_with("---"):
			_debug_print("[Linha %d] SEPARADOR --- - adicionando linha visual" % linha_count)
			var separator = HSeparator.new()
			separator.custom_minimum_size = Vector2(0, 2)
			root.add_child(separator)
			i += 1
			continue
		
		# Imagem: ![alt](path)
		if line_stripped.begins_with("!"):
			_debug_print("[Linha %d] IMAGEM detectada: %s" % [linha_count, line_stripped])
			var img_data = line_stripped.substr(2, line_stripped.find(")") - 2)  # remove ![
			var parts = img_data.split("](")
			if parts.size() == 2:
				var relative_path = parts[1].strip_edges()
				# Resolve o caminho relativo ao diretório do markdown
				var full_path = base_dir.path_join(relative_path)
				_debug_print("  -> Caminho relativo: %s" % relative_path)
				_debug_print("  -> Caminho completo: %s" % full_path)
				
				var tex = load(full_path) 
				if tex:
					# Container para centralizar a imagem
					var img_container = CenterContainer.new()
					img_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
					
					var img = TextureRect.new()
					img.texture = tex
					img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
					img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
					
					# Limita o tamanho da imagem com margem de segurança
					var img_size = tex.get_size()
					var max_width = 700  # Largura máxima em pixels (com margem de segurança)
					if img_size.x > max_width:
						var scale_factor = max_width / img_size.x
						img.custom_minimum_size = Vector2(max_width, img_size.y * scale_factor)
					else:
						img.custom_minimum_size = img_size
					
					img_container.add_child(img)
					root.add_child(img_container)
					_debug_print("  -> Imagem adicionada com sucesso (tamanho: %s)" % str(img.custom_minimum_size))
				else:
					_debug_print("  -> ERRO: Não foi possível carregar a imagem: " + full_path)
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
			
			# Verifica se a próxima linha contém [open_scene] ou [open_test]
			var caminho_cena = ""
			var caminho_teste = ""
			var linhas_puladas = 0
			
			# Verifica até 3 linhas à frente para encontrar [open_scene] e [open_test]
			for offset in range(1, 4):
				if i + offset >= lines.size():
					break
					
				var check_line = lines[i + offset].strip_edges()
				
				# Verifica [open_scene] (pode estar junto com [open_test] na mesma linha)
				if caminho_cena.is_empty() and check_line.find("[open_scene](") != -1:
					var regex_scene = RegEx.new()
					regex_scene.compile("\\[open_scene\\]\\(([^)]+)\\)")
					var match_scene = regex_scene.search(check_line)
					if match_scene:
						caminho_cena = match_scene.get_string(1).strip_edges()
						linhas_puladas = max(linhas_puladas, offset)
						_debug_print("  -> Caminho de cena detectado: %s" % caminho_cena)
				
				# Verifica [open_test] (pode estar junto com [open_scene] na mesma linha)
				if caminho_teste.is_empty() and check_line.find("[open_test](") != -1:
					var regex_test = RegEx.new()
					regex_test.compile("\\[open_test\\]\\(([^)]+)\\)")
					var match_test = regex_test.search(check_line)
					if match_test:
						caminho_teste = match_test.get_string(1).strip_edges()
						linhas_puladas = max(linhas_puladas, offset)
						_debug_print("  -> Caminho de teste detectado: %s" % caminho_teste)
				
				# Se encontrou ambos ou a linha está vazia, para de procurar
				if (not caminho_cena.is_empty() and not caminho_teste.is_empty()) or check_line.is_empty():
					break
			
			# Pula as linhas que continham os atalhos
			i += linhas_puladas
			linha_count += linhas_puladas
			
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
			
			# Cria HBoxContainer para título + botão (se houver cena)
			var hbox = HBoxContainer.new()
			hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			
			var rt = RichTextLabel.new()
			rt.bbcode_enabled = true
			rt.fit_content = true
			rt.scroll_active = false
			rt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			rt.bbcode_text = "[font_size=%d]%s[/font_size]" % [size_lbl, text_content]
			rt.add_theme_color_override("default_color", cor_titulo)
			rt.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
			hbox.add_child(rt)
			
			# Adiciona botão de abrir cena se houver caminho
			if not caminho_cena.is_empty():
				var full_scene_path = base_dir.path_join(caminho_cena)
				var btn = Button.new()
				btn.text = "📂 Abrir Cena"
				btn.custom_minimum_size = Vector2(120, 0)
				btn.pressed.connect(_on_botao_abrir_cena_pressed.bind(full_scene_path))
				hbox.add_child(btn)
				_debug_print("  -> Botão de abrir cena adicionado para: %s" % full_scene_path)
			
			# Adiciona botão de abrir teste se houver caminho
			if not caminho_teste.is_empty():
				# Extrai lista e exercício do caminho
				var partes = caminho_teste.split("/")
				if partes.size() >= 2:
					var lista = partes[-2]  # Penúltimo elemento
					var exercicio = partes[-1].get_basename()  # Último elemento sem extensão
					
					var btn_teste = Button.new()
					btn_teste.text = "🧪 Testar"
					btn_teste.custom_minimum_size = Vector2(100, 0)
					btn_teste.pressed.connect(_on_botao_abrir_teste_pressed.bind(lista, exercicio))
					hbox.add_child(btn_teste)
					_debug_print("  -> Botão de teste adicionado para: Lista=%s, Exercicio=%s" % [lista, exercicio])
			
			root.add_child(hbox)
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
		rt.add_theme_constant_override("line_separation", line_spacing)
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

func _adicionar_bloco_codigo(container: VBoxContainer, codigo: String, linguagem: String) -> void:
	_debug_print("  -> Adicionando bloco de código (linguagem: %s, linhas: %d)" % [linguagem, codigo.count("\n")])
	
	# Cria o CodeEdit
	var code_edit = CodeEdit.new()
	code_edit.text = codigo.strip_edges()
	code_edit.editable = false
	code_edit.scroll_fit_content_height = true
	code_edit.wrap_mode = TextEdit.LINE_WRAPPING_NONE
	code_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	code_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	code_edit.custom_minimum_size = Vector2(0, 100)
	
	# Aplica o syntax highlighter se disponível
	if syntax_highlighters.has(linguagem):
		code_edit.gutters_draw_line_numbers = true
		var highlighter: CodeHighlighter = syntax_highlighters[linguagem]
		if highlighter:
			code_edit.syntax_highlighter = highlighter
			_debug_print("    -> Syntax highlighter aplicado para: %s" % linguagem)
		else:
			_debug_print("    -> Syntax highlighter configurado mas null para: %s" % linguagem)
	else:
		_debug_print("    -> Nenhum syntax highlighter disponível para: %s" % linguagem)
	
	# Configura cores e estilo
	code_edit.add_theme_color_override("background_color", Color(0.1, 0.1, 0.12))
	code_edit.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
	code_edit.add_theme_font_size_override("font_size", normal_font_size)
	
	# Cria o botão de copiar
	var btn_copiar = Button.new()
	btn_copiar.text = "📋 Copiar"
	btn_copiar.custom_minimum_size = Vector2(100, 30)

	# Configura âncoras para canto superior direito
	btn_copiar.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	btn_copiar.offset_left = -110  # 100 (largura) + 10 (margem direita)
	btn_copiar.offset_top = 8      # Margem do topo
	btn_copiar.offset_right = -10  # Margem da direita
	btn_copiar.offset_bottom = 38  # 30 (altura) + 8 (margem do topo)
	btn_copiar.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	btn_copiar.grow_vertical = Control.GROW_DIRECTION_END
	
	# Estilo do botão
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = Color(0.2, 0.25, 0.3, 0.9)
	style_normal.corner_radius_top_left = 4
	style_normal.corner_radius_top_right = 4
	style_normal.corner_radius_bottom_left = 4
	style_normal.corner_radius_bottom_right = 4
	btn_copiar.add_theme_stylebox_override("normal", style_normal)
	
	var style_hover = StyleBoxFlat.new()
	style_hover.bg_color = Color(0.3, 0.35, 0.4, 0.95)
	style_hover.corner_radius_top_left = 4
	style_hover.corner_radius_top_right = 4
	style_hover.corner_radius_bottom_left = 4
	style_hover.corner_radius_bottom_right = 4
	btn_copiar.add_theme_stylebox_override("hover", style_hover)
	
	var style_pressed = StyleBoxFlat.new()
	style_pressed.bg_color = Color(0.15, 0.2, 0.25, 1.0)
	style_pressed.corner_radius_top_left = 4
	style_pressed.corner_radius_top_right = 4
	style_pressed.corner_radius_bottom_left = 4
	style_pressed.corner_radius_bottom_right = 4
	btn_copiar.add_theme_stylebox_override("pressed", style_pressed)
	
	# Conecta o sinal de clique
	btn_copiar.pressed.connect(_on_copiar_codigo_pressed.bind(code_edit, btn_copiar))

	code_edit.add_child(btn_copiar)
	container.add_child(code_edit)
	_debug_print("  -> Bloco de código adicionado com sucesso (com botão copiar)")

func _on_copiar_codigo_pressed(code_edit: CodeEdit, btn: Button) -> void:
	var codigo = code_edit.text
	DisplayServer.clipboard_set(codigo)
	_debug_print("Código copiado para o clipboard (%d caracteres)" % codigo.length())
	
	# Feedback visual: muda temporariamente o texto do botão
	var texto_original = btn.text
	btn.text = "✓ Copiado!"
	await get_tree().create_timer(1.5).timeout
	if is_instance_valid(btn):
		btn.text = texto_original

func _on_botao_abrir_cena_pressed(caminho_cena: String) -> void:
	_debug_print("Solicitando abertura da cena: %s" % caminho_cena)
	if FileAccess.file_exists(caminho_cena):
		abrir_cena_solicitada.emit(caminho_cena)
	else:
		push_error("Cena não encontrada: %s" % caminho_cena)

func _on_botao_abrir_teste_pressed(lista: String, exercicio: String) -> void:
	_debug_print("Solicitando abertura do teste: Lista=%s, Exercicio=%s" % [lista, exercicio])
	abrir_teste_solicitado.emit(lista, exercicio)
