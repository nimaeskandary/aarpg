class_name Player
extends CharacterBody2D

const DIR_4: Array[Vector2]     = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2          = Vector2.ZERO
var invulnerable: bool          = false
var hp: int                     = 6
var max_hp: int                 = 6

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hit_box: HitBox = $HitBox
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
signal direction_changed_signal (new_direction: Vector2)
signal player_damaged_signal(hurt_box: HurtBox)


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalPlayerManager.player = self
	state_machine.init(self)
	hit_box.damaged_signal.connect(take_damage)
	update_hp(max_hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()


func _physics_process(_delta):
	move_and_slide()


func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	# get normalized direction angle, and map to an index in dir_4, bias towards cardinal direction to honor the first pressed key
	var direction_id: int      = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_direction: Vector2 = DIR_4[direction_id]
	if new_direction == cardinal_direction:
		return false
	cardinal_direction = new_direction
	direction_changed_signal.emit(new_direction)
	# scaling instead of setting flip horizontal flag so that child nodes also are flipped
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true


func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())


func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"


func take_damage(hurt_box: HurtBox) -> void:
	if invulnerable:
		return
	update_hp(-hurt_box.damage)
	if hp > 0:
		player_damaged_signal.emit(hurt_box)
	else:
		player_damaged_signal.emit(hurt_box)
		update_hp(max_hp)


func update_hp(delta: int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	PlayerHud.update_hp(hp, max_hp)


func make_invulnerable(d: float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer(d).timeout
	invulnerable = false
	hit_box.monitoring = true
