extends FSM_Character_State

func OnEnter(_fsm : FSM):
	Tags.AddTags(["Running","OnGround"])
	var Char = _fsm.Owner as Character
	Char.Sprite.play("Run")

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	#var Char = _fsm.Owner as Character
	#var wot = _fsm.FramesInState % 20
	#if wot == 1 and _fsm.FramesInState > 10:
	#	Char.PlaySFX("res://Assets/Audio/SFX/08_Step_rock_02.wav")
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	var Char = _fsm.Owner as Character
	
	if (Char.Vars.GetVar("FacingDir") > 0 and Char.velocity.x < 0) or (Char.Vars.GetVar("FacingDir") < 0 and Char.velocity.x > 0):
		Char.velocity.x = 0
	
	if Char.ControllerTag("Attack(Down)"):
		return "AttackA1"
	if Char.ControllerTag("Slide(Down)"):
		return "Slide"
	if Char.ControllerTag("Jump(Down)") and !Char.HasTag("BelowFloor"):
		return "Jump"
	if Char.ControllerTag("Down") and abs(Char.velocity.x) > 175:
		return "Slide"
	if Char.ControllerTag("Dash(Down)"):
		return "Dash"
	if Char.DesiredMovementDirection.x == 0:
		return "Idle"
