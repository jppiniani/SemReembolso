extends CharacterBody2D

enum NpcState {
	idle
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D # Caminho do nó

var status: NpcState

func _ready() -> void:
	idle_state()

func _physics_process(delta: float) -> void:
	match status:
		NpcState.idle:
			idle_state()
	move_and_slide()
	
func idle_state():
	status = NpcState.idle
	if velocity.x == 0:
		anim.play("idle")
	
