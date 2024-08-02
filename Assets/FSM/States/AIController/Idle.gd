extends FSM_AI_State

var AICont = AIController
var Char = Character
func OnEnter(_fsm : FSM):
	AICont = _fsm.Owner
	Char = AICont.Owner

func Physics_Update(_fsm : FSM):
	if Game.GetCurrentPlayerActor() != null:
		var Player = Game.GetCurrentPlayerActor()
		if Player.global_position.x + 15 < Char.global_position.x:
			AICont.InputDirection.x = -1
		elif Player.global_position.x - 15 > Char.global_position.x:
			AICont.InputDirection.x = 1
		else:
			AICont.InputDirection.x = 0
		
		if Player.global_position.distance_to(Char.global_position) < 30 and !Player.HasTag("Dead"):
			AICont.Tags.AddTag("Attack")
		else:
			AICont.Tags.DelTag("Attack")

	super.Physics_Update(_fsm)
	return null
