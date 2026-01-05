extends Node

## Testes customizados para OrganizadorDeTarefas
## Este arquivo define testes por código em vez de JSON,
## permitindo validações complexas de objetos

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"nome": "Adicionar 1 tarefa e verificar retorno",
			"classe": "OrganizadorDeTarefas",
			"construtor_params": [],
			"metodo": "adicionar_tarefa",
			"entrada": ["Fazer compras"],
			"validar": _validar_adicionar_tarefa
		},
		{
			"nome": "Adicionar múltiplas tarefas com IDs incrementais",
			"classe": "OrganizadorDeTarefas",
			"construtor_params": [],
			"metodo": "adicionar_tarefa",
			"entrada": ["Estudar GDScript"],
			"validar": _validar_ids_incrementais
		},
		{
			"nome": "Obter tarefas vazio no início",
			"classe": "OrganizadorDeTarefas",
			"construtor_params": [],
			"metodo": "get_tarefas",
			"entrada": [],
			"validar": _validar_tarefas_vazio
		},
		{
			"nome": "Obter tarefas após adicionar",
			"classe": "OrganizadorDeTarefas",
			"construtor_params": [],
			"metodo": "get_tarefas",
			"entrada": [],
			"validar": _validar_obter_tarefas
		},
		{
			"nome": "Concluir tarefa por ID",
			"classe": "OrganizadorDeTarefas",
			"construtor_params": [],
			"metodo": "concluir_tarefa",
		"entrada": [0],
		"validar": _validar_concluir_tarefa
		},
		{
		"nome": "Deletar tarefa por ID",
		"classe": "OrganizadorDeTarefas",
		"construtor_params": [],
		"metodo": "deletar_tarefa",
		"entrada": [0],
			"validar": _validar_deletar_tarefa
		}
	]

func _validar_adicionar_tarefa(resultado, instancia):
	if resultado == null:
		return {"sucesso": false, "erro": "adicionar_tarefa() retornou null"}
	
	if not resultado.has_method("marcar_concluida"):
		return {"sucesso": false, "erro": "Retorno não é uma Tarefa válida"}
	
	if not "id" in resultado:
		return {"sucesso": false, "erro": "Tarefa não tem propriedade 'id'"}
	if not "descricao" in resultado:
		return {"sucesso": false, "erro": "Tarefa não tem propriedade 'descricao'"}
	if not "concluida" in resultado:
		return {"sucesso": false, "erro": "Tarefa não tem propriedade 'concluida'"}
	
	if resultado.id != 0:
		return {
			"sucesso": false,
			"erro": "ID esperado: 0, obtido: %d" % resultado.id,
			"saida_esperada": "Tarefa(id=0)",
			"saida_obtida": "Tarefa(id=%d)" % resultado.id
		}
	
	if resultado.descricao != "Fazer compras":
		return {
			"sucesso": false,
			"erro": "Descrição incorreta",
			"saida_esperada": "Fazer compras",
			"saida_obtida": resultado.descricao
		}
	
	if resultado.concluida != false:
		return {
			"sucesso": false,
			"erro": "Tarefa deveria estar não concluída",
			"saida_esperada": "false",
			"saida_obtida": str(resultado.concluida)
		}
	
	return {
		"sucesso": true,
		"erro": "",
		"saida_esperada": "Tarefa(id=0, descricao='Fazer compras', concluida=false)",
		"saida_obtida": "Tarefa(id=%d, descricao='%s', concluida=%s)" % [resultado.id, resultado.descricao, resultado.concluida]
	}

func _validar_ids_incrementais(resultado, instancia):
	# resultado é a tarefa da entrada "Estudar GDScript" com ID 0
	var tarefa1 = instancia.adicionar_tarefa("Primeira tarefa")
	var tarefa2 = instancia.adicionar_tarefa("Segunda tarefa")
	var tarefa3 = instancia.adicionar_tarefa("Terceira tarefa")
	
	if tarefa1.id != 1 or tarefa2.id != 2 or tarefa3.id != 3:
		return {
			"sucesso": false,
			"erro": "IDs não estão incrementando corretamente",
			"saida_esperada": "IDs: 1, 2, 3",
			"saida_obtida": "IDs: %d, %d, %d" % [tarefa1.id, tarefa2.id, tarefa3.id]
		}
	
	return {
		"sucesso": true,
		"erro": "",
		"saida_esperada": "IDs: 1, 2, 3",
		"saida_obtida": "IDs: 1, 2, 3"
	}

func _validar_tarefas_vazio(resultado, instancia):
	if resultado == null:
		return {"sucesso": false, "erro": "get_tarefas() retornou null"}
	
	if not resultado is Array:
		return {"sucesso": false, "erro": "get_tarefas() não retornou um Array"}
	
	if resultado.size() != 0:
		return {
			"sucesso": false,
			"erro": "Lista deveria estar vazia",
			"saida_esperada": "[]",
			"saida_obtida": str(resultado)
		}
	
	return {
		"sucesso": true,
		"erro": "",
		"saida_esperada": "Array vazio",
		"saida_obtida": "Array vazio"
	}

func _validar_obter_tarefas(resultado, instancia):
	instancia.adicionar_tarefa("Tarefa 1")
	instancia.adicionar_tarefa("Tarefa 2")
	
	var tarefas = instancia.get_tarefas()
	
	if tarefas.size() != 2:
		return {
			"sucesso": false,
			"erro": "Número de tarefas incorreto",
			"saida_esperada": "2 tarefas",
			"saida_obtida": "%d tarefas" % tarefas.size()
		}
	
	if tarefas[0].descricao != "Tarefa 1":
		return {"sucesso": false, "erro": "Primeira tarefa incorreta"}
	
	if tarefas[1].descricao != "Tarefa 2":
		return {"sucesso": false, "erro": "Segunda tarefa incorreta"}
	
	return {
		"sucesso": true,
		"erro": "",
		"saida_esperada": "2 tarefas corretas",
		"saida_obtida": "2 tarefas corretas"
	}

func _validar_concluir_tarefa(resultado, instancia):
	instancia.adicionar_tarefa("Fazer exercícios")
	var sucesso = instancia.concluir_tarefa(0)
	
	# Valida que retornou true
	if not sucesso:
		return {
			"sucesso": false,
			"erro": "concluir_tarefa() deveria retornar true",
			"saida_esperada": "true",
			"saida_obtida": str(sucesso)
		}
	
	var tarefas = instancia.get_tarefas()
	if tarefas.size() == 0:
		return {"sucesso": false, "erro": "Nenhuma tarefa encontrada"}
	
	if not tarefas[0].concluida:
		return {
			"sucesso": false,
			"erro": "Tarefa não foi marcada como concluída",
			"saida_esperada": "concluida=true",
			"saida_obtida": "concluida=false"
		}
	
	return {
		"sucesso": true,
		"erro": "",
		"saida_esperada": "true (tarefa concluída)",
		"saida_obtida": "true (tarefa concluída)"
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
			"sucesso": false,
			"erro": "deletar_tarefa() deveria retornar true",
			"saida_esperada": "true",
			"saida_obtida": str(sucesso)
		}
	
	if depois != antes - 1:
		return {
			"sucesso": false,
			"erro": "Tarefa não foi deletada",
			"saida_esperada": "%d tarefas" % (antes - 1),
			"saida_obtida": "%d tarefas" % depois
		}
	
	var tarefas = instancia.get_tarefas()
	if tarefas[0].id == 0:
		return {"sucesso": false, "erro": "Tarefa errada foi deletada (ID 0 ainda existe)"}
	
	return {
		"sucesso": true,
		"erro": "",
		"saida_esperada": "true (tarefa deletada)",
		"saida_obtida": "true (tarefa deletada)"
	}
