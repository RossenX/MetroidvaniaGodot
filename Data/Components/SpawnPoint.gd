extends Node2D
class_name SpawnPoint

@export var def : CharacterDefinitionResource
@export var IsPlayer : bool = false

func _ready():
	var command : String = ""
	if IsPlayer and Game.GetCurrentPlayerActor() != null:
		queue_free()
		return
	
	if IsPlayer:
		command  = "Player"
	else:
		command = def.DefaultController
	
	var spawnedChar : Character = Game.CreateCharacter(def.CharacterName,command,position)
	
	if scale.x > 0:
		spawnedChar.Vars.SetVar("FacingDir",1)
	else:
		spawnedChar.Vars.SetVar("FacingDir",-1)
	
	if command == "Player":
		Game.SetCurrentPlayerActor(spawnedChar)
	
	if scale.x > 0:
		spawnedChar.Vars.SetVar("FacingDir",1)
	else:
		spawnedChar.Vars.SetVar("FacingDir",-1)
	queue_free()
