# ---
# Eventually This will be the intro/loading at the start, for now, nothing
# ---
extends Node2D

func _init():
	Game.LoadGameData()

func _ready():
	Game.SetupGame()

func _process(delta):
	$Icon.self_modulate.a -= 1 * delta
	if $Icon.self_modulate.a <= 0:
		queue_free()
