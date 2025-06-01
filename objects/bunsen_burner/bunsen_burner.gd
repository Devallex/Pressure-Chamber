extends Node3D

@export var disabled: bool = false

@export var set_temperature: float = 573
@export var min_temperature: float = 573
@export var max_temperature: float = 1773

@onready var dialog := %TemperatureDialog

func _ready() -> void:
	%ActivityPrompt.triggered.connect(func():
		disabled = not disabled
	)
	
	Dialog.bind_dialog(%TemperaturePrompt, dialog)

func _process(delta: float) -> void:
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
