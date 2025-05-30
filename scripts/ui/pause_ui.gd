extends Control

func _on_settings_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	visible = false
	%settings_ui.visible = true

func _on_continue_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	visible = false
	get_parent().get_node("game_ui").visible = true
	%CanvasLayerBackground.layer = -1

func _on_redo_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	GlobalGame.set_matrix(GlobalGame.get_start_matrix())
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_exit_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	GlobalGame.set_matrix(GlobalGame.get_start_matrix())
	get_tree().change_scene_to_file("res://scenes/start.tscn")
