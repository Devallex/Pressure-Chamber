class_name Particle extends RigidBody2D

@onready var window_size = get_viewport().get_visible_rect().size

func is_going_out() -> bool:
	var pos = global_position
	var radius = 100  # Adjust based on particle size
	
	#return pos.x < -buffer or pos.x > window_size.x + buffer or \
		   #pos.y < -buffer or pos.y > window_size.y + buffer
	return (pos.y - radius < 0) or \
	(pos.y + radius > window_size.y) or \
	(false) or \
	(false)

func _process(delta: float) -> void:
	if is_going_out():
		print("IT'S COMING OUT")
		gravity_scale = gravity_scale * -1
