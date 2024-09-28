@tool

class_name ItemPickup
extends Node2D

@export var item_data: ItemData:
	set = set_item_data

@onready var area2d: Area2D = $Area2D
@onready var sprite2d: Sprite2D = $Sprite2D
@onready var audio_stream_player2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	update_texture()
	if Engine.is_editor_hint():
		return
	area2d.body_entered.connect(on_body_entered)


func on_body_entered(b) -> void:
	if b is Player and item_data:
		if GlobalPlayerManager.INVENTORY_DATA.add_item(item_data):
			item_picked_up()


func item_picked_up() -> void:
	area2d.body_entered.disconnect(on_body_entered)
	audio_stream_player2d.play()
	visible = false
	await audio_stream_player2d.finished
	queue_free()


func update_texture() -> void:
	if item_data:
		sprite2d.texture = item_data.texture


func set_item_data(v: ItemData) -> void:
	item_data = v