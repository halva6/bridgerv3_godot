extends Area2D

@export var temp_bridge: PackedScene
var input_name: String

# Check if the position in the matrix is valid
func is_position_valid(matrix: Array, matrix_x: int, matrix_y: int) -> bool:
	return matrix_y >= 0 && matrix_x >= 0 && matrix_y < len(matrix) && matrix_x < len(matrix[matrix_y]) && matrix[matrix_y][matrix_x] == 0

# Calculate rotation for the bridge based on direction
func calculate_rotation(direction: String) -> float:
	if direction == "up" or direction == "down":
		return deg_to_rad(90)
	return deg_to_rad(0)

# Try to place a temporary bridge at a specific position
func try_and_place(temp_bridge_group_name: String, matrix: Array, matrix_x: int, matrix_y: int, x: int, y: int, direction: String) -> void:
	if !is_position_valid(matrix, matrix_x, matrix_y):
		return
	
	var bridge_instance = temp_bridge.instantiate()
	get_parent().get_parent().add_child(bridge_instance)

	bridge_instance.rotation = calculate_rotation(direction)	
	bridge_instance.position = Vector2(x, y)
	bridge_instance.name = temp_bridge_group_name + "_" + str(x)+str(y)
	bridge_instance.add_to_group(temp_bridge_group_name)

func clear_temp_bridges(group_name: String, matrix: Array):
	for node in get_tree().get_nodes_in_group(group_name):
		node.queue_free()
	
	for y in range(len(matrix)):
		for x in range(len(matrix[0])):
			if matrix[y][x] == 5:
				matrix[y][x] = 0

# Place temporary bridges in all valid directions
func temp_bridges(temp_bridge_group_name: String, matrix: Array, matrix_x: int, matrix_y: int, x: int, y: int):
	clear_temp_bridges(temp_bridge_group_name, matrix)
	
	# Try placing bridges in all four directions
	try_and_place(temp_bridge_group_name, matrix, matrix_x, matrix_y - 1, x, y - 32, "up")    # Up
	try_and_place(temp_bridge_group_name, matrix, matrix_x, matrix_y + 1, x, y + 32, "down")  # Down
	try_and_place(temp_bridge_group_name, matrix, matrix_x - 1, matrix_y, x - 32, y, "left")  # Left
	try_and_place(temp_bridge_group_name, matrix, matrix_x + 1, matrix_y, x + 32, y, "right") # Right

func print_scene_tree(node: Node, indent: int = 0):
	var indentation = "    ".repeat(indent)  # Einrückung für Hierarchie
	print("%s%s (%s)" % [indentation, node.name, node.get_class()])
	
	# Rekursiv alle Kinder durchgehen
	for child in node.get_children():
		print_scene_tree(child, indent + 1)	


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		# Get the global position of the parent (Pier)
		var x: int = int(round(get_parent().global_position.x))
		var y: int = int(round(get_parent().global_position.y))
		
		# Convert global position to matrix coordinates
		var matrix_x: int = int(round(abs(x) / 32))
		var matrix_y: int = int(round(abs(y) / 32))
		
		var matrix = GlobalGame.get_matrix()
		var temp_bridge_group_name: String = "tempbridge"
		
		#print("Global Position: " + str(get_parent().global_position) + "; Position: " + str(get_parent().position))		
		#print("=== Scene Tree ===")
		#print_scene_tree(get_tree().root)
		
		# Verify the player owns the clicked object
		if get_parent().is_in_group(GlobalGame.get_current_player()+"pier"):
			# Place temporary bridges
			temp_bridges(temp_bridge_group_name, matrix, matrix_x, matrix_y, x, y)
		elif(get_parent().is_in_group("tempbridge")):
			clear_temp_bridges(temp_bridge_group_name, matrix)
