class_name InventoryUi
extends Control

const INVENTORY_SLOT: PackedScene = preload("res://GUI/PauseMenu/Inventory/InventorySlot.tscn")
@export var data: InventoryData

@onready var pause_menu: CanvasLayer = $"../../.."


func _ready() -> void:
	PauseMenu.show_signal.connect(update_inventory)
	PauseMenu.hide_signal.connect(clear_inventory)
	clear_inventory()


func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()


func update_inventory() -> void:
	for s in data.slots:
		var new_slot: InventorySlotUi = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
	(get_child(0) as InventorySlotUi).grab_focus()
