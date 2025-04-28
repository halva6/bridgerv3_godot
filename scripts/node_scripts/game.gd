extends Node

# Exported variables (editable in Godot editor)
@onready var is_multiplayer: bool = GlobalGame.get_local_multiplayer()  # Toggle between multiplayer vs AI mode
@export var start_player: String = "green"  # Which player starts the game
@export var simulation_number = 100

signal update_player_label(player: String)
signal set_computers_bridge(matrix_position: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalGame.set_current_player(start_player)
	emit_signal("update_player_label", start_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_n_move: Array  # Will store [current_player, finish_turn]
	
	# Determine players based on game mode
	if(is_multiplayer):
		player_n_move = _switch_player("green", "red", GlobalGame.get_current_player(), GlobalGame.get_finish_turn())
	else:
		player_n_move = _switch_player("green", "computer", GlobalGame.get_current_player(), GlobalGame.get_finish_turn())
		if(player_n_move[0] == "computer"):
			#var matrix_logic = MatrixLogic.new()
			var best_move = MCTS.new()
			var transform_matrix: Array = _transform_matrix(GlobalGame.get_matrix().duplicate(true))
			var matrix_position = best_move.find_best_move(transform_matrix,2) #matrix_logic.get_best_mcts(transform_matrix, simulation_number)
			print(matrix_position)
			emit_signal("set_computers_bridge", matrix_position)
			player_n_move[1] = true
	
	# Update global game state
	GlobalGame.set_current_player(player_n_move[0])
	GlobalGame.set_finish_turn(player_n_move[1])

# Handles player switching logic
# Parameters:
#   player1: First player identifier (String)
#   player2: Second player identifier (String)
#   current_player: Currently active player (String)
#   finish_turn: Whether the current turn is complete (bool)
# Returns: Array containing [new_current_player, new_finish_turn]
func _switch_player(player1: String, player2: String, current_player: String, finish_turn: bool) -> Array:
	if(finish_turn):
		if(!_game_over()):  # Only switch if game isn't over
			if (current_player == player1):
				current_player = player2
				emit_signal("update_player_label", current_player)
				finish_turn = false
			else:
				current_player = player1
				emit_signal("update_player_label", current_player)
				finish_turn = false
		else:
			return["", false]  # Empty string indicates game over
			
	return [current_player, finish_turn]


# Determines if the game has been won
# Returns: bool - true if a player has won, false otherwise
func _game_over() -> bool:
	# Create a transformed copy of the game matrix for analysis
	var transform_matrix: Array = _transform_matrix(GlobalGame.get_matrix().duplicate(true))
	
	# Check for both possible winners
	if (check_winner(transform_matrix, 1)):  # Player 1 (green)
		print("green wins")
		return true
	elif (check_winner(transform_matrix, 2)):  # Player 2 (red/computer)
		print("red wins")
		return true
	return false

# Normalizes the game matrix values for win checking
# Parameters:
#   matrix: The game board matrix to transform
# Returns: Transformed matrix where 3→1 and 4→2
func _transform_matrix(matrix: Array) -> Array:
	for i in range(len(matrix)):
		for j in range(len(matrix[i])):
			if(matrix[i][j] == 3):
				matrix[i][j] = 1  # Convert type 3 to player 1
			elif(matrix[i][j] == 4):
				matrix[i][j] = 2  # Convert type 4 to player 2
	return matrix

# Checks if specified player has a winning path
# Parameters:
#   matrix: Transformed game board
#   player: Which player to check (1 or 2)
# Returns: bool - true if player has winning path
func check_winner(matrix: Array, player: int):
	if player == 1:
		# Player 1 (green) wins by connecting top to bottom
		for start_col in range(len(matrix[0])):
			if matrix[0][start_col] == player:
				if dfs(matrix, 0, start_col, player, {}):
					return true
	elif player == 2:
		# Player 2 (red) wins by connecting left to right
		for start_row in range(len(matrix)):
			if matrix[start_row][0] == player:
				if dfs(matrix, start_row, 0, player, {}):
					return true
	return false

# Depth-first search for path checking
# Parameters:
#   matrix: Game board
#   row: Current row position
#   col: Current column position
#   player: Which player's path we're checking
#   visited: Dictionary tracking visited positions
# Returns: bool - true if winning path found
func dfs(matrix: Array, row: int, col: int, player: int, visited):
	# Win conditions for each player
	if player == 1 and row == len(matrix) - 1:  # Green reached bottom
		return true
	if player == 2 and col == len(matrix[0]) - 1:  # Red reached right edge
		return true

	visited[Vector2(row, col)] = true  # Mark current position as visited

	# Possible movement directions (4-way connectivity)
	var directions = [
		Vector2(1, 0),   # Down
		Vector2(0, 1),   # Right
		Vector2(-1, 0),  # Up
		Vector2(0, -1)   # Left
	]

	# Check all adjacent cells
	for direction in directions:
		var new_row = row + int(direction.x)
		var new_col = col + int(direction.y)
		
		# Check if new position is valid and unvisited
		if (new_row >= 0 and new_row < len(matrix) and 
			new_col >= 0 and new_col < len(matrix[0])):
			var new_pos = Vector2(new_row, new_col)
			if not visited.has(new_pos) and matrix[new_row][new_col] == player:
				if dfs(matrix, new_row, new_col, player, visited):
					return true  # Found winning path

	return false  # No winning path found from this position
