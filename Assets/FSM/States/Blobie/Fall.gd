extends FSM_Character_State

var CoyoteTime = 0
var Char : Character
func OnEnter(_fsm : FSM):
	Tags.AddTags(["InAir","Falling"])
	Char = _fsm.Owner as Character
	Char.Sprite.play("Fall")

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	CoyoteTime += 1
	return Transition(_fsm)

func Transition(_fsm : FSM):
	if _fsm.PrevState != null:
		if CoyoteTime < 15 and (_fsm.PrevState.name == "Run"):
			Char.velocity.y -= 2
			if Char.ControllerTag("Jump(Down)"):
				return "Jump"
		
	if Char.is_on_floor():
		return "Idle"
	
	if Char.ControllerTag("Dash(Down)"):
		return "Dash"
	
	if Char.ControllerTag("Attack(Down)"):
		if Char.ControllerTag("Down"):
			return "DashAttack"
		else:
			return "QuickAirAttack"
	
	if Char.is_actually_on_wall_only() and !Char.is_on_floor() and !Char.HasTag("NoClimb") and !Char.HasTag("AboveFloor") and !(Char.DesiredMovementDirection.y > 0):
		return "WallSlide"
