extends Node

# Scenes for the objects to spawn
@export var wall: PackedScene
@export var green_pier_scene: PackedScene
@export var red_pier_scene: PackedScene
@export var green_bridge_scene: PackedScene
@export var red_bridge_scene: PackedScene

# The matrix defining the grid layout
@onready var _matrix: Array = GlobalGame.get_matrix()

# Spacing between grid cells
@export var tile_spacing: float = 32

func _ready() -> void:
	_turn_off_camera()
	_generate_from_matrix()

func _turn_off_camera() -> void:
	var os_name: String = OS.get_name()
	
	if os_name == "Android" or os_name == "iOS":
		%Camera2DComputer.visible = false;
		%Camera2DComputer.enabled = false
		%Camera2DMobile.visible = true;
		%Camera2DMobile.enabled = true;
		

# Generate the grid based on the matrix
func _generate_from_matrix() -> void:
	for y in range(_matrix.size()):
		for x in range(_matrix[y].size()):
			var value: int = _matrix[y][x]
			var position: Vector2 = Vector2(x, y) * tile_spacing
			
			match value:
				-2:
					spawn_object(wall, position, deg_to_rad(90), "wall")
				-1:
					spawn_object(wall, position, 0, "wall")
				1:
					spawn_object(green_pier_scene, position, 0, "greenpier")
				2:
					spawn_object(red_pier_scene, position, 0, "redpier")
				3:
					spawn_object(green_bridge_scene, position, _calculate_bridge_rotation(_matrix, x, y, 1), "greenbridge")
				4:
					spawn_object(red_bridge_scene, position, _calculate_bridge_rotation(_matrix, x, y, 2), "redbridge")

# Spawn an object at a specific position and assign it to a group
func spawn_object(scene: PackedScene, position: Vector2, rotaion: float, group_name: String) -> void:
	if scene != null:
		var instance: Node = scene.instantiate()
		add_child(instance)
		instance.position = position
		instance.rotation = rotaion
		instance.name = group_name + "_" + str(int(position.x)) + "_" + str(int(position.y))
		instance.add_to_group(group_name)

func _is_position_valid(matrix: Array, x: int, y: int, valid_number: int = 0) -> bool:
	return y >= 0 and x >= 0 and y < len(matrix) and x < len(matrix[y]) and matrix[y][x] == valid_number

func _calculate_bridge_rotation(matrix: Array, x: int, y: int, valid_number: int) -> float:
	if _is_position_valid(matrix, x, y + 1, valid_number) or _is_position_valid(matrix, x, y - 1, valid_number):
			return deg_to_rad(90)
	return deg_to_rad(0)

func _on_game_root_set_computers_bridge(matrix_position: Vector2) -> void:
	#print("[DEBUG] matrix position: " + str(matrix_position))
	var position: Vector2 = matrix_position * tile_spacing
	var matrix: Array = GlobalGame.get_matrix()
	LocalDebug.print_matrix(matrix)
	var rotation: float = _calculate_bridge_rotation(matrix, matrix_position.x, matrix_position.y, 2)
	spawn_object(red_bridge_scene, position, rotation, "computerbridge")
	matrix[matrix_position.y][matrix_position.x] = 4
