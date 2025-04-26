extends Control

func _on_multiplayer_button_pressed() -> void:
	GlobalGame.set_local_multiplayer(true)
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	


func _on_singleplayer_button_pressed() -> void:
	GlobalGame.set_local_multiplayer(false)
	get_tree().change_scene_to_file("res://scenes/game.tscn")
