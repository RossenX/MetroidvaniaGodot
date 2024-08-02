extends AnimatedSprite2D
class_name SpriteVFX

func _init(loc : Vector2, sfx : String, _attached : bool = false, _actor : Actor = null):
	position = loc
	sprite_frames = load("res://Assets/Animations/VFX.tres")
	play(sfx)
	animation_finished.connect(_on_anim_end)

func _on_anim_end():
	queue_free()
