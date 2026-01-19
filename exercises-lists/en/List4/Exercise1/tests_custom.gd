extends Node

## Testes customizados para TaskOrganizer
## Este arquivo define testes por código em vez de JSON,
## permitindo validações complexas de objetos

func get_test_cases() -> Array[Dictionary]:
	return [
		{
			"name": "Adicionar 1 tarefa e verificar retorno",
			"class": "TaskOrganizer",
			"constructor_params": [],
			"method": "add_task",
			"input": ["Fazer compras"],
			"validate": _validate_add_task
		},
		{
			"name": "Adicionar múltiplas tarefas com IDs incrementais",
			"class": "TaskOrganizer",
			"constructor_params": [],
			"method": "add_task",
			"input": ["Estudar GDScript"],
			"validate": _validate_ids_incrementais
		},
		{
			"name": "Obter tarefas is_empty no início",
			"class": "TaskOrganizer",
			"constructor_params": [],
			"method": "get_tasks",
			"input": [],
			"validate": _validate_tasks_is_empty
		},
		{
			"name": "Obter tarefas após adicionar",
			"class": "TaskOrganizer",
			"constructor_params": [],
			"method": "get_tasks",
			"input": [],
			"validate": _validate_obter_tasks
		},
		{
			"name": "Concluir tarefa por ID",
			"class": "TaskOrganizer",
			"constructor_params": [],
			"method": "complete_task",
		"input": [0],
		"validate": _validate_complete_task
		},
		{
		"name": "Deletar tarefa por ID",
		"class": "TaskOrganizer",
		"constructor_params": [],
		"method": "delete_task",
		"input": [0],
			"validate": _validate_delete_task
		}
	]

func _validate_add_task(resultado, instancia):
	if resultado == null:
		return {"success": false, "error": "add_task() retornou null"}
	
	if not resultado.has_method("mark_completed"):
		return {"success": false, "error": "Retorno não é uma Task válida"}
	
	if not "id" in resultado:
		return {"success": false, "error": "Task não tem propriedade 'id'"}
	if not "description" in resultado:
		return {"success": false, "error": "Task não tem propriedade 'description'"}
	if not "completed" in resultado:
		return {"success": false, "error": "Task não tem propriedade 'completed'"}
	
	if resultado.id != 0:
		return {
			"success": false,
			"error": "ID esperado: 0, obtido: %d" % resultado.id,
			"expected_output": "Task(id=0)",
			"actual_output": "Task(id=%d)" % resultado.id
		}
	
	if resultado.description != "Fazer compras":
		return {
			"success": false,
			"error": "Descrição incorreta",
			"expected_output": "Fazer compras",
			"actual_output": resultado.description
		}
	
	if resultado.completed != false:
		return {
			"success": false,
			"error": "Task deveria estar não concluída",
			"expected_output": "false",
			"actual_output": str(resultado.completed)
		}
	
	return {
		"success": true,
		"error": "",
		"expected_output": "Task(id=0, description='Fazer compras', completed=false)",
		"actual_output": "Task(id=%d, description='%s', completed=%s)" % [resultado.id, resultado.description, resultado.completed]
	}

func _validate_ids_incrementais(resultado, instancia):
	# resultado é a tarefa da entrada "Estudar GDScript" com ID 0
	var tarefa1 = instancia.add_task("Primeira tarefa")
	var tarefa2 = instancia.add_task("Segunda tarefa")
	var tarefa3 = instancia.add_task("Terceira tarefa")
	
	if tarefa1.id != 1 or tarefa2.id != 2 or tarefa3.id != 3:
		return {
			"success": false,
			"error": "IDs não estão incrementando corretamente",
			"expected_output": "IDs: 1, 2, 3",
			"actual_output": "IDs: %d, %d, %d" % [tarefa1.id, tarefa2.id, tarefa3.id]
		}
	
	return {
		"success": true,
		"error": "",
		"expected_output": "IDs: 1, 2, 3",
		"actual_output": "IDs: 1, 2, 3"
	}

func _validate_tasks_is_empty(resultado, instancia):
	if resultado == null:
		return {"success": false, "error": "get_tasks() retornou null"}
	
	if not resultado is Array:
		return {"success": false, "error": "get_tasks() não retornou um Array"}
	
	if resultado.size() != 0:
		return {
			"success": false,
			"error": "Lista deveria estar vazia",
			"expected_output": "[]",
			"actual_output": str(resultado)
		}
	
	return {
		"success": true,
		"error": "",
		"expected_output": "Array is_empty",
		"actual_output": "Array is_empty"
	}

func _validate_obter_tasks(resultado, instancia):
	instancia.add_task("Task 1")
	instancia.add_task("Task 2")
	
	var tarefas = instancia.get_tasks()
	
	if tarefas.size() != 2:
		return {
			"success": false,
			"error": "Número de tarefas incorrect",
			"expected_output": "2 tarefas",
			"actual_output": "%d tarefas" % tarefas.size()
		}
	
	if tarefas[0].description != "Task 1":
		return {"success": false, "error": "Primeira tarefa incorreta"}
	
	if tarefas[1].description != "Task 2":
		return {"success": false, "error": "Segunda tarefa incorreta"}
	
	return {
		"success": true,
		"error": "",
		"expected_output": "2 tarefas corretas",
		"actual_output": "2 tarefas corretas"
	}

func _validate_complete_task(resultado, instancia):
	instancia.add_task("Fazer exercícios")
	var sucesso = instancia.complete_task(0)
	
	# Valida que retornou true
	if not sucesso:
		return {
			"success": false,
			"error": "complete_task() deveria retornar true",
			"expected_output": "true",
			"actual_output": str(sucesso)
		}
	
	var tarefas = instancia.get_tasks()
	if tarefas.size() == 0:
		return {"success": false, "error": "Nenhuma tarefa encontrada"}
	
	if not tarefas[0].completed:
		return {
			"success": false,
			"error": "Task não foi marcada como concluída",
			"expected_output": "completed=true",
			"actual_output": "completed=false"
		}
	
	return {
		"success": true,
		"error": "",
		"expected_output": "true (tarefa concluída)",
		"actual_output": "true (tarefa concluída)"
	}

func _validate_delete_task(resultado, instancia):
	instancia.add_task("Task para deletar")
	instancia.add_task("Task para manter")
	
	var antes = instancia.get_tasks().size()
	var sucesso = instancia.delete_task(0)
	var depois = instancia.get_tasks().size()
	
	# Valida que retornou true
	if not sucesso:
		return {
			"success": false,
			"error": "delete_task() deveria retornar true",
			"expected_output": "true",
			"actual_output": str(sucesso)
		}
	
	if depois != antes - 1:
		return {
			"success": false,
			"error": "Task não foi deletada",
			"expected_output": "%d tarefas" % (antes - 1),
			"actual_output": "%d tarefas" % depois
		}
	
	var tarefas = instancia.get_tasks()
	if tarefas[0].id == 0:
		return {"success": false, "error": "Task errada foi deletada (ID 0 ainda existe)"}
	
	return {
		"success": true,
		"error": "",
		"expected_output": "true (tarefa deletada)",
		"actual_output": "true (tarefa deletada)"
	}
