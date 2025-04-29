extends Control

@export var last_ui:String = "pause_ui"

func _on_back_button_pressed() -> void:
	visible = false
	get_parent().get_node(last_ui).visible = true


func _on_impressum_button_pressed() -> void:
	pass # Replace with function body.
	
	

func _on_tutorial_button_pressed() -> void:
	pass # Replace with function body.
