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

# --- ESPAÇO DA API ---
func preparar_envio_api() -> void:
	var dados_partida = {
		"nickname": Global.player_nickname,
		"tempo_segundos": Global.tempo_total,
		"moedas_coletadas": Global.coins,
		"comprou_bota": Global.has_boots,
		"comprou_armadura": Global.has_armor,
		"venceu_jogo": true
	}
	
	print("Simulando envio para o Banco de Dados: ", dados_partida)
	
	# var json_data = JSON.stringify(dados_partida)
	# var headers = ["Content-Type: application/json"]
	# http_request.request("http://localhost:5000/api/partida", headers, HTTPClient.METHOD_POST, json_data)
