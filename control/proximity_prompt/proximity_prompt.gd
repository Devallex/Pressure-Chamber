class_name ProximityPrompt extends Node3D

@export var action_text: String = "Activate" ## The text displayed on the prompt UI.
@export var activation_time: float = 0.125 ## How long the input_action must be held to trigger the prompt.
@export var deactivation_rate: float = 5 ## Decreases progress n times as fast as the activation rate.
@export var input_action: String = "primary_interact" ## The input bound in the project's input map.
@export var disabled: bool = false ## If on, disables all interaction and hides the prompt.
@export var frozen: bool = false ## If on, disables all interaction without hiding the prompt. Superseeded by disabled.
@export var one_shot: bool = false ## If on, self-disables once triggered for the first time. Can be re-enabled by scripts.
@export var camera_max_distance: float = 3.5 ## If the player is farther than this value, the prompt is unavailable.
@export var billboard: BaseMaterial3D.BillboardMode = BaseMaterial3D.BillboardMode.BILLBOARD_DISABLED ## How the prompt is oriented relative to the camera.
@export var hide_mode: HIDE_MODE = HIDE_MODE.NEVER

var keybinds = {
	"primary_interact": "E",
	"secondary_interact": "F",
	"hold_interact": "R"
}

const SHRINK_FACTOR: float = 0.85

var time_activated: float = 0
var original_transform: Transform3D
@onready var initial_transform: Transform3D = %Sprite3D.transform

signal stopped
signal started
signal triggered
signal released
signal any(trigger_state: TRIGGER_STATE)

enum TRIGGER_STATE {
	IDLE,
	STARTED,
	RELEASED,
	TRIGGERED
}

enum HIDE_MODE {
	NEVER,
	WHEN_DISABLED,
	WHEN_FAR
}

var signals_for_states = {
	TRIGGER_STATE.IDLE: stopped,
	TRIGGER_STATE.STARTED: started,
	TRIGGER_STATE.TRIGGERED: triggered,
	TRIGGER_STATE.RELEASED: released,
}

# Only trigger one prompt when pressing inputs
static var camera: Camera3D = Camera3D.new()
static var all_prompts: Array[ProximityPrompt] = []
static func getClosestPrompt(input_action: String):
	if Globals.is_paused:
		return null
	var closest_prompt: ProximityPrompt = null
	var closest_distance: float = INF
	for prompt in all_prompts:
		var distance: float = prompt.global_position.distance_to(camera.global_position)
		if prompt.disabled or prompt.input_action != input_action or distance > prompt.camera_max_distance:
			continue
		if distance <= closest_distance:
			closest_prompt = prompt
			closest_distance = distance
	return closest_prompt

var trigger_state: TRIGGER_STATE = TRIGGER_STATE.IDLE
func _setTriggerState(new_trigger_state: TRIGGER_STATE):
	if new_trigger_state == trigger_state:
		return
	trigger_state = new_trigger_state
	var event: Signal = signals_for_states[trigger_state]
	event.emit()
	any.emit(trigger_state)

func getTriggerState() -> TRIGGER_STATE:
	return trigger_state

func _updateVisuals():
	var local_camera_transform: Transform3D = global_transform.affine_inverse() * camera.global_transform
	var is_viewed_from_behind: bool = local_camera_transform.origin.z < 0
	if is_viewed_from_behind:
		%Sprite3D.transform = initial_transform.rotated_local(Vector3.UP, PI)
	else:
		%Sprite3D.transform = initial_transform
	%Sprite3D.billboard = billboard
	
	if isClosest():
		%Sprite3D.modulate = Color(1.0, 1.0, 1.0, 1.0)
		show()
	else:
		if disabled:
			if hide_mode == HIDE_MODE.WHEN_DISABLED:
				hide()
			else:
				show()
			%Sprite3D.modulate = Color(1.0, 0.5, 0.5, 0.5)
		else:
			if hide_mode != HIDE_MODE.NEVER:
				hide()
			else:
				show()
			%Sprite3D.modulate = Color(1.0, 1.0, 1.0, 0.5)
	
	%Action.text = action_text
	
	%Trigger.text = "Press " + keybinds[input_action]
	
	#%Sprite3D.billboard = billboard
	#%Key.text = input_action

func getCompletion() -> float:
	return time_activated / max(activation_time, 0.001)

func getTime() -> float:
	return time_activated

func isTriggered() -> bool:
	return getCompletion() >= 1.0

func reset() -> void:
	time_activated = 0
	_setTriggerState(TRIGGER_STATE.IDLE)

func isClosest() -> bool:
	return getClosestPrompt(input_action) == self

func isBeingActivated() -> bool:
	return Input.is_action_pressed(input_action) and isClosest()

func _shrinkIfPressed() -> void:
	scale = Vector3.ONE * lerpf(1, SHRINK_FACTOR, getCompletion())
	%Fill.anchor_right = getCompletion()

func _ready():
	all_prompts.append(self)
	_updateVisuals()

func _process(delta: float):
	if isBeingActivated():
		time_activated += delta
	else:
		time_activated -= delta * deactivation_rate
	time_activated = clampf(time_activated, 0, max(activation_time, 0.001))

	if isTriggered():
		_setTriggerState(TRIGGER_STATE.TRIGGERED)
		if one_shot:
			disabled = true
	elif isBeingActivated():
		_setTriggerState(TRIGGER_STATE.STARTED)
	elif getCompletion() != 0:
		_setTriggerState(TRIGGER_STATE.RELEASED)
	else:
		_setTriggerState(TRIGGER_STATE.IDLE)
	
	_updateVisuals()
	_shrinkIfPressed()
