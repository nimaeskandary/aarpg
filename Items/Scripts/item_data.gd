class_name ItemData
extends Resource

@export var name := ""

@export_multiline var description := ""
@export var texture: Texture2D
@export_category("Item Use Effects")
@export var effects: Array[ItemEffect]


func use() -> bool:
	if !effects or effects.size() == 0:
		return false
	for e in effects:
		if e:
			e.use()
	return true
