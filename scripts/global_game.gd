extends Node

@onready var _finish_turn: bool = false
var _current_player: String = "green"
var _TILE_DICT: Dictionary = {"greenpier": 1, "redpier": 2, "greenbridge": 3, "redbridge": 4, "tempbridge": 5}
var _count_turn: int = 0

# game board matrix
#   -1 ≙ not placeable space (e.g. walls/corners)
#    0 ≙ placeable space
#    1 ≙ green pier
#    2 ≙ red pier
#    3 ≙ green bridge
#    4 ≙ red bridge
#    5 ≙ temp bridge

@onready var _matrix: Array = [
	[ -1,  1, -1,  1, -1,  1, -1,  1, -1,  1, -1,  1, -1 ], #12
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1, -1,  1, -1,  1, -1,  1, -1,  1, -1,  1, -1 ] 
	]# 12
		
# getter
func get_matrix() -> Array:
	return _matrix

func get_finish_turn() -> bool:
	return self._finish_turn

func get_current_player() -> String:
	return _current_player
	
func get_TILE_DICT()-> Dictionary:
	return _TILE_DICT

func get_count_turn() -> int:
	return _count_turn

# setter
func set_matrix(matrix: Array) -> void:
	self._matrix = matrix

func set_finish_turn(finish_turn: bool) -> void:
	self._finish_turn = finish_turn

func set_current_player(current_player: String) -> void:
	_current_player = current_player

func increase_count_turn():
	_count_turn += 1
	
	
