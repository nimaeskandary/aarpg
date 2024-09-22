class_name EnemyStateWander extends EnemyState


@export var anim_name: String = "walk"
@export var wander_speed: float = 30.0
@export_category("AI")
@export var state_animation_duration: float = 0.7
@export var state_cycles_min: int = 1
@export var state_cycles_max: int = 3
@export var next_state: EnemyState


var timer: float = 0
var direction: Vector2

func init() -> void:
	pass


func enter() -> void:
	timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	var direction: Vector2 = enemy.DIR_4[randi_range(0, 3)]
	enemy.velocity = direction * wander_speed
	enemy.set_direction(direction)
	enemy.update_animation(anim_name)


func exit() -> void:
	pass


func process(delta: float) -> EnemyState:
	timer -= delta
	if timer <= 0:
		return next_state
	return null


func physics(delta: float) -> EnemyState:
	return null
