@tool
extends Area2D

@export var LevelName := "level_02"
var nodeName : String

func _process(_delta):
	if Engine.is_editor_hint():
		if name != "-> " + LevelName + "_" + str(get_index()):
			name = "-> " + LevelName + "_" + str(get_index())
			
func _physics_process(_delta):
	if !Engine.is_editor_hint():
		if Game.GetCurrentPlayerActor() in get_overlapping_bodies():
			Game.ChangeLevel(LevelName)
