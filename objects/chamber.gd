extends Node3D

@export var pressurize: bool = false
@export var target_pressure: float = 2.0

@export var atmosphere: PressureAtmosphere
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

func _process(delta: float) -> void:
	# Pressurize
	var pressure_goal: float = target_pressure
	if not pressurize:
		pressure_goal = atmosphere.atmosphere.pressure
	
	if pressure_goal < atmosphere.pressure:
		atmosphere.pressure -= delta
		atmosphere.pressure = max(atmosphere.pressure, pressure_goal)
	elif pressure_goal > atmosphere.pressure:
		atmosphere.pressure += delta
		atmosphere.pressure = min(atmosphere.pressure, pressure_goal)
