extends Node3D

#@export var exit_atmosphere: PressureAtmosphere = GlobalAtmosphere
@export var atmosphere: PressureAtmosphere
@export var field: Area3D

@export var bodies: Array[PressureBody]

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
	print(bodies)
