extends Area2D

@export var green_bridge: PackedScene
@export var red_bridge: PackedScene

#Instantiation of the real bridge on the position of the previous temporary bridge
func _instantiate_bridge(util: ClickUtil) -> void:
		var current_player: String = GlobalGame.get_current_player()
		var bridge_instance: Node
		var group_name: String
		if (current_player == "green"):
			bridge_instance = green_bridge.instantiate()
			group_name = "greenbridge"
		elif (current_player == "red"):
			bridge_instance = red_bridge.instantiate()
			group_name = "redbridge"
		else:
			return
			
		var matrix: Array = GlobalGame.get_matrix()
		util._pos = get_parent().position
		util.instantiate_scene(get_parent(), bridge_instance, get_parent().position, get_parent().rotation, current_player + "bridge", group_name)
		
		matrix[util.get_pos()[3]][util.get_pos()[2]] = GlobalGame.get_TILE_DICT()[current_player + "bridge"]
		GlobalGame.set_matrix(matrix)
		GlobalGame.increase_count_turn()
		#print("[DEBUG] Placing: " + group_name + "; Turn: " +  str(GlobalGame.get_count_turn()))
		#LocalDebug.print_matrix(matrix, "----- matrix -----")
		#LocalDebug.print_count_numbers(matrix)
		
		GlobalGame.set_finish_turn(true)
		

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click") and !event.is_canceled():
		event.set_canceled(true)
		var util: ClickUtil = ClickUtil.new()
		_instantiate_bridge(util)
		GlobalAudio.emit_signal("play_bridge_sound") # Sound
		util.clear_temp_bridges(get_tree(), "tempbridge")
