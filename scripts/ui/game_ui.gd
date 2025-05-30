extends Control

func _ready() -> void:
	if GlobalGame.get_local_multiplayer():
		%VisitLabel.visible = false


func _on_pause_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	visible = false
	%pause_ui.visible = true
	%CanvasLayerBackground.layer = 0
	
func _on_game_root_update_player_label(player: String) -> void:
	%PlayerLabel.text = player+"s turn"


func _on_game_root_set_win_ui(winner: String) -> void:
	%WinButton.visible = true
	%PlayerLabel.text = winner + " wins!"
	
	%VisitLabel.visible = true
	%VisitLabel.text = "Tap to exit"
	
	%ResetMoveButton.disabled = true

func _on_game_root_update_visit_label(visits: String) -> void:
	%VisitLabel.text = "Visits: " + visits


func _on_reset_move_button_pressed() -> void:
	GlobalGame.set_reset(true)


func _on_win_button_pressed() -> void:
	visible = false
	%win_ui.visible = true
	%CanvasLayerBackground.layer = 0
