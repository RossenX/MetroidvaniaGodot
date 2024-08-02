# ---
# Bassicly a dictionary, but a resource
# ---
extends Resource
class_name VarHolderResource

var Vars : Dictionary

func GetVars() -> Dictionary:
	return Vars

func GetVar(_name : StringName):
	if Vars.has(_name):
		return Vars.get(_name)
	else:
		return 0

func SetVar(_name : StringName,_value):
	Vars[_name] = _value
