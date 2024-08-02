extends FSM_Character_State

func OnEnter(_fsm : FSM):
	Tags.AddTags(["Idle","Standing","OnGround"])
	_fsm.Owner.Sprite.play("Idle")

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	_fsm.Owner.velocity *= 0.96
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	
	var Char = _fsm.Owner as Character
	if Char.ControllerTag("Down"):
		return "Crouch_to" # --- Idle -> Crouch
	
	if Char.ControllerTag("Attack(Down)"):
		return "AttackA1"
	
	if Char.ControllerTag("Jump(Down)") and !Char.HasTag("BelowFloor"):
		return "Jump"
	
	if Char.HasTag("AboveLadder") and Char.HasTag("BelowLadder"):
		return "ClimbLadder"
	
	if Char.ControllerTag("Dash(Down)"):
		return "Dash"
	
	if abs(Char.DesiredMovementDirection.x) > 0.1:
		return "Run"
