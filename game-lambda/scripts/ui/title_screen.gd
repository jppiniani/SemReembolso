extends Control

@onready var start_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/start_btn
@onready var opcoes_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/opcoes_btn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicaGlobal.tocar_musica("res://sounds/music/titleTheme.mp3")
	start_btn.grab_focus()
	$MenuOpcoes.voltar_pressionado.connect(_on_menu_opcoes_fechado)
	
	if Global.from_world != null and Global.from_world != "":
		var nome_do_no = Global.from_world + "Pos"
		
		# Verifica se o nó realmente existe na árvore antes de tentar acessá-lo
		if has_node(nome_do_no):
			$Player.global_position = get_node(nome_do_no).global_position
		else:
			print("Aviso: Ponto de spawn '", nome_do_no, "' não encontrado! Usando posição padrão.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_btn_pressed() -> void:
	Global.from_world = null
	get_tree().change_scene_to_file("res://scene/cenario_1.tscn")

func _on_opcoes_btn_pressed() -> void:
	$MenuOpcoes.visible = true
	$MarginContainer.visible = false
	$MenuOpcoes/MarginContainer/VBoxContainer/HSlider.grab_focus()

func _on_leaderboard_btn_pressed() -> void:
	# Instancia a tela do leaderboard por cima do menu. Ela se fecha sozinha no "Voltar".
	var cena := load("res://scene/leaderboard.tscn")
	add_child(cena.instantiate())


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
	
	
func _on_menu_opcoes_fechado() -> void:
	$MarginContainer.visible = true
	opcoes_btn.grab_focus()
