extends Node

func get_test_cases() -> Array[Dictionary]:
	return [
		{
			"class": "Inventory",
			"name": "✅ Inventory is_empty returns true",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_inventory_is_empty"
		},
		{
			"class": "Inventory",
			"name": "➕ Add item returns valid ID",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_add_item_returns_id"
		},
		{
			"class": "Inventory",
			"name": "📦 Added item appears in get_items()",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_item_in_get_items"
		},
		{
			"class": "Inventory",
			"name": "🏷️ get_item_name() returns correct name",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_get_item_name"
		},
		{
			"class": "Inventory",
			"name": "📝 get_item_description() returns correct description",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_get_item_description"
		},
		{
			"class": "Inventory",
			"name": "🔢 get_item_quantity() returns correct quantity",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_get_item_quantity"
		},
		{
			"class": "Inventory",
			"name": "🏷️🔢 get_item_name_with_quantity() returns correct format",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_get_item_name_with_quantity"
		},
		{
			"class": "Inventory",
			"name": "➖ Remove item decrements quantity",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_remove_item_decrements"
		},
		{
			"class": "Inventory",
			"name": "🗑️ Remove item to zero removes from inventory",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_remove_item_complete"
		},
		{
			"class": "Inventory",
			"name": "❌ get_item_name() with invalid ID returns empty string",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_get_item_name_invalid"
		},
		{
			"class": "Inventory",
			"name": "❌ get_item_quantity() with invalid ID returns -1",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_get_item_quantity_invalid"
		},
		{
			"class": "Item",
			"name": "📋 Item.to_dict() returns correct dictionary",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_item_to_dict"
		},
		{
			"class": "Inventory",
			"name": "➕➕ Add multiple items returns incremental IDs",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_multiple_items"
		},
		{
			"class": "Inventory",
			"name": "📦 get_items() returns dictionary copy",
			"method": "",
			"constructor_params": [],
			"input": [],
			"validate": "validate_get_items_returns_copy"
		}
	]

# ===== FUNÇÕES DE VALIDAÇÃO =====

func validate_inventory_is_empty(resultado, instancia) -> Dictionary:
	var is_empty = instancia.is_empty()
	
	if not is_empty is bool:
		return {
			"success": false,
			"error": "is_empty() must return a bool",
			"expected_output": true,
			"actual_output": is_empty
		}
	
	if is_empty != true:
		return {
			"success": false,
			"error": "New inventory must be is_empty",
			"expected_output": true,
			"actual_output": is_empty
		}
	
	return {"success": true, "error": ""}

func validate_add_item_returns_id(resultado, instancia) -> Dictionary:
	var id = instancia.add_item("Poção", "Restaura HP", null, 5)
	
	if not id is int:
		return {
			"success": false,
			"error": "add_item() must return an int (ID)",
			"expected_output": "int >= 0",
			"actual_output": str(type_string(typeof(id)))
		}
	
	if id < 0:
		return {
			"success": false,
			"error": "Returned ID must be >= 0",
			"expected_output": "ID >= 0",
			"actual_output": id
		}
	
	# Verifica se inventário não está mais is_empty
	if instancia.is_empty():
		return {
			"success": false,
			"error": "After adding item, is_empty() must return false",
			"expected_output": false,
			"actual_output": true
		}
	
	return {"success": true, "error": ""}

func validate_item_in_get_items(resultado, instancia) -> Dictionary:
	var id = instancia.add_item("Espada", "Arma de ataque", null, 1)
	var itens = instancia.get_items()
	
	if not itens is Dictionary:
		return {
			"success": false,
			"error": "get_items() must return a Dictionary",
			"expected_output": "Dictionary",
			"actual_output": type_string(typeof(itens))
		}
	
	if not itens.has(id):
		return {
			"success": false,
			"error": "Added item does not appear in get_items()",
			"expected_output": "Dictionary with key %d" % id,
			"actual_output": str(itens.keys())
		}
	
	var item = itens[id]
	if not item is Dictionary:
		return {
			"success": false,
			"error": "Item in get_items() must be a Dictionary",
			"expected_output": "Dictionary",
			"actual_output": type_string(typeof(item))
		}
	
	return {"success": true, "error": ""}

func validate_get_item_name(resultado, instancia) -> Dictionary:
	var id = instancia.add_item("Escudo", "Defesa +10", null, 2)
	var nome = instancia.get_item_name(id)
	
	if not nome is String:
		return {
			"success": false,
			"error": "get_item_name() must return a String",
			"expected_output": "String",
			"actual_output": type_string(typeof(nome))
		}
	
	if nome != "Escudo":
		return {
			"success": false,
			"error": "Returned name does not match added item",
			"expected_output": "Escudo",
			"actual_output": nome
		}
	
	return {"success": true, "error": ""}

func validate_get_item_description(resultado, instancia) -> Dictionary:
	var id = instancia.add_item("Arco", "Arma de longo alcance", null, 1)
	var description = instancia.get_item_description(id)
	
	if not description is String:
		return {
			"success": false,
			"error": "get_item_description() must return a String",
			"expected_output": "String",
			"actual_output": type_string(typeof(description))
		}
	
	if description != "Arma de longo alcance":
		return {
			"success": false,
			"error": "Returned description does not match added item",
			"expected_output": "Arma de longo alcance",
			"actual_output": description
		}
	
	return {"success": true, "error": ""}

func validate_get_item_quantity(resultado, instancia) -> Dictionary:
	var id = instancia.add_item("Flecha", "Munição para arco", null, 30)
	var quantity = instancia.get_item_quantity(id)
	
	if not quantity is int:
		return {
			"success": false,
			"error": "get_item_quantity() deve retornar int",
			"expected_output": "int",
			"actual_output": type_string(typeof(quantity))
		}
	
	if quantity != 30:
		return {
			"success": false,
			"error": "Returned quantity does not match added item",
			"expected_output": 30,
			"actual_output": quantity
		}
	
	return {"success": true, "error": ""}

func validate_get_item_name_with_quantity(resultado, instancia) -> Dictionary:
	var id = instancia.add_item("Poção de Mana", "Restaura MP", null, 8)
	var nome_com_qtd = instancia.get_item_name_com_quantity(id)
	
	if not nome_com_qtd is String:
		return {
			"success": false,
			"error": "get_item_name_com_quantity() must return a String",
			"expected_output": "String",
			"actual_output": type_string(typeof(nome_com_qtd))
		}
	
	# Aceita formatos: "Poção de Mana (8)" ou "Poção de Mana - 8" ou "Poção de Mana x8"
	var tem_nome = "Poção de Mana" in nome_com_qtd
	var tem_quantity = "8" in nome_com_qtd
	
	if not tem_nome or not tem_quantity:
		return {
			"success": false,
			"error": "String must contain item name and quantity",
			"expected_output": "String with 'Poção de Mana' e '8'",
			"actual_output": nome_com_qtd
		}
	
	return {"success": true, "error": ""}

func validate_remove_item_decrements(resultado, instancia) -> Dictionary:
	var id = instancia.add_item("Bomba", "Explosivo", null, 10)
	
	var sucesso = instancia.remove_item(id, 3)
	
	if not sucesso is bool:
		return {
			"success": false,
			"error": "remove_item() deve retornar bool",
			"expected_output": "bool",
			"actual_output": type_string(typeof(sucesso))
		}
	
	var quantity_apos = instancia.get_item_quantity(id)
	
	if quantity_apos != 7:
		return {
			"success": false,
			"error": "After removing 3 from 10, must remain 7",
			"expected_output": 7,
			"actual_output": quantity_apos
		}
	
	return {"success": true, "error": ""}

func validate_remove_item_complete(resultado, instancia) -> Dictionary:
	var id = instancia.add_item("Pedra", "Material comum", null, 5)
	
	# Remove todos os itens
	instancia.remove_item(id, 5)
	
	var itens = instancia.get_items()
	
	if itens.has(id):
		return {
			"success": false,
			"error": "Item with quantity 0 must be removed from inventory",
			"expected_output": "Item must not exist in dictionary",
			"actual_output": "Item still exists with quantity %d" % itens[id].get("quantity", -1)
		}
	
	return {"success": true, "error": ""}

func validate_get_item_name_invalid(resultado, instancia) -> Dictionary:
	var nome = instancia.get_item_name(999)
	
	if not nome is String:
		return {
			"success": false,
			"error": "get_item_name() must return String even with invalid ID",
			"expected_output": "Empty string",
			"actual_output": type_string(typeof(nome))
		}
	
	if nome != "":
		return {
			"success": false,
			"error": "get_item_name() with invalid ID must return empty string",
			"expected_output": '""',
			"actual_output": '"%s"' % nome
		}
	
	return {"success": true, "error": ""}

func validate_get_item_quantity_invalid(resultado, instancia) -> Dictionary:
	var quantity = instancia.get_item_quantity(999)
	
	if not quantity is int:
		return {
			"success": false,
			"error": "get_item_quantity() must return int even with invalid ID",
			"expected_output": -1,
			"actual_output": type_string(typeof(quantity))
		}
	
	if quantity != -1:
		return {
			"success": false,
			"error": "get_item_quantity() with invalid ID must return -1",
			"expected_output": -1,
			"actual_output": quantity
		}
	
	return {"success": true, "error": ""}

func validate_item_to_dict(resultado, instancia) -> Dictionary:
	# Carrega a classe Item do script do exercício
	var script_exercicio = load("res://listas/Lista4/Exercicio2/Exercicio2.gd")
	var classe_item = script_exercicio.Item
	
	var item = classe_item.new(0, 5, "Cristal", "Item raro", null)
	var dict = item.to_dict()
	
	if not dict is Dictionary:
		return {
			"success": false,
			"error": "to_dict() must return a Dictionary",
			"expected_output": "Dictionary",
			"actual_output": type_string(typeof(dict))
		}
	
	# Verifica se tem as chaves necessárias
	var chaves_necessarias = ["id", "quantity", "nome", "description", "texture"]
	for chave in chaves_necessarias:
		if not dict.has(chave):
			return {
				"success": false,
				"error": "to_dict() must have the key '%s'" % chave,
				"expected_output": str(chaves_necessarias),
				"actual_output": str(dict.keys())
			}
	
	# Verifica valores
	if dict["id"] != 0:
		return {
			"success": false,
			"error": "Value of 'id' incorrect",
			"expected_output": 0,
			"actual_output": dict["id"]
		}
	
	if dict["quantity"] != 5:
		return {
			"success": false,
			"error": "Value of 'quantity' incorrect",
			"expected_output": 5,
			"actual_output": dict["quantity"]
		}
	
	if dict["nome"] != "Cristal":
		return {
			"success": false,
			"error": "Value of 'nome' incorrect",
			"expected_output": "Cristal",
			"actual_output": dict["nome"]
		}
	
	if dict["description"] != "Item raro":
		return {
			"success": false,
			"error": "Value of 'description' incorrect",
			"expected_output": "Item raro",
			"actual_output": dict["description"]
		}
	
	return {"success": true, "error": ""}

func validate_multiple_items(resultado, instancia) -> Dictionary:
	var id1 = instancia.add_item("Item A", "Desc A", null, 1)
	var id2 = instancia.add_item("Item B", "Desc B", null, 2)
	var id3 = instancia.add_item("Item C", "Desc C", null, 3)
	
	# Verifica se IDs são diferentes
	if id1 == id2 or id2 == id3 or id1 == id3:
		return {
			"success": false,
			"error": "Item IDs must be unique",
			"expected_output": "Different IDs",
			"actual_output": "IDs: %d, %d, %d" % [id1, id2, id3]
		}
	
	# Verifica se todos estão no inventário
	var itens = instancia.get_items()
	if not itens.has(id1) or not itens.has(id2) or not itens.has(id3):
		return {
			"success": false,
			"error": "All added items must be in the inventory",
			"expected_output": "3 items in inventory",
			"actual_output": "%d items in inventory" % itens.size()
		}
	
	return {"success": true, "error": ""}

func validate_get_items_returns_copy(resultado, instancia) -> Dictionary:
	var id = instancia.add_item("Gema", "Preciosa", null, 1)
	
	var itens1 = instancia.get_items()
	var itens2 = instancia.get_items()
	
	# Modifica a primeira cópia
	itens1.clear()
	
	# Verifica se a segunda cópia ainda tem o item
	if not itens2.has(id):
		return {
			"success": false,
			"error": "get_items() must return a copy, not direct reference",
			"expected_output": "Modifying copy does not affect others",
			"actual_output": "Modification affected other copies"
		}
	
	# Verifica se o inventário original não foi afetado
	var itens3 = instancia.get_items()
	if not itens3.has(id):
		return {
			"success": false,
			"error": "get_items() must return copy, original inventory was modified",
			"expected_output": "Original inventory intact",
			"actual_output": "Original inventory was modified"
		}
	
	return {"success": true, "error": ""}
