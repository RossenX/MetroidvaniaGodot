extends AudioStreamPlayer2D
class_name OneTimeAudio

var pos : Vector2
func _init(_toPlay : String, _pos : Vector2):
	pos = _pos
	stream = load(_toPlay)
	finished.connect(_audio_end)
	Game.add_child(self)

func _audio_end():
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	play()
	global_position = pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
