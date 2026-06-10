extends Node

var from_world
var coins := 0

# Variáveis do cronômetro global
var tempo_total: float = 0.0
var minutes: int = 0
var seconds: int = 0
var contar_tempo: bool = false

func _process(delta: float) -> void:
	if not contar_tempo:
		return
		
	tempo_total += delta
	seconds = int(tempo_total) % 60
	minutes = int(tempo_total) / 60

func resetar_timer():
	tempo_total = 0.0
	minutes = 0
	seconds = 0
