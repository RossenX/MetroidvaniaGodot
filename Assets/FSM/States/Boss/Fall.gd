extends FSM_Character_State

func OnEnter(_fsm : FSM):
	Tags.AddTags(["InAir"])
	_fsm.Owner.Sprite.play("Idle")

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	var Char : Character = _fsm.Owner
	if !Char.is_on_floor():
		_fsm.Owner.velocity.y += 5
	_fsm.Owner.velocity.x *= 0.8
	return Transition(_fsm)

func Transition(_fsm : FSM):
	pass
