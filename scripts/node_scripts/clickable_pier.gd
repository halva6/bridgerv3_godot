extends Area2D

var input_name: String

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:	
	if event.is_action_pressed("click"):
		var x: int = int(round(abs(get_parent().position.x)/32))
		var y: int = int(round((get_parent().position.y)/32))
		
		if (get_parent() is Properties):
			print("x: " + str(x) + " y: " + str(y) + "; Name: " + get_parent().object_name)
			get_parent().position_x = x
			get_parent().position_y = y
