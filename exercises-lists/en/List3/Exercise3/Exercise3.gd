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
	
	#TODO
	#var car: Car = Car.new(p)
	#var msg_start = car.start_car()
	#var power = car.get_power()
	
	msg_start_car.modulate = Color.WHITE
	#msg_start_car.text = msg_start

	#car_power.text = "Car power: %s" % [Numeros.formatar(power)]
	car_power.modulate = Color.WHITE
# --- Class definitions ---

class CarEngine:
	var power: int
	#TODO: Complete the rest of the class
	

class Car:
	var engine: Engine
	#TODO: Complete the rest of the class
