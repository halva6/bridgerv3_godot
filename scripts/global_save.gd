extends Node

var save_path: String = "user://settings.save"

var spin_box_value: float = 5
var sound_slider_value: float = 1
var music_slider_value: float = 1
var player_button_index: int = 0
var size: int = 4

func save_settings(spin_box_value: float, sound_slider_value: float, music_slider_value: float, player_button_index: int) -> void:
	spin_box_value = spin_box_value
	sound_slider_value = sound_slider_value
	music_slider_value = music_slider_value
	player_button_index = player_button_index
	
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(spin_box_value)
	file.store_var(sound_slider_value)
	file.store_var(music_slider_value)
	file.store_var(player_button_index)
	file.store_var(size)
	file.close()
	
func load_settings() -> Array:
	if FileAccess.file_exists(save_path):
		var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
		spin_box_value = file.get_var()
		sound_slider_value = file.get_var()
		music_slider_value = file.get_var()
		player_button_index = file.get_var()
		file.close()
		
		return [spin_box_value, sound_slider_value, music_slider_value, player_button_index]
	else:
		save_settings(5.0,1.0,1.0,0)
	return [5.0,1.0,1.0,0]
	
func save_board_size(size: int) -> void:
	size = size
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(spin_box_value)
	file.store_var(sound_slider_value)
	file.store_var(music_slider_value)
	file.store_var(player_button_index)
	file.store_var(size)
	file.close()


func load_board_size() -> int:
	if FileAccess.file_exists(save_path):
		var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
		spin_box_value = file.get_var()
		sound_slider_value = file.get_var()
		music_slider_value = file.get_var()
		player_button_index = file.get_var()
		size = file.get_var()
		file.close()
		return size
	return 4
