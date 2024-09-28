class_name InventoryData
extends Resource

@export var slots: Array[SlotData]


# return whether it was able to pickup
func add_item(item: ItemData, count: int = 1) -> bool:
	for i in slots.size():
		var s: SlotData = slots[i]
		if s:
			if !s.item_data:
				s.item_data = item
				s.quantity = count
				return true
			if s.item_data == item:
				s.quantity += count
				return true
		else:
			var new_s = SlotData.new()
			new_s.item_data = item
			new_s.quantity = count
			slots[i] = new_s
			return true
	return false


func get_save_data() -> Array:
	var item_save: Array = []
	for i in slots.size():
		item_save.append(item_to_save(slots[i]))
	return item_save


func item_to_save(slot: SlotData) -> Dictionary:
	var result: Dictionary = {
								 resource_path = "", quantity = 0
							 }
	if slot:
		result.quantity = slot.quantity
		if slot.item_data:
			result.resource_path = slot.item_data.resource_path
	return result


func parse_save_data(save_data: Array) -> void:
	var array_size := slots.size()
	slots.clear()
	slots.resize(array_size)
	for i in save_data.size():
		slots[i] = item_from_save(save_data[i])


func item_from_save(save_object: Dictionary) -> SlotData:
	if !save_object or !save_object.resource_path or save_object.resource_path == "":
		return null
	var new_slot: SlotData = SlotData.new()
	new_slot.item_data = load(save_object.resource_path)
	new_slot.quantity = int(save_object.quantity)
	return new_slot
