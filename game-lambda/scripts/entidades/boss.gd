extends CharacterBody2D

enum BossState {
	walk,
	dead
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector

@export var tela_vitoria_cena: PackedScene

const SPEED = 50.0
var direction = 1
var status: BossState

# --- LÓGICA EXCLUSIVA DO CHEFE ---
var hp: int = 3
var is_invincible: bool = false # Previne dano duplo no mesmo salto

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		BossState.walk:
			walk_state(delta)
		BossState.dead:
			dead_state(delta)
	
	move_and_slide()

func go_to_walk_state():
	status = BossState.walk
	anim.play("walk")
	
func go_to_dead_state():
	status = BossState.dead
	anim.play("dead")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	
	Global.contar_tempo = false 
	
	await get_tree().create_timer(1.0).timeout 
	
	# Chama a interface de inserir o Nickname
	if tela_vitoria_cena:
		var tela = tela_vitoria_cena.instantiate()
		get_tree().root.add_child(tela)
		
	queue_free()
	
func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding() or not ground_detector.is_colliding():
		inverter_direcao()
		
func inverter_direcao():
	scale.x *= -1
	direction *= -1

func dead_state(_delta):
	pass

# --- O SISTEMA DE 3 ACERTOS ---
func take_damage():
	# Se o chefe estiver a piscar do último golpe ou já estiver morto, ignora
	if is_invincible or status == BossState.dead:
		return
		
	hp -= 1
	
	if hp <= 0:
		go_to_dead_state()
	else:
		# Se ainda tiver vida, ativa a invencibilidade temporária
		feedback_dano()

func feedback_dano() -> void:
	is_invincible = true
	
	# Usamos um Tween para fazer o chefe piscar a vermelho indicando que levou dano
	var tween = create_tween()
	tween.set_loops(3) # Repete o piscar 3 vezes
	
	# Fica vermelho escuro
	tween.tween_property(anim, "modulate", Color(0.8, 0.1, 0.1), 0.1)
	# Volta à cor original
	tween.tween_property(anim, "modulate", Color(1, 1, 1), 0.1)
	
	# Congela a execução desta função específica por meio segundo (0.5s)
	await get_tree().create_timer(0.5).timeout
	
	# O chefe volta a ficar vulnerável para o próximo salto do jogador
	is_invincible = false
	anim.modulate = Color(1, 1, 1) # Garante que a cor não fica presa a meio do processo
