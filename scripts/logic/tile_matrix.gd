extends Node

# Zuordnung der Atlas-Koordinaten zu Zahlenwerten (gemäß deiner Vorgabe)
const ATLAS_TO_NUMBER = {
	Vector2i(0, 0): 3,
	Vector2i(3, 0): 1,
	Vector2i(0, 1): 4,
	Vector2i(3, 1): 2,
	Vector2i(0, 2): 5,
	Vector2i(0, 3): -1  # Sonderfall, falls benötigt
}

func generate_tile_matrix() -> Array:
	var tilemap_layer: TileMapLayer = $TileMapLayer  # Anpassen, falls der Node anders heißt
	var matrix = []
	
	# Matrix-Größe: (0,0) bis einschließlich (24, 24) → 25x25 Felder
	for y in range(0, 25):  # 0..24 (25 Zeilen)
		var row = []
		for x in range(0, 25):  # 0..24 (25 Spalten)
			var tile_pos = Vector2i(x, y)
			
			# Prüfen, ob ein Tile existiert
			var source_id = tilemap_layer.get_cell_source_id(tile_pos)
			var atlas_coords = tilemap_layer.get_cell_atlas_coords(tile_pos)
			
			if source_id == -1:  # Kein Tile → 0
				row.append(0)
			else:
				# Atlas-Koordinaten in Zahl umwandeln (Standard: 0, falls nicht definiert)
				var number = ATLAS_TO_NUMBER.get(atlas_coords, 0)
				row.append(number)
		
		matrix.append(row)
	
	return matrix
	
func transform_matrix(matrix: Array) -> Array:
	var new_matrix = []

	for i in range(0,len(matrix),2):
		var row = []
		for j in range(0,len(matrix[i]),2):
			row.append(matrix[i][j])
		new_matrix.append(row)
	
	return new_matrix
			
func print_matrix(matrix: Array) -> void:
	for row in matrix:
		print(row)

# Beispielaufruf
func _ready():
	var tile_matrix = generate_tile_matrix()
	print("Ergebnis-Matrix (25x25): ")
	print_matrix(tile_matrix)
	print("\nErgebnis-Matrix transformed: ")
	print_matrix(transform_matrix(tile_matrix))
