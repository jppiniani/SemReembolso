extends Node2D

@onready var inimigos_terrestres = $InimigosTerrestres
@onready var inimigos_voadores = $InimigosVoadores
@onready var barreira_retorno = $BarreiraRetorno 

func _ready() -> void:
	if Global.from_world != null:
		$Player.global_position = get_node(Global.from_world + "Pos").global_position
		
	# Oculta os voadores por padrão
	inimigos_voadores.visible = false
	inimigos_voadores.process_mode = Node.PROCESS_MODE_DISABLED
	
	if Global.cenario2_modo_hard:
		ativar_modo_hard()
	else:
		# PRIMEIRA VISITA (MODO NORMAL)
		Global.ja_visitou_cenario_2 = true
		
		# Desliga a barreira para o jogador poder voltar à loja
		if barreira_retorno:
			barreira_retorno.process_mode = Node.PROCESS_MODE_DISABLED
			barreira_retorno.visible = false
			
		# Toca a música pacífica/normal da fase (Ajuste o caminho do seu áudio)
		MusicaGlobal.tocar_musica("res://sounds/music/battle1.mp3")

func ativar_modo_hard() -> void:
	# MODO HARD (SEGUNDA VISITA)
	
	MusicaGlobal.tocar_musica("res://sounds/music/fallingApart.mp3")
	
	if barreira_retorno:
		barreira_retorno.process_mode = Node.PROCESS_MODE_INHERIT
		barreira_retorno.visible = true
	
	inimigos_voadores.visible = true
	inimigos_voadores.process_mode = Node.PROCESS_MODE_INHERIT
	
	for orc in inimigos_terrestres.get_children():
		# Checa se o nó realmente tem o método antes de alterar (evita bugs)
		if orc.has_method("take_damage"):
			orc.imortal = true
			
			orc.modulate = Color(0.8, 0.3, 0.3)

#extends Node2D
#
#@onready var inimigos_terrestres: Node2D = $InimigosTerrestres
#@onready var inimigos_voadores: Node2D = $InimigosVoadores
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#inimigos_voadores.visible = false
	#inimigos_voadores.process_mode = Node.PROCESS_MODE_DISABLED
	#
	#if Global.cenario2_modo_hard:
		#ativar_modo_hard()
	#else:
		#Global.ja_visitou_cenario_2 = true
	#MusicaGlobal.tocar_musica("res://sounds/music/battle1.mp3")
	#if Global.from_world != null:
		#$Player.global_position = get_node(Global.from_world + "Pos").global_position
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass
#
#func ativar_modo_hard() -> void:
	## 1. Acorda os inimigos voadores (eles já devem estar configurados como imortais no script deles)
	#inimigos_voadores.visible = true
	#inimigos_voadores.process_mode = Node.PROCESS_MODE_INHERIT
	#
	## 2. Transforma os Orcs normais em imortais
	#for orc in inimigos_terrestres.get_children():
		## Checa se o nó realmente tem o método antes de alterar (evita bugs)
		#if orc.has_method("take_damage"):
			#orc.imortal = true
			#
			#orc.modulate = Color(0.8, 0.3, 0.3)
