class_name PressureRigidBody extends PressureBody

@onready var collision_shape: CollisionShape3D = %CollisionShape3D
@onready var csg_sphere: CSGSphere3D = %CSGSphere3D

func _ready():
	gasses[Gas.new({
		"symbol": "?",
		"name": "Test",
		"atomic_mass": 1
	})] = 0.05

func _affect_size(size: float):
	var radius: float = size / 2
	collision_shape.shape.radius = radius
	csg_sphere.radius = radius

func _process(delta: float) -> void:
	_update_pressure()
	_affect_size(_calculate_scalar())
