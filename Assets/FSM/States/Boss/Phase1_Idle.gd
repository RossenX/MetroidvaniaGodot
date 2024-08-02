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
	if Char.ControllerTag("Attack"):
		return "Phase1_Attack"
	
	if Char.Vars.GetVar("Life") <= 15:
		return "Phase2_Idle"
			
	if abs(Char.DesiredMovementDirection.x) > 0.1:
		return "Phase1_Walk"
