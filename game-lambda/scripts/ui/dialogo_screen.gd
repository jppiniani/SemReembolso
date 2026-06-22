extends Control
class_name DialogScreen

var _step: float = 0.05
var _id: int = 0
var data: Dictionary = {}

@export_category("Objects")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null
@export var _faceset: TextureRect = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	
	focus_mode = Control.FOCUS_ALL
	grab_focus()
	
	_initialize_dialog()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("interact") and _dialog.visible_ratio < 1:
		_step = 0.01
	else:
		_step = 0.05

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and _dialog.visible_ratio >= 1:
		
		get_viewport().set_input_as_handled() 
		
		_id += 1
		if _id == data.size():
			get_tree().paused = false
			queue_free()
			return
		
		_initialize_dialog()

func _initialize_dialog():
	_name.text = data[_id]["title"]
	_dialog.text = data[_id]["dialog"]
	_faceset.texture = load(data[_id]["faceset"])
	
	_dialog.visible_characters = 0
	while _dialog.visible_ratio < 1:
		# Pequena proteção: evita erros caso a cena feche antes do timer acabar
		if not is_inside_tree(): break 
		
		await get_tree().create_timer(_step).timeout
		_dialog.visible_characters += 1
