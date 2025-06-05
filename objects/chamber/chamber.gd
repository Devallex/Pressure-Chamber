class_name PressureChamber extends Node3D

@export var door_open: bool = false
@export var pressurize: bool = false

@export var atmosphere: PressureAtmosphere
@export var target_atmosphere: PressureAtmosphere
@export var field: Area3D
@export var volume: float = 20.0

var bodies: Array[PressureBody]

func _ready() -> void:
	var size = %CollisionShape3D.shape.size 
	volume = size.x * size.y * size.z * 1000.0
	
	field.body_entered.connect(func(body: Node3D):
		if not body.get("atmosphere"):
			return
		if not body.atmosphere in bodies:
			bodies.append(body.atmosphere)
			body.atmosphere.atmosphere = atmosphere
	)
	field.body_exited.connect(func(body: Node3D):
		if not body.get("atmosphere"):
			return
		if not body.atmosphere in bodies:
			return
		bodies.remove_at(bodies.find(body.atmosphere))
		body.atmosphere.atmosphere = atmosphere.atmosphere
	)
	
	%PressurizePrompt.triggered.connect(func():
		pressurize = not pressurize
	)
	%DoorPrompt.triggered.connect(func():
		door_open = not door_open
		if door_open:
			%Door.hide()
			%DoorPrompt.action_text = "Close"
			%Door.use_collision = false
		else:
			%Door.show()
			%DoorPrompt.action_text = "Open"
			%Door.use_collision = true
	)

func _process(delta: float) -> void:
	var balanced: bool = atmosphere.pressure == atmosphere.atmosphere.pressure

	target_atmosphere.temperature = %Thermostat.set_temperature
	target_atmosphere.gases = %Iigs.gases
	target_atmosphere.volume = volume

	%DoorPrompt.disabled = not balanced
	%PressurizePrompt.disabled = door_open
	
	
	# Pressurize
	var pressure_goal: float = target_atmosphere.pressure
	if not pressurize:
		pressure_goal = atmosphere.atmosphere.pressure
	
	if pressure_goal < atmosphere.pressure:
		atmosphere.pressure -= delta
		atmosphere.pressure = max(atmosphere.pressure, pressure_goal)
	elif pressure_goal > atmosphere.pressure:
		atmosphere.pressure += delta
		atmosphere.pressure = min(atmosphere.pressure, pressure_goal)
