class_name IsometricLevel
extends Node
# Class for all isometric levels, basis for each scene.
# Contains the width, height and heightmap of the level

# Variable Declaration

var width: int = 0
var length: int = 0

# An array of numbers representing the height of each tile in the map in the
# format heightmap[z][x]
var heightmap: = []

# Public Methods

# Returns the height on a given position. For this instance ortho y = z-axis
func get_height(ortho: Vector2):
	return heightmap[ortho.y][ortho.x]
