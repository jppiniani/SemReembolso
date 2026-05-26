extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicaGlobal.tocar_musica("res://sounds/music/battle1.mp3")
	if Global.from_world != null:
		$Player.global_position = get_node(Global.from_world + "Pos").global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
