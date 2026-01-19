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
	
func add_times_table(number1: int, 
					  operation: String, 
					  number2: int, 
					  result: int) -> void:
	# Selects the correct HFlowContainer based on the operation
	var flow_container: HFlowContainer 
	
	match operation:
		"+": flow_container = addition_flow_container
		"-": flow_container = subtraction_flow_container
		"*": flow_container = multiplication_flow_container
		"/": flow_container = division_flow_container
		_:
			push_error("Invalid operation: %s" % operation)
			return
			
	# For division, we group by divisor (number2); for others, by number1
	var group_key = number2 if operation == "/" else number1
	var vbox_name = str(group_key)
	var vbox: VBoxContainer

	# Retrieves or creates the VBoxContainer for this group
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

	# If there's already a VBoxContainer for this number1, use it; otherwise, create a new one
	if flow_container.has_node(vbox_name):
		vbox = flow_container.get_node(vbox_name)
	else:
		vbox = VBoxContainer.new()
		vbox.name = vbox_name
		flow_container.add_child(vbox)

	# Creates a Label with the expression and adds it to the VBoxContainer
	var label = Label.new()
	label.text = "%d %s %d = %d" % [number1, operation, number2, result]
	vbox.add_child(label)

#endregion

func generate_times_table(n: int) -> void:
	# Generate times tables for addition, subtraction, multiplication, and division
	# For each operation, calculate from 1 to 10
	for i in range(1, 11):
		# Addition: n + i
		add_times_table(n, "+", i, n + i)
		
		# Subtraction: n - i
		add_times_table(n, "-", i, n - i)
		
		# Multiplication: n * i
		add_times_table(n, "*", i, n * i)
		
		# Division: n / i (integer division)
		add_times_table(n, "/", i, n / i)
