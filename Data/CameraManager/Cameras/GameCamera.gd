extends Node2D
class_name GameCamera

var Camera : Camera2D

func _init():
	DoSetup()

func _ready():
	name = "GameCameraParent"

func Update(_delta):
	if Game.GetCurrentPlayerActor() != null:
		global_position.x = Game.GetCurrentPlayerActor().global_position.x
		global_position.y = Game.GetCurrentPlayerActor().global_position.y
	
func DoSetup():
	if Camera == null:
		Camera = Camera2D.new()
		Camera.name = "MainCamera"
		Camera.zoom *= 2
		Camera.drag_horizontal_enabled = true
		Camera.drag_vertical_enabled = true
		add_child(Camera)

func SetCurrent(_cur : bool):
	DoSetup()
	#Camera.current = _cur
