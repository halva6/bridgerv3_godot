extends Node

# Scenes for the objects to spawn
@export var green_pier_scene: PackedScene
@export var red_pier_scene: PackedScene
@export var green_bridge_scene: PackedScene
@export var red_bridge_scene: PackedScene

# The matrix defining the grid layout
var _matrix: Array = [
	[ -2,  1, -1,  1, -1,  1, -1,  1, -1,  1, -1,  1, -2 ],
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
	[ -2,  1, -1,  1, -1,  1, -1,  1, -1,  1, -1,  1, -2 ] 
]

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
				1:
					spawn_object(green_pier_scene, position)
				2:
					spawn_object(red_pier_scene, position)
				3:
					spawn_object(green_bridge_scene, position)
				4:
					spawn_object(red_bridge_scene, position)

# Spawn an object at a specific position
func spawn_object(scene: PackedScene, position: Vector2):
	if scene != null:
		var instance = scene.instantiate()
		add_child(instance)
		instance.position = position
