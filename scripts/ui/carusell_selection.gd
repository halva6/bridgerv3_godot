extends Control

@onready var object_container: HBoxContainer = %ObjectContainer
@onready var scroll_container: ScrollContainer = %GameboardScrollContainer

var target_index: int = 0 # Index of the currently selected item (VBoxContainer only)
var items: Array = [] # List of VBoxContainers in the carousel

const SELECTED_SCALE = Vector2(1.3, 1.3)
const UNSELECTED_SCALE = Vector2(1.0, 1.0)

func _ready() -> void:
	_collect_items()
	if items.size() > 0:
		target_index = clamp(GlobalSave.load_board_size(), 0, items.size() - 1)
		
		#Waiting 3 frames because the UI takes a little longer to be calculated - is a Godot property
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await _tween_scroll_to_index(target_index)
	_set_selection()
	_on_item_selected(target_index)

func _collect_items():
	items.clear()
	for child in object_container.get_children():
		if child is VBoxContainer:
			items.append(child)

func _set_selection():
	await get_tree().create_timer(0.01).timeout
	_select_deselect_highlight()

func _get_space_between() -> float:
	if items.size() == 0:
		return 0
	var distance_size = object_container.get_theme_constant("separation")
	var object_size = items[0].size.x
	return distance_size + object_size

# Centers the selected item in the ScrollContainer and animates the scroll
func _tween_scroll_to_index(index: int):
	if items.size() == 0:
		return
	var vbox = items[index]
	var vbox_global = vbox.get_global_rect()
	var scroll_global = scroll_container.get_global_rect()
	var scroll_center_x = scroll_global.position.x + scroll_global.size.x / 2
	var vbox_center_x = vbox_global.position.x + vbox_global.size.x / 2
	var current_scroll = scroll_container.scroll_horizontal
	var scroll_delta = vbox_center_x - scroll_center_x
	var target_scroll = current_scroll + scroll_delta

	# Limit scrolling to the maximum scroll values
	target_scroll = clamp(target_scroll, 0, scroll_container.get_h_scroll_bar().max_value)

	target_index = index
	var tween = get_tree().create_tween()
	tween.tween_property(scroll_container, "scroll_horizontal", target_scroll, 0.25)
	await tween.finished

func _select_deselect_highlight():
	if items.size() == 0:
		return
	for i in items.size():
		var vbox = items[i]
		var tex_rect = _get_texture_rect_from_vbox(vbox)
		if tex_rect:
			if i == target_index:
				tex_rect.modulate = Color(1,1,1)
				vbox.scale = SELECTED_SCALE
			else:
				tex_rect.modulate = Color(1,1,1,0.5)
				vbox.scale = UNSELECTED_SCALE

func get_selected_value():
	if items.size() == 0:
		return null
	return items[target_index]

func _on_previous_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	if items.size() == 0:
		return
	target_index = (target_index - 1 + items.size()) % items.size()
	await _tween_scroll_to_index(target_index)
	_select_deselect_highlight()
	_on_item_selected(target_index)

func _on_next_button_pressed() -> void:
	GlobalAudio.emit_signal("play_click_sound") #Sound
	if items.size() == 0:
		return
	target_index = (target_index + 1) % items.size()
	await _tween_scroll_to_index(target_index)
	_select_deselect_highlight()
	_on_item_selected(target_index)

func _get_texture_rect_from_vbox(vbox: VBoxContainer) -> TextureRect:
	for child in vbox.get_children():
		if child is TextureRect:
			return child
	return null

# This function returns the current index
func _on_item_selected(index: int) -> void:
	GlobalSave.save_board_size(index)
	GlobalGame.set_game_board_size(GlobalGame.get_game_size_dict()[index])
