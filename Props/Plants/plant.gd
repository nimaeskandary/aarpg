class_name Plant extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$HitBox.damaged_signal.connect(take_damage)


func take_damage(_damage: int) -> void:
	queue_free()
