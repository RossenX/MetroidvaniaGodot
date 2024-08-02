extends FSM_State
class_name FSM_Character_State

func OnEnter(_fsm : FSM):
	super.OnEnter(_fsm)

func Transition(_fsm : FSM):
	return GenericTransitions(_fsm.Owner)
	
func Physics_Update(_fsm : FSM):
	super.Physics_Update(_fsm)
	var HorizontalMovement = _fsm.Owner.velocity.move_toward(_fsm.Owner.DesiredMovementDirection * _fsm.Owner.GetMovementSpeed(),_fsm.Owner.GetAcceleration())  
	_fsm.Owner.velocity.x = HorizontalMovement.x
	if _fsm.Owner.HasTag("Flying"):
		_fsm.Owner.velocity.y = HorizontalMovement.y
	
# --- Generic Ground Transitions
func GenericTransitions(Char : Character):
	if Char.Vars.GetVar("Life") <= 0:
		return "Die"
	
	if Char.HasTag("WasHit") and !Char.HasTag("NoHitstun"):
		return "HitStun"
	
	if !Char.HasTag("OnGround") and !Char.HasTag("Jumping") and Char.is_on_floor():
		return "Idle"
	
	if (Char.HasTag("OnGround") and !Char.HasTag("Dash")) and !Char.is_on_floor():
		return "Fall"
	
func Post_Physics_Update(_fsm : FSM):
	if !_fsm.Owner.HasTag("Flying"):
		ApplyGravity(_fsm)
	
	ProcessVelocity(_fsm)
	
func ApplyGravity(_fsm : FSM):
	if _fsm.Owner.Tags.HasTag("OnGround"):
		_fsm.Owner.velocity.y = 0
		return
	
	if _fsm.Owner.HasTag("OnWall"):
		return
	
	var gravity_magnitude : float = ProjectSettings.get_setting("physics/2d/default_gravity")
	var GravityScale = _fsm.Owner.Vars.GetVar("GravityScale")
	_fsm.Owner.velocity.y += ((gravity_magnitude * _fsm.Delta) * GravityScale)
	_fsm.Owner.velocity.y = min(_fsm.Owner.velocity.y,500)

func ProcessVelocity(_fsm : FSM):
	if _fsm.Owner.velocity.length() > 0:
		if _fsm.Owner.move_and_slide():
			if _fsm.Owner.is_on_floor():
				_fsm.Owner.apply_floor_snap()
	
	if !_fsm.Owner.HasTag("FacingLock"):
		if _fsm.Owner.DesiredMovementDirection.x > 0:
			_fsm.Owner.Vars.SetVar("FacingDir",1)
		elif _fsm.Owner.DesiredMovementDirection.x < 0:
			_fsm.Owner.Vars.SetVar("FacingDir",-1)
	if _fsm.Owner.Vars.GetVar("FacingDir") < 0:
		_fsm.Owner.Sprite.flip_h = true
	else:
		_fsm.Owner.Sprite.flip_h = false
	
