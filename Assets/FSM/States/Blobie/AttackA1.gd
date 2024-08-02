extends FSM_Character_State

func OnEnter(_fsm : FSM):
	Tags.AddTags(["Attack","Standing","OnGround","FacingLock"])
	Next = "Idle"
	var Char = _fsm.Owner as Character
	Char.Sprite.play("AttackA1")
	if Char.DesiredMovementDirection.x > 0:
		Char.Vars.SetVar("FacingDir",1)
	elif Char.DesiredMovementDirection.x < 0:
		Char.Vars.SetVar("FacingDir",-1)
	
func Physics_Update(_fsm : FSM):
	var Char = _fsm.Owner as Character
	Char.velocity.x *= 0.8
	if _fsm.FramesInState == 16:
		Char.PlaySFX("res://Assets/Audio/SFX/swordSwing.wav")
		var hurtInfo = HurtBoxResource.new()
		hurtInfo.position.x = 16 * Char.Vars.GetVar("FacingDir")
		hurtInfo.position.y = -20
		hurtInfo.size.x = 40
		hurtInfo.size.y = 40
		hurtInfo.activeFor = 20
		Game.CreateHurtBox(Char,hurtInfo)
		Char.PlayVoice("res://Assets/Audio/Meghan Christian/Attack2.wav")
		
	if Char.ControllerTag("Attack(Down)") and _fsm.FramesInState > 16:
		Next = "AttackA2"
	
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
