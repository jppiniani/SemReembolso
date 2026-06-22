extends Node2D

const _DIALOG_SCREEN: PackedScene = preload("res://scene/dialogo_screen.tscn")

# Preencha com o caminho correto da sua cena da Loja!
const _SHOP_SCREEN: PackedScene = preload("res://entities/loja.tscn") 

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://sprites/faceset/mercador.png",
		"dialog": "Ola, seja bem vindo!",
		"title": "Mercador"
	},
	1: {
		"faceset": "res://sprites/faceset/mercador.png",
		"dialog": "Percebo que voce eh novo aqui",
		"title": "Mercador"
	},
	2: {
		"faceset": "res://sprites/faceset/mercador.png",
		"dialog": "Sou o mercador dessa terra, porem enfrento muitos perigos aqui sozinho...",
		"title": "Mercador"
	},
	3: {
		"faceset": "res://sprites/faceset/mercador.png",
		"dialog": "Preciso de um corajoso heroi que possa me livrar dos monstros que vivem aqui..",
		"title": "Mercador"
	},
	4: {
		"faceset": "res://sprites/faceset/mercador.png",
		"dialog": "Derrote os monstros que estao a frente para coletar moedas",
		"title": "Mercador"
	},
	5: {
		"faceset": "res://sprites/faceset/mercador.png",
		"dialog": "Depois volte e compre meus itens que te ajudarao a derrotar o monstro mais poderoso!",
		"title": "Mercador"
	},
}

@export_category("Objects")
@export var _hud: CanvasLayer = null

@onready var _dialog_area: Area2D = $Diálogo/DialogArea

var _can_interact: bool = false

func _ready() -> void:
	if Global.ja_visitou_cenario_2:
		Global.cenario2_modo_hard = true
		
	MusicaGlobal.tocar_musica("res://sounds/music/shop.mp3")
	Global.contar_tempo = true
	
	if Global.from_world != null:
		$Player.global_position = get_node(Global.from_world + "Pos").global_position
		
	_dialog_area.body_entered.connect(_on_dialog_area_body_entered)
	_dialog_area.body_exited.connect(_on_dialog_area_body_exited)

func _process(_delta: float) -> void:
	if _can_interact and Input.is_action_just_pressed("interact"):
		if _hud.get_child_count() == 0: 
			
			# Se for a primeira vez, mostra o diálogo
			if not Global.primeira_interacao_concluida:
				var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
				_new_dialog.data = _dialog_data
				_hud.add_child(_new_dialog)
				
				# Marca que a interação inicial foi concluída
				Global.primeira_interacao_concluida = true
				
				# Espera o diálogo ser finalizado e destruído (queue_free)
				await _new_dialog.tree_exited 
				
				# Abre a loja logo após o diálogo terminar
				abrir_loja()
				
			# Se não for a primeira vez, vai direto para a loja
			else:
				abrir_loja()

# Função modular para abrir a loja
func abrir_loja() -> void:
	var _nova_loja = _SHOP_SCREEN.instantiate()
	_hud.add_child(_nova_loja)

func _on_dialog_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		_can_interact = true

func _on_dialog_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_can_interact = false
