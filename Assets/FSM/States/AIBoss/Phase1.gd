extends FSM_AI_State

var AICont : AIController
var Char : Character 
var Player : Character
var AttackCoolDown = 0

func OnEnter(_fsm : FSM):
	AICont = _fsm.Owner
	Char = AICont.Owner
	Player = Game.GetCurrentPlayerActor()

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	if Game.GetCurrentPlayerActor() != null:
		if Player.global_position.x + 100 < Char.global_position.x:
			AICont.InputDirection.x = -1
		elif Player.global_position.x - 100 > Char.global_position.x:
			AICont.InputDirection.x = 1
		else:
			if Player.global_position.distance_to(Char.global_position) < 30:
				if Player.global_position.x < Char.global_position.x:
					AICont.InputDirection.x = 1
				else:
					AICont.InputDirection.x = -1
		
		if Char.HasTag("WallHit") and Char.HasTag("AboveFloor"):
			Char.velocity.y = -500
			Char.velocity.x = Char.Vars.GetVar("FacingDir") * -500
			
	return Transition(_fsm)

func Transition(_fsm : FSM):
	if Char.Vars.GetVar("Life") <= 15:
		return "Phase2"
		
	if AttackCoolDown <= 0:
		if Player.global_position.distance_to(Char.global_position) < 100 and !Player.HasTag("Dead"):
			if Player.global_position < Char.global_position:
				AICont.InputDirection.x = -1
			else:
				AICont.InputDirection.x = 1
			
			AttackCoolDown = 100
			AICont.Tags.AddTag("Attack")
	else:
		AttackCoolDown -= 1
		AICont.Tags.DelTag("Attack")

