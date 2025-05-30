# provides important things for instantiating objects during gameplay
class_name ClickUtil

var _pos: Vector2

func clear_temp_bridges(tree: SceneTree, group_name: String) -> void:
	for node in tree.get_nodes_in_group(group_name):
		node.queue_free()
		call_deferred("queue_free")

func instantiate_scene(parent: Sprite2D, instance: Sprite2D, new_pos: Vector2, object_rotation: float, object_name: String, group_name: String) -> void:
		parent.get_parent().add_child(instance)
		instance.position = new_pos
		instance.rotation = object_rotation
		instance.name = object_name + "_" + str(int(new_pos.x)) + "_" + str(int(new_pos.y))
		instance.add_to_group(group_name)

func get_pos() -> Array:
	var x: int = int(round(_pos.x))
	var y: int = int(round(_pos.y))
	
	var matrix_x: int = int(round(abs(x) / 32))
	var matrix_y: int = int(round(abs(y) / 32))
	
	return [x, y, matrix_x, matrix_y]
