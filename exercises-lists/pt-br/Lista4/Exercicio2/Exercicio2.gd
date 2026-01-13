extends Control
class_name Lista5Exercicio1

#region JahImplementado

@onready var lista_de_items: ItemList = %ListaDeItems
@onready var icone: TextureRect = %Icone
@onready var descricao: Label = %Descricao
@onready var nome: Label = %Nome
@onready var adicionar_item: Window = $AdicionarItem
@onready var remover_item: Window = $RemoverItem

var inventario : Inventario

var item_selecionado_id : int = -1

func _ready():
	inventario = Inventario.new()
	adicionar_item.visible = false
	remover_item.visible = false
	
	remover_item.inventario = inventario

func _on_add_pressed():
	
	adicionar_item.popup_centered()
	
	var resultado = await adicionar_item.operacao_concluida
	
	adicionar_item.hide()
	
	if not resultado:
		return
		
	var nome: String = resultado[0]
	var descricao: String = resultado[1]
	var textura: Texture = resultado[2]
	var quantidade: int = resultado[3]
	
	var id : int = inventario.adicionar_item(nome, descricao, textura, quantidade)
	
	_adicionar_item_na_lista(id)
	
func _adicionar_item_na_lista(id: int) -> void:
	var item : Dictionary = inventario.get_item(id)
	
	if item.is_empty():
		OS.alert("O item que você quer adicionar é invalido!\nConfere sua implementação do Inventário", "Erro!")
		return
	
	var nome_com_quant = inventario.get_item_nome_com_quantidade(id)
	
	if lista_de_items.get_item_text(id).is_empty():
		
		lista_de_items.add_item(nome_com_quant, item.textura)
	else:

		lista_de_items.set_item_text(id, nome_com_quant)
	
func _on_remove_pressed():
	
	if inventario.vazio():
		OS.alert("O inventário está vazio!", "Erro!")
		return
	
	remover_item.popup_centered()

	var resultado = await remover_item.operacao_concluida
	
	if not resultado:
		return
		
	var id: int = resultado[0]
	var quantidade: int = resultado[1]
	
	inventario.remover_item(id, quantidade)
	
	_atualizar_lista_de_itens(id)
	
func _atualizar_lista_de_itens(id: int) -> void:
	var item : Dictionary = inventario.get_item(id)
	
	if item.is_empty():
		lista_de_items.remove_item(id)
		if item_selecionado_id == id:
			icone.texture = null
			descricao.text = ""
			nome.text = ""
		return
	
	var nome_com_quant = inventario.get_item_nome_com_quantidade(id)
	
	lista_de_items.set_item_text(id, nome_com_quant)

func _on_lista_de_items_item_selected(index: int) -> void:
	var item = inventario.get_item(index)
	item_selecionado_id = index
	
	icone.texture = item.textura
	descricao.text = item.descricao
	nome.text = item.nome

#endregion

class Item:
	var id : int
	var quantidade : int
	var nome : String
	var descricao : String
	var textura : Texture
	
	func _init(p_id: int = -1,
				p_quantidade: int = 0,
				p_nome: String = "",
				p_descricao: String = "",
				p_textura: Texture = null) -> void:
		#TODO:
		pass
		
	func to_dict() -> Dictionary:
		#TODO:
		return {}

class Inventario:

	const LIMITE_QUANTIDADE_ITENS: int = 50
	var _itens: Dictionary = {}

	func _init() -> void:
		_itens = {}

	func vazio() -> bool:
		#TODO:
		return false

	func adicionar_item(nome: String,
					descricao: String,
					textura: Texture = null,
					quantidade: int = 1) -> int:
		#TODO
		return -1

	func remover_item(id: int, quantidade: int) -> bool:
		#TODO:
		return false

	func get_item(id: int) -> Dictionary:
		#TODO
		return {}

	func get_item_nome(id: int) -> String:
		#TODO
		return ""

	func get_item_nome_com_quantidade(id: int) -> String:
		#TODO
		return ""

	func get_item_descricao(id: int) -> String:
		#TODO
		return ""

	func get_item_quantidade(id: int) -> int:
		#TODO
		return -1

	func get_itens() -> Dictionary:
		#TODO
		return {}
