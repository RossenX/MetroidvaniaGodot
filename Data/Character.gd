# ---
# Extend the "Actor" into a "Character"
# The "Character" has the ability to have a Controller
# ---

extends Actor
class_name Character

#region Vars
# --- Character Definition to Load
var Definition : CharacterDefinitionResource
# --- Basic Components
var Collision := CollisionShape2D.new()
var Sprite := AnimatedSprite2D.new()
var Frames := SpriteFrames.new()
var Voice := AudioStreamPlayer2D.new()
var SFX := AudioStreamPlayer2D.new()
var WallCheck := RayCast2D.new()
var LedgeCheck := RayCast2D.new()
var LedgeEdgeCheck := RayCast2D.new()
var GroundCheck := RayCast2D.new()
var CeilingCheck := RayCast2D.new()
var InvulTime = 0

# --- Check GroundCheck ray, for 'ladders' layer
func is_above_ladder() -> bool:
	return false

func is_on_ledge() -> bool:
	if LedgeCheck.is_colliding() and LedgeEdgeCheck.is_colliding():
		var dist = LedgeCheck.get_collision_point().distance_to(LedgeEdgeCheck.get_collision_point())
		if(dist < 5):
			return true
	
	return false

func is_actually_on_wall() -> bool:
	return WallCheck.is_colliding() and LedgeCheck.is_colliding()

func is_actually_on_wall_only() -> bool:
	if is_on_floor():
		return false
	return is_actually_on_wall()

func ControllerTag(_tag : StringName):
	return CurrentController.Tags.HasTag(_tag)

func HasTag(_tag : StringName) -> bool:
	if super.HasTag(_tag) or StateMachine.CurState.Tags.HasTag(_tag):
		return true
	return  false

func PlayVoice(_sound : String):
	Voice.stream = load(_sound)
	Voice.bus = "Voice"
	Voice.play()

func PlaySFX(_sound : String):
	SFX.stream = load(_sound)
	SFX.bus = "SFX_Quiet"
	SFX.play()
	
func GetMovementType() -> Game.MovementTypeEnum:
	return Vars.GetVar("MovementType")

func GetMovementSpeed() -> float:
	return Vars.GetVar("WalkSpeed")

func GetAcceleration() -> float:
	return Vars.GetVar("Acceleration")

func GetTurnSpeed() -> float:
	return Vars.GetVar("TurnSpeed")

var DesiredMovementDirection := Vector2.ZERO

#endregion

# --- Controller for this Actor
var CurrentController : Controller
func GetCurrentController() -> Controller: return CurrentController

func SetCurrentController(_controllerTypeToMake):
	if CurrentController != null:
		CurrentController.queue_free()
		CurrentController.name = "DeadMeat"
		CurrentController = null
	
	if _controllerTypeToMake.to_lower() == "player":
		CurrentController = PlayerController.new()
	else:
		CurrentController = AIController.new(_controllerTypeToMake)
		
	if CurrentController != null:
		CurrentController.Init(self)
		Components.add_child(CurrentController)
		CurrentController.name = "Controller"
		
# --- REQUIRED VARS MUST ALWAYS EXIST EVEN IF THEY ARE WRONG FOR THIS CHARACTER THEY WILL OVERRIDE THEM
func AddDefaultVars():
	Vars.SetVar("WalkSpeed",200)
	Vars.SetVar("MovementType",Game.MovementTypeEnum.Ground)
	Vars.SetVar("Acceleration",10.0)
	Vars.SetVar("JumpForce",275.0)
	Vars.SetVar("Scale",1)
	Vars.SetVar("GravityScale",1)
	Vars.SetVar("FacingDir",1)
	Vars.SetVar("MaxLife",3)
	Vars.SetVar("Life",3)

func _init(_def : CharacterDefinitionResource):
	super._init()
	AddDefaultVars()
	Definition = _def

func _ready():
	# ---  Validate Definitions
	if Definition != null:
		set_name.call_deferred(Definition.CharacterName)
		StateMachine = FSM.new(self,Definition.FSMName)
		
		for i in Definition.Tags:
			Tags.AddTag(i)
		
		# --- Add Default Vars
		for n in Definition.Defaults.keys():
			Vars.SetVar(n,Definition.Defaults[n])
		
		Vars.SetVar("Height",Definition.Height)
		# --- Adjust based on Defaults
		scale.x = Vars.GetVar("Scale")
		scale.y = Vars.GetVar("Scale")
		rotation = 0
		
		# --- World Collision
		Collision.name = "WorldCollision"
		Collision.shape = CapsuleShape2D.new()
		Collision.shape.height = Definition.Height
		Collision.shape.radius = Collision.shape.height / 4.5
		Collision.position.y = -Collision.shape.height / 2
		
		collision_layer = Definition.CollisionLayer
		#collision_mask = Definition.CollisionLayer
		
		# --- World Collsion always
		set_collision_layer_value(1,false)
		set_collision_mask_value(1,true)
		
		# --- Make The Things
		Sprite.sprite_frames = Frames
		Sprite.name = "Sprite"
		Sprite.sprite_frames = Game.GetAnimations()[Definition.CharacterName]
		Sprite.scale *= Definition.ArtScale
		Sprite.position = Collision.position + Definition.ArtOffset
		Sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(Sprite)
		
		add_child(Collision)
		WallCheck.target_position.x = Collision.shape.radius * 2
		WallCheck.target_position.y = 0
		WallCheck.position.x = Collision.position.x
		WallCheck.position.y = Collision.position.y - (Collision.shape.height / 3)
		add_child(WallCheck)
		LedgeCheck.target_position = WallCheck.target_position
		LedgeCheck.position.y = -Collision.shape.height
		add_child(LedgeCheck)
		LedgeEdgeCheck.target_position.y = 10
		LedgeEdgeCheck.target_position.x = 0
		LedgeEdgeCheck.position.x = WallCheck.target_position.x
		LedgeEdgeCheck.position.y = LedgeCheck.position.y - 10
		LedgeEdgeCheck.hit_from_inside = true
		add_child(LedgeEdgeCheck)
		# --- Center Ray collies interactive objects on top of our player
		GroundCheck.position.y = (-Collision.shape.height / 2) - 1
		GroundCheck.target_position.y = Collision.shape.height / 1.2
		GroundCheck.hit_from_inside = true
		GroundCheck.set_collision_mask_value(16,true)
		add_child(GroundCheck)
		# --- Center Ray collies interactive objects on top of our player
		CeilingCheck.position.y = (-Collision.shape.height / 2) + 1
		CeilingCheck.target_position.y = -Collision.shape.height / 1.2
		CeilingCheck.hit_from_inside = true
		CeilingCheck.set_collision_mask_value(16,true)
		add_child(CeilingCheck)
		# --- Audio
		add_child(Voice)
		add_child(SFX)
		# --- State Machine can Start Now
		floor_snap_length = 10
		safe_margin = 0.5
		floor_constant_speed = true
		StateMachine.OnReady()
	else: # --- No Definition, BYE
		queue_free()
	
func _process(_delta):
	var ArtOffset := Definition.ArtOffset
	if StateMachine.CurState.ArtOffset != Vector2.ZERO:
		ArtOffset = StateMachine.CurState.ArtOffset
	
	WallCheck.target_position.x = Collision.shape.radius + 1
	LedgeCheck.target_position.x = Collision.shape.radius + 1
	LedgeCheck.position.y = -Collision.shape.height
	LedgeEdgeCheck.position.x = LedgeCheck.target_position.x
	LedgeEdgeCheck.position.y = LedgeCheck.position.y - 10
	
	if Vars.GetVar("FacingDir") < 0:
		ArtOffset.x *= -1
		WallCheck.target_position.x *= -1
		LedgeCheck.target_position.x *= -1
		LedgeEdgeCheck.position.x *= -1
		LedgeEdgeCheck.target_position.x *= -1
	
	if Collision.shape.height != Vars.GetVar("Height"):
		var oldHeight = Collision.shape.height
		var newHeight = Vars.GetVar("Height")
		var heightDiff= oldHeight - newHeight
		Collision.shape.height = Vars.GetVar("Height")
		position.y += heightDiff / 2
	
	Sprite.position = Collision.position + ArtOffset
	StateMachine.Update(_delta)

# --- Update tags what we are 'above' ladder ground whatever else we need
func UpdateWallTags():
	Tags.DelTag("NoClimb")
	Tags.DelTag("WallHit")
	while WallCheck.is_colliding():
		var body = WallCheck.get_collider()
		var bodyRID = WallCheck.get_collider_rid()
		Tags.AddTag("WallHit")
		
		if body is TileMap:
			var tile_data : TileData = body.get_cell_tile_data(body.get_layer_for_body_rid(bodyRID),body.get_coords_for_body_rid(bodyRID))
			if tile_data:
				var Data = tile_data.get_custom_data_by_layer_id(0)
				if Data:
					if Data == "NoClimb":
						Tags.AddTag("NoClimb")
		
		WallCheck.add_exception_rid(bodyRID)
		WallCheck.force_raycast_update()
	WallCheck.clear_exceptions()
	WallCheck.force_raycast_update()
	
# --- Update tags what we are 'above' ladder ground whatever else we need
func UpdateAboveTags():
	Tags.DelTags(["AboveLadder","AboveFloor"])
	while GroundCheck.is_colliding():
		var body = GroundCheck.get_collider()
		var bodyRID = GroundCheck.get_collider_rid()
		
		if body is TileMap:
			var tile_data : TileData = body.get_cell_tile_data(body.get_layer_for_body_rid(bodyRID),body.get_coords_for_body_rid(bodyRID))
			if tile_data:
				var Data = tile_data.get_custom_data_by_layer_id(0)
				if Data:
					if Data == "Ladder":
						Tags.AddTag("AboveLadder")
				else:
					Tags.AddTag("AboveFloor")
			
		GroundCheck.add_exception_rid(bodyRID)
		GroundCheck.force_raycast_update()
	GroundCheck.clear_exceptions()

func UpdateBelowTags():
	Tags.DelTags(["BelowLadder","BelowFloor"])
	while CeilingCheck.is_colliding():
		var body = CeilingCheck.get_collider()
		var bodyRID = CeilingCheck.get_collider_rid()
		
		if body is TileMap:
			var tile_data : TileData = body.get_cell_tile_data(body.get_layer_for_body_rid(bodyRID),body.get_coords_for_body_rid(bodyRID))
			if tile_data:
				var Data = tile_data.get_custom_data_by_layer_id(0)
				if Data:
					if Data == "Ladder":
						Tags.AddTag("BelowLadder")
				else:
					Tags.AddTag("BelowFloor")
			
		CeilingCheck.add_exception_rid(bodyRID)
		CeilingCheck.force_raycast_update()
	CeilingCheck.clear_exceptions()

func varSanityCheck():
	if Vars.GetVar("MaxLife") < Vars.GetVar("Life"):
		Vars.SetVar("Life",Vars.GetVar("MaxLife"))
	
func _physics_process(_delta):
	super(_delta)
	if GetCurrentController() != null:
		ProcessController(_delta)
	
	if HasTag("WasHit"):
		if Game.GetCurrentPlayerActor() == self:
			InvulTime = 60
		else:
			InvulTime = 28
	
	StateMachine.Physics_Update(_delta)
	# --- Sanity check some vars
	varSanityCheck()
	UpdateAboveTags()
	UpdateBelowTags()
	UpdateWallTags()
	
	if InvulTime > 0:
		Tags.DelTag("WasHit")
		InvulTime -= 1
		if InvulTime % 4:
			Sprite.modulate = Color(1,1,1,0)
		else:
			Sprite.modulate = Color(1,1,1,1)
		
		Tags.AddTag("InvinAll")
	else:
		Tags.DelTag("InvinAll")

func ProcessController(_delta):
	GetCurrentController().Update(_delta)
	var MoveDirection : Vector2 = GetCurrentController().InputDirection
	DesiredMovementDirection.x = round(MoveDirection.x)
	DesiredMovementDirection.y = round(MoveDirection.y)
