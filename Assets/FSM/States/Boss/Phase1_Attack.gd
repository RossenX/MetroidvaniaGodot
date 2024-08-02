extends FSM_Character_State

var Char : Character

func OnEnter(_fsm : FSM):
	Char = _fsm.Owner
	Tags.AddTags(["Attack","Standing","OnGround","FacingLock"])
	Next = "Phase1_Idle"
	Char.Sprite.play("Attack")
	if Char.DesiredMovementDirection.x > 0:
		Char.Vars.SetVar("FacingDir",1)
	elif Char.DesiredMovementDirection.x < 0:
		Char.Vars.SetVar("FacingDir",-1)
	
func Physics_Update(_fsm : FSM):
	Char.velocity.x *= 0.8
	if Char.Sprite.frame == 1 and !Tags.HasTag("Attacked"):
		Tags.AddTag("Attacked")
		var _fb = load("res://Assets/Projectiles/fireball.tscn").instantiate()
		_fb.global_position = Char.global_position
		_fb.global_position.y -= 30
		_fb.velocity.x = Char.Vars.GetVar("FacingDir")
		
		Char.add_child(_fb)
		
	return Transition(_fsm)

func Transition(_fsm : FSM):
	if Char.Vars.GetVar("Life") <= 15:
		return "Phase2_Idle"
