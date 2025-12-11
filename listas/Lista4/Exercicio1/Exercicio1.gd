extends Control

@export var tarefa_button_scene : PackedScene

@onready var tarefa_input = %Descricao
@onready var tarefa_list  = %Items

var organizador_de_tarefas = OrganizadorDeTarefas.new()

func adicionado_pressionado() -> void:
	var desc = tarefa_input.text.strip_edges()
	if desc != "":
		var tarefa = organizador_de_tarefas.adicionar_tarefa(desc)
		tarefa_input.text = ""
		_adicionar_tarefa_para_lista(tarefa)
	else:
		OS.alert("Descrição da tarefa está vazia", "Erro!")

func _adicionar_tarefa_para_lista(tarefa: Tarefa) -> void:

	var tarefa_button_instance : TarefaButton = tarefa_button_scene.instantiate()
	
	tarefa_button_instance.configurar(tarefa.descricao, tarefa.id)
	
	tarefa_button_instance.concluir_tarefa.connect(usuario_quer_concluir_tarefa.bind(tarefa_button_instance))
	tarefa_button_instance.deletar.connect(usuario_quer_excluir_tarefa.bind(tarefa_button_instance))
	
	tarefa_list.add_child(tarefa_button_instance)

func usuario_quer_concluir_tarefa(id: int, tarefa_botao: TarefaButton) -> void:
	organizador_de_tarefas.concluir_tarefa(id)
	
func usuario_quer_excluir_tarefa(id: int, tarefa_botao: TarefaButton) -> void:
	organizador_de_tarefas.deletar_tarefa(id)
	tarefa_list.remove_child(tarefa_botao)
	tarefa_botao.queue_free()

class Tarefa:
	var id: int
	var descricao: String
	var concluida: bool 

	func _init(p_id: int, p_descricao: String) -> void:
		#TODO
		pass

	func marcar_concluida() -> void:
		#TODO
		pass

class OrganizadorDeTarefas:
	var _tarefas: Array = []

	func adicionar_tarefa(desc: String) -> Tarefa:
		#TODO
		return null

	func concluir_tarefa(indice: int) -> void:
		#TODO
		pass

	func deletar_tarefa(indice: int) -> void:
		#TODO
		pass

	func get_tarefas() -> Array:
		#TODO
		return []
