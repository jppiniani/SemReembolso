extends CharacterBody2D

enum OrcState {
	walk,
	dead
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector

@export var coin_scene: PackedScene

const SPEED = 30.0
const JUMP_VELOCITY = -400.0

var status: OrcState

var direction = 1

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		OrcState.walk:
			walk_state(delta)
		OrcState.dead:
			dead_state(delta)
	
	move_and_slide()

func go_to_walk_state():
	status = OrcState.walk
	anim.play("walk")
	
func go_to_dead_state():
	status = OrcState.dead
	anim.play("dead")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	
	await get_tree().create_timer(0.7).timeout
	
	if coin_scene:
		var coin_instance = coin_scene.instantiate()
		coin_instance.global_position = global_position
		get_parent().call_deferred("add_child", coin_instance)
		
	queue_free()
	
func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
	
func dead_state(_delta):
	pass

func take_damage():
	go_to_dead_state()
