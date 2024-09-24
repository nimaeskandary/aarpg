extends Node

const SAVE_PATH: String = "user://"
signal game_loaded_signal
signal game_saved_signal

var current_save: Dictionary = {
								   scene_path = "",
								   player = {
									   hp = 1,
									   max_hp = 1,
									   pos_x = 0,
									   pos_y = 0
								   },
								   items = [],
								   persistence = [],
								   quests = []
							   }


func save_game():
	update_player_data()
	update_scene_path()
	var file              := FileAccess.open(SAVE_PATH + "save.json", FileAccess.WRITE)
	var save_json: String =  JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved_signal.emit()


func load_game():
	var file         := FileAccess.open(SAVE_PATH + "save.json", FileAccess.READ)
	var line: String =  file.get_line()
	var data         =  JSON.parse_string(line)
	if data == null:
		print("error parsing json: ", line)
	current_save = data
	GlobalLevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	await GlobalLevelManager.level_load_started_signal
	GlobalPlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	GlobalPlayerManager.player.max_hp = current_save.player.max_hp
	GlobalPlayerManager.player.hp = current_save.player.hp
	GlobalPlayerManager.player.update_hp(0)
	await GlobalLevelManager.level_loaded_signal
	game_loaded_signal.emit()


func update_player_data():
	var p: Player = GlobalPlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y


func update_scene_path():
	var p: String
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p