extends FSM_Character_State

var Char : Character

func OnEnter(_fsm : FSM):
	Char = _fsm.Owner
	Tags.AddTags(["OnGround"])
	_fsm.Owner.Sprite.play("Walk")

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	
	if Char.ControllerTag("Attack"):
		return "Attack"
		
	if Char.DesiredMovementDirection.x == 0:
		return "Idle"
