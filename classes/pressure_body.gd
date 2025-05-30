class_name PressureBody extends PressureAtmosphere

@export var scalar_weight: float = 1.0

#static var drag_target: PressureBody
#static var mouse_position: Vector3

func _affect_size(size: float):
	scale = Vector3.ONE * size

func _calculate_scalar() -> float:
	var pressure_difference: float = pressure / max(0.01, atmosphere.pressure)
	var scalar = scalar_weight * (pressure_difference - 1) + 1
	return scalar

func _process(delta: float) -> void:
	super(delta)
	
	_affect_size(_calculate_scalar())
	
	#position = position + Vector3(delta, 0, 0)
