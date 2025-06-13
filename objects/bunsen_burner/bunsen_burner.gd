extends Node3D

@export var disabled: bool = false

@export var set_temperature: float = 573
@export var min_temperature: float = 573
@export var max_temperature: float = 1773

@onready var dialog := %TemperatureDialog

@onready var place_slot: Area3D = %PlaceSlot

var current_body: PressureRigidBody
var previous_temperature: float = 0.0

func _add_body(pressure_body: PressureRigidBody):
	current_body = pressure_body
	previous_temperature = pressure_body.temperature
	pressure_body.temperature = set_temperature

func _ready() -> void:
	%ActivityPrompt.triggered.connect(func():
		disabled = not disabled
	)
	
	Dialog.bind_dialog(%TemperaturePrompt, dialog)
	
	
	
	place_slot.body_entered.connect(func(body: Node3D):
		if current_body != null:
			return
		if body.get_parent_node_3d() is not PressureRigidBody:
			return
		var pressure_body: PressureRigidBody = body.get_parent_node_3d()
		_add_body(pressure_body)
	)
	place_slot.body_exited.connect(func(body: Node3D):
		if current_body != body.get_parent_node_3d():
			return
		var pressure_body: PressureRigidBody = body.get_parent_node_3d()
		#pressure_body.temperature = previous_temperature
		current_body = null
	)

func _process(delta: float) -> void:
	if current_body:
		current_body.temperature = previous_temperature if disabled else set_temperature
		
	dialog.found = current_body != null
	var temperature_weight: float = (set_temperature - min_temperature) / (max_temperature - min_temperature)
	
	%Particles.emitting = not disabled
	var particle_material: StandardMaterial3D = %Particles.mesh.material
	particle_material.albedo_color = Color(1, 0.3, 0, 0.8).lerp(Color(0, 0, 1, 0.1), temperature_weight)
	
	if disabled:
		%ActivityPrompt.action_text = "Enable"
	else:
		%ActivityPrompt.action_text = "Disable"
	
	dialog.min_temperature = min_temperature
	dialog.max_temperature = max_temperature
	set_temperature = dialog.set_temperature
