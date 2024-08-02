extends FSM_Character_State

func OnEnter(_fsm : FSM):
	Tags.AddTags(["InAir"])
	_fsm.Owner.Sprite.play("Idle")

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	var Char : Character = _fsm.Owner
	if !Char.is_on_floor():
		_fsm.Owner.velocity.y = 50
	_fsm.Owner.velocity.x = 0
	return Transition(_fsm)

func Transition(_fsm : FSM):
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
