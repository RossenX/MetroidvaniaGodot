extends FSM_Character_State

var Char : Character

func OnEnter(_fsm : FSM):
	Char = _fsm.Owner as Character
	Tags.AddTags(["OnWall","FacingLock"])
	Char.Sprite.play("ClimbLadder")
	Char.velocity.x = 0
	ArtOffset.x = 1
	ArtOffset.y = 0
	var snapTo = ceil(Char.global_position.x / 16) * 16
	snapTo -= 8
	Char.global_position.x = snapTo
	Char.Vars.SetVar("FacingDir",1)
	Char.set_collision_mask_value(1,false)
	
func OnExit(_fsm : FSM):
	Char.apply_floor_snap()
	Char.set_collision_mask_value(1,true)
	
func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	Char.velocity.x = 0
	if Char.ControllerTag("Up"):
		Char.Sprite.play("ClimbLadder")
		Char.velocity.y = -50
	elif Char.ControllerTag("Down"):
		Char.Sprite.play_backwards("ClimbLadder")
		Char.velocity.y = 50
	else:
		Char.Sprite.pause()
		Char.velocity.y = 0
	
	return Transition(_fsm)
	
func Transition(_fsm : FSM):
	if Char.HasTag("AboveFloor") and !Char.HasTag("BelowFloor") and Char.HasTag("BelowLadder") and Char.DesiredMovementDirection.y > 0:
		return "Crouch_to_idle"
	
	if !Char.HasTag("AboveLadder"):
		return "Crouch_to_idle"
	
	if !Char.HasTag("BelowFloor"):
		if Char.DesiredMovementDirection.x != 0:
			if Char.ControllerTag("Dash(Down)"):
				return "Dash"
			if Char.HasTag("AboveFloor"):
				return "Run"
		
		if Char.ControllerTag("Jump(Down)"):
			return "Jump"
