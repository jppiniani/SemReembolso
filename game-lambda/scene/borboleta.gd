extends AnimatedSprite2D

# --- Configurações de ir para os lados ---
var velocidade_x: float = 60.0
var limite_esquerdo: float = -25.0
var limite_direito: float = 650.0

# --- Configurações do sobe e desce ---
var tempo: float = 0.0
var amplitude_y: float = 0.5 # Altura do pulinho
var velocidade_onda: float = 5.0 # Rapidez do sobe e desce

func _process(delta: float) -> void:
	# 1. Faz a borboleta ir para os lados
	position.x += velocidade_x * delta
	
	# Verifica se ela chegou na borda direita
	if position.x > limite_direito:
		velocidade_x = -60.0 # Muda a direção para a esquerda
		flip_h = true        # Vira o rostinho dela
		
	# Verifica se ela chegou na borda esquerda
	elif position.x < limite_esquerdo:
		velocidade_x = 60.0  # Muda a direção para a direita
		flip_h = false       # Desvira o rostinho dela

	# 2. Faz o movimento de onda (sobe e desce)
	tempo += delta * velocidade_onda
	position.y += sin(tempo) * amplitude_y
