class_name MatrixLogic

static func find_differences(matrix1: Array, matrix2: Array) -> Array:
	if matrix1.size() != matrix2.size() or matrix1[0].size() != matrix2[0].size():
		push_error("Matrices must have the same dimensions")
		return []
	
	var differences := []
	
	for i in range(matrix1.size()):
		for j in range(matrix1[0].size()):
			if matrix1[i][j] != matrix2[i][j]:
				differences.append(Vector2i(i, j))
	
	return differences

static func get_best_mcts(board: Array, simulations_number: int) -> Vector2i:
	if not check_winner(board, 1) and not check_winner(board, 2):
		var mcts = MCTS.new(board, 1)
		var move_board = mcts.best_move(simulations_number)
		
		var differences = find_differences(board, move_board)
		if differences.size() > 0:
			var first_difference = differences[0]
			return first_difference
	
	return Vector2i(-1, -1)

static func check_winner(board: Array, player: int) -> bool:
	if player == 1:
		for start_col in range(board[0].size()):
			if board[0][start_col] == player:
				if dfs(board, 0, start_col, player, {}):
					return true
	elif player == 2:
		for start_row in range(board.size()):
			if board[start_row][0] == player:
				if dfs(board, start_row, 0, player, {}):
					return true
	return false

static func dfs(board: Array, row: int, col: int, player: int, visited: Dictionary) -> bool:
	if player == 1 and row == board.size() - 1:
		return true
	if player == 2 and col == board[0].size() - 1:
		return true
	
	var directions = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]
	visited[Vector2i(row, col)] = true
	
	for direction in directions:
		var new_row = row + direction.x
		var new_col = col + direction.y
		if new_row >= 0 and new_row < board.size() and new_col >= 0 and new_col < board[0].size():
			if not visited.has(Vector2i(new_row, new_col)) and board[new_row][new_col] == player:
				if dfs(board, new_row, new_col, player, visited):
					return true
	return false

class MCTSNode:
	var state: Array
	var parent = null
	var children := []
	var wins := 0
	var visits := 0
	
	func _init(state: Array, parent = null):
		self.state = state
		self.parent = parent
	
	func get_valid_moves(board: Array, player: int) -> Array:
		var valid_moves := []
		for i in range(board.size()):
			for j in range(board[0].size()):
				if board[i][j] == 0:
					valid_moves.append(Vector2i(i, j))
		return valid_moves
	
	func is_fully_expanded(player: int) -> bool:
		return children.size() == get_valid_moves(state, player).size()
	
	func best_child(exploration_weight: float = 1.41) -> Object:
		var best_score := -INF
		var best_child = null
		for child in children:
			var uct_value = float(child.wins) / float(child.visits) + exploration_weight * sqrt(2 * log(float(visits)) / float(child.visits))
			if uct_value > best_score:
				best_score = uct_value
				best_child = child
		return best_child

class MCTS:
	var root: MCTSNode
	var player: int
	
	func _init(state: Array, player: int):
		root = MCTSNode.new(state)
		self.player = player
	
	func select(node: MCTSNode) -> MCTSNode:
		var current_node = node
		while current_node.is_fully_expanded(player):
			current_node = current_node.best_child()
		return current_node
	
	func expand(node: MCTSNode) -> MCTSNode:
		var valid_moves = get_valid_moves(node.state, player)
		var unexpanded_moves = []
		
		for move in valid_moves:
			var is_expanded = false
			for child in node.children:
				if are_states_equal(child.state, make_move(node.state, move, player)):
					is_expanded = true
					break
			if not is_expanded:
				unexpanded_moves.append(move)
		
		if unexpanded_moves.size() == 0:
			return node
		
		var move_to_expand = unexpanded_moves[0]
		var new_state = make_move(node.state, move_to_expand, player)
		var child_node = MCTSNode.new(new_state, node)
		node.children.append(child_node)
		return child_node
	
	func are_states_equal(a: Array, b: Array) -> bool:
		if a.size() != b.size() or a[0].size() != b[0].size():
			return false
		
		for i in range(a.size()):
			for j in range(a[0].size()):
				if a[i][j] != b[i][j]:
					return false
		return true
	
	func simulate(node: MCTSNode) -> int:
		var current_state = duplicate_state(node.state)
		var current_player = player
		var random = RandomNumberGenerator.new()
		random.randomize()
		
		while not MatrixLogic.check_winner(current_state, 1) and not MatrixLogic.check_winner(current_state, 2) and get_valid_moves(current_state, current_player).size() > 0:
			var moves = get_valid_moves(current_state, current_player)
			var move = moves[random.randi() % moves.size()]
			current_state = make_move(current_state, move, current_player)
			current_player = 3 - current_player
		
		if MatrixLogic.check_winner(current_state, player):
			return 1
		elif MatrixLogic.check_winner(current_state, 3 - player):
			return -1
		else:
			return 0
	
	func backpropagate(node: MCTSNode, result: int):
		var current_node = node
		while current_node != null:
			current_node.visits += 1
			current_node.wins += result
			current_node = current_node.parent
	
	func best_move(simulations_number: int) -> Array:
		for i in range(simulations_number):
			var node = select(root)
			if not MatrixLogic.check_winner(node.state, 1) and not MatrixLogic.check_winner(node.state, 2) and get_valid_moves(node.state, player).size() > 0:
				node = expand(node)
			var result = simulate(node)
			backpropagate(node, result)
		return root.best_child(0.0).state
	
	func get_valid_moves(board: Array, player: int) -> Array:
		var valid_moves := []
		for i in range(board.size()):
			for j in range(board[0].size()):
				if board[i][j] == 0:
					valid_moves.append(Vector2i(i, j))
		return valid_moves
	
	func make_move(board: Array, move: Vector2i, player: int) -> Array:
		var new_board = duplicate_state(board)
		new_board[move.x][move.y] = player
		return new_board
	
	func duplicate_state(state: Array) -> Array:
		var new_state = []
		for i in range(state.size()):
			new_state.append([])
			for j in range(state[0].size()):
				new_state[i].append(state[i][j])
		return new_state
