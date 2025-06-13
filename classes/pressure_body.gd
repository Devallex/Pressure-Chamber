class_name PressureBody extends PressureAtmosphere

@export var scalar_weight: float = 1.0

func _ready():
	add_to_group("presusre_body")

#static var drag_target: PressureBody
#static var mouse_position: Vector3

func _affect_size(size: float):
	scale = Vector3.ONE * size

func _calculate_scalar() -> float:
	var pressure_difference: float = pressure / max(0.001, atmosphere.pressure)**2
	#var scalar = 1e-3 * scalar_weight * (pressure_difference - 1.0) + 0.2
	#return scalar
	var max_pressure = 20.0
	var min_scalar = 0.05
	var max_scalar = 3.0
	
	if pressure <= 0.1:
		return min_scalar
	
	var time_to_max_scalar: float = 10000.0
	var clamped_pressure = clamp(pressure_difference, 0.0, time_to_max_scalar)
	var normalized = clamped_pressure / time_to_max_scalar
	var curved = pow(normalized, 1.0)
	return lerp(min_scalar, max_scalar, curved)


func _process(delta: float) -> void:
	super(delta)
	
	_affect_size(_calculate_scalar())
	
	#position = position + Vector3(delta, 0, 0)
