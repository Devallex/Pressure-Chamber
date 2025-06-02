class_name PressureRigidBody extends PressureBody

@export var min_size: float = 0.1
@export var max_size: float = 2

@onready var collision_shape: CollisionShape3D = %CollisionShape3D
@onready var csg_sphere: CSGSphere3D = %CSGSphere3D

var prompt: ProximityPrompt

func _ready():
	super()
	
	prompt = load("res://control/proximity_prompt/proximity_prompt.tscn").instantiate()
	prompt.billboard = BaseMaterial3D.BillboardMode.BILLBOARD_ENABLED
	prompt.input_action = "hold_interact"
	prompt.action_text = "Grab"
	prompt.disabled = true
	prompt.activation_time = 0.25
	prompt.camera_max_distance = 2.0
	prompt.hide_mode = ProximityPrompt.HIDE_MODE.WHEN_DISABLED
	prompt.triggered.connect(func():
		if Character.current:
			Character.current.hold(self)
	)
	gases[Gases.get_by_symbol("He")] = 0.05
	
	add_child(prompt)


func _affect_size(size: float):
	size = clampf(size, min_size,max_size)
	var radius: float = size / 2
	collision_shape.shape.radius = radius
	csg_sphere.radius = radius

func _process(delta: float) -> void:
	_update_pressure()
	_affect_size(_calculate_scalar())
	
	if Character.current:
		prompt.disabled = Character.current.holding != null
	
