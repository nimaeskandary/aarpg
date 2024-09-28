extends CanvasLayer

signal show_signal
signal hide_signal
@onready var button_save: Button = $Control/HBoxContainer/ButtonSave
@onready var button_load: Button = $Control/HBoxContainer/ButtonLoad
@onready var item_description: Label = $Control/ItemDescription
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var is_paused: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	hide_pause_menu()
	button_save.pressed.connect(on_save_pressed)
	button_load.pressed.connect(on_load_pressed)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		if is_paused:
			hide_pause_menu()
		else:
			show_paused_menu()
		get_viewport().set_input_as_handled()


func show_paused_menu():
	get_tree().paused = true
	visible = true
	is_paused = true
	show_signal.emit()


func hide_pause_menu():
	get_tree().paused = false
	visible = false
	is_paused = false
	hide_signal.emit()


func on_save_pressed() -> void:
	if !is_paused:
		return
	SaveManager.save_game()
	hide_pause_menu()


func on_load_pressed() -> void:
	if !is_paused:
		return
	SaveManager.load_game()
	await GlobalLevelManager.level_load_started_signal
	hide_pause_menu()


func update_item_description(new_text: String) -> void:
	if item_description:
		item_description.text = new_text


func play_audio(a: AudioStream) -> void:
	audio_stream_player.stream = a
	audio_stream_player.play()
