extends FSM_Character_State

var Char : Character

func OnEnter(_fsm : FSM):
	Char = _fsm.Owner
	Tags.AddTags(["Idle","Standing","OnGround"])
	_fsm.Owner.Sprite.play("Idle")

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	_fsm.Owner.velocity *= 0.7
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	
	if Char.ControllerTag("Attack"):
		return "Attack"
		
	if abs(Char.DesiredMovementDirection.x) > 0.1:
		return "Walk"
