extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

# --- CONFIGURAÇÕES DE PATRULHA ---
@export var patrol_distance: float = 150.0 # Quantos pixels ele viaja antes de virar
const SPEED = 60.0
var direction = 1
var start_x: float = 0.0

# --- CONFIGURAÇÕES DE VOO (ONDA SENOIDAL) ---
var tempo_passado: float = 0.0
@export var amplitude_voo: float = 30.0
@export var frequencia_voo: float = 3.0 #

func _ready() -> void:
	start_x = global_position.x
	anim.play("fly")
	anim.flip_h = (direction > 0)

func _physics_process(delta: float) -> void:
	velocity.x = SPEED * direction
	
	var distancia_percorrida = global_position.x - start_x
	
	if distancia_percorrida > patrol_distance and direction > 0:
		inverter_direcao()
	elif distancia_percorrida < -patrol_distance and direction < 0:
		inverter_direcao()
		
	tempo_passado += delta
	velocity.y = sin(tempo_passado * frequencia_voo) * amplitude_voo
		
	move_and_slide()

func inverter_direcao() -> void:
	direction *= -1
	anim.flip_h = (direction > 0)

# --- SISTEMA DE DANO E IMORTALIDADE ---

func take_damage() -> void:
	pass

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("tomar_dano"):
			body.tomar_dano()
