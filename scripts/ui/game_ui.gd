extends Control


func _on_pause_button_pressed() -> void:
	visible = false
	get_parent().get_node("pause_ui").visible = true
	get_parent().layer = 1


func _on_game_root_update_player_label(player: String) -> void:
	$MarginContainer/PlayerLabel.text = player+"s turn"
