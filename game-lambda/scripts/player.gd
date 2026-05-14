extends CharacterBody2D

# Classificar coisas como se fossem números  
enum PlayerState{ 
	idle,
	walk,
	jump,
	fall
}

# Variável nova referenciando o nó do AnimatedSprite2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D # Caminho do nó

const SPEED = 80.0
const JUMP_VELOCITY = -300.0

# Variavel que só pode receber algum dos valores do enum, se não gera erro
var status: PlayerState

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	
	# Se não está no chão, vai cair
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Fica a cima de todos os status pq é uma função "global"
	
	
	# Switch das outras linguagens, esse comando vai ficar rodando sempre que o jogo estiver aberto 
	# e vai conferindo qual o estado do player
	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.walk:
			walk_state()
		PlayerState.jump:
			jump_state()
		PlayerState.fall:
			fall_state()

	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")
	
func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")
	
func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	
func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall")

func idle_state():
	move()
	if velocity.x != 0:
		go_to_walk_state()
		return
	
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
	if !is_on_floor():
		go_to_fall_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
		
func jump_state():
	move()
	if Input.is_action_just_pressed("jump") && is_on_floor():
		go_to_jump_state()
		return
		
	if velocity.y > 0:
		go_to_fall_state()
		return
		
func fall_state():
	move()
	if is_on_floor():
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return

# Lógica da direção
func move():
	var direction := Input.get_axis("left", "right") # left e right estão no mapa de entrada com outras teclas
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false










# func _physics_process(delta: float) -> void:

	# Lógica do pulo
	# if Input.is_action_just_pressed("jump") and is_on_floor(): # jump está no mapa de entrada com outras teclas
		# velocity.y = JUMP_VELOCITY

	
	# Logica de andar mudou

	# Lógica das animações
	#if direction > 0: # SE direção maior que 0 (Direita)
		#anim.flip_h = false # Não vira a imagaem
		#anim.play("walk")
	#elif direction < 0: # SE direção menor que 0 (Esquerda)
		#anim.flip_h = true # Vira a imagem
		#anim.play("walk")
	#else:
		#anim.play("idle") # Idle para quando estiver parado
	#if not is_on_floor():
		#anim.play("jump") # Jump quando não estiver no chão
	# FIZ DIFERENTE DO TUTORIAL DO VIDEO PQ ELE NAO MUDAVA DE DIREÇÃO NO PULO
	# Com maquina de estados não precisa dessa gambiarra toda ^
