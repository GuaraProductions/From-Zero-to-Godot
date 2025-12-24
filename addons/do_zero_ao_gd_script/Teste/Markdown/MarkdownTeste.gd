extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarkdownPreProcessador.parse_markdown_to_scene("res://listas/Lista4/Lista4.md")
