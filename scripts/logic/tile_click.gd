extends Node2D

@export var tilemap_layer: TileMapLayer

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
