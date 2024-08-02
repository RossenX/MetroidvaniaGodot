extends FSM_Character_State

func OnEnter(_fsm : FSM):
	Next = "Crouch_loop"
	Tags.AddTags(["Crouching","OnGround"])
	var Char = _fsm.Owner as Character
	Char.Sprite.play("Idle_To_Crouch")
	Char.velocity.x = 0

func Physics_Update(_fsm : FSM):
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	var Char = _fsm.Owner as Character
	
	if Char.ControllerTag("Dash(Down)"):
		return "Dash"
	
	if !Char.ControllerTag("Down"):
		return "Idle"
