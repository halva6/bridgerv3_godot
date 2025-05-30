extends Control

@export var last_ui: String = "pause_ui"
@export var hide_mcts_speed: bool = false

var _is_spinbox_programmatic_change: bool = false

func _ready() -> void:
	if hide_mcts_speed:
		%MCTSSpeedBox.visible = false
		%StartPlayerBox.visible = false
	await get_tree().process_frame
	await get_tree().process_frame
	load_data()
	
	#This means that the spinbox can only be edited with the arrows and not with the keyboard
	var spin_box_line_edit: LineEdit = %MinutesSpinBox.get_line_edit()
	spin_box_line_edit.focus_mode = Control.FOCUS_NONE

func _on_back_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") # Sound
	_save_settings()
	visible = false
	get_parent().get_node(last_ui).visible = true


func _on_impressum_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") # Sound
	visible = false
	get_parent().get_node("impressum_ui").visible = true

func _on_tutorial_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") # Sound.
	visible = false
	get_parent().get_node("how_to_play_ui").visible = true


func _on_minutes_spin_box_value_changed(value: float) -> void:
	if !_is_spinbox_programmatic_change:
		GlobalAudio.emit_signal("play_click_sound") # Sound
		GlobalGame.set_simulation_time(int(value))

func _on_player_button_item_selected(index: int) -> void:
	GlobalAudio.emit_signal("play_click_sound") # Sound
	GlobalGame.set_start_player(%PlayerButton.get_item_text(index))

func _save_settings() -> void:
	var spin_box_value: float = %MinutesSpinBox.value
	var sound_slider_value: float = %SoundSlider.value
	var music_slider_value: float = %MusicSlider.value
	var player_button_index: int = %PlayerButton.get_selected_id()
	GlobalSave.save_settings(spin_box_value, sound_slider_value, music_slider_value, player_button_index)
	
func load_data() -> void:
	_is_spinbox_programmatic_change = true
	var settings_array: Array = GlobalSave.load_settings()
	%MinutesSpinBox.value = settings_array[0]
	%SoundSlider.value = settings_array[1]
	%MusicSlider.value = settings_array[2]
	%PlayerButton.select(settings_array[3])
	GlobalGame.set_start_player(%PlayerButton.get_item_text(settings_array[3]))
	_is_spinbox_programmatic_change = false
