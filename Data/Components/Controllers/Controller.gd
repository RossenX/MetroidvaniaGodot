extends Node
class_name Controller

var Tags : TagHolderResource = TagHolderResource.new()
var Owner : Character
var ControllerCamera : Camera3D = null
var InputDirection : Vector2 = Vector2.ZERO

func HasTag(_tag : StringName):
	return Tags.HasTag(_tag)

func Init(_Newowner : Character):
	Owner = _Newowner

func Update(_delta : float):
	pass
