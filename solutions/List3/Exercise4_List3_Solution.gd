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
	
	piggy_bank.set_name(text)
	update_account_information()
	result.text = "Name updated! New name: %s" % [text]

func update_account_information() -> void:
	information.text = str(piggy_bank)

class PiggyBank:
	
	var _balance: float = 0.0
	var _name: String = ""
	
	# Public property for backward compatibility
	var balance: float:
		get: return get_balance()
		set(value): set_balance(value)
	
	var name: String:
		get: return get_name()
		set(value): set_name(value)

	func _init(p_name: String = "User", p_balance: float = 0.0) -> void:
		_name = p_name
		_balance = p_balance
		
	func add(value: float) -> void:
		_balance += value

	func withdraw(value: float) -> bool:
		if _balance >= value:
			_balance -= value
			return true
		return false

	func set_balance(new_balance: float) -> float:
		_balance = new_balance
		return _balance

	func get_balance() -> float:
		return _balance
		
	func get_name() -> String:
		return _name
		
	func set_name(new_name: String) -> void:
		_name = new_name

	func _to_string() -> String:
		return "Name: %s\nBalance: $%s" % [_name, str(_balance).pad_decimals(2)]
