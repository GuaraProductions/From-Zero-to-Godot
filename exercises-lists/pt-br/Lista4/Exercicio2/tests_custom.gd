extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"class": "Inventario",
			"name": "✅ Inventário vazio retorna true",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_inventario_vazio"
		},
		{
			"class": "Inventario",
			"name": "➕ Adicionar item retorna ID válido",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_adicionar_item_retorna_id"
		},
		{
			"class": "Inventario",
			"name": "📦 Item adicionado aparece em get_itens()",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_item_em_get_itens"
		},
		{
			"class": "Inventario",
			"name": "🏷️ get_item_nome() retorna nome correto",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_get_item_nome"
		},
		{
			"class": "Inventario",
			"name": "📝 get_item_descricao() retorna descrição correta",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_get_item_descricao"
		},
		{
			"class": "Inventario",
			"name": "🔢 get_item_quantidade() retorna quantidade correta",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_get_item_quantidade"
		},
		{
			"class": "Inventario",
			"name": "🏷️🔢 get_item_nome_com_quantidade() retorna formato correto",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_get_item_nome_com_quantidade"
		},
		{
			"class": "Inventario",
			"name": "➖ Remover item decrementa quantidade",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_remover_item_decrementa"
		},
		{
			"class": "Inventario",
			"name": "🗑️ Remover item até zero remove do inventário",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_remover_item_completo"
		},
		{
			"class": "Inventario",
			"name": "❌ get_item_nome() com ID inválido retorna string vazia",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_get_item_nome_invalido"
		},
		{
			"class": "Inventario",
			"name": "❌ get_item_quantidade() com ID inválido retorna -1",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_get_item_quantidade_invalido"
		},
		{
			"class": "Item",
			"name": "📋 Item.to_dict() retorna dicionário correto",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_item_to_dict"
		},
		{
			"class": "Inventario",
			"name": "➕➕ Adicionar múltiplos itens retorna IDs incrementais",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_multiplos_itens"
		},
		{
			"class": "Inventario",
			"name": "📦 get_itens() retorna cópia do dicionário",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validar_get_itens_retorna_copia"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validar_inventario_vazio(resultado, instancia) -> Dictionary:
	var vazio = instancia.vazio()
	
	if not vazio is bool:
		return {
			"success": false,
			"error": "vazio() deve retornar um bool",
			"expected_output": true,
			"actual_output": vazio
		}
	
	if vazio != true:
		return {
			"success": false,
			"error": "Inventário novo deve estar vazio",
			"expected_output": true,
			"actual_output": vazio
		}
	
	return {"success": true, "error": ""}

func validar_adicionar_item_retorna_id(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Poção", "Restaura HP", null, 5)
	
	if not id is int:
		return {
			"success": false,
			"error": "adicionar_item() deve retornar um int (ID)",
			"expected_output": "int >= 0",
			"actual_output": str(type_string(typeof(id)))
		}
	
	if id < 0:
		return {
			"success": false,
			"error": "ID retornado deve ser >= 0",
			"expected_output": "ID >= 0",
			"actual_output": id
		}
	
	# Verifica se inventário não está mais vazio
	if instancia.vazio():
		return {
			"success": false,
			"error": "Após adicionar item, vazio() deve retornar false",
			"expected_output": false,
			"actual_output": true
		}
	
	return {"success": true, "error": ""}

func validar_item_em_get_itens(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Espada", "Arma de ataque", null, 1)
	var itens = instancia.get_itens()
	
	if not itens is Dictionary:
		return {
			"success": false,
			"error": "get_itens() deve retornar um Dictionary",
			"expected_output": "Dictionary",
			"actual_output": type_string(typeof(itens))
		}
	
	if not itens.has(id):
		return {
			"success": false,
			"error": "Item adicionado não aparece em get_itens()",
			"expected_output": "Dictionary com chave %d" % id,
			"actual_output": str(itens.keys())
		}
	
	var item = itens[id]
	if not item is Dictionary:
		return {
			"success": false,
			"error": "Item em get_itens() deve ser um Dictionary",
			"expected_output": "Dictionary",
			"actual_output": type_string(typeof(item))
		}
	
	return {"success": true, "error": ""}

func validar_get_item_nome(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Escudo", "Defesa +10", null, 2)
	var nome = instancia.get_item_nome(id)
	
	if not nome is String:
		return {
			"success": false,
			"error": "get_item_nome() deve retornar String",
			"expected_output": "String",
			"actual_output": type_string(typeof(nome))
		}
	
	if nome != "Escudo":
		return {
			"success": false,
			"error": "Nome retornado não corresponde ao item adicionado",
			"expected_output": "Escudo",
			"actual_output": nome
		}
	
	return {"success": true, "error": ""}

func validar_get_item_descricao(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Arco", "Arma de longo alcance", null, 1)
	var descricao = instancia.get_item_descricao(id)
	
	if not descricao is String:
		return {
			"success": false,
			"error": "get_item_descricao() deve retornar String",
			"expected_output": "String",
			"actual_output": type_string(typeof(descricao))
		}
	
	if descricao != "Arma de longo alcance":
		return {
			"success": false,
			"error": "Descrição retornada não corresponde ao item adicionado",
			"expected_output": "Arma de longo alcance",
			"actual_output": descricao
		}
	
	return {"success": true, "error": ""}

func validar_get_item_quantidade(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Flecha", "Munição para arco", null, 30)
	var quantidade = instancia.get_item_quantidade(id)
	
	if not quantidade is int:
		return {
			"success": false,
			"error": "get_item_quantidade() deve retornar int",
			"expected_output": "int",
			"actual_output": type_string(typeof(quantidade))
		}
	
	if quantidade != 30:
		return {
			"success": false,
			"error": "Quantidade retornada não corresponde ao item adicionado",
			"expected_output": 30,
			"actual_output": quantidade
		}
	
	return {"success": true, "error": ""}

func validar_get_item_nome_com_quantidade(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Poção de Mana", "Restaura MP", null, 8)
	var nome_com_qtd = instancia.get_item_nome_com_quantidade(id)
	
	if not nome_com_qtd is String:
		return {
			"success": false,
			"error": "get_item_nome_com_quantidade() deve retornar String",
			"expected_output": "String",
			"actual_output": type_string(typeof(nome_com_qtd))
		}
	
	# Aceita formatos: "Poção de Mana (8)" ou "Poção de Mana - 8" ou "Poção de Mana x8"
	var tem_nome = "Poção de Mana" in nome_com_qtd
	var tem_quantidade = "8" in nome_com_qtd
	
	if not tem_nome or not tem_quantidade:
		return {
			"success": false,
			"error": "String deve conter nome e quantidade do item",
			"expected_output": "String com 'Poção de Mana' e '8'",
			"actual_output": nome_com_qtd
		}
	
	return {"success": true, "error": ""}

func validar_remover_item_decrementa(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Bomba", "Explosivo", null, 10)
	
	var sucesso = instancia.remover_item(id, 3)
	
	if not sucesso is bool:
		return {
			"success": false,
			"error": "remover_item() deve retornar bool",
			"expected_output": "bool",
			"actual_output": type_string(typeof(sucesso))
		}
	
	var quantidade_apos = instancia.get_item_quantidade(id)
	
	if quantidade_apos != 7:
		return {
			"success": false,
			"error": "Após remover 3 de 10, deve restar 7",
			"expected_output": 7,
			"actual_output": quantidade_apos
		}
	
	return {"success": true, "error": ""}

func validar_remover_item_completo(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Pedra", "Material comum", null, 5)
	
	# Remove todos os itens
	instancia.remover_item(id, 5)
	
	var itens = instancia.get_itens()
	
	if itens.has(id):
		return {
			"success": false,
			"error": "Item com quantidade 0 deve ser removido do inventário",
			"expected_output": "Item não deve existir no dicionário",
			"actual_output": "Item ainda existe com quantidade %d" % itens[id].get("quantidade", -1)
		}
	
	return {"success": true, "error": ""}

func validar_get_item_nome_invalido(resultado, instancia) -> Dictionary:
	var nome = instancia.get_item_nome(999)
	
	if not nome is String:
		return {
			"success": false,
			"error": "get_item_nome() deve retornar String mesmo com ID inválido",
			"expected_output": "String vazia",
			"actual_output": type_string(typeof(nome))
		}
	
	if nome != "":
		return {
			"success": false,
			"error": "get_item_nome() com ID inválido deve retornar string vazia",
			"expected_output": '""',
			"actual_output": '"%s"' % nome
		}
	
	return {"success": true, "error": ""}

func validar_get_item_quantidade_invalido(resultado, instancia) -> Dictionary:
	var quantidade = instancia.get_item_quantidade(999)
	
	if not quantidade is int:
		return {
			"success": false,
			"error": "get_item_quantidade() deve retornar int mesmo com ID inválido",
			"expected_output": -1,
			"actual_output": type_string(typeof(quantidade))
		}
	
	if quantidade != -1:
		return {
			"success": false,
			"error": "get_item_quantidade() com ID inválido deve retornar -1",
			"expected_output": -1,
			"actual_output": quantidade
		}
	
	return {"success": true, "error": ""}

func validar_item_to_dict(resultado, instancia) -> Dictionary:
	# Carrega a classe Item do script do exercício
	var script_exercicio = load("res://listas/Lista4/Exercicio2/Exercicio2.gd")
	var classe_item = script_exercicio.Item
	
	var item = classe_item.new(0, 5, "Cristal", "Item raro", null)
	var dict = item.to_dict()
	
	if not dict is Dictionary:
		return {
			"success": false,
			"error": "to_dict() deve retornar um Dictionary",
			"expected_output": "Dictionary",
			"actual_output": type_string(typeof(dict))
		}
	
	# Verifica se tem as chaves necessárias
	var chaves_necessarias = ["id", "quantidade", "nome", "descricao", "textura"]
	for chave in chaves_necessarias:
		if not dict.has(chave):
			return {
				"success": false,
				"error": "to_dict() deve ter a chave '%s'" % chave,
				"expected_output": str(chaves_necessarias),
				"actual_output": str(dict.keys())
			}
	
	# Verifica valores
	if dict["id"] != 0:
		return {
			"success": false,
			"error": "Valor de 'id' incorreto",
			"expected_output": 0,
			"actual_output": dict["id"]
		}
	
	if dict["quantidade"] != 5:
		return {
			"success": false,
			"error": "Valor de 'quantidade' incorreto",
			"expected_output": 5,
			"actual_output": dict["quantidade"]
		}
	
	if dict["nome"] != "Cristal":
		return {
			"success": false,
			"error": "Valor de 'nome' incorreto",
			"expected_output": "Cristal",
			"actual_output": dict["nome"]
		}
	
	if dict["descricao"] != "Item raro":
		return {
			"success": false,
			"error": "Valor de 'descricao' incorreto",
			"expected_output": "Item raro",
			"actual_output": dict["descricao"]
		}
	
	return {"success": true, "error": ""}

func validar_multiplos_itens(resultado, instancia) -> Dictionary:
	var id1 = instancia.adicionar_item("Item A", "Desc A", null, 1)
	var id2 = instancia.adicionar_item("Item B", "Desc B", null, 2)
	var id3 = instancia.adicionar_item("Item C", "Desc C", null, 3)
	
	# Verifica se IDs são diferentes
	if id1 == id2 or id2 == id3 or id1 == id3:
		return {
			"success": false,
			"error": "IDs dos itens devem ser únicos",
			"expected_output": "IDs diferentes",
			"actual_output": "IDs: %d, %d, %d" % [id1, id2, id3]
		}
	
	# Verifica se todos estão no inventário
	var itens = instancia.get_itens()
	if not itens.has(id1) or not itens.has(id2) or not itens.has(id3):
		return {
			"success": false,
			"error": "Todos os itens adicionados devem estar no inventário",
			"expected_output": "3 itens no inventário",
			"actual_output": "%d itens no inventário" % itens.size()
		}
	
	return {"success": true, "error": ""}

func validar_get_itens_retorna_copia(resultado, instancia) -> Dictionary:
	var id = instancia.adicionar_item("Gema", "Preciosa", null, 1)
	
	var itens1 = instancia.get_itens()
	var itens2 = instancia.get_itens()
	
	# Modifica a primeira cópia
	itens1.clear()
	
	# Verifica se a segunda cópia ainda tem o item
	if not itens2.has(id):
		return {
			"success": false,
			"error": "get_itens() deve retornar uma cópia, não referência direta",
			"expected_output": "Modificar cópia não afeta outras",
			"actual_output": "Modificação afetou outras cópias"
		}
	
	# Verifica se o inventário original não foi afetado
	var itens3 = instancia.get_itens()
	if not itens3.has(id):
		return {
			"success": false,
			"error": "get_itens() deve retornar cópia, inventário original foi modificado",
			"expected_output": "Inventário original intacto",
			"actual_output": "Inventário original foi modificado"
		}
	
	return {"success": true, "error": ""}
