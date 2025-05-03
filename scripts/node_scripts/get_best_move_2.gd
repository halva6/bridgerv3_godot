#extends Node
#
#class_name GetBestMove2
#
#const ROWS: int = 13
#const COLS: int = 13
#
##------- Time -------
#var running: bool = true
#var elapsed: float = 0.0
#const TIME_LIMIT: float = 5.0
#
#class Knot:
	#var state: Array
	#var parent: Knot
	#var children: Array
	#var visits: float
	#var wins: int
	#var player: int
	#var untried_moves
	#
	#func _init(state: Array, parent:Knot = null, player:int = 2) -> void:
		#self.state = state
		#self.parent = parent
		#self.children = []
		#self.visits = 0
		#self.wins = 0
		#self.player = player
		#self.untried_moves = self.get_legal_moves()
	#
	#func get_legal_moves() -> Array:
		#var legal_moves: Array = []
		#for r in range(ROWS):
			#for c in range(COLS):
				#if self.state[r][c] == 0:
					#legal_moves.append([r,c])
					#return legal_moves
		#return legal_moves
	#
	#func best_uct():
		#var log_N_parent = log(visits)
		#var highest_utc: float = 0 # mögliche Fehlerstelle
		#var highest_utc_child: Knot
		#
		#for child in self.children:
			#if uct(child,log_N_parent) > highest_utc:
				#highest_utc_child = child
	#
	#func uct(n: Knot, log_N_parent) -> float:
		#if n.visits == 0:
			#return n.wins / n.visits + sqrt(2*log_N_parent / n.visits)
		#else:
			#return INF
	#
	#func expand():
		#var move = self.untried_moves.pop()
#
#func monte_carlo_tree_search(root: Knot):
	#while running:
		#var knot: Knot = root
		#while knot.fully_expanded() and knot.children:
			#knot = knot.best_uct()
		#if knot.untried_moves:
			#knot = knot.expand()
#
#
#func _process(delta):
	#if running:
		#elapsed += delta
		#if ! elapsed < TIME_LIMIT:
			#running = false
