extends Node
class_name FSM

var States : Dictionary = {}

# --- All Variables this actor has
var Vars : VarHolderResource = VarHolderResource.new()

#region States
# --- Owner could be Various Types of Nodes
var Owner

func GetInitState() -> String:
	return Definition.InitState

var Definition : FSMDefinitionResource

var CurState : FSM_State
var PrevState : FSM_State
var FramesInState : int = 0
var Delta : float = 0

#endregion

func _init(_owner, _fsmDefinition : String):
	Owner = _owner
	Definition = Game.GetFSMDefinition(_fsmDefinition)

func LoadStates():
	var _statePath = str("res://Assets/FSM/States/",Definition.FSMName,"/")
	var stateDir = DirAccess.open(_statePath)
	if stateDir:
		stateDir.list_dir_begin()
		var file_name = stateDir.get_next()
		while file_name != "":
			if !stateDir.current_is_dir():
				States[file_name.split(".")[0]] = str(_statePath,file_name)
				# --- Threaded Loading? I guess, because this seems to reduce lag spikes by A LOT
				if OS.has_feature("web"):
					ResourceLoader.load(str(_statePath,file_name))
				else:
					ResourceLoader.load_threaded_request(str(_statePath,file_name))
				print("Added State : ",file_name)
			file_name = stateDir.get_next()

func OnReady():
	LoadStates()
	ChangeState(GetInitState())
	if Owner is Character:
		Owner.Sprite.animation_finished.connect(_on_anim_end)

func _on_anim_end():
	if !CurState.Next.is_empty():
		ChangeState(CurState.Next)

func Update(_delta):
	if Owner.is_queued_for_deletion():
		queue_free()
	else:
		Delta = _delta
		if CurState == null:
			ChangeState(GetInitState())
		else:
			CurState.Update(self)

func Physics_Update(_delta):
	var _time_start = Time.get_ticks_usec()
	
	Delta = _delta
	if States.size() == 0:
		LoadStates()
	
	if CurState == null:
		ChangeState(GetInitState())
	else:
		# --- While we have a transition keep updating, untill we have no transition.
		var TransitionTo = CurState.Physics_Update(self)
		var TransitionCount = 0
		while TransitionTo != null:
			ChangeState(TransitionTo)
			TransitionTo = CurState.Physics_Update(self)
			TransitionCount += 1
			if TransitionCount > 64:
				printerr("INFINATE LOOP DETECTED!")
				break
	
	if CurState != null:
		CurState.Post_Physics_Update(self)
	
	var _time_stop = Time.get_ticks_usec()
	#print("Time To Update State: ms ",float(_time_stop - _time_start) / 1000)
	
	# --- Update how many frames we've been in this state
	FramesInState += 1

func ChangeState(_stateName : String):
	print("Change State: ",_stateName)
	if(States.get(_stateName) == null):
		print("State Not Found: ",_stateName)
		return
	
	var _state : FSM_State = load(States.get(_stateName)).new()
	if _state != null:
		if PrevState != null:
			PrevState.free()
		PrevState = CurState
		CurState = _state
		CurState.name = _stateName
		if PrevState != null:
			PrevState.OnExit(self)
		CurState.OnEnter(self)
		FramesInState = 0
	else:
		printerr("Changed to Null State!")
