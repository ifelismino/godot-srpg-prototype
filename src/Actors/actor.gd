class_name Actor
extends "res://src/grid_object.gd"
# Base class for all actors whether Playable, Guest or Enemy
# Contains common variables needed for actors

signal done_moving()

enum FacePosition{LEFT, RIGHT, UP, DOWN}

# Constant Declaration
const MAX_AP: int = 6
const MOVE_SPEED: float = 0.1

# Variable Declaration
export var fullName: String
export var portrait: String
export var move: int
export var jump: int
export var hp: int
export var maxHP: int
export var ap: int
export var lvl: int
export var speed: int
export (FacePosition) var facing = FacePosition.DOWN

var moveLimit: int
var initiative: float
var is_turn: bool
var is_idle: bool

var moveTile = preload("res://src/UserInterface/BlueTile.tscn")
func _ready() -> void:
	is_idle = true

func _process(delta: float) -> void:
	moveLimit = ap * move
	_get_Facing()
	if (is_idle):
		get_node("AnimationPlayer").play("idle")

func move_left() -> void:
	turn_left()
	is_idle = false
	for i in range (1 / MOVE_SPEED):
		get_node("AnimationPlayer").play("run")
		self.coordinate.x = clamp(coordinate.x - MOVE_SPEED, 0, level.width - 1)
		yield(get_tree(), "idle_frame")
	self.coordinate.x = round(self.coordinate.x)
	is_idle = true
	emit_signal("done_moving")

func move_right() -> void:
	turn_right()
	is_idle = false
	for i in range (1 / MOVE_SPEED):
		get_node("AnimationPlayer").play("run")
		self.coordinate.x = clamp(coordinate.x + MOVE_SPEED, 0, level.width - 1)
		yield(get_tree(), "idle_frame")
	self.coordinate.x = round(self.coordinate.x)
	is_idle = true
	emit_signal("done_moving")

func move_up() -> void:
	turn_up()
	is_idle = false
	for i in range (1 / MOVE_SPEED):
		get_node("AnimationPlayer").play("run")
		self.coordinate.y = clamp(coordinate.y - MOVE_SPEED, 0, level.width - 1)
		yield(get_tree(), "idle_frame")
	self.coordinate.y = round(self.coordinate.y)
	is_idle = true
	emit_signal("done_moving")

func move_down() -> void:
	turn_down()
	is_idle = false
	for i in range (1 / MOVE_SPEED):
		get_node("AnimationPlayer").play("run")
		self.coordinate.y = clamp(coordinate.y + MOVE_SPEED, 0, level.width - 1)
		yield(get_tree(), "idle_frame")
	self.coordinate.y = round(self.coordinate.y)
	is_idle = true
	emit_signal("done_moving")

func turn_left() -> void:
	self.rotation_degrees.y = -90
	facing = FacePosition.LEFT
	is_idle = true


func turn_right() -> void:
	self.rotation_degrees.y = 90
	facing = FacePosition.RIGHT
	is_idle = true

func turn_up() -> void:
	self.rotation_degrees.y = 180
	facing = FacePosition.UP
	is_idle = true

func turn_down() -> void:
	self.rotation_degrees.y = 0
	facing = FacePosition.DOWN
	is_idle = true

# Facilitates type-checking during area colliisions
func is_type(type):
	return type == "Actor" or .is_type(type)


func _get_Facing() -> void:
	if NumberUtility.coangle_of_270(self.rotation_degrees.y):
		self.facing = FacePosition.LEFT
	elif NumberUtility.coangle_of_180(self.rotation_degrees.y):
		self.facing = FacePosition.UP
	elif NumberUtility.coangle_of_90(self.rotation_degrees.y):
		self.facing = FacePosition.RIGHT
	else:
		self.facing = FacePosition.DOWN

func get_type():
	return "Actor"
