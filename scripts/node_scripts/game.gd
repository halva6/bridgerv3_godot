extends Node

#-------------- type of gamemode -------------------
@onready var _is_multiplayer: bool = GlobalGame.get_local_multiplayer() # Toggle between multiplayer vs AI mode
@onready var _start_player: String = GlobalGame.get_start_player() # Which player starts the game

#-------------- signals -------------------
signal update_player_label(player: String)
signal update_visit_label(visits: String)
signal set_computers_bridge(matrix_position: Vector2)
signal set_win_ui(winner: String)

#-------------- for computer ai ------------------
var _computer_thread: Thread
var _best_knot_properties: Array

#-------------- for resetting moves ------------------
var _game_stack: Array = []
var _player_stack: Array = []

@onready var _game_board_size: int = GlobalGame.get_game_board_size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !_is_multiplayer and _start_player == "red":
		_start_player = "computer"
	GlobalGame.set_current_player(_start_player)
	emit_signal("update_player_label", _start_player)
	
	_computer_thread = Thread.new()
	_game_stack.append(GlobalGame.get_start_matrix().duplicate(true))
	_player_stack.append(_start_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_n_move: Array # Will store [current_player, finish_turn]
	
	# Determine players based on game mode
	if (_is_multiplayer):
		player_n_move = _switch_player("green", "red", GlobalGame.get_current_player(), GlobalGame.get_finish_turn())
	else:
		player_n_move = _switch_player("green", "computer", GlobalGame.get_current_player(), GlobalGame.get_finish_turn())
		if (player_n_move[0] == "computer"):
			#Since not the entire array is copied in this case, 
			#but only the pointer to the array is passed, 
			#you can change the array without returning it in the other function, 
			#even though that is not the corresponding scope 
			#a blessing and a curse at the same time
			_manage_computer_ai(player_n_move)
		
	_manage_reset(player_n_move)
	
	# Update global game state
	GlobalGame.set_current_player(player_n_move[0])
	GlobalGame.set_finish_turn(player_n_move[1])

func _manage_computer_ai(player_n_move: Array) -> void:
	if !_computer_thread.is_started():
		var transform_matrix: Array = _transform_matrix(GlobalGame.get_matrix().duplicate(true))
		_computer_thread.start(_async_computer_calculation.bind(transform_matrix, GlobalGame.get_simulation_time()))
		
	if !_computer_thread.is_alive():
		emit_signal("set_computers_bridge", _best_knot_properties[0])
		emit_signal("update_visit_label", str(_best_knot_properties[1]))
		player_n_move[1] = true
		_computer_thread.wait_to_finish()


func _manage_reset(player_n_move: Array) -> void:
	if (GlobalGame.is_reset() and player_n_move[0] != "computer"):
		GlobalGame.set_reset(false)
		if _is_multiplayer and !_game_stack.is_empty():
			player_n_move[0] = _reset_move()
			emit_signal("update_player_label", player_n_move[0])
		elif !_is_multiplayer and len(_game_stack) > 1:
			_reset_move()
			player_n_move[0] = _reset_move()
			emit_signal("update_player_label", player_n_move[0])
		else:
			print("[ERROR] cant reset to the last move(s)")

func _async_computer_calculation(matrix: Array, simulation_time: int) -> void:
	var knots: Knots = Knots.new()
	_best_knot_properties = knots.monte_carlo_tree_search(matrix, simulation_time, _game_board_size)
	knots.free()

func _finde_diffrence(matrix1: Array, matrix2: Array) -> Vector2:
	for i in range(len(matrix1)):
		for j in range(len(matrix1[i])):
			if matrix2[j][i] != matrix1[j][i]:
				return Vector2(i, j)
			
	print("[ERROR] no diffrences in matrixes")
	return Vector2(-100, -100)

func _reset_move() -> String:
	# resets to an older game state - the game states are saved in a stack and popped when reset
	_game_stack.pop_back() # stack with the scores
	_player_stack.pop_back() # stack with the order of the players who were currently playing in order to be able to assign a player to each score
	var pushed_matrix: Array = _game_stack[-1]
	var current_matrix: Array = GlobalGame.get_matrix()
	
#	LocalDebug.print_matrix(pushed_matrix)
#	LocalDebug.print_matrix(current_matrix)
	
	var diffrence: Vector2 = _finde_diffrence(pushed_matrix, current_matrix) * 32
	var player_name: String = _player_stack[-1]
	
	%Spawner.get_node(player_name + "bridge_" + str(int(diffrence.x)) + "_" + str(int(diffrence.y))).queue_free()
	
	GlobalGame.set_matrix(pushed_matrix.duplicate(true))
	
	return player_name

# Handles player switching logic
# Parameters:
#   player1: First player identifier (String)
#   player2: Second player identifier (String)
#   current_player: Currently active player (String)
#   finish_turn: Whether the current turn is complete (bool)
# Returns: Array containing [new_current_player, new_finish_turn]
func _switch_player(player1: String, player2: String, current_player: String, finish_turn: bool) -> Array:
	if (finish_turn):
		if (!_game_over()): # Only switch if game isn't over
			if (current_player == player1):
				current_player = player2
				emit_signal("update_player_label", current_player)
				finish_turn = false
				_game_stack.append(GlobalGame.get_matrix().duplicate(true))
				_player_stack.append(current_player)
			else:
				current_player = player1
				emit_signal("update_player_label", current_player)
				finish_turn = false
				_game_stack.append(GlobalGame.get_matrix().duplicate(true))
				_player_stack.append(current_player)
		else:
			return ["", false] # Empty string indicates game over
			
	return [current_player, finish_turn]

func _manage_game_over() -> void:
	print("[DEBUG] " + GlobalGame.get_current_player() + "wins the game")
	emit_signal("set_win_ui", GlobalGame.get_current_player())
	GlobalAudio.emit_signal("stop_game_music")
	GlobalAudio.emit_signal("play_win_sound")

# Determines if the game has been won
# Returns: bool - true if a player has won, false otherwise
func _game_over() -> bool:
	# Create a transformed copy of the game matrix for analysis
	var transform_matrix: Array = _transform_matrix(GlobalGame.get_matrix().duplicate(true))
	
	# Check for both possible winners
	if _check_winner(transform_matrix, 1) or _check_winner(transform_matrix, 2): # Player 1 (green)
		_manage_game_over()
		return true
		
	return false

# Normalizes the game matrix values for win checking
# Parameters:
#   matrix: The game board matrix to transform
# Returns: Transformed matrix where 3→1 and 4→2
func _transform_matrix(matrix: Array) -> Array:
	for i in range(len(matrix)):
		for j in range(len(matrix[i])):
			if (matrix[i][j] == 3):
				matrix[i][j] = 1 # Convert type 3 to player 1
			elif (matrix[i][j] == 4):
				matrix[i][j] = 2 # Convert type 4 to player 2
	return matrix

func _check_winner(state: Array, player: int) -> bool:
	var visited: Dictionary = {}
	var stack: Array = []
	var directions: Array[Vector2] = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
	
	# Startpunkte setzen
	var starts := range(_game_board_size) if player == 1 else range(_game_board_size)
	for i: int in starts:
		var r := 0 if player == 1 else i
		var c := i if player == 1 else 0
		if state[r][c] == player and not visited.has(Vector2(r, c)):
			stack.append(Vector2(r, c))
		
		while stack.size() > 0:
			var current: Vector2 = stack.pop_back()
			if visited.has(current):
				continue
			visited[current] = true
			
			var cr: int = int(current.x)
			var cc: int = int(current.y)
			
			# Gewinnbedingungen prüfen
			if player == 1 and cr == _game_board_size - 1:
				return true
			if player == 2 and cc == _game_board_size - 1:
				return true
			
			# Nachbarn hinzufügen
			for direction in directions:
				var nr: int = cr + int(direction.x)
				var nc: int = cc + int(direction.y)
				var neighbor: Vector2 = Vector2(nr, nc)
				if nr >= 0 and nr < _game_board_size and nc >= 0 and nc < _game_board_size and not visited.has(neighbor):
					if state[nr][nc] == player:
						stack.append(neighbor)
	
	return false
