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

