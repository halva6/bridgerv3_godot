extends Control

func _on_restart_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	GlobalGame.set_matrix(GlobalGame.get_start_matrix())
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_exit_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	GlobalGame.set_matrix(GlobalGame.get_start_matrix())
	get_tree().change_scene_to_file("res://scenes/start.tscn")



func _on_game_root_set_win_ui(winner: String) -> void:
	$"MarginContainer/CenterContainer/VBoxContainer/WinLabel".text = winner + " wins!"
