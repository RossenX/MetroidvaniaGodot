extends Node2D

var hearts : Array = []
var heart_sprite = preload("res://Assets/UI/heart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Game.GetCurrentPlayerActor() != null:
		var playerMaxLife : int = Game.GetCurrentPlayerActor().Vars.GetVar("MaxLife")
		var playerLife : int = Game.GetCurrentPlayerActor().Vars.GetVar("Life")
		
		while hearts.size() < playerMaxLife:
			var newHeart = heart_sprite.instantiate()
			newHeart.position.x = hearts.size() * 16
			hearts.append(newHeart)
			add_child(hearts[hearts.size()-1])
			
		while hearts.size() > playerMaxLife:
			var oldHeart = hearts.pop_back()
			oldHeart.queue_free()
		
		var heartCount = 0
		for i in hearts:
			heartCount += 1
			if playerLife < heartCount:
				i.frame = 0
			else:
				i.frame = 2
