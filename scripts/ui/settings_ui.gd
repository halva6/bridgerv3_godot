extends Control

@export var last_ui:String = "pause_ui"
@export var hide_mcts_speed: bool = false

var save_path: String = "user://settings.save"

func _ready() -> void:
	load_data()
	if hide_mcts_speed:
		$MarginContainer/VBoxContainer/VBoxContainer/MCTSSpeedBox.visible = false

func _on_back_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	save_settings()
	visible = false
	get_parent().get_node(last_ui).visible = true


func _on_impressum_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	visible = false
	get_parent().get_node("impressum_ui").visible = true

func _on_tutorial_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound.
	visible = false
	get_parent().get_node("how_to_play_ui").visible = true


func _on_minutes_spin_box_value_changed(value: float) -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	GlobalGame.set_simulation_time(int(value))


func save_settings() -> void:
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var($"MarginContainer/VBoxContainer/VBoxContainer/MCTSSpeedBox/MinutesSpinBox".value)
	file.store_var($"MarginContainer/VBoxContainer/VBoxContainer/SoundBox/SoundSlider".value)
	file.store_var($"MarginContainer/VBoxContainer/VBoxContainer/MusicVBox/MusicSlider".value)

func load_data():
	if FileAccess.file_exists(save_path):
		var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
		$"MarginContainer/VBoxContainer/VBoxContainer/MCTSSpeedBox/MinutesSpinBox".value = file.get_var()
		$"MarginContainer/VBoxContainer/VBoxContainer/SoundBox/SoundSlider".value = file.get_var()
		$"MarginContainer/VBoxContainer/VBoxContainer/MusicVBox/MusicSlider".value = file.get_var()
		
