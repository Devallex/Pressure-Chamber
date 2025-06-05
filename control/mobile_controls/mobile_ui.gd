class_name MobileUI extends Control

@onready var movement_joystick: VirtualJoystick = %MovementJoystick
@onready var camera_joystick: VirtualJoystick = %CameraJoystick
@onready var primary_button: Button = %PrimaryButton
@onready var secondary_button: Button = %SecondaryButton
@onready var grab_button: Button = %GrabButton

var movement_direction: Vector2 = Vector2.ZERO
var camera_direction: Vector2 = Vector2.ZERO

func _ready():
	# Only show on mobile devices
	if not OS.has_feature("mobile"):
		hide()
		return
	
	movement_joystick.direction_changed.connect(_on_movement_changed)
	camera_joystick.direction_changed.connect(_on_camera_changed)
	
	primary_button.pressed.connect(_on_primary_pressed)
	secondary_button.pressed.connect(_on_secondary_pressed)
	grab_button.pressed.connect(_on_grab_pressed)

func _on_movement_changed(direction: Vector2):
	movement_direction = direction

func _on_camera_changed(direction: Vector2):
	camera_direction = direction

func _on_primary_pressed():
	# Trigger the closest proximity prompt with primary_interact
	var closest = ProximityPrompt.getClosestPrompt("primary_interact")
	if closest:
		closest._setTriggerState(ProximityPrompt.TRIGGER_STATE.TRIGGERED)

func _on_secondary_pressed():
	# Trigger the closest proximity prompt with secondary_interact  
	var closest = ProximityPrompt.getClosestPrompt("secondary_interact")
	if closest:
		closest._setTriggerState(ProximityPrompt.TRIGGER_STATE.TRIGGERED)

func _on_grab_pressed():
	# Trigger the grab action (hold_interact)
	var closest = ProximityPrompt.getClosestPrompt("hold_interact")
	if closest:
		closest._setTriggerState(ProximityPrompt.TRIGGER_STATE.TRIGGERED)
