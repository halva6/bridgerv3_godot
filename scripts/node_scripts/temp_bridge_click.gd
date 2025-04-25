extends Area2D

@export var green_bridge: PackedScene
@export var red_bridge: PackedScene

func instantiate_bridge(util: ClickUtil) -> void:
		var current_player: String = GlobalGame.get_current_player()
		var bridge_instance: Node
		var group_name: String
		if(current_player == "green"):
			bridge_instance = green_bridge.instantiate()
			group_name = "greenbridge"
		elif(current_player == "red"):
			bridge_instance = red_bridge.instantiate()
			group_name = "redbridge"
		else:
			return
			
		var matrix = GlobalGame.get_matrix()
		util.pos = get_parent().position
		util.instantiate_scene(get_parent(),bridge_instance, get_parent().position, get_parent().rotation, "temp_bridge", group_name)
		
		matrix[util.get_pos()[3]][util.get_pos()[2]] = GlobalGame.get_TILE_DICT()[current_player+"bridge"]
		GlobalGame.set_matrix(matrix)
		#GlobalGame.print_matrix(matrix, "===== matrix ====")
		GlobalGame.set_finish_turn(true)
		

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		var util = ClickUtil.new()
		instantiate_bridge(util)
		util.clear_temp_bridges(get_tree(),"tempbridge", GlobalGame.get_matrix())
