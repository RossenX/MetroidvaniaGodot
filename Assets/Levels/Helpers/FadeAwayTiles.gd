extends TileMap
var currentAlpha = 1.0
func _ready():
	visible = true

func _physics_process(_delta):
	if Game.GetCurrentPlayerActor() in $Area.get_overlapping_bodies():
		currentAlpha -= 0.05
	else:
		currentAlpha += 0.05
	
	currentAlpha = clampf(currentAlpha,0.5,1)
	modulate = Color(1,1,1,currentAlpha)
