extends Node
class_name CameraManager

var CurrentCamera : GameCamera

func _init():
	# --- Make Camera
	CurrentCamera = GameCamera.new()
	CurrentCamera.SetCurrent(true)
	add_child(CurrentCamera)
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		Input.action_press("MouseYaw+",-event.relative.x)
		Input.action_press("MouseYaw-",event.relative.x)
		Input.action_press("MousePitch+",-event.relative.y)
		Input.action_press("MousePitch-",event.relative.y)

func _process(_delta):
	if CurrentCamera != null:
		CurrentCamera.Update(_delta)
	
	# --- Release the Camera Mouse Actions
	Input.action_release("MouseYaw+")
	Input.action_release("MouseYaw-")
	Input.action_release("MousePitch+")
	Input.action_release("MousePitch-")
