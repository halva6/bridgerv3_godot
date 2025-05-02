class_name BetBestMove2

const SIMULATIONS = 5000
const PLAYER_HUMAN = 1
const PLAYER_AI = 2
const SIZE = 11

func get_best_move(board: Array, player: int = PLAYER_AI) -> Vector2:
	var root_state = board.duplicate(true)
	var root_player = player
	var wins = {}
	var plays = {}
	
	for i in SIMULATIONS:
		var state = duplicate_matrix(root_state)
		var visited_states = []
		var current_player = root_player
		var expand = true

		# Playout phase
		while true:
			var moves = get_valid_moves(state)
			if moves.size() == 0:
				break

			# Heuristik: zufällig aus gültigen Zügen
			var move = moves[randi() % moves.size()]
			state = play_move(state, move, current_player)
			var state_key = matrix_to_key(state)

			if expand and !plays.has(state_key):
				expand = false
				plays[state_key] = 0
				wins[state_key] = 0
			visited_states.append(state_key)

			if is_winner(state, current_player):
				break
			current_player = 3 - current_player  # 1 -> 2, 2 -> 1

		# Backpropagation
		var winner = get_winner(state)
		for key in visited_states:
			if !plays.has(key):
				continue
			plays[key] += 1
			if winner == root_player:
				wins[key] += 1

	# Auswahl des besten Zuges
	var best_move = null
	var best_win_rate = -1.0
	for move in get_valid_moves(root_state):
		var next_state = play_move(root_state, move, root_player)
		var key = matrix_to_key(next_state)
		if plays.has(key) and plays[key] > 0:
			var win_rate = float(wins[key]) / plays[key]
			if win_rate > best_win_rate:
				best_win_rate = win_rate
				best_move = move

	return best_move if best_move != null else get_valid_moves(root_state).front()


func get_valid_moves(matrix: Array) -> Array:
	var moves = []
	for y in SIZE:
		for x in SIZE:
			if matrix[y][x] == 0:
				moves.append(Vector2(x, y))
	return moves


func play_move(matrix: Array, move: Vector2, player: int) -> Array:
	var new_matrix = duplicate_matrix(matrix)
	new_matrix[move.y][move.x] = player
	return new_matrix


func duplicate_matrix(matrix: Array) -> Array:
	var copy = []
	for row in matrix:
		copy.append(row.duplicate())
	return copy


func matrix_to_key(matrix: Array) -> String:
	return JSON.stringify(matrix)


func get_winner(matrix: Array) -> int:
	if is_winner(matrix, PLAYER_HUMAN):
		return PLAYER_HUMAN
	if is_winner(matrix, PLAYER_AI):
		return PLAYER_AI
	return 0


func is_winner(matrix: Array, player: int) -> bool:
	var visited = {}
	var stack = []

	if player == 1:
		for x in SIZE:
			if matrix[0][x] == 1:
				stack.append(Vector2(x, 0))
	else:
		for y in SIZE:
			if matrix[y][0] == 2:
				stack.append(Vector2(0, y))

	while stack.size() > 0:
		var pos = stack.pop_back()
		var x = int(pos.x)
		var y = int(pos.y)

		if visited.has(str(x, ",", y)):
			continue
		visited[str(x, ",", y)] = true

		if player == 1 and y == SIZE - 1:
			return true
		if player == 2 and x == SIZE - 1:
			return true

		for dir in [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1),
					Vector2(1,1), Vector2(-1,-1)]:
			var nx = x + int(dir.x)
			var ny = y + int(dir.y)
			if nx >= 0 and ny >= 0 and nx < SIZE and ny < SIZE:
				if matrix[ny][nx] == player:
					stack.append(Vector2(nx, ny))
	return false
