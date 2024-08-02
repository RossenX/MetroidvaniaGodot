# ---
# Any Node that requires a Finite State Machine
# ---

extends CharacterBody2D
class_name Actor

# --- Generic Vars
var Components : Node = Node.new()
# --- Finite State Machine
var StateMachine : FSM
# --- Because Tags are life
var Tags : TagHolderResource = TagHolderResource.new()
# --- All Variables this actor has
var Vars : VarHolderResource = VarHolderResource.new()

func HasTag(_tag : StringName) -> bool:
	return Tags.HasTag(_tag)

func DelTag(_tag : StringName):
	Tags.DelTag(_tag)

func _init():
	set_process_input(false)
	set_process_shortcut_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	set_process(false)
	# --- Component Container
	Components.name = "Components"
	add_child(Components)

func _physics_process(_delta):
	pass
