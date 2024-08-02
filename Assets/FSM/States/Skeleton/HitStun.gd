extends FSM_Character_State

var Char : Character
func OnEnter(_fsm : FSM):
	Char = _fsm.Owner as Character
	Tags.AddTags(["HitStun","OnGround","InvinAll","FacingLock"])
	Next = "Idle"
	Char.Sprite.play("Hitstun")
	Char.velocity.x = 0
	Char.DelTag("WasHit")

func OnExit(_fsm: FSM):
	pass

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	Char.velocity.x = 0
	return Transition(_fsm)

func Transition(_fsm : FSM):
	pass
