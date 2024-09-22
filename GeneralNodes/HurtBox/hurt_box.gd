class_name HurtBox extends Area2D

@export var damage: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(on_enter)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func on_enter(a: Area2D) -> void:
	if a is HitBox:
		a.take_damage(damage)
