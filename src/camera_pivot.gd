extends Spatial
# Takes care of the camera rotation and the input corresponding to it.

signal rotation_changed(angle)

# Minimum time between successive rotations. Measured in seconds
const BETWEEN_ROTATIONS = 0.25

# Angular speed of the rotation. Measured in degrees/second
const ANGULAR_SPEED = 90

# Speed of following pointer
const FOLLOW_SPEED = 7

# Flags for the rotation animation
var _is_animating: bool = false

# Flag for input accept
var _is_input_active:bool = true

# Timer for input delay
var _timer = 0.0

# Target angle for rotation. Measured in degrees
var _target_angle: int = 0

# Current Angle because comparing self.rotation_degrees.y doesn't work
var _angle = 0

# Position of the pointer
var follow_pos: Vector3 = Vector3.ZERO

# Gets the inputs and processes the animation
func _process(delta: float) -> void:
	_correct_angle()
	_timer += delta
	if _is_input_active and _timer > BETWEEN_ROTATIONS:
		if Input.is_action_pressed("right_shoulder"):
			_target_angle = self.rotation_degrees.y - 90
			_is_input_active = false
			_is_animating = true
		if Input.is_action_pressed("left_shoulder"):
			_target_angle = self.rotation_degrees.y + 90
			_is_input_active = false
			_is_animating = true
	_follow(delta)
	_rotation_animation(delta)

# Animation for the rotation
func _rotation_animation(delta:float):
	if abs(_angle - _target_angle) > 0.5:
		var _direction = (_target_angle - _angle)/abs(_target_angle - _angle)
		_angle += _direction * ANGULAR_SPEED * delta
		self.rotation_degrees.y = _angle
	else:
		_angle = _target_angle
		self.rotation_degrees.y = _angle
		if _is_animating == true:
			_is_animating = false
			emit_signal("rotation_changed", _angle)
			_timer = 0.0
			_is_input_active = true

func _correct_angle():
	if _is_animating == false:
		if NumberUtility.compare_floats_lax(_angle, 360):
			_angle = 0
			_target_angle = _angle
			self.rotation_degrees.y = _angle
		if NumberUtility.compare_floats_lax(_angle, -360):
			_angle = 0
			_target_angle = _angle
			self.rotation_degrees.y = _angle

func _follow(delta: float):
	if self.translation.distance_to(follow_pos) > 0.5:
		self.translation += self.translation.direction_to(follow_pos) * FOLLOW_SPEED * delta

func _on_TilePointer_pointer_moved(x, y, z) -> void:
	follow_pos = Vector3(x, y ,z)
