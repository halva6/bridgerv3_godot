# providing global critical data
extends Node

var _finish_turn: bool = false
var _multiplayer: bool = true
var _level_mode: bool = false
var _current_player: String = "green"
var _start_player: String = "green"
var _TILE_DICT: Dictionary = {"greenpier": 1, "redpier": 2, "greenbridge": 3, "redbridge": 4, "tempbridge": 5}
var _count_turn: int = 0

var _smmiulation_time: int = 5

var _do_reset: bool = false

var _game_board_size: int = 12
const _game_size_dict: Dictionary = {0: 5, 1: 7, 2: 9, 3: 11, 4: 13, 5: 15, 6: 17}

var _level_description: String = ""


# game board matrix
#	-1 ≙ not placeable space (e.g. walls/corners)
#	 0 ≙ placeable space
#	 1 ≙ green pier
#	 2 ≙ red pier
#	 3 ≙ green bridge
#	 4 ≙ red bridge
#	 5 ≙ temp bridge
var _matrix: Array
var _start_matrix: Array

# getter
func get_matrix() -> Array:
	return _matrix
	
func get_local_multiplayer() -> bool:
	return _multiplayer

func get_level_mode() -> bool:
	return _level_mode

func get_finish_turn() -> bool:
	return self._finish_turn

func get_current_player() -> String:
	return _current_player
	
func get_start_player() -> String:
	return _start_player
	
func get_TILE_DICT() -> Dictionary:
	return _TILE_DICT

func get_count_turn() -> int:
	return _count_turn

func get_start_matrix() -> Array:
	return _start_matrix

func get_simulation_time() -> int:
	return _smmiulation_time
	
func is_reset() -> bool:
	return _do_reset
	
func get_game_board_size() -> int:
	return _game_board_size

func get_game_size_dict() -> Dictionary:
	return _game_size_dict
	
func get_level_description() -> String:
	return _level_description

# setter
func set_matrix(matrix: Array) -> void:
	self._matrix = matrix
	
func set_local_multiplayer(mulitplayer: bool) -> void:
	self._multiplayer = mulitplayer
	
func set_level_mode(levelmode: bool) -> void:
	self._level_mode = levelmode

func set_finish_turn(finish_turn: bool) -> void:
	self._finish_turn = finish_turn

func set_current_player(current_player: String) -> void:
	self._current_player = current_player

func set_start_player(start_player: String) -> void:
	self._start_player = start_player

func increase_count_turn() -> void:
	_count_turn += 1
	
func set_start_matrix(start_matrix: Array) -> void:
	_start_matrix = start_matrix

func set_simulation_time(time: int) -> void:
	self._smmiulation_time = time
	
func set_reset(reset: bool) -> void:
	_do_reset = reset
	
func set_game_board_size(size: int) -> void:
	_game_board_size = size
	
func set_level_description(level_description: String) -> void:
	self._level_description = level_description
