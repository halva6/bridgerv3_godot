extends Node

@export var is_multiplayer: bool = true
@export var start_player: String = "green"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalGame.set_current_player(start_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_n_move: Array
	
	if(is_multiplayer):
		player_n_move = _switch_player("green", "red", GlobalGame.get_current_player(), GlobalGame.get_finish_turn())
	else:
		player_n_move = _switch_player("green", "computer", GlobalGame.get_current_player(), GlobalGame.get_finish_turn())
	
	GlobalGame.set_current_player(player_n_move[0])
	GlobalGame.set_finish_turn(player_n_move[1])
	

#changes the players, returns a array of the current_player and finishturn
func _switch_player(player1: String, player2: String, current_player: String, finish_turn: bool) -> Array:
	if(finish_turn):
		if(!_game_over()):
			if (current_player == player1):
				current_player = player2
				finish_turn = false
			else:
				current_player = player1
				finish_turn = false
		else:
			return["", false]
			
	return [current_player, finish_turn]
	
# checks if a player wins 
func _game_over() -> bool:
	if(check_winner(GlobalGame.get_matrix(), 1)):
		print("green wins")
		return true
	elif (check_winner(GlobalGame.get_matrix(),2)):
		print("red wins")
		return true
	return false


	
	
func check_winner(matrix: Array, player: int):
	if player == 1:
		for start_col in range(len(matrix[0])):
			if matrix[0][start_col] == player:
				if dfs(matrix, 0, start_col, player, {}):
					return true
	elif player == 2:
		for start_row in range(len(matrix)):
			if matrix[start_row][0] == player:
				if dfs(matrix, start_row, 0, player, {}):
					return true
	return false


func dfs(matrix: Array, row: int, col: int, player: int, visited):
	if player == 1 and row == len(matrix) - 1:
		return true
	if player == 2 and col == len(matrix[0]) - 1:
		return true

	visited[Vector2(row, col)] = true

	var directions = [
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(-1, 0),
		Vector2(0, -1)
	]

	for direction in directions:
		var new_row = row + int(direction.x)
		var new_col = col + int(direction.y)
		if new_row >= 0 and new_row < len(matrix) and new_col >= 0 and new_col < len(matrix[0]):
			var new_pos = Vector2(new_row, new_col)
			if not visited.has(new_pos) and matrix[new_row][new_col] == player:
				if dfs(matrix, new_row, new_col, player, visited):
					return true

	return false
