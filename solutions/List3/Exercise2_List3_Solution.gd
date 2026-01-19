extends MarginContainer

#region AlreadyImplemented

@onready var result: Label = $Resultado
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

@export var dog_audio : AudioStreamOggVorbis
@export var cat_audio : AudioStreamOggVorbis
@export var sheep_audio : AudioStreamOggVorbis

func _ready() -> void:
	audio.volume_linear = $VBox/AudioSlider.value

func play_audio(sound_effect: AudioStreamOggVorbis) -> void:
	audio.stream = sound_effect
	audio.play()

func _on_audio_slider_value_changed(value: float) -> void:
	audio.volume_linear = value

#endregion

func _on_cachorro_pressed() -> void:
	var animal: Animal = Dog.new(dog_audio)
	result.text = animal.speak()
	play_audio(animal.get_sound_effect())

func _on_gato_pressed() -> void:
	var animal: Animal = Cat.new(cat_audio)
	result.text = animal.speak()
	play_audio(animal.get_sound_effect())

func _on_ovelha_pressed() -> void:
	var animal: Animal = Sheep.new(sheep_audio)
	result.text = animal.speak()
	play_audio(animal.get_sound_effect())

# --- Class definitions ---

class Animal:
	
	var name: String
	var sound_effect: AudioStreamOggVorbis
	
	# Base method (can be virtual/abstract)
	func speak() -> String:
		printerr("Wrong use of class!")
		return "…"
		
	func get_sound_effect() -> AudioStreamOggVorbis:
		return sound_effect

class Dog extends Animal:
	
	func _init(new_sound_effect: AudioStreamOggVorbis) -> void:
		sound_effect = new_sound_effect
	
	func speak() -> String:
		return "Woof woof!"

class Cat extends Animal:
	
	func _init(new_sound_effect: AudioStreamOggVorbis) -> void:
		sound_effect = new_sound_effect
	
	func speak() -> String:
		return "Meow!"

class Sheep extends Animal:
	
	func _init(new_sound_effect: AudioStreamOggVorbis) -> void:
		sound_effect = new_sound_effect
	
	func speak() -> String:
		return "Baaah!"
