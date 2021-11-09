class_name BattleManager
extends Spatial
# Class for facilitating the battle system. Handles the battle algorithm and the
# UI Accept/Cancel inputs. Placed on the YSort Node directly enclosing the Actors

# Signal Declaration
signal show_command(actor_value)
signal hide_command()
signal wait_anim()
enum Phases {REVIEWING, COMMAND_SELECT, MOVE_SELECT, ACTION_SELECT, TARGET_SELECT, WAIT_SELECT, STATUS}


# Variable Declaration
var pathfinder = load("res://src/Utility/pathfinder.gd")

export (Phases) var phase = Phases.REVIEWING

var _turnCounter : int = 0
var moveArray: Array = []

export onready var battlers: Array = get_children()
onready var level: IsometricLevel = self.owner
onready var tilePointer: TilePointer = level.get_node("TilePointer")
onready var tileContainer: TileContainer = level.get_node("TileContainer")
onready var battleHUD: BattleHUD = level.get_node("BattleHUD")

func _ready() -> void:
	calculate_turn_order()
	
func _process(delta: float) -> void:
	if battlers[_turnCounter].is_turn != true:
		_start_turn()
	match phase:
		Phases.REVIEWING:
			_review_phase()
		Phases.COMMAND_SELECT:
			_command_phase()
		Phases.MOVE_SELECT:
			_move_phase()

func is_occupied(coordinate : Vector2) -> bool:
	for battler in battlers:
		if battler.coordinate == coordinate:
			return true
	return false

func calculate_turn_order() -> void:
	for battler in battlers:
		randomize()
		battler.initiative = battler.speed + rand_range(-1.00,1.00)
		battler.is_turn = false
	battlers.sort_custom(self, "speed_comparison")
	for battler in battlers:
		print(battler.name + " " + str(battler.initiative))

func speed_comparison(a, b):
	if a.initiative > b.initiative:
		return true
	return false

func _start_turn() -> void:
	battlers[_turnCounter].is_turn = true
	tilePointer.coordinate = battlers[_turnCounter].coordinate
	emit_signal("show_command",battlers[_turnCounter])
	
	phase = Phases.COMMAND_SELECT

func _finish_turn() -> void:
	battlers[_turnCounter].is_turn = false
	_turnCounter += 1
	if _turnCounter >= battlers.size():
		_turnCounter = 0
		calculate_turn_order()

func _review_phase() -> void:
	tilePointer.activate()
	battleHUD.set_keep_actor_info(false)
	if Input.is_action_just_pressed("ui_cancel"):
		tilePointer.coordinate = battlers[_turnCounter].coordinate
	if Input.is_action_just_pressed("ui_accept"):
		if tilePointer.actor != null:
			if tilePointer.actor.coordinate == tilePointer.coordinate and tilePointer.actor.is_turn == true:
				emit_signal("show_command", tilePointer.actor)
				phase = Phases.COMMAND_SELECT

func _command_phase() -> void:
	tilePointer.deactivate()
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("hide_command")
		phase = Phases.REVIEWING

func _move_phase() -> void:
	tilePointer.activate()
	battleHUD.set_keep_actor_info(true)
	if Input.is_action_just_pressed("ui_cancel"):
		tileContainer.depopulate_tile_container()
		tilePointer.coordinate = battlers[_turnCounter].coordinate
		emit_signal("show_command",battlers[_turnCounter])
		phase = Phases.COMMAND_SELECT
	if Input.is_action_just_pressed("ui_accept"):
		if tilePointer.is_on_marker == true:
			tileContainer.depopulate_tile_container()
			_actor_move()
			tileContainer.add_single_tile(battlers[_turnCounter].moveTile, tilePointer.coordinate)
			phase = Phases.COMMAND_SELECT
#			battlers[_turnCounter].coordinate = tilePointer.coordinate
			yield(self, "wait_anim")
			emit_signal("show_command", battlers[_turnCounter])
			tileContainer.depopulate_tile_container()
			
		else:
			print("Cannot Move Here")

func _actor_move() -> void:
	var _actor: Actor = battlers[_turnCounter]
	var _target = pathfinder.realToArrayCoordinates(tilePointer.coordinate, _actor)
	var _solvedPath = pathfinder.find_shortest_path(moveArray, _target, _actor)
	var _optimizedPath = pathfinder.optimizePath(_solvedPath)
	for i in range(_optimizedPath.size() - 1):
		var _move_Vector: Vector2 = _optimizedPath[i].location.direction_to(_optimizedPath[i + 1].location)
		if _move_Vector == Vector2.UP:
			_actor.move_up()
		elif _move_Vector == Vector2.DOWN:
			_actor.move_down()
		elif _move_Vector == Vector2.LEFT:
			_actor.move_left()
		else:
			_actor.move_right()
		yield(_actor, "done_moving")
		if i % _actor.move == 0:
			_actor.ap -= 1
			battleHUD.update_actor_value()
	emit_signal("wait_anim")

func _on_move_button_pressed() -> void:
	var _actor = battlers[_turnCounter]
	moveArray = pathfinder.calculate_move_possible(_actor, level, self)
	tileContainer.populate_tile_container(_actor, _actor.moveTile, _actor.moveLimit + 1, moveArray)
	phase = Phases.MOVE_SELECT
