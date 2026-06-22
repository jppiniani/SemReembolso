extends CharacterBody2D

# Classificar coisas como se fossem números  
enum PlayerState{ 
	idle,
	walk,
	jump,
	fall,
	dead
}

# Variável nova referenciando o nó do AnimatedSprite2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D # Caminho do nó
@onready var jump_sfx: AudioStreamPlayer = $jump
@onready var reload_timer: Timer = $ReloadTimer

const SPEED = 80.0
var JUMP_VELOCITY = -320.0

var vida_base: int = 1
var vida_atual: int = 1
var is_invincible: bool = false
var tempo_invencibilidade: float = 1.5 # Tempo em segundos que ele ficará piscando

# Variavel que só pode receber algum dos valores do enum, se não gera erro
var status: PlayerState

func _ready() -> void:
	add_to_group("Player")
	atualizar_equipamentos()
	
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
		PlayerState.dead:
			dead_state(delta)

	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")
	
func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")
	
func go_to_jump_state():
	jump_sfx.play()
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	
func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall")
	
func go_to_dead_state():
	if status == PlayerState.dead:
		return
	
	status = PlayerState.dead
	anim.play("dead")
	velocity = Vector2.ZERO
	reload_timer.start()

func idle_state():
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
		
	move()
	if velocity.x != 0:
		go_to_walk_state()
		return
	
	
	
func walk_state():
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
		
	if !is_on_floor():
		go_to_fall_state()
		return
		
	move()
	if velocity.x == 0:
		go_to_idle_state()
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

func dead_state(_delta):
	pass

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

func _on_hitbox_area_entered(area: Area2D) -> void:
	if velocity.y > 0:
		# inimigo morre
		area.get_parent().take_damage()
		go_to_jump_state()
	else:
		tomar_dano()
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("LethalArea"):
		tomar_dano()
	
	
func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()

func atualizar_equipamentos():
# Bota aumenta a altura do pulo
	if Global.has_boots:
		JUMP_VELOCITY = -450.0

	# Armadura concede o dobro de vida base
	if Global.has_armor:
		vida_atual = vida_base * 2
	# Crie recursos "SpriteFrames" diferentes para cada variação do personagem
	if Global.has_boots and Global.has_armor:
	# anim.sprite_frames = preload("res://caminho/para/frames_completo.tres")
		pass
	elif Global.has_boots:
	# anim.sprite_frames = preload("res://caminho/para/frames_bota.tres")
		pass
	elif Global.has_armor:
	# anim.sprite_frames = preload("res://caminho/para/frames_armadura.tres")
		pass
		
func tomar_dano() -> void:
	# Ignora o dano se já estiver morto ou invencível
	if status == PlayerState.dead or is_invincible:
		return
	vida_atual -= 1
	
	if vida_atual <= 0:
		# Se a vida zerou, morre de vez
		go_to_dead_state()
	else:
		# Se sobreviveu, significa que tinha armadura. 
		# Ela quebra IMEDIATAMENTE.
		Global.has_armor = false
		# Atualiza o visual para tirar a armadura do corpo
		atualizar_equipamentos() 
		# Inicia os i-frames piscantes
		ativar_invencibilidade()
		
func ativar_invencibilidade() -> void:
	is_invincible = true
	
	# Cria uma animação via código (Tween)
	var tween = create_tween()
	# Faz o Tween repetir a animação de piscar várias vezes
	tween.set_loops(int(tempo_invencibilidade * 5)) 
	
	# Deixa o sprite quase transparente (Alpha 0.2) em 0.1 segundos
	tween.tween_property(anim, "modulate:a", 0.2, 0.1)
	# Volta para a cor sólida (Alpha 1.0) em 0.1 segundos
	tween.tween_property(anim, "modulate:a", 1.0, 0.1)
	
	# Pausa a execução DESTA função até o tempo de invencibilidade acabar
	await get_tree().create_timer(tempo_invencibilidade).timeout
	
	# Retorna ao estado vulnerável
	is_invincible = false
	anim.modulate.a = 1.0 # Garante que a opacidade volte ao normal (100%) no final
	
	# OPCIONAL: Se quiser que ele "perca" a armadura visualmente ao tomar dano
	if vida_atual == 1:
		Global.has_armor = false
		atualizar_equipamentos() # Roda aquela função que troca os sprites frames
		
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
