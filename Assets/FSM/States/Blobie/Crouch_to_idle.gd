extends FSM_Character_State

func OnEnter(_fsm : FSM):
	Next = "Idle"
	Tags.AddTags(["Crouching","OnGround"])
	var Char = _fsm.Owner as Character
	Char.Sprite.play("Crouch_To_Idle")
	Char.velocity.x = 0

func Physics_Update(_fsm : FSM):
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	var Char = _fsm.Owner as Character
	if Char.ControllerTag("Down(Down)"):
		return "Crouch_loop"
