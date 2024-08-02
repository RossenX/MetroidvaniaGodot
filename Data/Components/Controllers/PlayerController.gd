extends Controller
class_name PlayerController

func Update(_delta : float):
	if Panku.get_shell_visibility():
		InputDirection = Vector2.ZERO
		return
	
	# --- General Movement
	InputDirection = Input.get_vector("Left","Right","Up","Down")
	
	# --- Inputs -> Tags
	for i in InputMap.get_actions():
		if Input.is_action_pressed(i):
			if Input.is_action_just_pressed(i):
				Tags.AddTag(i+"(Down)")
			else:
				Tags.DelTag(i+"(Down)")
			Tags.AddTag(i)
		else:
			Tags.DelTag(i+"(Down)")
			Tags.DelTag(i)
