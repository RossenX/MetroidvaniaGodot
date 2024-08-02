# ---
# Tags for Life
# ---
extends Resource
class_name TagHolderResource

var Tags : Array[StringName] = []

func AddTags(_tags : Array[StringName]):
	for _tag in _tags:
		AddTag(_tag)

func AddTag(_tag : StringName):
	if !HasTag(_tag):
		Tags.push_back(_tag)

func DelTag(_tag : StringName):
	Tags.erase(_tag)

func DelTags(_tags : Array[StringName]):
	for _tag in _tags:
		DelTag(_tag)

func HasTag(_tag : StringName) -> bool:
	return Tags.has(_tag)
