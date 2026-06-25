extends Node
# ============================================================================
# Api - Singleton (autoload) que centraliza TODA a conversa com a API Flask.
#
# Requisições HTTP são assíncronas: a gente "pede" agora e a resposta chega
# depois. Por isso cada função dispara o pedido e o resultado volta por um
# SINAL, que as telas do jogo escutam (connect).
#
# Uso nas telas:
#   Api.itens_recebidos.connect(minha_funcao)
#   Api.buscar_itens()
# ============================================================================

# Endereço da API. Usamos 127.0.0.1 (IPv4) em vez de "localhost" de propósito:
# "localhost" pode resolver para IPv6 (::1), onde o Flask não escuta, e travar
# a requisição. Se um dia rodar em outro PC/porta, muda só aqui.
const BASE_URL := "http://127.0.0.1:5000"

# Sinais avisam o jogo quando a resposta chega.
signal itens_recebidos(itens: Dictionary)          # GET /api/itens
signal leaderboard_recebido(sucesso: bool, lista: Array)  # GET /api/leaderboard
signal partida_enviada(sucesso: bool)              # POST /api/partida

# Guarda a última resposta de /api/itens. Permite a loja exibir os nomes na
# hora (sem piscar o nome padrão) quando o prefetch já trouxe os dados.
var itens_cache: Dictionary = {}


# --- GET /api/itens : nomes herdados da loja --------------------------------
func buscar_itens() -> void:
	var req := HTTPRequest.new()
	add_child(req)
	req.timeout = 5.0
	req.request_completed.connect(_on_itens.bind(req))
	var erro := req.request(BASE_URL + "/api/itens")
	if erro != OK:
		# Nem conseguiu disparar (API fora do ar) -> manda vazio, loja usa nomes padrão.
		req.queue_free()
		itens_recebidos.emit({})

func _on_itens(result, response_code, _headers, body, req) -> void:
	req.queue_free()
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		itens_recebidos.emit({})
		return
	var dados = JSON.parse_string(body.get_string_from_utf8())
	if typeof(dados) != TYPE_DICTIONARY:
		itens_recebidos.emit({})
		return
	itens_cache = dados
	itens_recebidos.emit(dados)


# --- POST /api/partida : grava a run ao morrer no Cenário 4 -----------------
func enviar_partida(dados: Dictionary) -> void:
	var req := HTTPRequest.new()
	add_child(req)
	req.timeout = 5.0
	req.request_completed.connect(_on_partida.bind(req))
	var headers := ["Content-Type: application/json"]
	var corpo := JSON.stringify(dados)
	var erro := req.request(BASE_URL + "/api/partida", headers, HTTPClient.METHOD_POST, corpo)
	if erro != OK:
		req.queue_free()
		partida_enviada.emit(false)

func _on_partida(result, response_code, _headers, _body, req) -> void:
	req.queue_free()
	var ok: bool = result == HTTPRequest.RESULT_SUCCESS and (response_code == 200 or response_code == 201)
	partida_enviada.emit(ok)


# --- GET /api/leaderboard : ranking por tempo -------------------------------
func buscar_leaderboard() -> void:
	var req := HTTPRequest.new()
	add_child(req)
	req.timeout = 5.0
	req.request_completed.connect(_on_leaderboard.bind(req))
	var erro := req.request(BASE_URL + "/api/leaderboard")
	if erro != OK:
		req.queue_free()
		leaderboard_recebido.emit(false, [])

func _on_leaderboard(result, response_code, _headers, body, req) -> void:
	req.queue_free()
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		leaderboard_recebido.emit(false, [])
		return
	var dados = JSON.parse_string(body.get_string_from_utf8())
	if typeof(dados) != TYPE_DICTIONARY or not dados.has("leaderboard"):
		leaderboard_recebido.emit(false, [])
		return
	leaderboard_recebido.emit(true, dados["leaderboard"])
