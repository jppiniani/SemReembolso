extends Control

@onready var label_tempo: Label = $VBoxContainer/Label3
@onready var input_nick: LineEdit = $VBoxContainer/LineEdit
@onready var btn_avancar: Button = $VBoxContainer/Button

func _ready() -> void:
	# Pausa o jogo para o inimigo/fundo parar enquanto ele digita
	get_tree().paused = true 
	input_nick.grab_focus()
	
	# --- ATUALIZAÇÃO DO TEMPO NA TELA ---
	var tempo_formatado = str("%02d" % Global.minutes) + "m:" + str("%02d" % Global.seconds) + "s"
	label_tempo.text = tempo_formatado
	
	btn_avancar.pressed.connect(_on_btn_avancar_pressed)

func _on_btn_avancar_pressed() -> void:
	# Remove espaços em branco antes e depois do nome
	var nick = input_nick.text.strip_edges()
	
	if nick != "":
		Global.player_nickname = nick
		get_tree().paused = false # Despausa o jogo
		
		# Avança para o desfecho
		get_tree().change_scene_to_file("res://scene/cenario_4.tscn")
		queue_free()
	else:
		print("O jogador precisa digitar um nome!")
