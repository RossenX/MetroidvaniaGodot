extends Controller
class_name AIController

var StateMachine : FSM

func _init(AIfsmName : String):
	StateMachine  = FSM.new(self,AIfsmName)

func Update(_delta : float):
	StateMachine.Physics_Update(_delta)
	pass
