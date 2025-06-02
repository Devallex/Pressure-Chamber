class_name NumberRange extends Resource

@export var min: float = 0.0
@export var max: float = 1.0

func _init(_min: float, _max: float) -> void:
	min = _min
	max = _max

func lerp(weight: float) -> float:
	return lerpf(min, max, weight)
# TODO: "Will refactor later" - Alex
