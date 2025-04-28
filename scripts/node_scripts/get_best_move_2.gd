class_name MCTS

var exploration_constant = 1.41  # Typischer Wert für UCB1
var simulation_count = 2000      # Anzahl der Simulationen pro Zug

# Hauptfunktion, die den besten Zug findet
func find_best_move(board: Array, player: int) -> Vector2:
	var root_node = MCTSNode.new(board, null, null, 3 - player, exploration_constant)  # 3-player wechselt den Spieler (1->2, 2->1)
	
	for i in range(simulation_count):
		var node = select_node(root_node)
		var result = simulate(node)
		backpropagate(node, result)
	
	return root_node.get_best_move()

# Node-Klasse für den MCTS-Baum
class MCTSNode:
	var board: Array
	var parent: MCTSNode
	var move
	var player: int  # Spieler, der diesen Zug gemacht hat
	var children: Array = []
	var wins: float = 0
	var visits: int = 0
	var untried_moves: Array = []
	var exploration_constant
	
	func _init(p_board: Array, p_parent: MCTSNode, p_move, p_player: int, ec):
		board = p_board.duplicate(true)  # Tiefe Kopie des Boards
		parent = p_parent
		move = p_move
		player = p_player
		self.exploration_constant = ec
		
		# Finde alle möglichen Züge (Positionen mit 0)
		for y in range(board.size()):
			for x in range(board[y].size()):
				if board[y][x] == 0:
					untried_moves.append(Vector2(x, y))
	
	# Wähle den besten Kindknoten basierend auf UCB1
	func select_child() -> MCTSNode:
		var selected_child = null
		var best_score = -INF
		
		for child in children:
			var score = child.get_ucb1(exploration_constant)
			if score > best_score:
				best_score = score
				selected_child = child
		
		return selected_child
	
	# Erweitere den Baum um einen neuen Knoten
	func expand() -> MCTSNode:
		if untried_moves.size() == 0:
			return null
		
		var move = untried_moves.pop_front()
		var new_board = board.duplicate(true)
		new_board[move.y][move.x] = 3 - player  # Spieler wechseln
		
		var new_node = MCTSNode.new(new_board, self, move, 3 - player, exploration_constant)
		children.append(new_node)
		return new_node
	
	# Berechne UCB1-Wert für diesen Knoten
	func get_ucb1(exploration: float) -> float:
		if visits == 0:
			return INF
		return (wins / visits) + exploration * sqrt(log(parent.visits) / visits)
	
	# Hole den besten Zug basierend auf Besuchsanzahlen
	func get_best_move() -> Vector2:
		var best_move = null
		var most_visits = -1
		
		for child in children:
			if child.visits > most_visits:
				most_visits = child.visits
				best_move = child.move
		
		return best_move

# Phase 1: Auswahl - Wähle einen Knoten zur Erweiterung
func select_node(node: MCTSNode) -> MCTSNode:
	while not is_terminal(node.board):
		if node.untried_moves.size() > 0:
			return node.expand()
		else:
			node = node.select_child()
	return node

# Phase 2: Simulation - Simuliere ein zufälliges Spiel bis zum Ende
func simulate(node: MCTSNode) -> int:
	var sim_board = node.board.duplicate(true)
	var current_player = 3 - node.player  # Spieler wechseln
	
	while not is_terminal(sim_board):
		var moves = get_available_moves(sim_board)
		if moves.size() == 0:
			break  # Unentschieden
		
		var random_move = moves[randi() % moves.size()]
		sim_board[random_move.y][random_move.x] = current_player
		current_player = 3 - current_player
	
	return get_game_result(sim_board, node.player)

# Phase 3: Backpropagation - Aktualisiere Statistiken
func backpropagate(node: MCTSNode, result: int):
	while node != null:
		node.visits += 1
		if result == node.player:
			node.wins += 1
		elif result == 0:  # Unentschieden
			node.wins += 0.5
		node = node.parent

# Hilfsfunktionen
func is_terminal(board: Array) -> bool:
	return check_win(board, 1) or check_win(board, 2) or get_available_moves(board).size() == 0

func get_available_moves(board: Array) -> Array:
	var moves = []
	for y in range(board.size()):
		for x in range(board[y].size()):
			if board[y][x] == 0:
				moves.append(Vector2(x, y))
	return moves

func get_game_result(board: Array, player: int) -> int:
	if check_win(board, 1):
		return 1
	elif check_win(board, 2):
		return 2
	return 0  # Unentschieden

# Überprüfe, ob ein Spieler gewonnen hat
func check_win(board: Array, player: int) -> bool:
	if player == 1:
		# Überprüfe vertikale Verbindung für Spieler 1 (von oben nach unten)
		return check_vertical_connection(board, player)
	else:
		# Überprüfe horizontale Verbindung für Spieler 2 (von links nach rechts)
		return check_horizontal_connection(board, player)

func check_vertical_connection(board: Array, player: int) -> bool:
	var visited = []
	for y in range(board.size()):
		visited.append([])
		for x in range(board[y].size()):
			visited[y].append(false)
	
	# Starte von der obersten Reihe
	for x in range(board[0].size()):
		if board[0][x] == player and not visited[0][x]:
			if dfs_vertical(board, visited, x, 0, player):
				return true
	return false

func dfs_vertical(board: Array, visited: Array, x: int, y: int, player: int) -> bool:
	if y < 0 or y >= board.size() or x < 0 or x >= board[0].size():
		return false
	if board[y][x] != player or visited[y][x]:
		return false
	
	visited[y][x] = true
	
	# Wenn wir die unterste Reihe erreicht haben
	if y == board.size() - 1:
		return true
	
	# Überprüfe alle 4 Richtungen
	return (dfs_vertical(board, visited, x+1, y, player) or
			dfs_vertical(board, visited, x-1, y, player) or
			dfs_vertical(board, visited, x, y+1, player) or
			dfs_vertical(board, visited, x, y-1, player))

func check_horizontal_connection(board: Array, player: int) -> bool:
	var visited = []
	for y in range(board.size()):
		visited.append([])
		for x in range(board[y].size()):
			visited[y].append(false)
	
	# Starte von der linkesten Spalte
	for y in range(board.size()):
		if board[y][0] == player and not visited[y][0]:
			if dfs_horizontal(board, visited, 0, y, player):
				return true
	return false

func dfs_horizontal(board: Array, visited: Array, x: int, y: int, player: int) -> bool:
	if y < 0 or y >= board.size() or x < 0 or x >= board[0].size():
		return false
	if board[y][x] != player or visited[y][x]:
		return false
	
	visited[y][x] = true
	
	# Wenn wir die rechte Spalte erreicht haben
	if x == board[0].size() - 1:
		return true
	
	# Überprüfe alle 4 Richtungen
	return (dfs_horizontal(board, visited, x+1, y, player) or
			dfs_horizontal(board, visited, x-1, y, player) or
			dfs_horizontal(board, visited, x, y+1, player) or
			dfs_horizontal(board, visited, x, y-1, player))
