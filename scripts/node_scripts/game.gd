extends Node

# Exported variables (editable in Godot editor)
@onready var is_multiplayer: bool = GlobalGame.get_local_multiplayer()  # Toggle between multiplayer vs AI mode
@export var start_player: String = "green"  # Which player starts the game

#-------------- signals -------------------
signal update_player_label(player: String)
signal update_visit_label(visits: String)
signal set_computers_bridge(matrix_position: Vector2)
signal set_win_ui(winner: String)

#-------------- for computer ai ------------------
var thread1: Thread
var best_knot: Knots.Knot
var visits: int = 0
var knots: Knots = Knots.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalGame.set_current_player(start_player)
	emit_signal("update_player_label", start_player)
	
	thread1 = Thread.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_n_move: Array  # Will store [current_player, finish_turn]
	
	# Determine players based on game mode
	if(is_multiplayer):
		player_n_move = _switch_player("green", "red", GlobalGame.get_current_player(), GlobalGame.get_finish_turn())
	else:
		player_n_move = _switch_player("green", "computer", GlobalGame.get_current_player(), GlobalGame.get_finish_turn())
		if(player_n_move[0] == "computer"):
			var transform_matrix: Array = _transform_matrix(GlobalGame.get_matrix().duplicate(true))
			if !thread1.is_started():
				var mcts: Knots.Knot = knots.Knot.new(transform_matrix)
				thread1.start(async_computer_calculation.bind(knots,mcts, GlobalGame.get_simulation_time()))
			
			if !thread1.is_alive():
				var matrix_position: Vector2 = finde_diffrence(transform_matrix,best_knot.state)
				emit_signal("set_computers_bridge", matrix_position)
				emit_signal("update_visit_label", str(visits))
				player_n_move[1] = true
				thread1.wait_to_finish()
				

	# Update global game state
	GlobalGame.set_current_player(player_n_move[0])
	GlobalGame.set_finish_turn(player_n_move[1])
	
func async_computer_calculation(knots:Knots, mcts: Knots.Knot, simulation_time:int) -> void:
	best_knot = knots.monte_carlo_tree_search(mcts, simulation_time)
	visits = mcts.visits

func finde_diffrence(matrix1: Array, matrix2:Array) -> Vector2:
	for i in range(len(matrix1)):
		for j in range(len(matrix1[i])):
			if matrix2[j][i] != matrix1[j][i]:
				return Vector2(i,j)
			
	print("[ERROR] no diffrences in matrixes")
	return Vector2(-100,-100)
	

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
		emit_signal("set_win_ui",GlobalGame.get_current_player())
		return true
	elif (check_winner(transform_matrix, 2)):  # Player 2 (red/computer)
		print("red wins")
		emit_signal("set_win_ui", GlobalGame.get_current_player())
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

func check_winner(state: Array, player: int) -> bool:
	var visited: Dictionary = {}
	var stack: Array = []
	var directions: Array[Vector2] = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
	
	# Startpunkte setzen
	var starts := range(13) if player == 1 else range(13)
	for i: int in starts:
		var r := 0 if player == 1 else i
		var c := i if player == 1 else 0
		if state[r][c] == player and not visited.has(Vector2(r, c)):
			stack.append(Vector2(r, c))
		
		while stack.size() > 0:
			var current:Vector2 = stack.pop_back()
			if visited.has(current):
				continue
			visited[current] = true
			
			var cr: int = int(current.x)
			var cc: int = int(current.y)
			
			# Gewinnbedingungen prüfen
			if player == 1 and cr == 13 - 1:
				return true
			if player == 2 and cc == 13 - 1:
				return true
			
			# Nachbarn hinzufügen
			for direction in directions:
				var nr: int = cr + int(direction.x)
				var nc: int = cc + int(direction.y)
				var neighbor: Vector2 = Vector2(nr, nc)
				if nr >= 0 and nr < 13 and nc >= 0 and nc < 13 and not visited.has(neighbor):
					if state[nr][nc] == player:
						stack.append(neighbor)
	
	return false
