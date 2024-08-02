extends FSM_Character_State

var OldHeight
func OnEnter(_fsm : FSM):
	Tags.AddTags(["Crouching","OnGround"])
	var Char = _fsm.Owner as Character
	Char.Sprite.play("Crouch_Loop")
	OldHeight = Char.Vars.GetVar("Height")
	Char.Vars.SetVar("Height", OldHeight / 1.5)
	ArtOffset.y = -OldHeight / 3
	ArtOffset.x = Char.Sprite.position.x * Char.Vars.GetVar("FacingDir")
	
func OnExit(_fsm : FSM):
	var Char = _fsm.Owner as Character
	Char.Vars.SetVar("Height", OldHeight)

func Physics_Update(_fsm : FSM):
	var Char = _fsm.Owner as Character
	Char.velocity.x *= 0.9
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	var Char = _fsm.Owner as Character
	
	if Char.HasTag("AboveLadder") and !Char.HasTag("BelowLadder") and Char.ControllerTag("Down"):
		return "ClimbLadder"
		
	if Char.ControllerTag("Attack(Down)"):
		return "AttackA2"
	
	if !Char.ControllerTag("Down"):
		return "Crouch_to_idle"
