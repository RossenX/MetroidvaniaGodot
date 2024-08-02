extends FSM_Character_State

func OnEnter(_fsm : FSM):
	Tags.AddTags(["Attack","InAir","OnGround","FacingLock"])
	Next = "Idle"
	var Char = _fsm.Owner as Character
	Char.Sprite.play("AttackA2")
	if Char.DesiredMovementDirection.x > 0:
		Char.Vars.SetVar("FacingDir",1)
	elif Char.DesiredMovementDirection.x < 0:
		Char.Vars.SetVar("FacingDir",-1)
	
func Physics_Update(_fsm : FSM):
	var Char = _fsm.Owner as Character
	Char.velocity.x *= 0.9
	if _fsm.FramesInState == 2:
		Char.PlaySFX("res://Assets/Audio/SFX/swordSwing.wav")
		var hurtInfo = HurtBoxResource.new()
		hurtInfo.position.x = 0 * Char.Vars.GetVar("FacingDir")
		hurtInfo.position.y = -20
		hurtInfo.size.x = 60
		hurtInfo.size.y = 46
		hurtInfo.activeFor = 10
		Game.CreateHurtBox(Char,hurtInfo)
	
	if _fsm.FramesInState == 2:
		Char.PlayVoice("res://Assets/Audio/Meghan Christian/Attack1.wav")
	
	if Char.ControllerTag("Attack(Down)") and _fsm.FramesInState > 2:
		Next = "DashAttack"
		
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
