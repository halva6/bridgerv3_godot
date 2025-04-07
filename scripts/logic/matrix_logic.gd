extends Node


func check_winner(board: Array, player: int) -> bool:
	var rows = board.size()
	var cols = board[0].size()

	var visited := {}

	if player == 1:
		for col in cols:
			if board[0][col] == player:
				if dfs(board, 0, col, player, visited):
					return true

	elif player == 2:
		for row in rows:
			if board[row][0] == player:
				if dfs(board, row, 0, player, visited):
					return true

	return false


func dfs(board: Array, row: int, col: int, player: int, visited: Dictionary) -> bool:
	var rows = board.size()
	var cols = board[0].size()

	if player == 1 and row == rows - 1:
		return true
	if player == 2 and col == cols - 1:
		return true

	var key = Vector2i(row, col)
	visited[key] = true

	var directions = [
		Vector2i(1, 0),
		Vector2i(0, 1),
		Vector2i(-1, 0),
		Vector2i(0, -1)
	]

	for dir in directions:
		var new_row = row + dir.x
		var new_col = col + dir.y

		if new_row >= 0 and new_row < rows and new_col >= 0 and new_col < cols:
			var next_key = Vector2i(new_row, new_col)
			if not visited.has(next_key) and board[new_row][new_col] == player:
				if dfs(board, new_row, new_col, player, visited):
					return true

	return false
