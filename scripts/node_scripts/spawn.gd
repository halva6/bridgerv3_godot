extends Node

# Scenes for the objects to spawn
@export var wall: PackedScene
@export var rotatet_wall: PackedScene
@export var green_pier_scene: PackedScene
@export var red_pier_scene: PackedScene
@export var green_bridge_scene: PackedScene
@export var red_bridge_scene: PackedScene

# The matrix defining the grid layout
@onready var _matrix: Array = GlobalGame.get_matrix()

# Spacing between grid cells
@export var tile_spacing: float = 32

func _ready():
	generate_from_matrix()

# Generate the grid based on the matrix
func generate_from_matrix():
	for y in range(_matrix.size()):
		for x in range(_matrix[y].size()):
			var value = _matrix[y][x]
			var position = Vector2(x, y) * tile_spacing
			
			match value:
				-2:
					spawn_object(rotatet_wall, position, "wall")
				-1:
					spawn_object(wall, position, "wall")
				1:
					spawn_object(green_pier_scene, position, "greenpier")
				2:
					spawn_object(red_pier_scene, position, "redpier")
				3:
					spawn_object(green_bridge_scene, position, "greenbridge")
				4:
					spawn_object(red_bridge_scene, position, "redbridge")

# Spawn an object at a specific position and assign it to a group
func spawn_object(scene: PackedScene, position: Vector2, group_name: String):
	if scene != null:
		var instance = scene.instantiate()
		add_child(instance)
		instance.position = position
		instance.name = group_name + "_" + str(position.x)+str(position.y)
		instance.add_to_group(group_name)
