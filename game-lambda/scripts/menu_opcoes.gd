extends Control

signal voltar_pressionado
var master_bus = AudioServer.get_bus_index("Master")
#@onready var botaoSom = $MarginContainer/VBoxContainer/HBoxContainer/BotaoSom
@onready var h_slider: HSlider = $MarginContainer/VBoxContainer/HSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Pega o volume atual do bus "Master" em decibéis (dB)
	var volume_db_atual = AudioServer.get_bus_volume_db(master_bus)
	
	# Converte de dB para linear (0.0 a 1.0 ou o valor que seu slider usar)
	# e define o valor do slider SEM emitir o sinal, para evitar loops.
	h_slider.set_value_no_signal(db_to_linear(volume_db_atual))
	
	visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


#func _on_botao_som_toggled(toggled_on: bool) -> void:
	## Se toggled_on for verdadeiro (botão ligado), mute fica falso.
	## Se for falso (botão desligado), mute fica verdadeiro.
	#AudioServer.set_bus_mute(master_bus, not toggled_on)


func _on_voltar_btn_pressed() -> void:
	# Apenas esconde o menu de opções quando clicar em voltar
	visible = false
	voltar_pressionado.emit()


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
