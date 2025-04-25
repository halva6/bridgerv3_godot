extends Node

@onready var _finish_turn: bool = false
var _current_player: String = "green"
var _TILE_DICT: Dictionary = {"greenpier": 1, "redpier": 2, "greenbridge": 3, "redbridge": 4, "tempbridge": 5}

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
	[  2,  4,  2,  4,  2,  4,  2,  4,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  4,  2,  0,  2,  0,  2 ],
	[ -1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1 ],
	[  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2,  0,  2 ],
	[ -1,  1, -1,  1, -1,  1, -1,  1, -1,  1,  0,  1, -1 ] 
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

# setter
func set_matrix(matrix: Array) -> void:
	self._matrix = matrix

func set_finish_turn(finish_turn: bool) -> void:
	self._finish_turn = finish_turn

func set_current_player(current_player: String) -> void:
	_current_player = current_player
	
	
# Prints a 2D array (matrix) in a formatted way to the Godot console.
# Handles alignment, empty matrices, and dynamic sizing.
#
# @param matrix: The 2D array to print (Array[Array]).
# @param header: Optional header text (String). Defaults to "".
func print_matrix(matrix: Array, header: String = "") -> void:
	# Print optional header if provided
	if header != "":
		print(header)
	
	# Early return if the matrix is empty
	if matrix.is_empty():
		print("[] (Empty matrix)")
		return
	
	# --- Calculate max element length for alignment ---
	var max_length := 0  # Track the longest string representation
	
	# Iterate through all elements to find the maximum length
	for row in matrix:
		for element in row:
			var element_str := str(element)  # Convert any type to string
			if element_str.length() > max_length:
				max_length = element_str.length()
	
	# --- Print the matrix dimensions ---
	print("Matrix [", matrix.size(), "x", matrix[0].size(), "]:")
	
	# --- Print each row with formatting ---
	for row in matrix:
		var row_str := "| "  # Start row with a boundary
		
		# Add each element (right-padded for alignment)
		for element in row:
			row_str += str(element).rpad(max_length) + " "  # Align right
		
		row_str += "|"  # Close row boundary
		print(row_str)   # Print the formatted row
