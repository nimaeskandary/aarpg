class_name State_Attack extends State

@export var attack_sound: AudioStream
@export_range(1, 20, 0.5) var decelerate_speed: float = 5.0

@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var walk = $"../Walk"
@onready var idle = $"../Idle"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_animation_player: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"

var attacking: bool = false

func enter() -> void:
	attacking = true
	animation_player.animation_finished.connect(end_attack)
	attack_animation_player.play("attack_" + player.anim_direction())
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	player.update_animation("attack")


func exit() -> void:
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false


func process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null


func physics(_delta: float) -> State:
	return null
	

func handle_input(_event: InputEvent) -> State:
	return null
	

func end_attack(_new_anim_name: String) -> void:
	attacking = false
