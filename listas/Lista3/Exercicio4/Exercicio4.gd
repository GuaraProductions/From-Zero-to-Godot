extends MarginContainer

#region JahImplementado

@onready var adicionar_saldo_field: LineEdit = %AdicionarSaldoField
@onready var sacar_dinheiro_field: LineEdit = %SacarDinheiroField
@onready var mudar_nome_field: LineEdit = %MudarNomeField
@onready var resultado: Label = %Resultado
@onready var informacoes: Label = %Informacoes

var cofre : Cofrinho

func _ready() -> void:
	cofre = Cofrinho.new()
	atualizar_informacoes_da_conta()

func _eh_valido(texto: String) -> bool:
	return texto.is_valid_float()

func adicionar():
	var texto = adicionar_saldo_field.text.strip_edges()
	if not _eh_valido(texto):
		resultado.text = "Erro: Valor inválido."
		resultado.modulate = Color.RED
		return
	cofre.adicionar(float(texto))
	atualizar_informacoes_da_conta()
	resultado.text = \
	 "Dinheiro adicionado com sucesso!:\nSaldo atualizado: %s" % \
	 [Numeros.formatar(cofre.saldo)]

func sacar():
	var texto = sacar_dinheiro_field.text.strip_edges()
	if not _eh_valido(texto):
		resultado.text = "Erro: Valor inválido."
		resultado.modulate = Color.RED
		return
	var ok = cofre.sacar(float(texto))
	atualizar_informacoes_da_conta()
	if ok:
		resultado.text = "Dinheiro sacado com sucesso!\nSaldo atualizado: %s" % [str(cofre.get_saldo()).pad_decimals(2)]
	else:
		resultado.text = "Não foi possível sacar"

#endregion

func mudar_nome() -> void:
	var texto = mudar_nome_field.text.strip_edges()

	#TODO: Inserir lógica para alterar nome
	atualizar_informacoes_da_conta()
	resultado.text = "Nome atualizado! Novo nome: %s" % [texto]

func atualizar_informacoes_da_conta() -> void:
	informacoes.text = str(cofre)

class Cofrinho:
	
	#TODO
	var saldo: float = 0.0
	var nome: String = ""

	func _init(nome: String = "Usuario", 
			saldo: float = 0.0) -> void:
		self.nome = nome
		self.saldo = saldo
		
	func adicionar(valor: float) -> void:
		# TODO
		pass

	func sacar(valor: float) -> bool:
		# TODO
		return false

	func set_saldo(novo_saldo: float) -> float:
		# TODO
		return 0.0

	func get_saldo() -> float:
		# TODO
		return 0.0
		
	func get_nome() -> String:
		# TODO
		return ""
		
	func set_nome(novo_nome: String) -> void:
		# TODO
		pass

	func _to_string() -> String:
		return "Nome: %s\nSaldo: R$%s" % [self.nome, str(self.saldo).pad_decimals(2)]
