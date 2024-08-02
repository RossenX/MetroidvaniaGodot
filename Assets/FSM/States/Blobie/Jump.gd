extends FSM_Character_State

func OnEnter(_fsm : FSM):
	Tags.AddTags(["InAir","Jumping"])
	var Char = _fsm.Owner as Character
	_fsm.Owner.velocity.y = -_fsm.Owner.Vars.GetVar("JumpForce")
	Char.Sprite.play("Jump")
	if !Char.is_on_floor():
		Tags.AddTag("AirJump")
	
func Physics_Update(_fsm : FSM):
	var Char = _fsm.Owner as Character
	if _fsm.FramesInState == 1:
		Char.PlayVoice("res://Assets/Audio/Meghan Christian/jump01.wav")
		Char.PlaySFX("res://Assets/Audio/SFX/30_Jump_03.wav")
	
	if _fsm.FramesInState == 1 and Tags.HasTag("AirJump"):
		var VFXpos : Vector2 = Char.global_position
		VFXpos.y -= 10
		VFXpos.x -= 5 * Char.Vars.GetVar("FacingDir")
		var VFX = SpriteVFX.new(VFXpos,"AirJump")
		VFX.scale.x *= Char.Vars.GetVar("FacingDir")
		Char.add_child(VFX)
		VFX.z_index = Char.z_index
		VFX.top_level = true
		
	super.Physics_Update(_fsm)
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	
	# --- Jump -> Land
	var Char = _fsm.Owner as Character
	if Char.velocity.y > 0:
		return "Fall"
	
	if !Char.ControllerTag("Jump") and Char.velocity.y < 10:
		Char.velocity.y *= 0.8
		
	if Char.ControllerTag("Dash(Down)"):
		return "Dash"
	
	if Char.ControllerTag("Attack(Down)"):
		if Char.ControllerTag("Down"):
			return "DashAttack"
		else:
			return "QuickAirAttack"
	
	if Char.is_on_floor() and _fsm.FramesInState > 10:
		return "Idle"
