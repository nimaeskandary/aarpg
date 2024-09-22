extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	if GlobalPlayerManager.player_spawned == false:
		GlobalPlayerManager.set_player_position(global_position)
		GlobalPlayerManager.player_spawned = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
