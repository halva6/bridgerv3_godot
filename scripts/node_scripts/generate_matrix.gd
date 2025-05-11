extends Node

func _on_multiplayer_button_pressed() -> void:
	var generated_matrix: Array = generate_matrix(GlobalGame.get_game_board_size())
	GlobalGame.set_matrix(generated_matrix.duplicate(true))
	GlobalGame.set_start_matrix(generated_matrix.duplicate(true))


func _on_singleplayer_button_pressed() -> void:
	var generated_matrix: Array = generate_matrix(GlobalGame.get_game_board_size())
	GlobalGame.set_matrix(generated_matrix.duplicate(true))
	GlobalGame.set_start_matrix(generated_matrix.duplicate(true))
	
func generate_matrix(size):
	var col_array: Array = []
	var row_array: Array = []
	for i in range(size):
		if i == 0 or i == size-1:
			for j in range(size):
				if j % 2 == 0:
					row_array.append(-1)
				else:
					row_array.append(1)
			row_array[0] = -3
			row_array[-1] = -3
		elif i % 2 != 0:
			for j in range(size):
				if j % 2 == 0:
					row_array.append(2)
				else:
					row_array.append(0)
		else:
			for j in range(size):
				if j % 2 == 0:
					row_array.append(0)
				else:
					row_array.append(1)
			row_array[0] = -2
			row_array[-1] = -2
		col_array.append(row_array.duplicate(true))
		row_array.clear()
	return col_array
