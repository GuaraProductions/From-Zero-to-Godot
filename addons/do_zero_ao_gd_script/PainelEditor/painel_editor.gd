@tool
extends PanelContainer

@onready var seja_bem_vindo: VBoxContainer = %"Seja Bem Vindo"
@onready var listas_de_exercicios: VBoxContainer = %"Listas De Exercicios"
@onready var exercicios: PainelTestes = %Exercicios
@onready var ebook: VBoxContainer = %Ebook

func _ready() -> void:
	# Conecta sinal de abrir teste da lista de exercícios
	if listas_de_exercicios.has_signal("abrir_teste_exercicio"):
		listas_de_exercicios.abrir_teste_exercicio.connect(_on_abrir_teste_exercicio)
	seja_bem_vindo.visible = true

func _on_abrir_teste_exercicio(lista: String, exercicio: String) -> void:
	# Muda para a aba de exercícios
	seja_bem_vindo.visible = false
	listas_de_exercicios.visible = false
	exercicios.visible = true
	ebook.visible = false
	
	# Chama função do painel de testes para selecionar o exercício
	exercicios.selecionar_exercicio(lista, exercicio)
