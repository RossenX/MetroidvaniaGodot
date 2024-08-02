extends AnimatedSprite2D
class_name FireBall

var ActiveFrames = 0
var velocity := Vector2.ZERO

func _ready():
	var hurtInfo = HurtBoxResource.new()
	hurtInfo.position.x = 10
	hurtInfo.position.y = 0
	hurtInfo.size.x = 20
	hurtInfo.size.y = 15
	hurtInfo.activeFor = -1
	hurtInfo.OnlyHitPlayer = true
	Game.CreateHurtBox(self,hurtInfo)
	top_level = true

func _physics_process(_delta):
	rotation = velocity.angle()
	ActiveFrames += 1
	position += velocity * 3
	if ActiveFrames > 190:
		queue_free()
