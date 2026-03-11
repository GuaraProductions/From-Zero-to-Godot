@tool
extends Node

#region AlreadyImplemented

const MAX : int = 10

@onready var input = %Entrada
@onready var error = %ErroTexto
@onready var times_table = %TabuadaGrid
@onready var subtraction_flow_container: HFlowContainer = %SubtracaoFlowContainer
@onready var multiplication_flow_container: HFlowContainer = %MultiplicacaoFlowContainer
@onready var addition_flow_container: HFlowContainer = %AdicaoFlowContainer
@onready var division_flow_container: HFlowContainer = %DivisaoFlowContainer
@onready var times_table_panel: PanelContainer = %TabuadaPanel

func _ready() -> void:
	times_table_panel.visible = false

func _is_valid_number(text: String) -> bool:
	return text.is_valid_int()
	
func _is_within_range(num: int) -> bool:
	return num > 0 and num < MAX

func calcular():
	
	_remove_nodes(addition_flow_container)
	_remove_nodes(subtraction_flow_container)
	_remove_nodes(multiplication_flow_container)
	_remove_nodes(division_flow_container)
	
	var text = input.text
	
	if not _is_valid_number(text):
		error.text = "Error! Text input is invalid!\nEnter a positive integer number!"
		error.modulate = Color.RED
		error.visible = true
		times_table_panel.visible = false
		return

	var n = int(text)
	
	if not _is_within_range(n):
		error.text = "Error! Text input is invalid!\nEnter a number greater than %d and less than %d!" % [0, MAX]
		error.modulate = Color.RED
		error.visible = true
		times_table_panel.visible = false
		return
	
	times_table_panel.visible = true
	error.visible = false
	generate_times_table(n)
	
func _remove_nodes(node: Control) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

func adicionar_tabuada(numero1: int, 
					  operacao: String, 
					  numero2: int, 
					  resultado: int) -> void:
	# Seleciona o HFlowContainer correto com base na operação
	var flow_container: HFlowContainer 
	
	match operacao:
		"+": flow_container = addition_flow_container
		"-": flow_container = subtraction_flow_container
		"*": flow_container = multiplication_flow_container
		"/": flow_container = division_flow_container
		_:
			push_error("Operação inválida: %s" % operacao)
			return
			
	# Para divisão, agrupamos pelo divisor (numero2); para as demais, pelo numero1
	var group_key = numero2 if operacao == "/" else numero1
	var vbox_name = str(group_key)
	var vbox: VBoxContainer

	# Recupera ou cria o VBoxContainer para esse grupo
	if flow_container.has_node(vbox_name):
		vbox = flow_container.get_node(vbox_name)
	else:
		var vseperator_1 = VSeparator.new()
		var vseperator_2 = VSeparator.new()
		vbox = VBoxContainer.new()
		vbox.name = vbox_name
		flow_container.add_child(vseperator_1)
		flow_container.add_child(vbox)
		flow_container.add_child(vseperator_2)

	# Se já existe um VBoxContainer para esse numero1, usa-o; caso contrário, cria um novo
	if flow_container.has_node(vbox_name):
		vbox = flow_container.get_node(vbox_name)
	else:
		vbox = VBoxContainer.new()
		vbox.name = vbox_name
		flow_container.add_child(vbox)

	# Cria um Label com a expressão e adiciona ao VBoxContainer
	var label = Label.new()
	label.text = "%d %s %d = %d" % [numero1, operacao, numero2, resultado]
	vbox.add_child(label)

#endregion

func generate_times_table(n: int) -> void:
	# Generate times tables for addition, subtraction, multiplication, and division
	# For each operation, calculate from 1 to 10
	for i in range(1, 11):
		# Addition: n + i
		for j in range(1, n + 1):
			adicionar_tabuada(i, "+", j, i + j)
	for i in range(1, 11):
		for j in range(1, n + 1):
			# Subtraction: n - i
			adicionar_tabuada(i, "-", j, i - j)
	for i in range(1, 11):
		for j in range(1, n + 1):
			adicionar_tabuada(i, "*", j, i * j)
			# Multiplication: n * i
	for i in range(1, 11):
		for j in range(1, n + 1):
			# Division: n / i (integer division)
			var resultado : int = j
			adicionar_tabuada(i * j, "/", i, resultado)
