class_name EnemyStateStun extends EnemyState


@export var anim_name: String = "stun"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0
@export_category("AI")
@export var next_state: EnemyState


var direction: Vector2
var animation_finished: bool


func init() -> void:
	enemy.enemy_damaged_signal.connect(on_enemy_damage)


func enter() -> void:
	enemy.invulnerable = true
	animation_finished = false
	direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.set_direction(direction)
	enemy.velocity = direction * -knockback_speed
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(on_animation_finished)


func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect(on_animation_finished)


func process(delta: float) -> EnemyState:
	if animation_finished:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * delta
	return null


func physics(delta: float) -> EnemyState:
	return null


func on_enemy_damage() -> void:
	state_machine.change_state(self)


func on_animation_finished(_a: String) -> void:
	animation_finished = true
