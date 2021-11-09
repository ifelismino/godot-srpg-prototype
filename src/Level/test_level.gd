extends IsometricLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	width = 10
	length = 10
	heightmap = [[4, 1, 1, 1, 1, 2, 1, 1, 1, 1],
				 [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
				 [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
				 [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
				 [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
				 [1, 1, 1, 1, 1, 1, 1, 1, 1, 3],
				 [1, 1, 3, 1, 1, 1, 1, 1, 1, 2],
				 [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
				 [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
				 [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]
