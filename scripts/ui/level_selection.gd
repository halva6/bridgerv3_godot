extends Control

func _on_level_1_button_pressed() -> void:
	manage_levels(1)

func _on_level_2_button_pressed() -> void:
	manage_levels(2)

func _on_level_3_button_pressed() -> void:
	manage_levels(3)

func _on_level_4_button_pressed() -> void:
	manage_levels(4)

func _on_level_5_button_pressed() -> void:
	manage_levels(5)

func _on_level_6_button_pressed() -> void:
	manage_levels(6)

func _on_level_7_button_pressed() -> void:
	manage_levels(7)

func _on_level_8_button_pressed() -> void:
	manage_levels(8)
	

func manage_levels(level: int) -> void:
	GlobalAudio.emit_signal("play_click_sound")
	var data: Dictionary = load_json("res://assets/level/level" + str(level) + ".json")
	
	if !data.is_empty():
		var matrix: Array = data["matrix"]
		var meta: Dictionary = data["meta"]
		
		GlobalGame.set_level_mode(true)
		
		GlobalGame.set_matrix(matrix.duplicate(true))
		GlobalGame.set_start_matrix(matrix.duplicate(true))
		
		GlobalGame.set_game_board_size(int(meta["rows"]))
		GlobalGame.set_simulation_time(int(meta["simulation_time"]))
		GlobalGame.set_start_player(meta["start_player"])
		
		GlobalGame.set_level_description(meta["description"])
		
		GlobalGame.set_local_multiplayer(false)
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func load_json(file_path: String) -> Dictionary:
	if FileAccess.file_exists(file_path):
		var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var json_text: String = file.get_as_text()
		file.close()
		var json: JSON = JSON.new()
		var error: Error = json.parse(json_text)
		if error == OK:
			var data: Dictionary = json.data
			if typeof(data) == TYPE_DICTIONARY:
				return data
			else:
				print("[ERROR] unexpected file format")
		else:
			print("[ERROR] JSON Parse Error: ", json.get_error_message())
	else:
		print("[ERROR] file is not existing ", file_path)
	return {}
