extends Node

@export var tilemap_layer: TileMapLayer

@onready var matrix_script = $Matrix

var current_player: String

func get_current_player() -> String:
	return self.current_player
	
func set_current_player(current_player: String) -> void:
	self.current_player = current_player
	
func valid_player(atlas_coords) -> bool: # mit den Atlas-Coords lässt sich der Typ bestimmen
	return (current_player == "green" && atlas_coords == Vector2i(3,0)) || (current_player == "red" && atlas_coords == Vector2i(3,1))

func delete_temp_bridges(big_matrix: Array)->void:
	for i in range(len(big_matrix)):
		for j in range(len(big_matrix[i])):
			if big_matrix[i][j] == 5:
				print(i,j)
				big_matrix[i][j] = 0
				tilemap_layer.set_cell(Vector2i(j,i))

func evaluate_and_place_bridges(atlas_coords, tile_coords) -> void:
		if !valid_player(atlas_coords):
			return
		var big_matrix = matrix_script.get_big_matrix()
		delete_temp_bridges(big_matrix)
		#set the temp bridges right here		
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Bildschirmposition → Weltposition über den Viewport-CanvasTransform
		var screen_pos = event.position
		var world_pos = get_viewport().get_canvas_transform().affine_inverse() * screen_pos

		# Weltposition in lokale TileMapLayer-Koordinaten
		var local_pos = tilemap_layer.to_local(world_pos)
		var tile_coords = tilemap_layer.local_to_map(local_pos)

		# Infos holen
		var source_id = tilemap_layer.get_cell_source_id(tile_coords)
		if source_id == -1:
			print("Kein Tile bei Koordinaten: ", tile_coords)
			return
		
		var atlas_coords = tilemap_layer.get_cell_atlas_coords(tile_coords)
		
		print("Geklickt auf TileMap-Koordinate: ", tile_coords)
		print("Atlas-Koordinaten: ", atlas_coords)
		
		evaluate_and_place_bridges(atlas_coords, tile_coords)
		

		
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
