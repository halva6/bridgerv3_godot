extends Node

var save_path: String = "user://settings.save"

var spin_box_value: float
var sound_slider_value: float
var music_slider_value: float
var size: int

func save_settings(spin_box_value: float, sound_slider_value: float, music_slider_value: float) -> void:
	spin_box_value = spin_box_value
	sound_slider_value = sound_slider_value
	music_slider_value = music_slider_value
	
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(spin_box_value)
	file.store_var(sound_slider_value)
	file.store_var(music_slider_value)
	file.store_var(size)
	file.close()
	
func load_settings() -> Array:
	if FileAccess.file_exists(save_path):
		var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
		spin_box_value = file.get_var()
		sound_slider_value = file.get_var()
		music_slider_value = file.get_var()
		file.close()
		
		return [spin_box_value, sound_slider_value, music_slider_value]
	return [1.0,1.0,1.0]
	
func save_board_size(size: int) -> void:
	size = size
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(spin_box_value)
	file.store_var(sound_slider_value)
	file.store_var(music_slider_value)
	file.store_var(size)
	file.close()
	
func load_board_size() -> int:
	if FileAccess.file_exists(save_path):
		var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
		file.get_var()
		file.get_var()
		file.get_var()
		size = file.get_var()
		file.close()
		return size
	return 4
