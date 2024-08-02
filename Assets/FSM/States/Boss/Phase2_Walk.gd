extends FSM_Character_State

var Char : Character

func OnEnter(_fsm : FSM):
	Char = _fsm.Owner
	Tags.AddTags(["Flying"])
	_fsm.Owner.Sprite.play("Walk")
	
func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	return Transition(_fsm)

func Transition(_fsm : FSM):
	if Char.Vars.GetVar("Life") <= 0:
		return "Die"
		
	if Char.ControllerTag("Attack"):
		return "Phase2_Attack"
	
	if Char.DesiredMovementDirection.x == 0:
		return "Phase2_Idle"
