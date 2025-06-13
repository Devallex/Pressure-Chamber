class_name Particle extends RigidBody2D

@export var radius: float = 100.0
@export var initial_speed: float = 100.0
@export var label: String = "?"
@export var color: Color = Color.BLACK

func _update_visuals() -> void:
	%CollisionShape.shape.radius = radius
	%Sprite.scale = Vector2.ONE * (radius / 100.0)
	
	%Label.text = label
	
	var inverted = color.inverted()
	if inverted.get_luminance() < 0.5:
		inverted = inverted.darkened(1.0)
	else:
		inverted = inverted.lightened(1.0)
	%Label.add_theme_color_override("font_color", inverted)
	
	var gradient: Gradient = %Sprite.texture.gradient
	gradient.set_color(0, color)


var last_velocity
func _ready() -> void:
	_update_visuals()
	position = Vector2()
	
	var viewport_size: Vector2 = get_viewport_rect().size
	position = Vector2(viewport_size.x * randf(), viewport_size.y * randf())
	
	linear_velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * initial_speed

func _integrate_forces(state):
	# Store last velocity before physics step
	state.linear_velocity = state.linear_velocity.normalized() * initial_speed
