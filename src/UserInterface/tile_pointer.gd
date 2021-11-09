class_name TilePointer
extends "res://src/grid_object.gd"
# The class for the tile selection pointer. Handles all the logic for moving
# and collision detection.

# Signal Declaration
signal pointer_moved(x, y, z)
signal show_actor_info(actor_value)
signal hide_actor_info()

# Variable Declaration
var is_active: bool = true
var actor: Actor = null
var is_on_marker: bool = false

# Used for timing between inputs
var _lastStep: float = 0.0
var _timeBetweenSteps: float = 0.15
var _timer: float = 0.0

var _angle: int = 0

# Used for dealing with area collisions
var _currentArea: Area = null

func _process(delta: float) -> void:
	if is_active:
		_timer += delta
		_get_input()
		get_node("AnimationPlayer").play("pointer_idle")
		_currentArea = null

func _setCoordinate(_value: Vector2):
	coordinate = _value
	height = _calc_height(coordinate)
	emit_signal("pointer_moved", coordinate.x, height, coordinate.y)

#Public Methods

# Changes the state of the object to stop input
func activate() -> void:
	visible = true	
	is_active = true

func deactivate() -> void:
	visible = false
	is_active = false

# Private Methods

# Each move is delayed by a certain time for held buttons
func _get_input() -> void:
	if (_timer - _lastStep) > _timeBetweenSteps:
		if Input.is_action_pressed("ui_up"):
			_lastStep = _timer
			_calc_up()
		if Input.is_action_pressed("ui_down"):
			_lastStep = _timer
			_calc_down()
		if Input.is_action_pressed("ui_left"):
			_lastStep = _timer
			_calc_left()
		if Input.is_action_pressed("ui_right"):
			_lastStep = _timer
			_calc_right()

# Accounts for the rotation of the camera. Calculate which direction is which
func _calc_up() -> void:
	if NumberUtility.coangle_of_360(_angle):
		move_up()
	elif NumberUtility.coangle_of_270(_angle):
		move_right()
	elif NumberUtility.coangle_of_180(_angle):
		move_down()
	else:
		move_left()

func _calc_right() -> void:
	if NumberUtility.coangle_of_360(_angle):
		move_right()
	elif NumberUtility.coangle_of_270(_angle):
		move_down()
	elif NumberUtility.coangle_of_180(_angle):
		move_left()
	else:
		move_up()

func _calc_down() -> void:
	if NumberUtility.coangle_of_360(_angle):
		move_down()
	elif NumberUtility.coangle_of_270(_angle):
		move_left()
	elif NumberUtility.coangle_of_180(_angle):
		move_up()
	else:
		move_right()

func _calc_left() -> void:
	if NumberUtility.coangle_of_360(_angle):
		move_left()
	elif NumberUtility.coangle_of_270(_angle):
		move_up()
	elif NumberUtility.coangle_of_180(_angle):
		move_right()
	else:
		move_down()


func _on_Camera_Pivot_rotation_changed(angle) -> void:
	_angle = angle


func _on_area_shape_entered(area_id: int, area: Area, area_shape: int, self_shape: int) -> void:
	if area.get_parent().get_type() == "Actor":
		actor = area.get_parent()
		if abs(actor.coordinate.distance_to(self.coordinate)) < 1:
			emit_signal("show_actor_info", actor)
	if area.get_parent().get_type() == "TileMarker":
		is_on_marker = true
	_currentArea = area


func _on_area_shape_exited(area_id: int, area: Area, area_shape: int, self_shape: int) -> void:
	if _currentArea == null:
		emit_signal("hide_actor_info")
		actor = null
		is_on_marker = false		
	elif _currentArea.get_parent().get_type() != "Actor":
		emit_signal("hide_actor_info")
		actor = null
	elif _currentArea.get_parent().get_type() != "TileMarker":
		is_on_marker = false
