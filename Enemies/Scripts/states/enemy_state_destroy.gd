class_name EnemyStateDestroy
extends EnemyState

@export var anim_name: String = "destroy"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@onready var hurt_box: HurtBox = $"../../HurtBox"

var damage_position: Vector2
var direction: Vector2


func init() -> void:
	enemy.enemy_destroyed_signed.connect(on_enemy_destroyed)


func enter() -> void:
	enemy.invulnerable = true
	hurt_box.set_deferred("monitorable", false)
	hurt_box.set_deferred("monitoring", false)
	direction = enemy.global_position.direction_to(damage_position)
	enemy.set_direction(direction)
	enemy.velocity = direction * -knockback_speed
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(on_animation_finished)


func exit() -> void:
	pass


func process(delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * delta
	return null


func physics(_delta: float) -> EnemyState:
	return null


func on_enemy_destroyed(hb: HurtBox) -> void:
	damage_position = hb.global_position
	state_machine.change_state(self)


func on_animation_finished(_a: String) -> void:
	enemy.queue_free()
