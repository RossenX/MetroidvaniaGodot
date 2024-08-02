extends FSM_Character_State

func OnEnter(_fsm : FSM):
	Tags.AddTags(["Dash","OnGround","InAir","FacingLock"])
	Next = "Idle"
	var Char = _fsm.Owner as Character
	Char.Sprite.play("DashAttack")
	if Char.DesiredMovementDirection.x > 0:
		Char.Vars.SetVar("FacingDir",1)
	elif Char.DesiredMovementDirection.x < 0:
		Char.Vars.SetVar("FacingDir",-1)
		
	if !Char.is_on_floor():
		Char.velocity.y = -150
	else:
		Char.velocity.y = 0
		Char.velocity.x += 100 * Char.Vars.GetVar("FacingDir")

func Physics_Update(_fsm : FSM):
	var Char = _fsm.Owner as Character
	if Char.is_on_floor():
		Char.velocity.x *= 0.9
	else:
		Char.velocity.x *= 0.98
	
	if _fsm.FramesInState == 15:
		Char.PlaySFX("res://Assets/Audio/SFX/swordSwing.wav")
		var hurtInfo = HurtBoxResource.new()
		hurtInfo.position.x = 5 * Char.Vars.GetVar("FacingDir")
		hurtInfo.position.y = -20
		hurtInfo.size.x = 60
		hurtInfo.size.y = 50
		hurtInfo.activeFor = 15
		Game.CreateHurtBox(Char,hurtInfo)
		
	if _fsm.FramesInState == 5:
		Char.PlayVoice("res://Assets/Audio/Meghan Christian/Attack_Big1.wav")
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
