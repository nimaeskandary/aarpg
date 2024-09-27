class_name InventorySlotUi
extends Button

var slot_data: SlotData:
	set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect(item_focused)
	focus_exited.connect(item_unfocused)


func set_slot_data(v: SlotData) -> void:
	slot_data = v
	if !slot_data:
		return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)


func item_focused() -> void:
	if slot_data and slot_data.item_data and slot_data.item_data.description:
		PauseMenu.update_item_description(slot_data.item_data.description)
	else:
		PauseMenu.update_item_description("")


func item_unfocused() -> void:
	PauseMenu.update_item_description("")
