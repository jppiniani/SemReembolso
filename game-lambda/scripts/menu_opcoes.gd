extends Control

signal voltar_pressionado
var master_bus = AudioServer.get_bus_index("Master")
@onready var botaoSom = $MarginContainer/VBoxContainer/HBoxContainer/BotaoSom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Quando o menu abrir, garante que o botão mostra o estado real do som
	botaoSom.button_pressed = not AudioServer.is_bus_mute(master_bus)
	visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_botao_som_toggled(toggled_on: bool) -> void:
	# Se toggled_on for verdadeiro (botão ligado), mute fica falso.
	# Se for falso (botão desligado), mute fica verdadeiro.
	AudioServer.set_bus_mute(master_bus, not toggled_on)


func _on_voltar_btn_pressed() -> void:
	# Apenas esconde o menu de opções quando clicar em voltar
	visible = false
	voltar_pressionado.emit()
