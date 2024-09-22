class_name Enemy extends CharacterBody2D

@export var hp: int = 3

signal direction_changed_signal(new_direction: Vector2)
signal enemy_damaged_signal(hurt_box: HurtBox)
signal enemy_destroyed_signed(hurt_box: HurtBox)

const DIR_4: Array[Vector2] = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player: Player
var invulnerable: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $SlimeSprite
@onready var hit_box: HitBox = $HitBox
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine


# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.init(self)
	assert(GlobalPlayerManager.player != null, "player is not initialized!")
	player = GlobalPlayerManager.player
	hit_box.damaged_signal.connect(take_damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta: float) -> void:
	move_and_slide()


func set_direction(_new_direction: Vector2) -> bool:
	direction = _new_direction
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
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged_signal.emit(hurt_box)
	else:
		enemy_destroyed_signed.emit(hurt_box)
