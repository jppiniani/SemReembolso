extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collect_sfx: AudioStreamPlayer = $collect

var pode_coletar : bool = false
var coins := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Desativa a colisão no início para o jogador não pegar no ar
	monitoring = false
	
	# Posições para simular a física
	var pos_chao = global_position
	var pos_ar = pos_chao + Vector2(0, -35) # Sobe 35 pixels
	
	# Tween para animar a moeda
	var tween = create_tween()
	
	# 1. Sobe rápido (EASE_OUT faz ela perder força no topo, como na gravidade)
	tween.tween_property(self, "global_position", pos_ar, 0.2)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	# 2. Cai rápido de volta pro exato lugar do chão (EASE_IN faz ela ganhar velocidade caindo)
	tween.tween_property(self, "global_position", pos_chao, 0.2)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
	
	# Espera o pulinho (Tween) terminar
	await tween.finished
	
	# Ativa a colisão para o jogador poder coletar
	monitoring = true
	pode_coletar = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(_body: Node2D) -> void:
	if pode_coletar:
		pode_coletar = false # Evita rodar o som/animação duas vezes
		set_deferred("monitoring", false)   # Desativa colisão para não coletar de novo
		anim.play("collect")
		# Evita a colisão dupla de moedas
		await $CollisionShape2D.call_deferred("queue_free")
		collect_sfx.play()
		Global.coins += coins
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "collect":
		queue_free()
