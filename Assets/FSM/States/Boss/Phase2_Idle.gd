extends FSM_Character_State

var Char : Character

func OnEnter(_fsm : FSM):
	Char = _fsm.Owner
	Tags.AddTags(["Idle","Flying"])
	_fsm.Owner.Sprite.play("Idle")

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	_fsm.Owner.velocity *= 0.7
	return Transition(_fsm)

func Transition(_fsm : FSM):
	if Char.Vars.GetVar("Life") <= 0:
		return "Die"
		
	if Char.ControllerTag("Attack"):
		return "Phase2_Attack"
	
	if abs(Char.DesiredMovementDirection.x) > 0.1:
		return "Phase2_Walk"
