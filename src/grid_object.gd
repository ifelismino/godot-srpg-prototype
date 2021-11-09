class_name GridObject
extends Spatial
# Base Class of the Objects placed on the isometric grid.
# Processes the location of the Object based on it's isometric grid
# coordinates and height. Also processes the move functionality of the object.

# Variable Declaration
export var coordinate: Vector2 = Vector2.ZERO setget _setCoordinate
export var height: float = 0

# The isometric level parent.
onready var level: IsometricLevel = self.owner

func _process(delta: float) -> void:
	height = _calc_height(coordinate)
	self.translation = Vector3(coordinate.x, height, coordinate.y)

# Movement functions clamp movement inside the grid boundaries.
func move_left() -> void:
	self.coordinate.x = clamp(coordinate.x - 1, 0, level.width - 1)

func move_right() -> void:
	self.coordinate.x = clamp(coordinate.x + 1, 0, level.width - 1)

func move_up() -> void:
	self.coordinate.y = clamp(coordinate.y - 1, 0, level.length - 1)

func move_down() -> void:
	self.coordinate.y = clamp(coordinate.y + 1, 0, level.length - 1)

func _setCoordinate(_value: Vector2):
	coordinate = _value
	height = _calc_height(coordinate)

# Gets the height at the coordinate specified
func _calc_height(_coordinate: Vector2) -> float:
	if level != null:
		return level.get_height(_coordinate)
	return 0.0
