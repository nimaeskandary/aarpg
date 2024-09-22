class_name Plant extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$HitBox.damaged_signal.connect(take_damage)


func take_damage(_hurt_box: HurtBox) -> void:
	queue_free()
