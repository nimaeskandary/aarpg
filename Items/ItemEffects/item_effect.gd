class_name ItemEffect
extends Resource

@export var use_description: String
@export var sound: AudioStream


func use() -> void:
	if sound:
		PauseMenu.play_audio(sound)
