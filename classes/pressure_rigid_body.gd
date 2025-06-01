class_name PressureRigidBody extends PressureBody

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
	prompt.hide_mode = ProximityPrompt.HIDE_MODE.WHEN_DISABLED
	prompt.triggered.connect(func():
		if Character.current:
			Character.current.hold(self)
	)
	add_child(prompt)
	
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
	
	if Character.current:
		prompt.disabled = Character.current.holding != null
	
