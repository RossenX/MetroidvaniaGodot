extends Node
class_name FSM_State

var Next : String
var ArtOffset : Vector2 = Vector2.ZERO
var Tags : TagHolderResource = TagHolderResource.new()

func OnEnter(_fsm : FSM):
	return null

func Update(_fsm : FSM):
	return null

func Post_Update(_fsm : FSM):
	return null

func Physics_Update(_fsm : FSM):
	return null

func Post_Physics_Update(_fsm : FSM):
	return null

# --- Returns which transition we should change to or null
func Transition(_fsm : FSM):
	return null

func OnExit(_fsm : FSM):
	return null
