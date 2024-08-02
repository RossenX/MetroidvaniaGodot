extends FSM_Character_State

var Char : Character
func OnEnter(_fsm : FSM):
	Char = _fsm.Owner as Character
	Tags.AddTags(["HitStun","OnGround","InvinAll","Dead","FacingLock"])
	Char.Sprite.play("Die")
	Char.velocity.x = 0
	Char.DelTag("WasHit")

func OnExit(_fsm: FSM):
	pass

func Physics_Update(_fsm : FSM):
	pass

func Transition(_fsm : FSM):
	pass
