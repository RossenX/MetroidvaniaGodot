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
	if Char.ControllerTag("Attack"):
		return "Phase1_Attack"
	
	if Char.Vars.GetVar("Life") <= 15:
		return "Phase2_Idle"
	
	if Char.DesiredMovementDirection.x == 0:
		return "Phase1_Idle"
