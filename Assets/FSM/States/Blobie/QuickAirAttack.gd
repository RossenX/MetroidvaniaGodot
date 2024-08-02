extends FSM_Character_State

var Char : Character

func OnEnter(_fsm : FSM):
	Tags.AddTags(["Attack","InAir","FacingLock"])
	Next = "Idle"
	Char = _fsm.Owner as Character
	Char.Sprite.play("AttackA2")
	Char.Sprite.speed_scale = 3
	Char.velocity.x *= 0.95
	if Char.DesiredMovementDirection.x > 0:
		Char.Vars.SetVar("FacingDir",1)
	elif Char.DesiredMovementDirection.x < 0:
		Char.Vars.SetVar("FacingDir",-1)

func OnExit(_fsm : FSM):
	Char.Sprite.speed_scale = 1

func Physics_Update(_fsm : FSM):
	if _fsm.FramesInState == 2:
		Char.PlaySFX("res://Assets/Audio/SFX/swordSwing.wav")
		var hurtInfo = HurtBoxResource.new()
		hurtInfo.position.x = 0 * Char.Vars.GetVar("FacingDir")
		hurtInfo.position.y = -20
		hurtInfo.size.x = 60
		hurtInfo.size.y = 40
		hurtInfo.activeFor = 10
		Game.CreateHurtBox(Char,hurtInfo)
	
	if Char.ControllerTag("Attack(Down)") and _fsm.FramesInState > 0:
		Next = "DashAttack"
	return Transition(_fsm)

func Transition(_fsm : FSM):
	pass
	# --- Generic Transitions
	# var TransitionTo = super.Transition(_fsm)
	# if TransitionTo != null:
	# 	return TransitionTo
