extends Control

@export var task_button_scene : PackedScene

@onready var task_input = %Descricao
@onready var task_list  = %Items

var task_organizer = TaskOrganizer.new()

func add_button_pressed() -> void:
	var desc = task_input.text.strip_edges()
	if desc != "":
		var task = task_organizer.add_task(desc)
		task_input.text = ""
		_add_task_to_list(task)
	else:
		OS.alert("Task description is empty", "Error!")

func _add_task_to_list(task: Task) -> void:

	var task_button_instance : TarefaButton = task_button_scene.instantiate()
	
	task_button_instance.configurar(task.description, task.id)
	
	task_button_instance.concluir_tarefa.connect(user_wants_to_complete_task.bind(task_button_instance))
	task_button_instance.deletar.connect(user_wants_to_delete_task.bind(task_button_instance))
	
	task_list.add_child(task_button_instance)

func user_wants_to_complete_task(id: int, task_button: TarefaButton) -> void:
	task_organizer.complete_task(id)
	
func user_wants_to_delete_task(id: int, task_button: TarefaButton) -> void:
	task_organizer.delete_task(id)
	task_list.remove_child(task_button)
	task_button.queue_free()

class Task:
	var id: int
	var description: String
	var completed: bool = false

	func _init(p_id: int, p_description: String) -> void:
		id = p_id
		description = p_description
		completed = false

	func mark_completed() -> void:
		completed = true

class TaskOrganizer:
	var _tasks: Array = []

	func add_task(desc: String) -> Task:
		var new_id = _tasks.size()
		var new_task = Task.new(new_id, desc)
		_tasks.append(new_task)
		return new_task

	func complete_task(index: int) -> bool:
		if index >= 0 and index < _tasks.size():
			_tasks[index].mark_completed()
			return true
		return false

	func delete_task(index: int) -> bool:
		if index >= 0 and index < _tasks.size():
			_tasks.remove_at(index)
			return true
		return false

	func get_tasks() -> Array:
		return _tasks.duplicate()
