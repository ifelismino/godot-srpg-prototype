class_name BattleHUD
extends Control
# Class for the in-battle heads up display. Contains the menus and other information

# Signal Declaration
signal move_button_pressed()

# Variable declaration
var _commandActor: Actor = null
var _keepActorInfo: bool = false

onready var ActorInfo: TextureRect = get_node("CanvasLayer/ActorInfoFrame")
onready var TargetInfo: TextureRect = get_node("CanvasLayer/TargetInfoFrame")

onready var Height: Label = get_node("CanvasLayer/Height")

onready var CommandMenu: TextureRect = get_node("CanvasLayer/CommandMenu")

# Public Methods
func set_keep_actor_info(value: bool) -> void:
	_keepActorInfo = value

func update_actor_value() -> void:
	_show_actor_info(_commandActor)

# Private Methods
func _show_command (_actor: Actor) -> void:
	_hide_target_info()
	_commandActor = _actor
	CommandMenu.visible = true
	CommandMenu.get_node("ScrollContainer/VBoxContainer").get_child(0).grab_focus()

func _hide_command () -> void:
	CommandMenu.visible = false
	for button in CommandMenu.get_node("ScrollContainer/VBoxContainer").get_children():
		button.release_focus()

func _update_height_label(_height : float) -> void:
	Height.text = "%s h" % _height

func _show_actor_info (_actor : Actor) -> void:
	ActorInfo.get_node("Portrait").texture = load(_actor.portrait)
	ActorInfo.get_node("ActorName").text = "%s" % _actor.fullName
	ActorInfo.get_node("Health").text = "%s" % _actor.hp
	ActorInfo.get_node("MaxHealth").text = "%s" % _actor.maxHP
	ActorInfo.get_node("Level").text = "%s" % _actor.lvl
	_set_actor_ap_display(_actor.ap)
	ActorInfo.visible = true

func _hide_actor_info () -> void:
	if _keepActorInfo == false:
		ActorInfo.get_node("Portrait").texture = null
		ActorInfo.get_node("ActorName").text = "%s"
		ActorInfo.get_node("Health").text = "%s"
		ActorInfo.get_node("MaxHealth").text = "%s"
		ActorInfo.get_node("Level").text = "%s"
		ActorInfo.visible = false

func _show_target_info (_actor: Actor) -> void:
	TargetInfo.get_node("Portrait").texture = load(_actor.portrait)
	TargetInfo.get_node("ActorName").text = "%s" % _actor.fullName
	TargetInfo.get_node("Health").text = "%s" % _actor.hp
	TargetInfo.get_node("MaxHealth").text = "%s" % _actor.maxHP
	TargetInfo.get_node("Level").text = "%s" % _actor.lvl
	_set_target_ap_display(_actor.ap)
	TargetInfo.visible = true

func _hide_target_info () -> void:
	TargetInfo.get_node("Portrait").texture = null
	TargetInfo.get_node("ActorName").text = "%s"
	TargetInfo.get_node("Health").text = "%s"
	TargetInfo.get_node("MaxHealth").text = "%s"
	TargetInfo.get_node("Level").text = "%s"
	TargetInfo.visible = false

func _set_actor_ap_display (ap: int) -> void:
	for i in range (1, 7):
		if ap >= i:
			ActorInfo.get_node("AP/AP %s" % i).visible = true
		else:
			ActorInfo.get_node("AP/AP %s" % i).visible = false

func _set_target_ap_display (ap: int) -> void:
	for i in range (1, 7):
		if ap >= i:
			TargetInfo.get_node("AP/AP %s" % i).visible = true
		else:
			TargetInfo.get_node("AP/AP %s" % i).visible = false

func _on_TilePointer_pointer_moved(x, y, z) -> void:
	_update_height_label(y)


func _on_TilePointer_show_actor_info(actor_value) -> void:
	if _keepActorInfo == false:
		_show_actor_info(actor_value)
	elif actor_value != _commandActor:
		_show_target_info(actor_value)
	else:
		_show_actor_info(actor_value)


func _on_TilePointer_hide_actor_info() -> void:
	if _keepActorInfo == false:
		_hide_actor_info()
	_hide_target_info()


func _on_Move_pressed() -> void:
	_hide_command()
	emit_signal("move_button_pressed")

func _on_Act_pressed() -> void:
	print("Acting")


func _on_Wait_pressed() -> void:
	print("Waiting")


func _on_Status_pressed() -> void:
	print("Status")

func _on_Battlers_show_command(actor_value) -> void:
	_show_command(actor_value)

func _on_Battlers_hide_command() -> void:
	_hide_command()

