class_name GetBestMove

var matrix = GlobalGame.get_matrix()

const PLAYER = 1
const COMPUTER = 2
const INF = 999999

func is_winning_path(player):
	var visited = {}
	
	if player == PLAYER:
		for x in range(matrix.size()):
			if matrix[0][x] == PLAYER:
				if dfs(0, x, PLAYER, visited):
					return true
	elif player == COMPUTER:
		for y in range(matrix[0].size()):
			if matrix[y][0] == COMPUTER:
				if dfs(y, 0, COMPUTER, visited):
					return true
	return false

func dfs(row, col, player, visited):
	if player == PLAYER and row == matrix.size() - 1:
		return true
	if player == COMPUTER and col == matrix[0].size() - 1:
		return true

	visited[[row, col]] = true
	
	for neighbor in get_neighbors(row, col):
		var n_row = neighbor[0]
		var n_col = neighbor[1]
		
		if not visited.has([n_row, n_col]) and matrix[n_row][n_col] == player:
			if dfs(n_row, n_col, player, visited):
				return true
	return false

func get_neighbors(row, col):
	var directions = [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [1, 1], [-1, 1], [1, -1]]
	var neighbors = []

	for direction in directions:
		var n_row = row + direction[0]
		var n_col = col + direction[1]
		
		if n_row >= 0 and n_row < matrix.size() and n_col >= 0 and n_col < matrix[0].size():
			neighbors.append([n_row, n_col])
	return neighbors

func minimax(depth, is_maximizing, alpha, beta):
	if is_winning_path(COMPUTER):
		return INF
	elif is_winning_path(PLAYER):
		return -INF
	elif depth == 0 or not has_moves():
		return evaluate_board()

	if is_maximizing:
		var max_eval = -INF
		for move in get_valid_moves():
			make_move(move, COMPUTER)
			var eval = minimax(depth - 1, false, alpha, beta)
			undo_move(move)
			max_eval = max(max_eval, eval)
			alpha = max(alpha, eval)
			if beta <= alpha:
				break
		return max_eval
	else:
		var min_eval = INF
		for move in get_valid_moves():
			make_move(move, PLAYER)
			var eval = minimax(depth - 1, true, alpha, beta)
			undo_move(move)
			min_eval = min(min_eval, eval)
			beta = min(beta, eval)
			if beta <= alpha:
				break
		return min_eval

func get_valid_moves():
	var moves = []
	for y in range(matrix.size()):
		for x in range(matrix[y].size()):
			if matrix[y][x] == 0:
				moves.append([y, x])
	return moves

func make_move(move, player):
	matrix[move[0]][move[1]] = player

func undo_move(move):
	matrix[move[0]][move[1]] = 0

func evaluate_board():
	# Heuristic for evaluating the board state
	return 0

func has_moves():
	for row in matrix:
		if 0 in row:
			return true
	return false

func best_move():
	var best_val = -INF
	var best_move = null

	for move in get_valid_moves():
		make_move(move, COMPUTER)
		var move_val = minimax(3, false, -INF, INF)
		undo_move(move)

		if move_val > best_val:
			best_val = move_val
			best_move = move
	return best_move
