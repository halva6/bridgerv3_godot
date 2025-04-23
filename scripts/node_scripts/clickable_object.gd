extends Area2D

var input_name: String

func is_position_valid(matrix: Array, matrix_x: int, matrix_y: int) -> bool:
	print("")
	return matrix_y >= 0 && matrix_x >= 0 && matrix_y < len(matrix) && matrix_x < len(matrix[matrix_y]) && matrix[matrix_y][matrix_x] == 0

func calculate_rotation(direction: String)-> float:
	if (direction == "up" || direction == "down"):
		return deg_to_rad(90)
	else:
		return deg_to_rad(0)
	
func try_and_place(matrix: Array, matrix_x: int, matrix_y: int, x: int, y: int, direction:String) -> void:
	if !is_position_valid(matrix, matrix_x, matrix_y): 
		return
	
	var bridge_scene = preload("res://gameobjects/red_bridge.tscn")
	var bridge_instance = bridge_scene.instantiate()
	bridge_instance.rotation = calculate_rotation(direction)
	bridge_instance.position.x = x - 40
	bridge_instance.position.y = y - 328
	
	add_child(bridge_instance)
	var temp_bridge_list = GlobalGame.get_temp_bridge_list()
	temp_bridge_list.append(bridge_instance)
	GlobalGame.set_temp_bridge_list(temp_bridge_list)
	
func temp_bridges(matrix_x: int, matrix_y: int, x: int, y: int):
	var matrix = GlobalGame.get_matrix()
	GlobalGame.clear_temp_bridges()
	try_and_place(matrix, matrix_x, matrix_y - 1, x, y - 32, "up")
	try_and_place(matrix, matrix_x, matrix_y + 1, x, y + 32, "down")
	try_and_place(matrix, matrix_x - 1, matrix_y, x - 32, y, "left")
	try_and_place(matrix, matrix_x + 1, matrix_y, x + 32, y, "right")
	#print(GlobalGame.get_matrix())

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:	
	if event.is_action_pressed("click"):
		var x: int = get_parent().position.x
		var y: int = get_parent().position.y
		
		var matrix_x: int = int(round(abs(x)/32))
		var matrix_y: int = int(round((y)/32))
		
		var object_name = ""
		
		if (get_parent() is Properties):
			print("matrix X: " + str(matrix_x) + "; matrix Y: " + str(matrix_y) + " x: " + str(x) + " y: " + str(y) + "; Name: " + get_parent().object_name)
			object_name = get_parent().object_name
			get_parent().position_x = matrix_x
			get_parent().position_y = matrix_y
			
		var current_player: String = GlobalGame.get_current_player()
		
		#print("Current Player: " +  current_player + " is true: " + str(current_player.to_lower() in object_name.to_lower()))
		if object_name.containsn(current_player):
			temp_bridges(matrix_x, matrix_y, y, x)
			#y; x
