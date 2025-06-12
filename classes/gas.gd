class_name Gas extends Resource

@export var name: String
@export var symbol: String
@export var atomic_mass: float = 1.0
@export var vdw_radius: float = 1.0
@export var vdw_a: float = 0.0
@export var vdw_b: float = 0.0
@export var color: Color

func _init(data: Dictionary[String, Variant]) -> void:
	name = data["name"]
	symbol = data["symbol"]
	atomic_mass = data["atomic_mass"]
	vdw_radius = data["vdw_radius"]
	color = data["color"]
	vdw_a = data["vdw_a"]
	vdw_b = data["vdw_b"]
