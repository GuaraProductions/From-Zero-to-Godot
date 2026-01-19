extends MarginContainer

#region AlreadyImplemented

@onready var add_balance_field: LineEdit = %AdicionarSaldoField
@onready var withdraw_money_field: LineEdit = %SacarDinheiroField
@onready var change_name_field: LineEdit = %MudarNomeField
@onready var result: Label = %Resultado
@onready var information: Label = %Informacoes

var piggy_bank : PiggyBank

func _ready() -> void:
	piggy_bank = PiggyBank.new()
	update_account_information()

func _is_valid(text: String) -> bool:
	return text.is_valid_float()

func adicionar():
	var text = add_balance_field.text.strip_edges()
	if not _is_valid(text):
		result.text = "Error: Invalid value."
		result.modulate = Color.RED
		return
	piggy_bank.add(float(text))
	update_account_information()
	result.text = \
	 "Money added successfully!:\nUpdated balance: %s" % \
	 [Numeros.formatar(piggy_bank.balance)]

func sacar():
	var text = withdraw_money_field.text.strip_edges()
	if not _is_valid(text):
		result.text = "Error: Invalid value."
		result.modulate = Color.RED
		return
	var ok = piggy_bank.withdraw(float(text))
	update_account_information()
	if ok:
		result.text = "Money withdrawn successfully!\nUpdated balance: %s" % [str(piggy_bank.get_balance()).pad_decimals(2)]
	else:
		result.text = "Could not withdraw"

#endregion

func change_name() -> void:
	var text = change_name_field.text.strip_edges()

	#TODO: Insert logic to change name
	update_account_information()
	result.text = "Name updated! New name: %s" % [text]

func update_account_information() -> void:
	information.text = str(piggy_bank)

class PiggyBank:
	
	#TODO
	var balance: float = 0.0
	var name: String = ""

	func _init(name: String = "User", 
			balance: float = 0.0) -> void:
		self.name = name
		self.balance = balance
		
	func add(value: float) -> void:
		# TODO
		pass

	func withdraw(value: float) -> bool:
		# TODO
		return false

	func set_balance(new_balance: float) -> float:
		# TODO
		return 0.0

	func get_balance() -> float:
		# TODO
		return 0.0
		
	func get_name() -> String:
		# TODO
		return ""
		
	func set_name(new_name: String) -> void:
		# TODO
		pass

	func _to_string() -> String:
		return "Name: %s\nBalance: $%s" % [self.name, str(self.balance).pad_decimals(2)]
