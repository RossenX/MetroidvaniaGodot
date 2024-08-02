extends Node
# ---
# RossenX MetroidVania Engine For GODOT!
# ---

var StartingLevel = "Level_01"
#region Vars
var _characterDefinitions : Dictionary = {}
func GetCharacterDefinition(_charName : StringName) -> CharacterDefinitionResource:
	for c in GetCharacterDefinitions().keys():
		if c.to_lower() == _charName.to_lower():
			return load(GetCharacterDefinitions()[c])
	return null
func GetCharacterDefinitions() -> Dictionary:
	return _characterDefinitions
func SetCharacterDefinitions(_cDef : Dictionary):
	_characterDefinitions = _cDef

var _fsmDefinitions : Dictionary = {}
func GetFSMDefinition(_fsmName : String) -> FSMDefinitionResource:
	if GetFSMDefinitions().has(_fsmName):
		return load(GetFSMDefinitions()[_fsmName])
	else:
		return null
func GetFSMDefinitions() -> Dictionary:
	return _fsmDefinitions
func SetFSMDefinitions(_newFSMDefs : Dictionary):
	_fsmDefinitions = _newFSMDefs
	
var _levelList : Array[StringName] = []
func GetLevelList() -> Array[StringName]:
	return _levelList
func SetLevelList(_lvlList : Array[StringName]):
	_levelList = _lvlList

var _actors : Node = Node.new()
func GetActors() -> Node:
	return _actors
func SetActors(_act : Node):
	_actors = _act

var _animations : Dictionary = {}
func GetAnimations() -> Dictionary:
	return _animations

var _level : GameLevel
func GetLevel() -> GameLevel:
	return _level
func SetLevel(_lvl : GameLevel):
	_level = _lvl

var _cameraManager : CameraManager = CameraManager.new()
func GetCameraManager() -> CameraManager:
	return _cameraManager
func SetCameraManager(_cam : CameraManager):
	_cameraManager = _cam

var _currentPlayerActor : Actor
func GetCurrentPlayerActor() -> Actor:
	return _currentPlayerActor
func SetCurrentPlayerActor(_actor : Actor):
	_currentPlayerActor = _actor

var _settings : GameSettings = GameSettings.new()
func GetSettings() -> GameSettings:
	return _settings
func SetSettings(_set : GameSettings):
	_settings = _set

var _showDebugShapes = true
func ShowDebugShapes(_enabled):
	_showDebugShapes = _enabled
	if !_showDebugShapes:
		UpdateDebugShapes()

var _debugShapes:  Node = Node.new()
func GetDebugShapes() -> Node:
	return _debugShapes
func SetDebugShapes(_node : Node):
	_debugShapes = _node

var _musicPlayer := AudioStreamPlayer.new()
func GetMusicPlayer() -> AudioStreamPlayer:
	return _musicPlayer
func SetMusicPlayer(_node : AudioStreamPlayer):
	_musicPlayer = _node

var _hud : CanvasLayer
func GetHUD() -> CanvasLayer:
	return _hud
func setHUD(_node : CanvasLayer):
	_hud = _node

# --- Hacky low effort way of preventing respawns of items
var _collectedItems : Array = []
func GetCollectedItems() -> Array:
	return _collectedItems

# --- For Parsing Data
const CharacterDefinitionFolder = "res://Assets/Characters/Definitions/"
const LevelsFolder = "res://Assets/Levels/GameLevels/"
const AnimationsFolder = "res://Assets/Animations/"
const FSMFolder = "res://Assets/FSM/Definitions/"

# --- Enums
enum CharacterControllerTypeEnum {None = 0,Player = 1,AI = 2,}
enum MovementTypeEnum {Ground = 0,Air = 1,Water = 2}
#endregion

var Tags : TagHolderResource = TagHolderResource.new()
var MusicPlayer : AudioStreamPlayer = AudioStreamPlayer.new()
var CurrentMusic : String
var MusicPriority = 0
func ChangeMusic(_newmusic : String, _prio : int):
	if _newmusic != CurrentMusic and MusicPriority <= _prio:
		MusicPlayer.stream = load(_newmusic)
		MusicPlayer.bus = "Music"
		MusicPlayer.play(0)
		CurrentMusic = _newmusic
		MusicPriority = _prio

func _ready():
	ChangeLevel(StartingLevel)

func LoadGameData():
	# --- MusicPlayer
	add_child(MusicPlayer)
	MusicPlayer.name = "MusicPlayer"
	
	LoadLevels()
	LoadCharacterDefinitions()
	LoadAnimations()
	LoadFSMs()
	CreateHUD()
	
func CreateHUD():
	var hud = load("res://Assets/UI/inGame.tscn").instantiate()
	add_child(hud)
	setHUD(hud)

func SetupGame():
	# --- Debug Shapes
	GetDebugShapes().name = "DebugShapes"
	add_child(GetDebugShapes())
	
	# --- Actor Container
	GetActors().name = "Actors"
	add_child(GetActors())
	
	# --- Camera Manager
	GetCameraManager().name = "CameraManager"
	add_child(GetCameraManager())
	
	# --- If it's not standalone, half size it
	if !OS.has_feature("editor"):
		print("Running an exported build.")
	else:
		print("Running from the editor.")
		DisplayServer.window_set_size(Vector2i(960, 540))
		DisplayServer.window_set_position(Vector2i(480, 270))
		SetTeleportWithLeftClick(true)

func LoadFSMs():
	var FSMDir = DirAccess.open(FSMFolder)
	if FSMDir:
		FSMDir.list_dir_begin()
		var file_name = FSMDir.get_next()
		while file_name != "":
			if !FSMDir.current_is_dir():
				if file_name.ends_with(".remap"):
					file_name = file_name.erase(file_name.length() - 6,6)
				GetFSMDefinitions()[file_name.split(".")[0]] = str(FSMFolder,file_name)
				# --- Threaded Loading? I guess, because this seems to reduce lag spikes by A LOT
				if OS.has_feature("web"):
					ResourceLoader.load(str(FSMFolder,file_name))
				else:
					ResourceLoader.load_threaded_request(str(FSMFolder,file_name))
				print("Added FSM: ",file_name)
			file_name = FSMDir.get_next()

func LoadLevels():
	var LevelDir = DirAccess.open(LevelsFolder)
	if LevelDir:
		LevelDir.list_dir_begin()
		var file_name = LevelDir.get_next()
		while file_name != "":
			if !LevelDir.current_is_dir() and file_name.ends_with(".tscn"):
				GetLevelList().append(file_name)
				print(str("Added Level: ",file_name))
			file_name = LevelDir.get_next()

func LoadCharacterDefinitions():
	var Chardir = DirAccess.open(CharacterDefinitionFolder)
	if Chardir:
		Chardir.list_dir_begin()
		var file_name = Chardir.get_next()
		while file_name != "":
			if !Chardir.current_is_dir():
				# --- On Export tres are renamed to tres.remap, but we cannot load .remap file and must load it without the .remap at the end.
				if file_name.ends_with(".remap"):
					file_name = file_name.erase(file_name.length() - 6,6)
				GetCharacterDefinitions()[file_name.split(".")[0]] = str(CharacterDefinitionFolder,file_name)
				print(str("Added Character Definitions: ",file_name))
				# --- Threaded Loading? I guess, because this seems to reduce lag spikes by A LOT
				if OS.has_feature("web"):
					ResourceLoader.load(str(CharacterDefinitionFolder,file_name))
				else:
					ResourceLoader.load_threaded_request(str(CharacterDefinitionFolder,file_name))
				file_name = Chardir.get_next()

func LoadAnimations():
	var AnimDir = DirAccess.open(AnimationsFolder)
	if AnimDir:
		AnimDir.list_dir_begin()
		var file_name = AnimDir.get_next()
		while file_name != "":
			if !AnimDir.current_is_dir():
				if file_name.ends_with(".remap"):
					file_name = file_name.erase(file_name.length() - 6,6)
				var AnimPath = str(AnimDir.get_current_dir(),"/",file_name)
				GetAnimations()[file_name.split(".")[0]] = load(AnimPath);
				print(str("Added AnimationSet: ",file_name,"->",AnimPath,":",GetAnimations().size()))
				file_name = AnimDir.get_next()

func ChangeLevel(LevelName : String):
	if GetLevel() != null:
		GetLevel().name = "DeadMeat"
		GetLevel().queue_free()
		for i in GetActors().get_children():
			if i != GetCurrentPlayerActor():
				i.queue_free()
	
	SetLevel(load(str(LevelsFolder,LevelName,".tscn")).instantiate())
	add_child(GetLevel())
	#GetLevel().name = "Level"
	move_child(GetLevel(),0)
	
func CreateCharacter(CharacterName : StringName, ControllerType, Position : Vector2) -> Character:
	var _def : CharacterDefinitionResource = GetCharacterDefinition(CharacterName)
	if _def != null:
		var CreatingCharacter : Character = Character.new(_def)
		CreatingCharacter.position = Position
		GetActors().add_child(CreatingCharacter)
		CreatingCharacter.SetCurrentController(ControllerType)
		return CreatingCharacter
	else:
		push_error(str("Could not find Character Definition For: ",CharacterName))
		return null

func ControlCharacter(pChar : Character):
	if pChar != null:
		SetCurrentPlayerActor(pChar)
		GetCurrentPlayerActor().SetCurrentController(Game.CharacterControllerTypeEnum.Player)
	else:
		push_error(str("ControlCharacter -> Failed"))

func GameSpeed(_speed : float):
	Engine.time_scale = _speed
	Engine.time_scale = max(Engine.time_scale,0.1)
	Engine.physics_ticks_per_second = 60 * Engine.time_scale

func _input(event):
	if TeleportWithLeftClick:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == 1 and GetCurrentPlayerActor() != null:
				var posInLevel = GetLevel().get_local_mouse_position()
				GetCurrentPlayerActor().global_position = GetLevel().global_position + posInLevel

func _process(_delta):
	if !OS.has_feature("web") and Input.is_action_just_pressed("QuitGame"):
		get_tree().quit()
	
	if GodMode and GetCurrentPlayerActor() != null:
		GetCurrentPlayerActor().Vars.SetVar("Life",GetCurrentPlayerActor().Vars.GetVar("MaxLife"))
	if _showDebugShapes:
		UpdateDebugShapes()

func CreateHurtBox(actor : Node2D, hurtboxInfo : HurtBoxResource):
	var daBox = HurtBox.new(actor,hurtboxInfo)
	actor.add_child(daBox)

# --- Grab the player
var TeleportWithLeftClick : bool = false
func SetTeleportWithLeftClick(allowGrab : bool):
	TeleportWithLeftClick = allowGrab

# --- Hard reset the entire game
func HardReset():
	Tags.DelTag("GameOver")
	Tags.DelTag("GameWon")
	
	MusicPlayer.stop()
	CurrentMusic = ""
	MusicPriority = 0
	if GetCurrentPlayerActor():
		GetCurrentPlayerActor().queue_free()
		SetCurrentPlayerActor(null)
	
	_collectedItems.clear()
	ChangeLevel(StartingLevel)

var GodMode = false
func ToggleGodMode():
	GodMode = !GodMode

#region Debug Draw
func DebugRenderMode(_debugDrawMode : Viewport.DebugDraw = Viewport.DEBUG_DRAW_DISABLED):
	get_viewport().debug_draw = _debugDrawMode

func UpdateDebugShapes():
	# --- Clear all the shapes from the previous frame
	for a in GetDebugShapes().get_children():
		a.queue_free()

# --- Draw a Debug Line for this frame
func DrawDebugLine(startPoint : Vector3, endPoint : Vector3, colorToUse : Color):
	# --- Early Out
	if !_showDebugShapes:
		return
	
	# --- Material
	var mat = StandardMaterial3D.new()
	mat.albedo_color = colorToUse
	mat.disable_receive_shadows = true
	# --- The Mesh Instance
	var DebugShape := MeshInstance3D.new()
	DebugShape.set_cast_shadows_setting(GeometryInstance3D.SHADOW_CASTING_SETTING_OFF)
	# --- The Mesh To Draw
	var DebugLine := ImmediateMesh.new()
	# --- Draw The Line
	DebugLine.clear_surfaces()
	DebugLine.surface_begin(PrimitiveMesh.PRIMITIVE_LINES)
	DebugLine.surface_add_vertex(startPoint)
	DebugLine.surface_add_vertex(endPoint)
	DebugLine.surface_end()
	DebugLine.surface_set_material(0,mat)
	DebugShape.mesh = DebugLine
	# --- Add as child
	GetDebugShapes().add_child(DebugShape)
#endregion
