extends Node

#region JahImplementado

const MAX : int = 10

@onready var entrada = %Entrada
@onready var erro = %ErroTexto
@onready var tabuada = %TabuadaGrid
@onready var subtracao_flow_container: HFlowContainer = %SubtracaoFlowContainer
@onready var multiplicacao_flow_container: HFlowContainer = %MultiplicacaoFlowContainer
@onready var adicao_flow_container: HFlowContainer = %AdicaoFlowContainer
@onready var divisao_flow_container: HFlowContainer = %DivisaoFlowContainer
@onready var tabuada_panel: PanelContainer = %TabuadaPanel

func _ready() -> void:
	tabuada_panel.visible = false

func _eh_numero_valido(texto: String) -> bool:
	return texto.is_valid_int()
	
func _esta_dentro_do_intervalo(num: int) -> bool:
	return num > 0 and num < MAX

func calcular():
	
	_remover_nodes(adicao_flow_container)
	_remover_nodes(subtracao_flow_container)
	_remover_nodes(multiplicacao_flow_container)
	_remover_nodes(divisao_flow_container)
	
	var texto = entrada.text
	
	if not _eh_numero_valido(texto):
		erro.text = "Erro! A entrada de texto é inválida!\nColoque um número inteiro positivo!"
		erro.modulate = Color.RED
		erro.visible = true
		tabuada_panel.visible = false
		return

	var n = int(texto)
	
	if not _esta_dentro_do_intervalo(n):
		erro.text = "Erro! A entrada de texto é inválida!\nColoque um número maior que %d e menor que %d!" % [0, MAX]
		erro.modulate = Color.RED
		erro.visible = true
		tabuada_panel.visible = false
		return
	
	tabuada_panel.visible = true
	erro.visible = false
	gerar_tabuada(n)
	
func _remover_nodes(node: Control) -> void:
	for crianca in node.get_children():
		node.remove_child(crianca)
		crianca.queue_free()
	
func adicionar_tabuada(numero1: int, 
					  operacao: String, 
					  numero2: int, 
					  resultado: int) -> void:
	# Seleciona o HFlowContainer correto com base na operação
	var flow_container: HFlowContainer 
	
	match operacao:
		"+": flow_container = adicao_flow_container
		"-": flow_container = subtracao_flow_container
		"*": flow_container = multiplicacao_flow_container
		"/": flow_container = divisao_flow_container
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

func gerar_tabuada(n: int) -> void:
	# TODO: Retorne uma string com a tabuada de n (1 a 10)
	"""
	Representações das operações
	+ -> Adicao
	- -> Subtracao
	* -> Multiplicação
	/ -> Divisão
	
	Use a função "adicionar_tabuada" para colocar o resultado
	de uma tabuada na tela
	
	aqui vai um exemplo:
	adicionar_tabuada(numero1, "+", numero2, numero1 + numero2)
	"""
	pass
