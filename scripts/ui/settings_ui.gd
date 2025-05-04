extends Control

@export var last_ui:String = "pause_ui"
@export var hide_mcts_speed: bool = false

func _ready() -> void:
	$MarginContainer/VBoxContainer/VBoxContainer/MCTSSpeedBox/MinutesSpinBox.value = GlobalGame.get_simulation_time()
	if hide_mcts_speed:
		$MarginContainer/VBoxContainer/VBoxContainer/MCTSSpeedBox.visible = false

func _on_back_button_pressed() -> void:
	visible = false
	get_parent().get_node(last_ui).visible = true


func _on_impressum_button_pressed() -> void:
	pass # Replace with function body.
	
	

func _on_tutorial_button_pressed() -> void:
	pass # Replace with function body.


func _on_minutes_spin_box_value_changed(value: float) -> void:
	GlobalGame.set_simulation_time(int(value))
