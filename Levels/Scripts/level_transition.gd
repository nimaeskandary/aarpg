@tool
class_name LevelTransition
extends Area2D

enum SIDE {LEFT, RIGHT, TOP, BOTTOM}
@export_file("*.tscn") var level
# this must match the name of the transition on the other side
@export var target_transition_area: String = "LevelTransition"

@export_category("Collision Area Settings")
@export_range(1, 12, 1, "or_greater") var size: int = 2:
	set(_v):
		size = _v
		update_area()

@export var side: SIDE = SIDE.LEFT:
	set(_v):
		side = _v
		update_area()

@export var toggle_snap: bool = false:
	set(_v):
		snap_to_grid()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_area()
	# so tool window doesn't do all this extra logic
	if Engine.is_editor_hint():
		return
	monitoring = false
	place_player()
	await GlobalLevelManager.level_loaded_signal
	monitoring = true
	body_entered.connect(player_entered)


func player_entered(_p: Node2D) -> void:
	GlobalLevelManager.load_new_level(level, target_transition_area, get_offset())


func place_player() -> void:
	if name != GlobalLevelManager.target_transition:
		return
	GlobalPlayerManager.set_player_position(global_position + GlobalLevelManager.position_offset)


func get_offset() -> Vector2:
	var offset: Vector2     = Vector2.ZERO
	var player_pos: Vector2 = GlobalPlayerManager.player.global_position
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = player_pos.y - global_position.y
		offset.x = 16
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		offset.x = player_pos.x - global_position.x
		offset.y = 16
		if side == SIDE.TOP:
			offset.y *= -1
	return offset


func update_area() -> void:
	var new_rect: Vector2     = Vector2(32, 32)
	var new_position: Vector2 = Vector2.ZERO
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
	(collision_shape.shape as RectangleShape2D).size = new_rect
	collision_shape.position = new_position


func snap_to_grid() -> void:
	position.x = round(position.x / 16) * 16
	position.y = round(position.y / 16) * 16
