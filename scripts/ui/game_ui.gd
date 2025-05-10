extends Control

func _ready() -> void:
	if GlobalGame.get_local_multiplayer():
		$MarginContainer/VBoxContainer/VisitLabel.visible = false


func _on_pause_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	visible = false
	get_parent().get_node("pause_ui").visible = true
	get_parent().layer = 1


func _on_game_root_update_player_label(player: String) -> void:
	$MarginContainer/VBoxContainer/PlayerLabel.text = player+"s turn"


func _on_game_root_set_win_ui(winner: String) -> void:
	visible = false
	get_parent().get_node("win_ui").visible = true
	get_parent().layer = 1


func _on_game_root_update_visit_label(visits: String) -> void:
	$MarginContainer/VBoxContainer/VisitLabel.text = "Visits: " + visits
