extends MarginContainer

#region AlreadyImplemented

@onready var power_input = %Entrada
@onready var btn_start = %Calcular
@onready var msg_start_car = %MsgLigarCarro
@onready var car_power = %PotenciaDoCarro

func _is_valid(text: String) -> bool:
	return text.is_valid_float() or text.is_valid_int()

#endregion

func _on_ligar_pressed() -> void:
	var text = power_input.text.strip_edges()
	if not _is_valid(text):
		msg_start_car.text = "Error! Invalid power! Enter a number!"
		msg_start_car.modulate = Color.RED
		return

	var p = int(text)
	
	# Create engine and car using composition
	var engine = CarEngine.new(p)
	var car: Car = Car.new(engine)
	var msg_start = car.start_car()
	var power = car.get_power()
	
	msg_start_car.modulate = Color.WHITE
	msg_start_car.text = msg_start

	car_power.text = "Car power: %s" % [Numeros.formatar(power)]
	car_power.modulate = Color.WHITE

# --- Class definitions ---

class CarEngine:
	var power: int
	var running: bool = false
	
	func _init(p_power: int) -> void:
		power = p_power
	
	func start() -> String:
		running = true
		return "Engine started! Power: %d" % power
	
	func get_power() -> int:
		return power

class Car:
	var engine: CarEngine
	
	func _init(p_engine: CarEngine) -> void:
		engine = p_engine
	
	func start_car() -> String:
		return engine.start()
	
	func get_power() -> int:
		return engine.get_power()
