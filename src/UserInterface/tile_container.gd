class_name TileContainer
extends Spatial
# Handles populating and depopulatting tile markers in the scene
func populate_tile_container(_source: Actor, _tile: PackedScene, _border: int, _map: Array) -> void:
	# Iterate through the map
	for r in range(1, _border):
		for i in range (-r, r + 1):
			for j in range (-r, r + 1):
				if abs(i) == r or abs(j) == r:
					var u = _border + i
					var v = _border + j
					if _map[u][v] < 900:
						var tile = _tile.instance()
						self.add_child(tile)
						tile.level = self.owner
						tile.coordinate = Vector2(_source.coordinate.x + i, _source.coordinate.y + j)
		yield(get_tree(), "idle_frame")

func add_single_tile(_tile: PackedScene, _coordinate: Vector2):
	var tile = _tile.instance()
	self.add_child(tile)
	tile.level = self.owner
	tile.coordinate = _coordinate

func depopulate_tile_container() -> void:
	for child in self.get_children():
		child.queue_free()
		
