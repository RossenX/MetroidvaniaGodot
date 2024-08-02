extends FSM_Character_State

var Char : Character
var opacity = 0.2

func OnEnter(_fsm : FSM):
	Tags.AddTags(["Dash","OnGround","FacingLock"])
	Next = "Idle"
	Char = _fsm.Owner as Character
	Char.Sprite.play("Dash")
	Char.PlaySFX("res://Assets/Audio/SFX/30_Jump_03.wav")

func OnExit(_fsm : FSM):
	Char.Sprite.modulate = Color.WHITE

func Physics_Update(_fsm : FSM):
	if _fsm.FramesInState == 3:
		if !Char.is_on_floor():
			Char.velocity.y = -150

		if Char.DesiredMovementDirection.x != 0:
			Char.velocity.x = Char.DesiredMovementDirection.x * 450
		else:
			Char.velocity.x =  Char.Vars.GetVar("FacingDir") * 450
		
		if Char.velocity.x > 0:
			Char.Vars.SetVar("FacingDir",1)
		elif Char.velocity.x < 0:
			Char.Vars.SetVar("FacingDir",-1)
		
		#if Char.is_on_floor():
		
		var VFXpos := Char.global_position
		VFXpos.y -= 15
		var DustType = "Dust"
		if !Char.is_on_floor():
			DustType = "AirDust"
			Tags.AddTag("AirDash")
			
		var VFX = SpriteVFX.new(VFXpos,DustType)
		VFX.scale.x *= Char.Vars.GetVar("FacingDir")
		Char.add_child(VFX)
		VFX.z_index = Char.z_index
		VFX.top_level = true
		
		Char.Sprite.modulate = Color(1,1,1,opacity)
		
	if _fsm.FramesInState > 3:
		if Char.is_on_floor():
			Char.velocity.x *= 0.92
		else:
			Char.velocity.x *= 0.94
	
		if opacity < 1:
			opacity += 0.015
			Char.Sprite.modulate = Color(1,1,1,opacity)
			Tags.AddTag("InvinAll")
		elif opacity >= 1:
			Tags.DelTag("InvinAll")
	
	return Transition(_fsm)

func Transition(_fsm : FSM):
	# --- Generic Transitions
	var TransitionTo = super.Transition(_fsm)
	if TransitionTo != null:
		return TransitionTo
	
	if _fsm.FramesInState > 5 and Char.is_actually_on_wall_only() and !Char.is_on_floor() and !Char.HasTag("NoClimb") and !(Char.DesiredMovementDirection.y > 0):
		return "WallSlide"
	if Char.ControllerTag("Jump(Down)") and _fsm.FramesInState > 0:
		if Char.is_on_floor():
			return "Jump"
		elif !Tags.HasTag("AirDash") and _fsm.FramesInState < 30:
			return "Jump"
	
	if Char.is_actually_on_wall_only() and !Char.is_on_floor() and !Char.HasTag("NoClimb") and !Char.HasTag("AboveFloor") and !(Char.DesiredMovementDirection.y > 0):
		return "WallSlide"
	if _fsm.FramesInState > 3 and Char.is_on_floor() and Char.ControllerTag("Down"):
		return "Slide"
	if Char.ControllerTag("Attack(Down)"):
		return "DashAttack"
