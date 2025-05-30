extends Button

@export var current_controll: Control
@export var next_controll_name: String = "settings_ui"

func _on_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	current_controll.visible = false
	current_controll.get_parent().get_node(next_controll_name).visible = true
