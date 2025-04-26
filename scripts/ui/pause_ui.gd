extends Control

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_continue_button_pressed() -> void:
	visible = false
	get_parent().get_node("game_ui").visible = true
	get_parent().layer = -1

func _on_redo_button_pressed() -> void:
	GlobalGame.set_matrix(GlobalGame.get_start_matrix())
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_exit_button_pressed() -> void:
	GlobalGame.set_matrix(GlobalGame.get_start_matrix())
	get_tree().change_scene_to_file("res://scenes/start.tscn")
