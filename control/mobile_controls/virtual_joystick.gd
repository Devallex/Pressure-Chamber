class_name VirtualJoystick extends Control

@export var deadzone_size: float = 0.2
@export var max_distance: float = 100.0

var is_pressed: bool = false
var knob_position: Vector2 = Vector2.ZERO
var center_position: Vector2

@onready var background: Control = %Background
@onready var knob: Control = %Knob

signal direction_changed(direction: Vector2)

func _ready():
	center_position = size / 2
	knob.position = center_position - knob.size / 2
	
func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			is_pressed = true
			_update_knob_position(event.position)
		else:
			is_pressed = false
			_reset_knob()
	elif event is InputEventScreenDrag and is_pressed:
		_update_knob_position(event.position)

func _update_knob_position(touch_pos: Vector2):
	var relative_pos = touch_pos - center_position
	var distance = relative_pos.length()
	
	if distance > max_distance:
		relative_pos = relative_pos.normalized() * max_distance
	
	knob_position = relative_pos
	knob.position = center_position + knob_position - knob.size / 2
	
	# Calculate direction for movement
	var direction = Vector2.ZERO
	if distance > deadzone_size:
		direction = relative_pos.normalized() * min(distance / max_distance, 1.0)
	
	direction_changed.emit(direction)

func _reset_knob():
	knob_position = Vector2.ZERO
	knob.position = center_position - knob.size / 2
	direction_changed.emit(Vector2.ZERO)
