extends Node

## Testes customizados para OrganizadorDeTarefas
## Este arquivo define testes por código em vez de JSON,
## permitindo validações complexas de objetos

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"name": "Adicionar 1 tarefa e verificar retorno",
			"class": "OrganizadorDeTarefas",
			"constructor_params": [],
			"method": "adicionar_tarefa",
			"input": ["Fazer compras"],
			"validate": _validar_adicionar_tarefa
		},
		{
			"name": "Adicionar múltiplas tarefas com IDs incrementais",
			"class": "OrganizadorDeTarefas",
			"constructor_params": [],
			"method": "adicionar_tarefa",
			"input": ["Estudar GDScript"],
			"validate": _validar_ids_incrementais
		},
		{
			"name": "Obter tarefas vazio no início",
			"class": "OrganizadorDeTarefas",
			"constructor_params": [],
			"method": "get_tarefas",
			"input": [],
			"validate": _validar_tarefas_vazio
		},
		{
			"name": "Obter tarefas após adicionar",
			"class": "OrganizadorDeTarefas",
			"constructor_params": [],
			"method": "get_tarefas",
			"input": [],
			"validate": _validar_obter_tarefas
		},
		{
			"name": "Concluir tarefa por ID",
			"class": "OrganizadorDeTarefas",
			"constructor_params": [],
			"method": "concluir_tarefa",
		"input": [0],
		"validate": _validar_concluir_tarefa
		},
		{
		"name": "Deletar tarefa por ID",
		"class": "OrganizadorDeTarefas",
		"constructor_params": [],
		"method": "deletar_tarefa",
		"input": [0],
			"validate": _validar_deletar_tarefa
		}
	]

func _validar_adicionar_tarefa(resultado, instancia):
	if resultado == null:
		return {"success": false, "error": "adicionar_tarefa() retornou null"}
	
	if not resultado.has_method("marcar_concluida"):
		return {"success": false, "error": "Retorno não é uma Tarefa válida"}
	
	if not "id" in resultado:
		return {"success": false, "error": "Tarefa não tem propriedade 'id'"}
	if not "descricao" in resultado:
		return {"success": false, "error": "Tarefa não tem propriedade 'descricao'"}
	if not "concluida" in resultado:
		return {"success": false, "error": "Tarefa não tem propriedade 'concluida'"}
	
	if resultado.id != 0:
		return {
			"success": false,
			"error": "ID esperado: 0, obtido: %d" % resultado.id,
			"expected_output": "Tarefa(id=0)",
			"actual_output": "Tarefa(id=%d)" % resultado.id
		}
	
	if resultado.descricao != "Fazer compras":
		return {
			"success": false,
			"error": "Descrição incorreta",
			"expected_output": "Fazer compras",
			"actual_output": resultado.descricao
		}
	
	if resultado.concluida != false:
		return {
			"success": false,
			"error": "Tarefa deveria estar não concluída",
			"expected_output": "false",
			"actual_output": str(resultado.concluida)
		}
	
	return {
		"success": true,
		"error": "",
		"expected_output": "Tarefa(id=0, descricao='Fazer compras', concluida=false)",
		"actual_output": "Tarefa(id=%d, descricao='%s', concluida=%s)" % [resultado.id, resultado.descricao, resultado.concluida]
	}

func _validar_ids_incrementais(resultado, instancia):
	# resultado é a tarefa da entrada "Estudar GDScript" com ID 0
	var tarefa1 = instancia.adicionar_tarefa("Primeira tarefa")
	var tarefa2 = instancia.adicionar_tarefa("Segunda tarefa")
	var tarefa3 = instancia.adicionar_tarefa("Terceira tarefa")
	
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

func _validar_tarefas_vazio(resultado, instancia):
	if resultado == null:
		return {"success": false, "error": "get_tarefas() retornou null"}
	
	if not resultado is Array:
		return {"success": false, "error": "get_tarefas() não retornou um Array"}
	
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
		"expected_output": "Array vazio",
		"actual_output": "Array vazio"
	}

func _validar_obter_tarefas(resultado, instancia):
	instancia.adicionar_tarefa("Tarefa 1")
	instancia.adicionar_tarefa("Tarefa 2")
	
	var tarefas = instancia.get_tarefas()
	
	if tarefas.size() != 2:
		return {
			"success": false,
			"error": "Número de tarefas incorreto",
			"expected_output": "2 tarefas",
			"actual_output": "%d tarefas" % tarefas.size()
		}
	
	if tarefas[0].descricao != "Tarefa 1":
		return {"success": false, "error": "Primeira tarefa incorreta"}
	
	if tarefas[1].descricao != "Tarefa 2":
		return {"success": false, "error": "Segunda tarefa incorreta"}
	
	return {
		"success": true,
		"error": "",
		"expected_output": "2 tarefas corretas",
		"actual_output": "2 tarefas corretas"
	}

func _validar_concluir_tarefa(resultado, instancia):
	instancia.adicionar_tarefa("Fazer exercícios")
	var sucesso = instancia.concluir_tarefa(0)
	
	# Valida que retornou true
	if not sucesso:
		return {
			"success": false,
			"error": "concluir_tarefa() deveria retornar true",
			"expected_output": "true",
			"actual_output": str(sucesso)
		}
	
	var tarefas = instancia.get_tarefas()
	if tarefas.size() == 0:
		return {"success": false, "error": "Nenhuma tarefa encontrada"}
	
	if not tarefas[0].concluida:
		return {
			"success": false,
			"error": "Tarefa não foi marcada como concluída",
			"expected_output": "concluida=true",
			"actual_output": "concluida=false"
		}
	
	return {
		"success": true,
		"error": "",
		"expected_output": "true (tarefa concluída)",
		"actual_output": "true (tarefa concluída)"
	}

func _validar_deletar_tarefa(resultado, instancia):
	instancia.adicionar_tarefa("Tarefa para deletar")
	instancia.adicionar_tarefa("Tarefa para manter")
	
	var antes = instancia.get_tarefas().size()
	var sucesso = instancia.deletar_tarefa(0)
	var depois = instancia.get_tarefas().size()
	
	# Valida que retornou true
	if not sucesso:
		return {
			"success": false,
			"error": "deletar_tarefa() deveria retornar true",
			"expected_output": "true",
			"actual_output": str(sucesso)
		}
	
	if depois != antes - 1:
		return {
			"success": false,
			"error": "Tarefa não foi deletada",
			"expected_output": "%d tarefas" % (antes - 1),
			"actual_output": "%d tarefas" % depois
		}
	
	var tarefas = instancia.get_tarefas()
	if tarefas[0].id == 0:
		return {"success": false, "error": "Tarefa errada foi deletada (ID 0 ainda existe)"}
	
	return {
		"success": true,
		"error": "",
		"expected_output": "true (tarefa deletada)",
		"actual_output": "true (tarefa deletada)"
	}
