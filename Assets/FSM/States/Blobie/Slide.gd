extends FSM_Character_State

var OldHeight

var Char : Character
func OnEnter(_fsm : FSM):
	Tags.AddTags(["Sliding","OnGround"])
	Next = "Idle"
	Char = _fsm.Owner
	Char.Sprite.play("Slide")
	OldHeight = Char.Vars.GetVar("Height")
	Char.Vars.SetVar("Height", OldHeight / 1.5)
	ArtOffset.y = -OldHeight / 3
	ArtOffset.x = Char.Sprite.position.x * Char.Vars.GetVar("FacingDir")

func OnExit(_fsm : FSM):
	Char.Vars.SetVar("Height", OldHeight)

func Physics_Update(_fsm : FSM):
	if _fsm.FramesInState < 20:
		Char.velocity.x *= 0.99
	else:
		Char.velocity.x *= 0.9
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	
	if !Char.HasTag("BelowFloor"):
		if _fsm.FramesInState > 35:
			if Char.ControllerTag("Down"):
				return "Crouch_loop"
			
		if Char.ControllerTag("Attack(Down)"):
			return "AttackA2"
		
		if Char.ControllerTag("Jump(Down)"):
			return "Jump"
	elif abs(Char.velocity.x) < 5:
		Char.velocity.x = 5 * Char.Vars.GetVar("FacingDir")
