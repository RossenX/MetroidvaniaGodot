extends FSM_Character_State

func OnEnter(_fsm : FSM):
	var Char = _fsm.Owner as Character
	ArtOffset.x = 6
	ArtOffset.y = 2
	Tags.AddTags(["WallSliding","OnWall","FacingLock"])
	Char.Sprite.play("WallSlide")
	Char.velocity.x = 0

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	# --- Max wallslide speed
	var Char = _fsm.Owner as Character
	Char.velocity.x = 0
	if _fsm.FramesInState < 6:
		Char.velocity.y = 0
	else:
		Char.velocity.y = lerpf(Char.velocity.y,250,0.05)
	return Transition(_fsm)
	
func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	
	var Char = _fsm.Owner as Character
	if Char.is_on_floor():
		return "Idle"
	
	if Char.DesiredMovementDirection.y > 0 or !Char.is_actually_on_wall() or Char.HasTag("NoClimb"):
		return "Fall"
	
	# --- Hmm i don't like that hitting the other direction makes you fall off
	if Char.is_on_ledge() and !(Char.DesiredMovementDirection.y > 0):
		return "LedgeGrab"
	
	if Char.DesiredMovementDirection.x != 0 and Char.ControllerTag("Dash(Down)"):
		var wannaGo = round(Char.DesiredMovementDirection.x)
		if wannaGo == Char.Vars.GetVar("FacingDir") * -1:
			return "Dash"
	
	if Char.ControllerTag("Jump(Down)"):
		return "Jump"
