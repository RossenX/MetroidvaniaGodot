@tool
extends Area2D

var playerOutOfBounds : int = 0

func _get_configuration_warnings() -> PackedStringArray:
	return []

func _ready():
	if !Engine.is_editor_hint():
		visible = false

func _physics_process(_delta):
	if !Engine.is_editor_hint():
		if Game.GetCurrentPlayerActor() != null:
			if !(Game.GetCurrentPlayerActor() in get_overlapping_bodies()):
				playerOutOfBounds += 1
			else:
				playerOutOfBounds = 0
			
			if playerOutOfBounds > 10:
				playerOutOfBounds = 0
				Game.GetCurrentPlayerActor().global_position = get_parent().global_position
