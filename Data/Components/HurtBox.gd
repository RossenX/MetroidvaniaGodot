extends Area2D
class_name HurtBox

var AlreadyHitActors : Array = []

var ColBox := CollisionShape2D.new()
var activeFor : int
var hitboxInfo : HurtBoxResource
var _Actor : Node2D
var OnlyHitPlayer : bool
# --- Lol hacky
var Audio : AudioStreamPlayer2D = AudioStreamPlayer2D.new()

func _init(_owner : Node2D, _res : HurtBoxResource):
	_Actor = _owner
	hitboxInfo = _res
	var daBox := RectangleShape2D.new()
	daBox.size = _res.size
	ColBox.shape = daBox
	position = _res.position
	OnlyHitPlayer = _res.OnlyHitPlayer
	
	for i in range(31):
		set_collision_layer_value(i + 1,true)
		set_collision_mask_value(i + 1,true)
	
	# --- Does not 'hit' the world
	set_collision_layer_value(1,false)
	set_collision_mask_value(1,false)
		
	add_child(ColBox)

func _ready():
	pass

func _process(_delta):
	pass

func _physics_process(_delta):
	if has_overlapping_bodies():
		for i in get_overlapping_bodies():
			if OnlyHitPlayer and i != Game.GetCurrentPlayerActor():
				AlreadyHitActors.append(i)
				continue
				
			if !(i in AlreadyHitActors):
				if i is Actor and i != _Actor and !i.HasTag("InvinAll"):
					if i is Character:
						i.PlayVoice("res://Assets/Audio/SFX/03_Claw_03.wav")
						
					AlreadyHitActors.append(i)
					i.Tags.AddTag("WasHit")
					i.Vars.SetVar("Life",i.Vars.GetVar("Life") - 1)
		
	activeFor += 1
	if activeFor > hitboxInfo.activeFor and hitboxInfo.activeFor != -1:
		queue_free()
