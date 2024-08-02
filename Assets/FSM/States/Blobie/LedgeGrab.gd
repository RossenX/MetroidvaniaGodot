extends FSM_Character_State

func OnEnter(_fsm : FSM):
	var Char = _fsm.Owner as Character
	ArtOffset.x = 10
	ArtOffset.y = 2
	Next = "LedgeGrab_loop"
	Tags.AddTags(["WallSliding","OnWall","FacingLock"])
	Char.Sprite.play("LedgeGrab")

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	# --- Max wallslide speed
	var Char = _fsm.Owner as Character
	Char.velocity.x = 0
	Char.velocity.y = 0
	return Transition(_fsm)
	
func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	
	var Char = _fsm.Owner as Character
	if Char.is_on_floor():
		return "Idle"
	
	if Char.DesiredMovementDirection.y > 0 or !Char.is_actually_on_wall() or Char.HasTag("AboveFloor"):
		return "Fall"
	# --- Hmm i don't like that hitting the other direction makes you fall off
	
	if Char.DesiredMovementDirection.x != 0 and Char.ControllerTag("Dash(Down)"):
		return "Dash"
	
	if Char.ControllerTag("Jump(Down)"):
		return "Jump"
