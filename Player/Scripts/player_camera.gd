class_name PLayerCamera extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# for first load of script
	update_limits(GlobalLevelManager.current_tilemap_bounds)
	# for future changes
	GlobalLevelManager.tilemap_bounds_changed_signal.connect(update_limits)


# expecting top left corner and bottom right corner
func update_limits(bounds: Array[Vector2]) -> void:
	if !bounds || bounds.size() != 2:
		return
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
