extends Control

signal visibility(is_visible: bool)
var _was_visible: bool = true

func _on_multiplayer_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") # Sound
	GlobalGame.set_local_multiplayer(true)
	GlobalGame.set_level_mode(false)
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_singleplayer_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") # Sound
	GlobalGame.set_local_multiplayer(false)
	GlobalGame.set_level_mode(false)
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_settings_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") # Sound
	visible = false
	get_parent().get_node("settings_ui").visible = true
	_manage_visibilty()

func _on_level_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound")
	visible = false
	get_parent().get_node("level_selection_ui").visible = true

func _manage_visibilty() -> void:
	emit_signal("visibility", false)
	_was_visible = true

func _process(delta: float) -> void:
	if self.visible and _was_visible:
		_was_visible = false
		emit_signal("visibility", true)
