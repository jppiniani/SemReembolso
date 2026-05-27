extends CanvasLayer

@onready var voltar_btn: Button = $menuHolder/voltar_btn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	$MenuOpcoes.voltar_pressionado.connect(_on_menu_opcoes_fechado)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_voltar_btn_pressed() -> void:
	get_tree().paused = false
	visible = false
	MusicaGlobal.abafar_musica_pause(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not get_tree().paused:
		visible = true
		get_tree().paused = true
		voltar_btn.grab_focus()
		
		MusicaGlobal.abafar_musica_pause(true)
		
		get_viewport().set_input_as_handled()

func _on_opcoes_btn_pressed() -> void:
	# Mostra a tela de opções quando clicar
	$MenuOpcoes.visible = true 
	$menuHolder.visible = false
	$MenuOpcoes/MarginContainer/VBoxContainer/HBoxContainer/BotaoSom.grab_focus()

func _on_sair_btn_pressed() -> void:
	get_tree().quit()

func _on_menu_opcoes_fechado() -> void:
	$menuHolder.visible = true
	voltar_btn.grab_focus()
