extends Control

func _on_multiplayer_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	GlobalGame.set_local_multiplayer(true)
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	


func _on_singleplayer_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	GlobalGame.set_local_multiplayer(false)
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_settings_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	visible = false
	get_parent().get_node("settings_ui").visible = true
