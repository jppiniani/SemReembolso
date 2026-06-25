extends Node

var from_world
var coins := 0
var player_nickname: String = ""

var ja_visitou_cenario_2: bool = false
var cenario2_modo_hard: bool = false

# Variáveis do cronômetro global
var tempo_total: float = 0.0
var minutes: int = 0
var seconds: int = 0
var contar_tempo: bool = false

# Variáveis dos Itens (ESTADO DE JOGO: has_armor "quebra" ao tomar dano).
var has_boots: bool = false
var has_armor: bool = false

# Posse PERMANENTE dos itens (para a herança no banco). Ao contrário de has_armor,
# estas NUNCA são zeradas ao tomar dano: registram o que foi COMPRADO na run.
var comprou_bota: bool = false
var comprou_armadura: bool = false

var primeira_interacao_concluida: bool = false

func _process(delta: float) -> void:
	if not contar_tempo:
		return
		
	tempo_total += delta
	seconds = int(tempo_total) % 60
	minutes = int(tempo_total) / 60

func resetar_partida() -> void:
	player_nickname = ""
	coins = 0
	resetar_timer()
	contar_tempo = false
	
	has_boots = false
	has_armor = false
	comprou_bota = false
	comprou_armadura = false
	
	cenario2_modo_hard = false
	ja_visitou_cenario_2 = false
	
	primeira_interacao_concluida = false
	
	from_world = null

func resetar_timer():
	tempo_total = 0.0
	minutes = 0
	seconds = 0
