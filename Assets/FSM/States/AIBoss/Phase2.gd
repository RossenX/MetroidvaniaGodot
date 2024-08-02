extends FSM_AI_State

var AICont : AIController
var Char : Character 
var Player : Character
var StageRef : GameLevel
var AttackCoolDown = 300

func OnEnter(_fsm : FSM):
	AICont = _fsm.Owner
	Char = AICont.Owner
	Player = Game.GetCurrentPlayerActor()
	Char.Vars.SetVar("WalkSpeed",150)

func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	if Game.GetCurrentPlayerActor() != null:
		if _fsm.Vars.GetVar("GoingToPoint") is int:
			_fsm.Vars.SetVar("GoingToPoint","Stage_Center")
		
		if StageRef == null:
			StageRef = Game.GetLevel()
		
		var PointToGoTo : Node2D = StageRef.get_node_or_null(_fsm.Vars.GetVar("GoingToPoint"))
		if PointToGoTo != null:
			var AngleToPoint = PointToGoTo.global_position - Char.global_position
			if AngleToPoint.length() < 20:
				match  _fsm.Vars.GetVar("GoingToPoint"):
					"Stage_Center":
						_fsm.Vars.SetVar("GoingToPoint","Stage_Left")
					"Stage_Left":
						_fsm.Vars.SetVar("GoingToPoint","Stage_Right")
					"Stage_Right":
						_fsm.Vars.SetVar("GoingToPoint","Stage_Left")
						
			AICont.InputDirection = AngleToPoint.normalized()
		else:
			print("Iono")
	return Transition(_fsm)

func Transition(_fsm : FSM):
	if AttackCoolDown <= 0:
		AttackCoolDown = 120
		AICont.Tags.AddTag("Attack")
	else:
		AttackCoolDown -= 1
		AICont.Tags.DelTag("Attack")
