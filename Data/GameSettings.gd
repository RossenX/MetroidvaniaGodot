extends Resource
class_name GameSettings

var MouseSensativity : Vector2 = Vector2(1,1)

func GetMouseSensativity() -> Vector2:
	return MouseSensativity / 10 * (Vector2(DisplayServer.window_get_size()) / Vector2(Game.get_tree().root.content_scale_size))

func SetMouseSensativity(_newSensativity : Vector2):
	MouseSensativity = _newSensativity
