extends Control
class_name List4Exercise2

#region AlreadyImplemented

@onready var item_list: ItemList = %ListaDeItems
@onready var icon: TextureRect = %Icone
@onready var description: Label = %Descricao
@onready var label_name: Label = %Nome
@onready var add_item: Window = $AdicionarItem
@onready var remove_item: Window = $RemoverItem

var inventory : Inventory

var selected_item_id : int = -1

func _ready():
	inventory = Inventory.new()
	add_item.visible = false
	remove_item.visible = false
	
	remove_item.inventory = inventory

func _on_add_pressed():
	
	add_item.popup_centered()
	
	var result = await add_item.operation_completed
	
	add_item.hide()
	
	if not result:
		return
		
	var name_value: String = result[0]
	var desc: String = result[1]
	var texture: Texture = result[2]
	var quantity: int = result[3]
	
	var id : int = inventory.add_item(name_value, desc, texture, quantity)
	
	_add_item_to_list(id)
	
func _add_item_to_list(id: int) -> void:
	var item : Dictionary = inventory.get_item(id)
	
	if item.is_empty():
		OS.alert("The item you want to add is invalid!\nCheck your Inventory implementation", "Error!")
		return
	
	var name_with_quantity = inventory.get_item_name_with_quantity(id)
	
	if item_list.get_item_text(id).is_empty():
		
		item_list.add_item(name_with_quantity, item.texture)
	else:

		item_list.set_item_text(id, name_with_quantity)
	
func _on_remove_pressed():
	
	if inventory.is_empty():
		OS.alert("The inventory is empty!", "Error!")
		return
	
	remove_item.popup_centered()

	var result = await remove_item.operation_completed
	
	if not result:
		return
		
	var id: int = result[0]
	var quantity: int = result[1]
	
	inventory.remove_item(id, quantity)
	
	_update_item_list(id)
	
func _update_item_list(id: int) -> void:
	var item : Dictionary = inventory.get_item(id)
	
	if item.is_empty():
		item_list.remove_item(id)
		if selected_item_id == id:
			icon.texture = null
			description.text = ""
			label_name.text = ""
		return
	
	var name_with_quantity = inventory.get_item_name_with_quantity(id)
	
	item_list.set_item_text(id, name_with_quantity)

func _on_lista_de_items_item_selected(index: int) -> void:
	var item = inventory.get_item(index)
	selected_item_id = index
	
	icon.texture = item.texture
	description.text = item.description
	label_name.text = item.name

#endregion

class Item:
	var id : int
	var quantity : int
	var name : String
	var description : String
	var texture : Texture
	
	func _init(p_id: int = -1,
				p_quantity: int = 0,
				p_name: String = "",
				p_description: String = "",
				p_texture: Texture = null) -> void:
		#TODO:
		pass
		
	func to_dict() -> Dictionary:
		#TODO:
		return {}

class Inventory:

	const MAX_ITEM_QUANTITY: int = 50
	var _items: Dictionary = {}

	func _init() -> void:
		_items = {}

	func is_empty() -> bool:
		#TODO:
		return false

	func add_item(name: String,
					description: String,
					texture: Texture = null,
					quantity: int = 1) -> int:
		#TODO
		return -1

	func remove_item(id: int, quantity: int) -> bool:
		#TODO:
		return false

	func get_item(id: int) -> Dictionary:
		#TODO
		return {}

	func get_item_name(id: int) -> String:
		#TODO
		return ""

	func get_item_name_with_quantity(id: int) -> String:
		#TODO
		return ""

	func get_item_description(id: int) -> String:
		#TODO
		return ""

	func get_item_quantity(id: int) -> int:
		#TODO
		return -1

	func get_items() -> Dictionary:
		#TODO
		return {}
