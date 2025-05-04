extends Control

func _on_restart_button_pressed() -> void:
	GlobalGame.set_matrix(GlobalGame.get_start_matrix())
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_exit_button_pressed() -> void:
	GlobalGame.set_matrix(GlobalGame.get_start_matrix())
	get_tree().change_scene_to_file("res://scenes/start.tscn")



func _on_game_root_set_win_ui(winner: String) -> void:
	$"TextureRect/MarginContainer/CenterContainer/VBoxContainer/WinLabel".text = winner + " wins!"
