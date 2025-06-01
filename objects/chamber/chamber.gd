class_name PressureChamber extends Node3D

@export var door_open: bool = false
@export var pressurize: bool = false

@export var atmosphere: PressureAtmosphere
@export var target_atmosphere: PressureAtmosphere
@export var field: Area3D

var bodies: Array[PressureBody]

func _ready() -> void:
	field.body_entered.connect(func(body: Node3D):
		print(body)
		if not body is PressureBody:
			return
		if not body in bodies:
			bodies.append(body)
			body.atmosphere = atmosphere
	)
	field.body_exited.connect(func(body: Node3D):
		if not body is PressureBody:
			return
		if not body in bodies:
			return
		bodies.remove_at(bodies.find(body))
		body.atmosphere = atmosphere.atmosphere
	)
	
	%PressurizePrompt.triggered.connect(func():
		pressurize = not pressurize
	)
	%DoorPrompt.triggered.connect(func():
		door_open = not door_open
		if door_open:
			%Door.hide()
			%Door.use_collision = false
		else:
			%Door.show()
			%Door.use_collision = true
	)

func _process(delta: float) -> void:
	var balanced: bool = atmosphere.pressure == atmosphere.atmosphere.pressure

	target_atmosphere.temperature = %Thermostat.set_temperature

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
