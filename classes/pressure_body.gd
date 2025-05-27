class_name PressureBody extends PressureAtmosphere

@export var scalar_weight: float = 1.0
#
#@onready var camera = get_viewport().get_camera_3d()
#static var drag_target: PressureBody
#static var mouse_position: Vector3

func _process(delta: float) -> void:
	var pressure_difference: float = pressure / atmosphere.pressure
	var scalar = scalar_weight * (pressure_difference - 1) + 1
	print(scalar)
	scale = Vector3.ONE * scalar
	
	position = position + Vector3(delta, 0, 0)

#static func _input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.pressed:
				#var ray = RayCast3D.new()
				#ray.target_position
				#drag_target = object
			#else:
				#drag_target = null
