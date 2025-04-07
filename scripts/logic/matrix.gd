extends Node

@onready var tile_matrix = $TileMatrix
@onready var big_matrix = tile_matrix.generate_tile_matrix()
@onready var matrix = tile_matrix.transform_matrix(big_matrix)

func set_matrix(matrix: Array) -> void:
	self.matrix = matrix

func get_matrix() -> Array:
	return self.matrix
	
func set_big_matrix(big_matrix: Array) -> void:
	self.big_matrix = big_matrix
	
func get_big_matrix() -> Array:
	return self.big_matrix
