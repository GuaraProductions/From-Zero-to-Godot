extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarkdownPreProcessador.parse_markdown_to_scene("res://addons/do_zero_ao_gd_script/Teste/Markdown/markdown.md")
