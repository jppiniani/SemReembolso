extends AudioStreamPlayer

var volume_normal: float = -10.0
var volume_pausado: float = -20.0

func tocar_musica(caminho_da_musica: String):
	var nova_musica = load(caminho_da_musica)
	if stream == nova_musica:
		return # Não reinicia se a música já for a mesma

	stream = nova_musica
	volume_db = volume_normal
	play()
	
func abafar_musica_pause(esta_pausado: bool):
	var tween = create_tween()

	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) 

	if esta_pausado:
# Anima o volume atual até o volume_pausado em 0.5 segundos
		tween.tween_property(self, "volume_db", volume_pausado, 0.5)
	else:
# Retorna a música ao volume_normal em 0.5 segundos
		tween.tween_property(self, "volume_db", volume_normal, 0.5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
