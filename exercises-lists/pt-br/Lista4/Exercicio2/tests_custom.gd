extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"classe": "Inventario",
			"nome": "✅ Inventário vazio retorna true",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_inventario_vazio"
		},
		{
			"classe": "Inventario",
			"nome": "➕ Adicionar item retorna ID válido",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_adicionar_item_retorna_id"
		},
		{
			"classe": "Inventario",
			"nome": "📦 Item adicionado aparece em get_itens()",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_item_em_get_itens"
		},
		{
			"classe": "Inventario",
			"nome": "🏷️ get_item_nome() retorna nome correto",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_get_item_nome"
		},
		{
			"classe": "Inventario",
			"nome": "📝 get_item_descricao() retorna descrição correta",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_get_item_descricao"
		},
		{
			"classe": "Inventario",
			"nome": "🔢 get_item_quantidade() retorna quantidade correta",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_get_item_quantidade"
		},
		{
			"classe": "Inventario",
			"nome": "🏷️🔢 get_item_nome_com_quantidade() retorna formato correto",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_get_item_nome_com_quantidade"
		},
		{
			"classe": "Inventario",
			"nome": "➖ Remover item decrementa quantidade",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_remover_item_decrementa"
		},
		{
			"classe": "Inventario",
			"nome": "🗑️ Remover item até zero remove do inventário",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_remover_item_completo"
		},
		{
			"classe": "Inventario",
			"nome": "❌ get_item_nome() com ID inválido retorna string vazia",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_get_item_nome_invalido"
		},
		{
			"classe": "Inventario",
			"nome": "❌ get_item_quantidade() com ID inválido retorna -1",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_get_item_quantidade_invalido"
		},
		{
			"classe": "Item",
			"nome": "📋 Item.to_dict() retorna dicionário correto",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_item_to_dict"
		},
		{
			"classe": "Inventario",
			"nome": "➕➕ Adicionar múltiplos itens retorna IDs incrementais",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_multiplos_itens"
		},
		{
			"classe": "Inventario",
			"nome": "📦 get_itens() retorna cópia do dicionário",
			"metodo": "",
			"construtor_params": [],
			"entrada": [],
			"validar": "validar_get_itens_retorna_copia"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_inventario_vazio(resultado, instancia) -> Dictionary:
	var vazio = instancia.vazio()
	
	if not vazio is bool:
		return {
			"sucesso": false,
			"erro": "vazio() deve retornar um bool",
			"saida_esperada": true,
			"saida_obtida": vazio
		}
	
	if vazio != true:
		return {
			"sucesso": false,
			"erro": "Inventário novo deve estar vazio",
			"saida_esperada": true,
			"saida_obtida": vazio
		}
	
	return {"sucesso": true, "erro": ""}

func validar_adicionar_item_retorna_id(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Poção", "Restaura HP", null, 5)
	
	if not id is int:
		return {
			"sucesso": false,
			"erro": "adicionar_item() deve retornar um int (ID)",
			"saida_esperada": "int >= 0",
			"saida_obtida": str(type_string(typeof(id)))
		}
	
	if id < 0:
		return {
			"sucesso": false,
			"erro": "ID retornado deve ser >= 0",
			"saida_esperada": "ID >= 0",
			"saida_obtida": id
		}
	
	# Verifica se inventário não está mais vazio
	if instancia.vazio():
		return {
			"sucesso": false,
			"erro": "Após adicionar item, vazio() deve retornar false",
			"saida_esperada": false,
			"saida_obtida": true
		}
	
	return {"sucesso": true, "erro": ""}

func validar_item_em_get_itens(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Espada", "Arma de ataque", null, 1)
	var itens = instancia.get_itens()
	
	if not itens is Dictionary:
		return {
			"sucesso": false,
			"erro": "get_itens() deve retornar um Dictionary",
			"saida_esperada": "Dictionary",
			"saida_obtida": type_string(typeof(itens))
		}
	
	if not itens.has(id):
		return {
			"sucesso": false,
			"erro": "Item adicionado não aparece em get_itens()",
			"saida_esperada": "Dictionary com chave %d" % id,
			"saida_obtida": str(itens.keys())
		}
	
	var item = itens[id]
	if not item is Dictionary:
		return {
			"sucesso": false,
			"erro": "Item em get_itens() deve ser um Dictionary",
			"saida_esperada": "Dictionary",
			"saida_obtida": type_string(typeof(item))
		}
	
	return {"sucesso": true, "erro": ""}

func validar_get_item_nome(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Escudo", "Defesa +10", null, 2)
	var nome = instancia.get_item_nome(id)
	
	if not nome is String:
		return {
			"sucesso": false,
			"erro": "get_item_nome() deve retornar String",
			"saida_esperada": "String",
			"saida_obtida": type_string(typeof(nome))
		}
	
	if nome != "Escudo":
		return {
			"sucesso": false,
			"erro": "Nome retornado não corresponde ao item adicionado",
			"saida_esperada": "Escudo",
			"saida_obtida": nome
		}
	
	return {"sucesso": true, "erro": ""}

func validar_get_item_descricao(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Arco", "Arma de longo alcance", null, 1)
	var descricao = instancia.get_item_descricao(id)
	
	if not descricao is String:
		return {
			"sucesso": false,
			"erro": "get_item_descricao() deve retornar String",
			"saida_esperada": "String",
			"saida_obtida": type_string(typeof(descricao))
		}
	
	if descricao != "Arma de longo alcance":
		return {
			"sucesso": false,
			"erro": "Descrição retornada não corresponde ao item adicionado",
			"saida_esperada": "Arma de longo alcance",
			"saida_obtida": descricao
		}
	
	return {"sucesso": true, "erro": ""}

func validar_get_item_quantidade(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Flecha", "Munição para arco", null, 30)
	var quantidade = instancia.get_item_quantidade(id)
	
	if not quantidade is int:
		return {
			"sucesso": false,
			"erro": "get_item_quantidade() deve retornar int",
			"saida_esperada": "int",
			"saida_obtida": type_string(typeof(quantidade))
		}
	
	if quantidade != 30:
		return {
			"sucesso": false,
			"erro": "Quantidade retornada não corresponde ao item adicionado",
			"saida_esperada": 30,
			"saida_obtida": quantidade
		}
	
	return {"sucesso": true, "erro": ""}

func validar_get_item_nome_com_quantidade(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Poção de Mana", "Restaura MP", null, 8)
	var nome_com_qtd = instancia.get_item_nome_com_quantidade(id)
	
	if not nome_com_qtd is String:
		return {
			"sucesso": false,
			"erro": "get_item_nome_com_quantidade() deve retornar String",
			"saida_esperada": "String",
			"saida_obtida": type_string(typeof(nome_com_qtd))
		}
	
	# Aceita formatos: "Poção de Mana (8)" ou "Poção de Mana - 8" ou "Poção de Mana x8"
	var tem_nome = "Poção de Mana" in nome_com_qtd
	var tem_quantidade = "8" in nome_com_qtd
	
	if not tem_nome or not tem_quantidade:
		return {
			"sucesso": false,
			"erro": "String deve conter nome e quantidade do item",
			"saida_esperada": "String com 'Poção de Mana' e '8'",
			"saida_obtida": nome_com_qtd
		}
	
	return {"sucesso": true, "erro": ""}

func validar_remover_item_decrementa(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Bomba", "Explosivo", null, 10)
	
	var sucesso = instancia.remover_item(id, 3)
	
	if not sucesso is bool:
		return {
			"sucesso": false,
			"erro": "remover_item() deve retornar bool",
			"saida_esperada": "bool",
			"saida_obtida": type_string(typeof(sucesso))
		}
	
	var quantidade_apos = instancia.get_item_quantidade(id)
	
	if quantidade_apos != 7:
		return {
			"sucesso": false,
			"erro": "Após remover 3 de 10, deve restar 7",
			"saida_esperada": 7,
			"saida_obtida": quantidade_apos
		}
	
	return {"sucesso": true, "erro": ""}

func validar_remover_item_completo(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Pedra", "Material comum", null, 5)
	
	# Remove todos os itens
	instancia.remover_item(id, 5)
	
	var itens = instancia.get_itens()
	
	if itens.has(id):
		return {
			"sucesso": false,
			"erro": "Item com quantidade 0 deve ser removido do inventário",
			"saida_esperada": "Item não deve existir no dicionário",
			"saida_obtida": "Item ainda existe com quantidade %d" % itens[id].get("quantidade", -1)
		}
	
	return {"sucesso": true, "erro": ""}

func validar_get_item_nome_invalido(resultado, instancia) -> Dictionary:
	var nome = instancia.get_item_nome(999)
	
	if not nome is String:
		return {
			"sucesso": false,
			"erro": "get_item_nome() deve retornar String mesmo com ID inválido",
			"saida_esperada": "String vazia",
			"saida_obtida": type_string(typeof(nome))
		}
	
	if nome != "":
		return {
			"sucesso": false,
			"erro": "get_item_nome() com ID inválido deve retornar string vazia",
			"saida_esperada": '""',
			"saida_obtida": '"%s"' % nome
		}
	
	return {"sucesso": true, "erro": ""}

func validar_get_item_quantidade_invalido(resultado, instancia) -> Dictionary:
	var quantidade = instancia.get_item_quantidade(999)
	
	if not quantidade is int:
		return {
			"sucesso": false,
			"erro": "get_item_quantidade() deve retornar int mesmo com ID inválido",
			"saida_esperada": -1,
			"saida_obtida": type_string(typeof(quantidade))
		}
	
	if quantidade != -1:
		return {
			"sucesso": false,
			"erro": "get_item_quantidade() com ID inválido deve retornar -1",
			"saida_esperada": -1,
			"saida_obtida": quantidade
		}
	
	return {"sucesso": true, "erro": ""}

func validar_item_to_dict(resultado, instancia) -> Dictionary:
	# Carrega a classe Item do script do exercício
	var script_exercicio = load("res://listas/Lista4/Exercicio2/Exercicio2.gd")
	var classe_item = script_exercicio.Item
	
	var item = classe_item.new(0, 5, "Cristal", "Item raro", null)
	var dict = item.to_dict()
	
	if not dict is Dictionary:
		return {
			"sucesso": false,
			"erro": "to_dict() deve retornar um Dictionary",
			"saida_esperada": "Dictionary",
			"saida_obtida": type_string(typeof(dict))
		}
	
	# Verifica se tem as chaves necessárias
	var chaves_necessarias = ["id", "quantidade", "nome", "descricao", "textura"]
	for chave in chaves_necessarias:
		if not dict.has(chave):
			return {
				"sucesso": false,
				"erro": "to_dict() deve ter a chave '%s'" % chave,
				"saida_esperada": str(chaves_necessarias),
				"saida_obtida": str(dict.keys())
			}
	
	# Verifica valores
	if dict["id"] != 0:
		return {
			"sucesso": false,
			"erro": "Valor de 'id' incorreto",
			"saida_esperada": 0,
			"saida_obtida": dict["id"]
		}
	
	if dict["quantidade"] != 5:
		return {
			"sucesso": false,
			"erro": "Valor de 'quantidade' incorreto",
			"saida_esperada": 5,
			"saida_obtida": dict["quantidade"]
		}
	
	if dict["nome"] != "Cristal":
		return {
			"sucesso": false,
			"erro": "Valor de 'nome' incorreto",
			"saida_esperada": "Cristal",
			"saida_obtida": dict["nome"]
		}
	
	if dict["descricao"] != "Item raro":
		return {
			"sucesso": false,
			"erro": "Valor de 'descricao' incorreto",
			"saida_esperada": "Item raro",
			"saida_obtida": dict["descricao"]
		}
	
	return {"sucesso": true, "erro": ""}

func validar_multiplos_itens(resultado, instancia) -> Dictionary:
	var id1 = instancia.adicionar_item("Item A", "Desc A", null, 1)
	var id2 = instancia.adicionar_item("Item B", "Desc B", null, 2)
	var id3 = instancia.adicionar_item("Item C", "Desc C", null, 3)
	
	# Verifica se IDs são diferentes
	if id1 == id2 or id2 == id3 or id1 == id3:
		return {
			"sucesso": false,
			"erro": "IDs dos itens devem ser únicos",
			"saida_esperada": "IDs diferentes",
			"saida_obtida": "IDs: %d, %d, %d" % [id1, id2, id3]
		}
	
	# Verifica se todos estão no inventário
	var itens = instancia.get_itens()
	if not itens.has(id1) or not itens.has(id2) or not itens.has(id3):
		return {
			"sucesso": false,
			"erro": "Todos os itens adicionados devem estar no inventário",
			"saida_esperada": "3 itens no inventário",
			"saida_obtida": "%d itens no inventário" % itens.size()
		}
	
	return {"sucesso": true, "erro": ""}

func validar_get_itens_retorna_copia(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Gema", "Preciosa", null, 1)
	
	var itens1 = instancia.get_itens()
	var itens2 = instancia.get_itens()
	
	# Modifica a primeira cópia
	itens1.clear()
	
	# Verifica se a segunda cópia ainda tem o item
	if not itens2.has(id):
		return {
			"sucesso": false,
			"erro": "get_itens() deve retornar uma cópia, não referência direta",
			"saida_esperada": "Modificar cópia não afeta outras",
			"saida_obtida": "Modificação afetou outras cópias"
		}
	
	# Verifica se o inventário original não foi afetado
	var itens3 = instancia.get_itens()
	if not itens3.has(id):
		return {
			"sucesso": false,
			"erro": "get_itens() deve retornar cópia, inventário original foi modificado",
			"saida_esperada": "Inventário original intacto",
			"saida_obtida": "Inventário original foi modificado"
		}
	
	return {"sucesso": true, "erro": ""}
