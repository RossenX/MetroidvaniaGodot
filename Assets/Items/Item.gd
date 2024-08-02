extends Sprite2D
class_name GameItem

@export var iRes : ItemResource

func _ready():
	texture = iRes.ItemImage
	if (get_parent().get_name() + "_" + get_name()) in Game._collectedItems:
		queue_free()

func _process(_delta):
	$TouchArea.position = offset

func _physics_process(_delta):
	var PlayerChar = Game.GetCurrentPlayerActor()
	if PlayerChar != null:
		var TouchZone : Area2D = $TouchArea
		if PlayerChar in TouchZone.get_overlapping_bodies():
			var varCount = 0
			for i in iRes.affectedVars:
				PlayerChar.Vars.SetVar(i,PlayerChar.Vars.GetVar(i) + iRes.affectedVarsAmount[varCount])
				varCount += 1
			
			var OTA = OneTimeAudio.new("res://Assets/Audio/SFX/pickup.wav",global_position)
			Game._collectedItems.append(get_parent().get_name() + "_" + get_name())
			print(get_parent().get_name() + "_" + get_name())
			queue_free()
