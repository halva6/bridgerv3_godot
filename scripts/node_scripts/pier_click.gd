extends Area2D

@export var temp_bridge: PackedScene
var input_name: String

# Check if the position in the matrix is valid
func is_position_valid(matrix: Array, x: int, y: int) -> bool:
	return y >= 0 and x >= 0 and y < len(matrix) and x < len(matrix[y]) and matrix[y][x] == 0

# Calculate rotation based on direction
func calculate_rotation(direction: String) -> float:
	return deg_to_rad(90) if direction in ["up", "down"] else deg_to_rad(0)
	#print("[VALID] matrix len: " + str(len(matrix[y])) + ";" + str(len(matrix)) + " x;y: " + str(Vector2(x,y)) + " Matrix[x][y]: " + str(matrix[x][y]))


# Get offset for a given direction
func get_offset(direction: String) -> Array:
	match direction:
		"up": return [0, -1, 0, -32]
		"down": return [0, 1, 0, 32]
		"left": return [-1, 0, -32, 0]
		"right": return [1, 0, 32, 0]
		_ : return [0, 0, 0, 0]

# Place a temporary bridge at a position if valid
func try_place_bridge(group_name: String, matrix: Array, util: ClickUtil, direction: String) -> void:
	var pos = util.get_pos()
	var offset = get_offset(direction)
	if is_position_valid(matrix, (pos[2] + offset[0]), (pos[3] + offset[1])):
		var bridge_instance = temp_bridge.instantiate()
		util.instantiate_scene(get_parent(), bridge_instance, Vector2((pos[0] + offset[2]), (pos[1] + offset[3])), calculate_rotation(direction), "temp_bridge", group_name)

# Place temporary bridges in all directions
func place_temp_bridges(group_name: String, matrix: Array, util: ClickUtil) -> void:
	util.clear_temp_bridges(get_tree(), group_name, matrix)
	for direction in ["up", "down", "left", "right"]:
		try_place_bridge(group_name, matrix, util, direction)
	
	print_matrix(matrix)

# Print the scene tree structure (for debugging purposes)
func print_scene_tree(node: Node, indent: int = 0) -> void:
	var indentation = "    ".repeat(indent)
	print("%s%s (%s)" % [indentation, node.name, node.get_class()])
	for child in node.get_children():
		print_scene_tree(child, indent + 1)

# Gibt eine 2D-Matrix lesbar in der Konsole aus
func print_matrix(matrix: Array) -> void:
	if matrix.is_empty():
		print("[] (Leere Matrix)")
		return
	
	# Bestimme die maximale Länge eines Elements für saubere Formatierung
	var max_length := 0
	for row in matrix:
		for element in row:
			var element_str := str(element)
			if element_str.length() > max_length:
				max_length = element_str.length()
	
	# Ausgabe jeder Zeile mit Formatierung
	print("Matrix [", matrix.size(), "x", matrix[0].size(), "]:")
	for row in matrix:
		var row_str := "| "
		for element in row:
			row_str += str(element).rpad(max_length) + " "  # Rechtsbündige Ausrichtung
		row_str += "|"
		print(row_str)

# Handle input events
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click") and get_parent().is_in_group(GlobalGame.get_current_player() + "pier"):
		var matrix = GlobalGame.get_matrix()
		var group_name: String = "tempbridge"
		var util = ClickUtil.new()
		
		util.pos = get_parent().position
		place_temp_bridges(group_name, matrix, util)
