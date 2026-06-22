extends Control

@onready var btn_bota: Button = $MarginContainer/VBoxContainer/Item1/VBoxContainer/botao_bota
@onready var btn_armadura: Button = $MarginContainer/VBoxContainer/Item2/VBoxContainer/botao_armadura
@onready var btn_sair: Button = $btn_sair
const cena_dialogo: PackedScene = preload("res://scene/dialogo_screen.tscn")
@export var rosto_mercador: String = "res://sprites/faceset/mercador.png"

var preco_bota = 100
var preco_armadura = 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	atualizar_interface()
	# [ESPAÇO RESERVADO PARA API] - Fazer GET para pegar nome dos antigos donos e atualizar as Labels.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		fechar_loja()
		# O segredo: "Avisa" o Godot que esse input já foi tratado e o consome!
		get_viewport().set_input_as_handled()

func atualizar_interface() -> void:
	# Apenas o número
	btn_bota.text = str(preco_bota)
	btn_armadura.text = str(preco_armadura)
	
	# Deixa o botão cinza se já foi comprado, mas continua clicável
	if Global.has_boots:
		btn_bota.modulate = Color(0.5, 0.5, 0.5) 
		
	if Global.has_armor:
		btn_armadura.modulate = Color(0.5, 0.5, 0.5)

func disparar_dialogo(texto: String) -> void:
	var focado = get_viewport().gui_get_focus_owner()
	if focado:
		focado.release_focus()

	if cena_dialogo == null:
		print("Erro: Cena de diálogo não foi atribuída.")
		return
		
	var balao = cena_dialogo.instantiate()
	balao.data = {
		0: {
			"title": "Mercador",
			"dialog": texto,
			"faceset": rosto_mercador
		}
	}
	add_child(balao)

func _on_botao_bota_pressed() -> void:
	if Global.has_boots:
		disparar_dialogo("Ei, voce ja possui esse item!")
		return
		
	if Global.coins >= preco_bota:
		Global.coins -= preco_bota
		Global.has_boots = true
		finalizar_compra()
		disparar_dialogo("Obrigado por comprar!")
	else:
		disparar_dialogo("Voce nao possui moedas necessarias!")


func _on_botao_armadura_pressed() -> void:
	if Global.has_armor:
		disparar_dialogo("Ei, voce ja possui esse item!")
		return
		
	if Global.coins >= preco_armadura:
		Global.coins -= preco_armadura
		Global.has_armor = true
		finalizar_compra()
		disparar_dialogo("Obrigado por comprar!")
	else:
		disparar_dialogo("Voce nao possui moedas necessarias!")
		
func finalizar_compra() -> void:
	atualizar_interface()
	
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.atualizar_equipamentos()

func fechar_loja() -> void:
	# Destrói o nó da loja atual, removendo-o da tela do jogador
	queue_free()


func _on_btn_sair_pressed() -> void:
	fechar_loja()
