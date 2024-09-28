extends Node

const PLAYER: PackedScene           = preload("res://Player/player.tscn")
const INVENTORY_DATA: InventoryData = preload("res://GUI/PauseMenu/Inventory/player_inventory.tres")
var player: Player
var player_spawned: bool            = false


func _ready() -> void:
	add_player_instance()
	# failsafe in case we forgot to add a player spawn
	await get_tree().create_timer(0.2).timeout
	player_spawned = true


func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)


func set_player_position(new_pos: Vector2) -> void:
	player.global_position = new_pos


func set_as_parent(p: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	p.add_child(player)


func unparent_player(p: Node2D) -> void:
	p.remove_child(player)
