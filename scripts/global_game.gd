extends Node

@onready var _finish_turn: bool = false
var _current_player: String = "green"
var _temp_bridge_list: Array = []

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
	[  2,  0,  2,  0,  2,  0,  2,  3,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  4,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1,  1, -1 ],
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

func get_temp_bridge_list() -> Array:
	return _temp_bridge_list

# setter
func set_matrix(matrix: Array) -> void:
	self._matrix = matrix

func set_finish_turn(finish_turn: bool) -> void:
	self._finish_turn = finish_turn

func set_current_player(current_player: String) -> void:
	_current_player = current_player
	
func set_temp_bridge_list(temp_bridge_list: Array) -> void:
	_temp_bridge_list = temp_bridge_list


func clear_temp_bridges():
	for temp_bridge in _temp_bridge_list:
		if is_instance_valid(temp_bridge):
			temp_bridge.queue_free()
	_temp_bridge_list
	
	for y in range(len(_matrix)):
		for x in range(len(_matrix[0])):
			if _matrix[y][x] == 5:
				_matrix[y][x] = 0
