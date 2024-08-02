extends FSM_Character_State

var Char : Character

func OnEnter(_fsm : FSM):
	Char = _fsm.Owner
	Tags.AddTags(["Attack","Flying","FacingLock"])
	Next = "Phase2_Idle"
	Char.Sprite.play("Attack")
	if Char.DesiredMovementDirection.x > 0:
		Char.Vars.SetVar("FacingDir",1)
	elif Char.DesiredMovementDirection.x < 0:
		Char.Vars.SetVar("FacingDir",-1)
	
func Physics_Update(_fsm : FSM):
	Char.velocity.x *= 0.8
	if Char.Sprite.frame == 1 and !Tags.HasTag("Attacked"):
		Tags.AddTag("Attacked")
		var BallToSpawn : float = 8.0
		if Char.Vars.GetVar("Life") <= 10:
			BallToSpawn = 16.0
		if Char.Vars.GetVar("Life") <= 5:
			Char.Vars.SetVar("WalkSpeed",200)
		
		for i in range(BallToSpawn):
			var fb = load("res://Assets/Projectiles/fireball.tscn").instantiate()
			fb.global_position = Char.global_position
			fb.global_position.y -= 30
			fb.velocity = Vector2.RIGHT.rotated(deg_to_rad((360/BallToSpawn)*i))
			Char.add_child(fb)
			
	return Transition(_fsm)

func Transition(_fsm : FSM):
	if Char.Vars.GetVar("Life") <= 0:
		return "Die"
