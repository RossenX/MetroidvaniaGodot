extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$"Game Over".visible = false
	$Win.visible = false
	
	if Game.Tags.HasTag("GameOver"):
		$"Game Over".visible = true
	elif Game.Tags.HasTag("GameWon"):
		$Win.visible = true
	
	if $"Game Over".visible or $Win.visible:
		if Game.GetCurrentPlayerActor().ControllerTag("Retry"):
			Game.HardReset()
