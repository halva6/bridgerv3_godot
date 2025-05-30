extends Node
class_name Knots

const PLAYER_HUMAN: int = 1
const PLAYER_AI: int = 2
var _game_board_size: int = 13

class Knot:
	var state: Array
	var parent: Knot = null
	var children: Array[Knot] = []
	var visits: int = 0
	var wins: int = 0
	var player: int
	var untried_moves: Array[Vector2]
	var game_board_size: int

	func _init(state: Array, game_board_size: int, parent: Knot = null, player: int = PLAYER_HUMAN) -> void:
		self.state = state
		self.parent = parent
		self.player = player
		self.game_board_size = game_board_size
		self.untried_moves = _get_legal_moves()

	func _get_legal_moves() -> Array[Vector2]:
		var moves: Array[Vector2] = []
		for r in range(game_board_size):
			for c in range(game_board_size):
				if state[r][c] == 0:
					moves.append(Vector2(r, c))
		return moves

	func expand() -> Knot:
		var move: Vector2 = untried_moves.pop_back()
		var new_state: Array = []
		for row: Array in state:
			new_state.append(row.duplicate(true))
		new_state[move.x][move.y] = next_player()
		var child_node: Knot = Knot.new(new_state, game_board_size, self, next_player())
		children.append(child_node)
		return child_node

	func next_player() -> int:
		return PLAYER_AI if player == PLAYER_HUMAN else PLAYER_HUMAN

	func fully_expanded() -> bool:
		return untried_moves.size() == 0

	func best_uct() -> Knot:
		var log_N_parent: float = log(visits)
		var best_node: Knot = null
		var best_score: float = - INF
		for child: Knot in children:
			var uct_score: float = child.wins / float(child.visits) + sqrt(2 * log_N_parent / float(child.visits)) if child.visits > 0 else INF
			if uct_score > best_score:
				best_score = uct_score
				best_node = child
		return best_node

	func best_child() -> Knot:
		var best_node: Knot = null
		var most_visits: int = -1
		for child: Knot in children:
			if child.visits > most_visits:
				most_visits = child.visits
				best_node = child
		return best_node

# Helper function for recursively deleting the tree - otherwise memory leaks will occur
func _delete_tree(node: Knot) -> void:
	if node == null:
		return
	for child in node.children:
		_delete_tree(child)
	# Remove references
	node.parent = null
	node.children.clear()
	# There is no destructor in GDScript, so deleting the references is sufficient
	# The object is then removed by the garbage collector

func _check_win(matrix: Array, player: int, do_pre_search: bool) -> bool:
	# Possible movement directions (4-way connectivity)
	var directions: Array = [
			Vector2(1, 0), # Down
			Vector2(0, 1), # Right
			Vector2(-1, 0), # Up
			Vector2(0, -1) # Left
		]
	if player == 1:
		if do_pre_search:
			if !_pre_check_win(matrix, player):
				return false
		for start_col in range(len(matrix[0])):
			if matrix[0][start_col] == player:
				if _dfs(matrix, 0, start_col, player, {}, directions):
					return true
	elif player == 2:
		if do_pre_search:
			if !_pre_check_win(matrix, player):
				return false
		for start_row in range(len(matrix)):
			if matrix[start_row][0] == player:
				if _dfs(matrix, start_row, 0, player, {}, directions):
					return true
	return false

func _pre_check_win(matrix: Array, player: int) -> bool:
	if player == 1:
		for i in range(1, len(matrix), 2):
			if !matrix[i].has(player):
				return false
	elif player == 2:
		var num_cols: int = matrix[0].size()
		for col in range(1, num_cols, 2):
			var found_two: bool = false
			for row: Array in matrix:
				if row[col] == 2:
					found_two = true
					break
			if not found_two:
				return false
	return true

func _dfs(matrix: Array, row: int, col: int, player: int, visited: Dictionary, directions: Array) -> bool:
	if player == 1 and row == _game_board_size - 1:
		return true
	if player == 2 and col == _game_board_size - 1:
		return true

	visited[Vector2(row, col)] = true
	for direction: Vector2 in directions:
		var new_row: int = row + int(direction.x)
		var new_col: int = col + int(direction.y)
		if (new_row >= 0 and new_row < _game_board_size and new_col >= 0 and new_col < _game_board_size):
			var new_pos: Vector2 = Vector2(new_row, new_col)
			if not visited.has(new_pos) and matrix[new_row][new_col] == player:
				if _dfs(matrix, new_row, new_col, player, visited, directions):
					return true
	return false

func _simulate_random_game(state: Array, player: int) -> int:
	var current_player: int = player
	while true:
		var moves: Array[Vector2] = []
		for r in range(_game_board_size):
			for c in range(_game_board_size):
				if state[r][c] == 0:
					moves.append(Vector2(r, c))
		if moves.is_empty():
			break
		elif _check_win(state, PLAYER_AI, true):
			return -1
		elif _check_win(state, PLAYER_HUMAN, true):
			return 1
		var move: Vector2 = moves[randi() % moves.size()]
		state[move.x][move.y] = current_player
		current_player = PLAYER_AI if current_player == PLAYER_HUMAN else PLAYER_HUMAN

	if _check_win(state, PLAYER_HUMAN, false):
		return 1
	elif _check_win(state, PLAYER_AI, false):
		return -1
	return 0

func _backpropagate(node: Knot, result: int) -> void:
	while node != null:
		node.visits += 1
		if (node.player == PLAYER_HUMAN and result == 1) or (node.player == PLAYER_AI and result == -1):
			node.wins += 1
		node = node.parent

# see the more detailed code documentation in the README.md
func monte_carlo_tree_search(root_state: Array, simulation_time: int, board_size: int) -> Array:
	self._game_board_size = board_size
	var root: Knot = Knot.new(root_state, board_size)
	var start_time: float = Time.get_unix_time_from_system()
	while Time.get_unix_time_from_system() - start_time < simulation_time:
		var node: Knot = root
		while node.fully_expanded() and not node.children.is_empty():
			node = node.best_uct()
		if not node.untried_moves.is_empty():
			node = node.expand()
		var result: int = _simulate_random_game(node.state.duplicate(true), node.player)
		_backpropagate(node, result)
	
	var visits: int = root.visits
	print("[DEBUG] Visits: " + str(visits))
	
	var best_child: Knot = root.best_child()
	# Find the train that leads to the best child
	var move: Vector2 = _find_move(root.state.duplicate(true), best_child.state.duplicate(true))
	# Delete the entire tree to free memory
	_delete_tree(root)
	return [move, visits]

func _find_move(parent_state: Array, child_state: Array) -> Vector2:
	for i in range(len(parent_state)):
		for j in range(len(parent_state[i])):
			if child_state[j][i] != parent_state[j][i]:
				return Vector2(i, j)
			
	print("[ERROR] no diffrences in matrixes")
	return Vector2(-1, -1)

# for evaluating the runtime complexity and speed of the algorithms
func _write_to_csv(file_path: String, data: Array[String]) -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE_READ)

	for row: String in data:
		file.store_line(row)
	file.close()
