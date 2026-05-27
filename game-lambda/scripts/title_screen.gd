extends Control

@onready var start_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/start_btn
@onready var opcoes_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/opcoes_btn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicaGlobal.tocar_musica("res://sounds/music/titleTheme.mp3")
	start_btn.grab_focus()
	$MenuOpcoes.voltar_pressionado.connect(_on_menu_opcoes_fechado)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/rascunho.tscn")

func _on_opcoes_btn_pressed() -> void:
	$MenuOpcoes.visible = true
	$MarginContainer.visible = false
	$MenuOpcoes/MarginContainer/VBoxContainer/HBoxContainer/BotaoSom.grab_focus()

func _on_leaderboard_btn_pressed() -> void:
	pass # Replace with function body.


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
	
	
func _on_menu_opcoes_fechado() -> void:
	$MarginContainer.visible = true
	opcoes_btn.grab_focus()
