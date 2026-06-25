extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
#@onready var http_request: HTTPRequest = $API_Request

func _ready() -> void:
	MusicaGlobal.stop()
	anim_player.animation_finished.connect(_on_animation_finished)
	
	anim_player.play("animacao_final")

func _on_animation_finished(_anim_name: String) -> void:
	preparar_envio_api()
	
	Global.resetar_partida()
	
	get_tree().change_scene_to_file("res://scene/title_screen.tscn")

# --- ENVIO PARA A API ---
func preparar_envio_api() -> void:
	var dados_partida = {
		"nickname": Global.player_nickname,
		"tempo_segundos": Global.tempo_total,
		"moedas_coletadas": Global.coins,
		"comprou_bota": Global.comprou_bota,
		"comprou_armadura": Global.comprou_armadura,
		"venceu_jogo": true
	}

	# Dispara o POST único da run. A requisição vive no autoload Api, então
	# continua e completa mesmo depois desta cena ser trocada pelo menu.
	Api.enviar_partida(dados_partida)
