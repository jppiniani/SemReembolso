extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass
var player: Node2D

func get_player():
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() == 0:
		push_error("Player não foi encontrado!")
		return
			
	player = nodes[0]
	
func _physics_process(_delta: float) -> void:
	get_player()
	if player:
		if player.position < position:
			anim.flip_h = 1
		else:
			anim.flip_h = 0
