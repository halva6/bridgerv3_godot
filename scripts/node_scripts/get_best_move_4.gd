class_name Knoten

const ROWS = 13
const COLS = 13
const PLAYER_HUMAN = 2
const PLAYER_AI = 1
const TIME_LIMIT = 5.0

class Knote:
	var state: Array
	var parent: Knote
	var children: Array
	var visits: int
	var wins: int
	var player: int
	var untried_moves: Array

	func _init(state: Array, parent: Knote = null, player: int = PLAYER_AI) -> void:
		self.state = state
		self.parent = parent
		self.children = []
		self.visits = 0
		self.wins = 0
		self.player = player
		self.untried_moves = get_legal_moves()

	func get_legal_moves() -> Array:
		var moves = []
		for r in range(ROWS):
			for c in range(COLS):
				if state[r][c] == 0:
					moves.append(Vector2(r, c))
		return moves

	func expand() -> Knote:
		var move = untried_moves.pop_back()
		var new_state = []
		for row in state:
			new_state.append(row.duplicate())
		new_state[move.x][move.y] = next_player()
		var child_node = Knote.new(new_state, self, next_player())
		children.append(child_node)
		return child_node

	func next_player() -> int:
		return PLAYER_HUMAN if player == PLAYER_AI else PLAYER_AI

	func fully_expanded() -> bool:
		return untried_moves.size() == 0

	func best_uct() -> Knote:
		var log_N_parent = log(visits)
		var best_node = null
		var best_uct = -INF

		for child in children:
			var uct_value = 0.0
			if child.visits > 0:
				uct_value = child.wins / child.visits + sqrt(2 * log_N_parent / child.visits)
			else:
				uct_value = INF

			if uct_value > best_uct:
				best_uct = uct_value
				best_node = child

		return best_node

	func best_child() -> Knote:
		var best_node = null
		var most_visits = -INF

		for child in children:
			if child.visits > most_visits:
				most_visits = child.visits
				best_node = child

		return best_node

func check_win(matrix: Array, player: int):
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

func simulate_random_game(state: Array, player: int) -> int:
	var current_player = player
	while true:
		var moves = []
		for r in range(ROWS):
			for c in range(COLS):
				if state[r][c] == 0:
					moves.append(Vector2(r, c))
		if moves.is_empty() or check_win(state, PLAYER_HUMAN) or check_win(state, PLAYER_AI):
			break
		var move = moves[randi() % moves.size()]
		state[move.x][move.y] = current_player
		current_player = PLAYER_HUMAN if current_player == PLAYER_AI else PLAYER_AI
	if check_win(state, PLAYER_AI):
		return 1
	elif check_win(state, PLAYER_HUMAN):
		return -1
	return 0

func backpropagate(node: Knote, result: int) -> void:
	while node != null:
		node.visits += 1
		if (node.player == PLAYER_AI and result == 1) or (node.player == PLAYER_HUMAN and result == -1):
			node.wins += 1
		node = node.parent

func monte_carlo_tree_search(root: Knote) -> Knote:
	var start_time: float = Time.get_unix_time_from_system()
	while Time.get_unix_time_from_system() - start_time < TIME_LIMIT:
		var node = root
		while node.fully_expanded() and node.children.size() > 0:
			node = node.best_uct()
		if node.untried_moves.size() > 0:
			node = node.expand()
		var result = simulate_random_game(node.state, node.player)
		backpropagate(node, result)
	print("[DEBUG] Visits: " + str(root.visits))
	return root.best_child()
