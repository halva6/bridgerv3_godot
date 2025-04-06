extends Node

@export var green_pier_scene: PackedScene
@export var red_pier_scene: PackedScene
@export var green_bridge_scene: PackedScene
@export var red_bridge_scene: PackedScene
@export var wall_scene: PackedScene

@export var cell_size: float = 1.0

var matrix: Array

func visualize_matrix(input_matrix: Array):
	matrix = input_matrix
	var offset = calculate_matrix_offset(matrix)

	for row in matrix.size():
		for col in matrix[row].size():
			spawn_cell(row, col, offset)


func calculate_matrix_offset(matrix: Array) -> Vector2:
	var offset_x = -matrix[0].size() * cell_size / 2 + cell_size / 2
	var offset_y = matrix.size() * cell_size / 2 - cell_size / 2
	return Vector2(offset_x, offset_y)


func spawn_cell(row: int, col: int, offset: Vector2):
	var cell_value = matrix[row][col]
	var position = Vector3(col * cell_size + offset.x, -row * cell_size + offset.y, 0)
	var prefab = get_prefab_for_cell_value(cell_value)

	if prefab:
		var instance = prefab.instantiate()
		instance.name = "%d %d" % [row, col]
		var rotation = get_rotation_for_cell(row, col, cell_value)
		instance.rotation_degrees = rotation
		add_child(instance)
		instance.global_position = position
		#attach_metadata(instance, row, col, cell_value)


func get_prefab_for_cell_value(value: int) -> PackedScene:
	match value:
		-1:
			return wall_scene
		1:
			return green_pier_scene
		2:
			return red_pier_scene
		3:
			return green_bridge_scene
		4:
			return red_bridge_scene
		_:
			return null


func get_rotation_for_cell(row: int, col: int, value: int) -> Vector3:
	if value == 3 or value == 4:
		var target_value = value == 3 and 1 or 2
		if should_rotate(row, col, target_value):
			return Vector3(0, 0, 90)
	elif value == -1 and (col == 0 or col == matrix[0].size() - 1):
		return Vector3(0, 0, 90)
	return Vector3.ZERO


func should_rotate(row: int, col: int, target_value: int) -> bool:
	if row > 0 and matrix[row - 1][col] == target_value:
		return true
	if row < matrix.size() - 1 and matrix[row + 1][col] == target_value:
		return true
	return false


func attach_metadata(instance: Node, row: int, col: int, value: int):
	if value == 1 or value == 2:
		if instance.has_method("set_metadata"):  # You can define this in a custom script
			instance.set_metadata(col, row, value == 1 and "GreenPier" or "RedPier")
