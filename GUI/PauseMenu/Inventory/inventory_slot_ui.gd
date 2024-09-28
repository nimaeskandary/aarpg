class_name InventorySlotUi
extends Button

var slot_data: SlotData:
	set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func _ready() -> void:
	clear()
	focus_entered.connect(item_focused)
	focus_exited.connect(item_unfocused)
	pressed.connect(item_pressed)


func set_slot_data(v: SlotData) -> void:
	if !v or v.quantity <= 0:
		slot_data = null
		return clear()
	slot_data = v
	texture_rect.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)


func clear() -> void:
	texture_rect.texture = null
	label.text = ""
	PauseMenu.update_item_description("")


func item_focused() -> void:
	if slot_data and slot_data.item_data and slot_data.item_data.description:
		PauseMenu.update_item_description(slot_data.item_data.description)
	else:
		PauseMenu.update_item_description("")


func item_unfocused() -> void:
	PauseMenu.update_item_description("")


func item_pressed() -> void:
	if slot_data and slot_data.item_data and slot_data.quantity > 0:
		var was_used: bool = slot_data.item_data.use()
		if was_used:
			slot_data.quantity -= 1
			set_slot_data(slot_data)
