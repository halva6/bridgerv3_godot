extends Node

@export var save_path: String = "user://settings.save"

var _spin_box_value: float = 5
var _sound_slider_value: float = 1
var _music_slider_value: float = 1
var _player_button_index: int = 0
var _size: int = 4

# saving the settings in an external file, as a byte stream
func save_settings(spin_box_value: float, sound_slider_value: float, music_slider_value: float, player_button_index: int) -> void:
	self._spin_box_value = spin_box_value
	self._sound_slider_value = sound_slider_value
	self._music_slider_value = music_slider_value
	self._player_button_index = player_button_index
	
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(spin_box_value)
	file.store_var(sound_slider_value)
	file.store_var(music_slider_value)
	file.store_var(player_button_index)
	file.store_var(_size)
	file.close()
	
# the variables must always be read one after the other; it's like a queue 
# the first variable to be stored must also be the first variable to be read
func load_settings() -> Array:
	if FileAccess.file_exists(save_path):
		var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
		self._spin_box_value = file.get_var()
		self._sound_slider_value = file.get_var()
		self._music_slider_value = file.get_var()
		self._player_button_index = file.get_var()
		file.close()
		
		return [_spin_box_value, _sound_slider_value, _music_slider_value, _player_button_index]
	else:
		save_settings(5.0, 1.0, 1.0, 0)
	return [5.0, 1.0, 1.0, 0]
	
func save_board_size(size: int) -> void:
	size = size
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(self._spin_box_value)
	file.store_var(self._sound_slider_value)
	file.store_var(self._music_slider_value)
	file.store_var(self._player_button_index)
	file.store_var(size)
	file.close()


func load_board_size() -> int:
	if FileAccess.file_exists(save_path):
		var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
		self._spin_box_value = file.get_var()
		self._sound_slider_value = file.get_var()
		self._music_slider_value = file.get_var()
		self._player_button_index = file.get_var()
		self._size = file.get_var()
		file.close()
		return _size
	return 4
