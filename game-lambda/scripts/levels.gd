extends Node2D

const _DIALOG_SCREEN: PackedScene = preload("res://scene/dialogo_screen.tscn")
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

# Pega a referência da DialogArea que está na sua árvore de nós
@onready var _dialog_area: Area2D = $DialogArea

# Variável para controlar se o jogador está perto o suficiente
var _can_interact: bool = false

func _ready() -> void:
	MusicaGlobal.tocar_musica("res://sounds/music/shop.mp3")
	if Global.from_world != null:
		$Player.global_position = get_node(Global.from_world + "Pos").global_position
		
	 #Conecta os sinais da Area2D via código (Padrão do Godot 4)
	_dialog_area.body_entered.connect(_on_dialog_area_body_entered)
	_dialog_area.body_exited.connect(_on_dialog_area_body_exited)

func _process(delta: float) -> void:
	# Verifica se pode interagir E se o botão foi pressionado
	if _can_interact and Input.is_action_just_pressed("ui_accept"):
		
		# Verifica se já não existe um diálogo na tela para evitar sobreposição
		if _hud.get_child_count() == 0: 
			var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
			_new_dialog.data = _dialog_data
			_hud.add_child(_new_dialog)



# Acionado quando algum corpo entra na Area2D
func _on_dialog_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		_can_interact = true

# Acionado quando algum corpo sai da Area2D
func _on_dialog_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_can_interact = false


#func _on_dialog_area_body_entered(body: Node2D) -> void:
	#print("Alguém entrou na área: ", body.name)
	#pass # Replace with function body.
#
#
#func _on_dialog_area_body_exited(body: Node2D) -> void:
	#pass # Replace with function body.


## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#MusicaGlobal.tocar_musica("res://sounds/music/shop.mp3")
	#if Global.from_world != null:
		#$Player.global_position = get_node(Global.from_world + "Pos").global_position
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass
