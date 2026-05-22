extends CanvasLayer

@onready var voltar_btn: Button = $menuHolder/voltar_btn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_voltar_btn_pressed() -> void:
	get_tree().paused = false
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true
		voltar_btn.grab_focus()

func _on_opcoes_btn_pressed() -> void:
	pass # Replace with function body.


func _on_sair_btn_pressed() -> void:
	get_tree().quit()
