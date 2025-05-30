extends Area2D

@export var temp_bridge: PackedScene

# Check if the position in the matrix is valid
func _is_position_valid(matrix: Array, x: int, y: int) -> bool:
	return y >= 0 and x >= 0 and y < len(matrix) and x < len(matrix[y]) and matrix[y][x] == 0

# Calculate rotation based on direction
func _calculate_rotation(direction: String) -> float:
	return deg_to_rad(90) if direction in ["up", "down"] else deg_to_rad(0)
	#print("[VALID] matrix len: " + str(len(matrix[y])) + ";" + str(len(matrix)) + " x;y: " + str(Vector2(x,y)) + " Matrix[x][y]: " + str(matrix[x][y]))

# Get offset for a given direction
func _get_offset(direction: String) -> Array:
	match direction:
		"up": return [0, -1, 0, -32]
		"down": return [0, 1, 0, 32]
		"left": return [-1, 0, -32, 0]
		"right": return [1, 0, 32, 0]
		_: return [0, 0, 0, 0]

# Place a temporary bridge at a position if valid
func _try_place_bridge(group_name: String, matrix: Array, util: ClickUtil, direction: String) -> void:
	var pos: Array = util.get_pos()
	var offset: Array = _get_offset(direction)
	if _is_position_valid(matrix, (pos[2] + offset[0]), (pos[3] + offset[1])):
		var bridge_instance: Node = temp_bridge.instantiate()
		util.instantiate_scene(get_parent(), bridge_instance, Vector2((pos[0] + offset[2]), (pos[1] + offset[3])), _calculate_rotation(direction), "temp_bridge", group_name)

# Place temporary bridges in all directions
func _place_temp_bridges(group_name: String, matrix: Array, util: ClickUtil) -> void:
	util.clear_temp_bridges(get_tree(), group_name)
	for direction: String in ["up", "down", "left", "right"]:
		_try_place_bridge(group_name, matrix, util, direction)

# Handle input events
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click") and get_parent().is_in_group(GlobalGame.get_current_player() + "pier"):
		var matrix: Array = GlobalGame.get_matrix()
		var group_name: String = "tempbridge"
		var util: ClickUtil = ClickUtil.new()
		
		GlobalAudio.emit_signal("play_click_sound") # Sound
		
		util._pos = get_parent().position
		_place_temp_bridges(group_name, matrix, util)
