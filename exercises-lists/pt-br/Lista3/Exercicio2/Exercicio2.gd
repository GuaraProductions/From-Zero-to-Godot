extends MarginContainer

#region JahImplementado

@onready var resultado: Label = $Resultado
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

@export var audio_cachorro : AudioStreamOggVorbis
@export var audio_gato : AudioStreamOggVorbis
@export var audio_ovelha : AudioStreamOggVorbis

func _ready() -> void:
	audio.volume_linear = $VBox/AudioSlider.value

func tocar_audio(efeito_sonoro: AudioStreamOggVorbis) -> void:
	audio.stream = efeito_sonoro
	audio.play()

func _on_audio_slider_value_changed(value: float) -> void:
	audio.volume_linear = value

#endregion

func _on_cachorro_pressed() -> void:
	var animal: Animal = Cachorro.new(audio_cachorro)
	resultado.text = animal.falar()
	tocar_audio(animal.get_efeito_sonoro())

func _on_gato_pressed() -> void:
	pass #TODO
	#var animal: Animal = Gato.new()
	#resultado.text = animal.falar()
	#tocar_audio(animal.get_efeito_sonoro())

func _on_ovelha_pressed() -> void:
	pass #TODO
	#var animal: Animal = Ovelha.new()
	#resultado.text = animal.falar()
	#tocar_audio(animal.get_efeito_sonoro())

# --- Definições das classes ---

class Animal:
	
	var nome: String
	var efeito_sonoro: AudioStreamOggVorbis
	
	# Método base (pode ser virtual/abstrato)
	func falar() -> String:
		printerr("Uso errado da classe!")
		return "…"
		
	func get_efeito_sonoro() -> AudioStreamOggVorbis:
		return efeito_sonoro

class Cachorro extends Animal:
	
	func _init(novo_efeito_sonoro: AudioStreamOggVorbis) -> void:
		efeito_sonoro = novo_efeito_sonoro
	
	func falar() -> String:
		# TODO: 
		return ""

#TODO: Fazer as outras classes
