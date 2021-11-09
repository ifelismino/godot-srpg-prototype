class_name TileMarker
extends "res://src/grid_object.gd"
# Class for tile markers for movement and action target


# Facilitates type-checking during area colliisions
func is_type(type):
	return type == "TileMarker" or .is_type(type)

func get_type(): 
	return "TileMarker"
