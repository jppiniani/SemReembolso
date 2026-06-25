extends Control
# ============================================================================
# Tela de Leaderboard. A interface inteira é construída por código no _ready().
# Pede o ranking ao autoload Api e preenche a lista (posição / apelido / tempo).
# O botão "Voltar" fecha a tela (queue_free), revelando o menu por baixo.
# ============================================================================

var lista_container: VBoxContainer  # onde as linhas do ranking entram
var label_status: Label             # mostra "Carregando...", erro ou "vazio"


func _ready() -> void:
	# Ocupa a tela inteira.
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Usa o mesmo tema do menu, pra fonte/estilo combinarem.
	var tema = load("res://UI/TemaBotaoMenu/temaMenu.tres")
	if tema:
		theme = tema

	_montar_ui()

	# Escuta a resposta (uma vez) e dispara o GET do ranking.
	Api.leaderboard_recebido.connect(_ao_receber_leaderboard, CONNECT_ONE_SHOT)
	Api.buscar_leaderboard()


func _montar_ui() -> void:
	# Fundo escuro que cobre o menu e bloqueia cliques por baixo.
	var fundo := ColorRect.new()
	fundo.color = Color(0.05, 0.05, 0.08, 0.96)
	fundo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(fundo)

	var margem := MarginContainer.new()
	margem.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margem.add_theme_constant_override("margin_left", 12)
	margem.add_theme_constant_override("margin_right", 12)
	margem.add_theme_constant_override("margin_top", 8)
	margem.add_theme_constant_override("margin_bottom", 8)
	add_child(margem)

	var vbox := VBoxContainer.new()
	margem.add_child(vbox)

	# Título.
	var titulo := Label.new()
	titulo.text = "LEADERBOARD"
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_font_size_override("font_size", 18)
	vbox.add_child(titulo)

	# Cabeçalho das colunas.
	vbox.add_child(_criar_linha("#", "Apelido", "Tempo"))

	# Lista rolável (caso tenha muitas runs).
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)

	lista_container = VBoxContainer.new()
	lista_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(lista_container)

	# Mensagem de status (carregando / erro / vazio).
	label_status = Label.new()
	label_status.text = "Carregando..."
	label_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(label_status)

	# Botão Voltar.
	var voltar := Button.new()
	voltar.text = "Voltar"
	voltar.size_flags_horizontal = Control.SIZE_SHRINK_END
	voltar.pressed.connect(_on_voltar)
	vbox.add_child(voltar)
	voltar.grab_focus()


# Cria uma linha com 3 colunas alinhadas: posição | apelido | tempo.
func _criar_linha(pos: String, nick: String, tempo: String) -> HBoxContainer:
	var linha := HBoxContainer.new()

	var l_pos := Label.new()
	l_pos.text = pos
	l_pos.custom_minimum_size = Vector2(26, 0)

	var l_nick := Label.new()
	l_nick.text = nick
	l_nick.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l_nick.clip_text = true

	var l_tempo := Label.new()
	l_tempo.text = tempo
	l_tempo.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	l_tempo.custom_minimum_size = Vector2(70, 0)

	linha.add_child(l_pos)
	linha.add_child(l_nick)
	linha.add_child(l_tempo)
	return linha


# Chamado quando a resposta da API chega.
func _ao_receber_leaderboard(sucesso: bool, lista: Array) -> void:
	if not sucesso:
		# Fluxo de erro do PDF (UC4 - E01 / MSG001).
		label_status.text = "Erro de conexao.\nNao foi possivel carregar o ranking no momento."
		return

	if lista.is_empty():
		label_status.text = "Nenhuma run registrada ainda."
		return

	label_status.visible = false

	var posicao := 1
	for entrada in lista:
		var t := int(entrada.get("tempo_segundos", 0))
		var tempo_fmt := "%02dm:%02ds" % [t / 60, t % 60]
		var nick := str(entrada.get("nickname", ""))
		lista_container.add_child(_criar_linha(str(posicao), nick, tempo_fmt))
		posicao += 1


func _on_voltar() -> void:
	queue_free()
