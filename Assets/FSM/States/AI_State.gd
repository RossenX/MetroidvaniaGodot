extends FSM_State
class_name FSM_AI_State

func Transition(_fsm : FSM):
	var Char : Character = _fsm.Owner
	if Char.Vars.GetVar("Life") <= 0:
		return "Die"
