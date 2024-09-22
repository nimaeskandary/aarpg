class_name State_Stun
extends State

@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0
@export var invulnerable_duration: float = 1.0

var hurt_box: HurtBox
var direction: Vector2
var next_state: State = null

@onready var idle = $"../Idle"


func init() -> void:
	player.player_damaged_signal.connect(player_damaged)


func enter() -> void:
	player.animation_player.animation_finished.connect(animation_finished)
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	player.set_direction()
	player.update_animation("stun")
	player.make_invulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")


func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(animation_finished)


func process(delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * delta
	return next_state


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null


func player_damaged(hb: HurtBox) -> void:
	hurt_box = hb
	state_machine.change_state(self)


func animation_finished(_a: String) -> void:
	next_state = idle