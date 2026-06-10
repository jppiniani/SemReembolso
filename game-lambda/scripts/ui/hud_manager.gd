extends Node

@onready var coins_counter: Label = $Control/MarginContainer/Coins_Container/coins_counter as Label
@onready var timer_counter: Label = $Control/MarginContainer/Timer_Container/timer_counter as Label

var minutes = 0
var seconds = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins_counter.text = str("%04d" % Global.coins)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	coins_counter.text = str("%04d" % Global.coins)
	timer_counter.text = str("%02d" % Global.minutes) + ":" + str("%02d" % Global.seconds)
