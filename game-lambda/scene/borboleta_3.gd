extends AnimatedSprite2D

var velocidade_x: float = 60.0
var limite_esquerdo: float = -40.0
var limite_direito: float = 650.0

func _process(delta: float) -> void:
	# Aplica o movimento
	position.x += velocidade_x * delta
	
	# Se bater no limite da direita, vira para a esquerda
	if position.x > limite_direito:
		velocidade_x = -60.0 # Velocidade negativa faz ela voltar
		flip_h = true # Vira o desenho da borboleta de costas
		
	# Se bater no limite da esquerda, vira para a direita de novo
	elif position.x < limite_esquerdo:
		velocidade_x = 60.0 # Velocidade positiva faz ir pra frente
		flip_h = false # Desvira o desenho da borboleta
