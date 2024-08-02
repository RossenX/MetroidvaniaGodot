@tool
extends TileMap
class_name GameLevel

var NavMeshGenerated = false
var Tags : TagHolderResource = TagHolderResource.new()
var LevelMap : TileMap
@export var LevelSettings : LevelSettingsResource
@export var StageMusic : Resource
@export var MusicPriority : int = 0

func AddLayerIfNotExist(layerName : String, zIndex : int):
	if GetLayerIDbyName(layerName) == null:
		var LayerIndex = get_layers_count()
		add_layer(LayerIndex)
		set_layer_name(LayerIndex,layerName)
		set_layer_z_index(LayerIndex,zIndex)
		
func GetLayerIDbyName(layerName : String):
	for i in get_layers_count():
		if get_layer_name(i) == layerName:
			return i
	return null

func _init():
	if !Engine.is_editor_hint():
		if Game.GetCurrentPlayerActor() == null:
			var a = Transform3D()
			a.origin.x = -4.735
			a.origin.y = 3
			a.origin.z = -3.23
			a.basis = a.basis.rotated(Vector3.UP,deg_to_rad(-90))

func _ready():
	if !Engine.is_editor_hint():
		if StageMusic != null:
			Game.ChangeMusic(StageMusic.resource_path,MusicPriority)
		
		$PlayArea/Bounds.visible = false
		Game.GetCameraManager().CurrentCamera.Camera.limit_left = $PlayArea/Bounds.global_position.x - $PlayArea/Bounds.shape.size.x / 2
		Game.GetCameraManager().CurrentCamera.Camera.limit_right = $PlayArea/Bounds.global_position.x + $PlayArea/Bounds.shape.size.x / 2
		Game.GetCameraManager().CurrentCamera.Camera.limit_bottom = $PlayArea/Bounds.global_position.y + $PlayArea/Bounds.shape.size.y / 2
		Game.GetCameraManager().CurrentCamera.Camera.limit_top = $PlayArea/Bounds.global_position.y - $PlayArea/Bounds.shape.size.y / 2
	else: # --- Setup Layers
		AddLayerIfNotExist("Background",-2)
		AddLayerIfNotExist("Middleground",-1)
		AddLayerIfNotExist("Base",1)
		AddLayerIfNotExist("Farmiddle",2)
		AddLayerIfNotExist("Foreground",3)
		AddLayerIfNotExist("Info",3)
		while GetLayerIDbyName("") != null:
			remove_layer(GetLayerIDbyName(""))
	
	
func GetSpawnPoint(_spawnpointType:String) -> SpawnPoint:
	return null;
