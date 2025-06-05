class_name Character extends CharacterBody3D

var mobile_ui: MobileUI

var gravity = Vector3.DOWN * 12  # strength of gravity
var base_speed = 4  # movement speed
var jump_speed = 6  # jump strength
var spin = 0.05  # rotation speed
var clamp_spin = 5
var safe_positions = [Vector3(0, 5, 0)]

static var current: Character

var holding: Node3D
var holding_original_parent: Node3D

var max_camera_angle = deg_to_rad(75)

var window_size: Vector2

const safe_positions_amnt = 100

const CROUCH_SPEED = 10

var jump = false

func is_controlling_character():
	return not Globals.is_paused and not Dialog.in_dialog

func rotateCameraX(a, b):
	#b = clamp(b, -1, 1)
	var resultRotation = $Camera.rotation.x - lerp(0.0, a, b)
	if abs(resultRotation) <= max_camera_angle:
		$Camera.rotate_x(-lerp(0.0, a, b))
		$Camera.rotation.x = clamp(
			resultRotation,
			-max_camera_angle,
			max_camera_angle
		)

func drop():
	if not holding:
		return
	
	%HoldViewport.remove_child(holding)
	holding_original_parent.add_child(holding)
	holding.global_transform = %Hold.global_transform
	holding = null

func hold(item: Node3D):
	drop()
	holding_original_parent = item.get_parent()
	holding_original_parent.remove_child(item)
	%HoldViewport.add_child(item)
	holding = item

func get_input(delta):
	var vy = velocity.y
	velocity = Vector3()
	var actual_speed = base_speed
	var currentHeight = $CollisionShape.shape.height
	if is_controlling_character():
		if Input.is_action_pressed("sprint"):
			actual_speed *= 2.5
		if mobile_ui and OS.has_feature("mobile"):
			var mobile_movement = mobile_ui.movement_direction
			if mobile_movement != Vector2.ZERO:
				velocity += -actual_speed * transform.basis.z * mobile_movement.y
				velocity += actual_speed * transform.basis.x * mobile_movement.x
		else:
			if Input.is_action_pressed("move_forward"):
				velocity += -actual_speed * transform.basis.z
			if Input.is_action_pressed("move_back"):
				velocity += actual_speed * transform.basis.z
			if Input.is_action_pressed("move_right"):
				velocity += actual_speed * transform.basis.x
			if Input.is_action_pressed("move_left"):
				velocity += -actual_speed * transform.basis.x
		if Input.is_action_pressed("crouch"):
				$CollisionShape.shape.height = lerp(currentHeight, 1.0, min(1.0, delta * CROUCH_SPEED))
		else:
			$CollisionShape.shape.height = lerp(currentHeight, 2.0, min(1.0, delta * CROUCH_SPEED))
		if is_on_floor() and Input.is_action_pressed("jump") and currentHeight > 1.95:
				vy += jump_speed
	
	if velocity == Vector3.ZERO and vy < 0 and is_on_floor() and safe_positions[-1] != position and position.y > 0:
		safe_positions.append(position)
		if len(safe_positions) > 5:
			safe_positions.remove_at(0)
	velocity.y = vy
	
	# Camera panning keys
	
	if is_controlling_character():
		var turn_left = Input.is_action_pressed("turn_left")
		var turn_right = Input.is_action_pressed("turn_right")
		if turn_left != turn_right:
			if turn_left:
				rotate_y(-lerp(0.0, spin, -0.25))
			elif turn_right:
				rotate_y(-lerp(0.0, spin, 0.25))
		var look_up = Input.is_action_pressed("look_up")
		var look_down = Input.is_action_pressed("look_down")
		if look_up != look_down and abs($Camera.rotation.x) + spin < max_camera_angle:
			if look_up:
				rotateCameraX(spin, -0.25)
			elif look_down:
				rotateCameraX(spin, 0.25)
	if mobile_ui and OS.has_feature("mobile") and is_controlling_character():
		var camera_input = mobile_ui.camera_direction
		if camera_input != Vector2.ZERO:
			# Apply camera movement
			rotate_y(-camera_input.x * 0.02)
			rotateCameraX(0.02, camera_input.y)

func _unhandled_input(event):
	if OS.has_feature("mobile"):
		return
	
	if event is InputEventMouseMotion and is_controlling_character():
		moveMouse(event.relative)

func moveMouse(relative: Vector2):
	relative *= 0.5
	if relative.x > 0:
		rotate_y(-lerp(0.0, spin, relative.x / 10))
	elif relative.x < 0:
		rotate_y(-lerp(0.0, spin, relative.x / 10))
	if relative.y > 0.0 or relative.y < 0.0:
		rotateCameraX(spin, relative.y / 10)

func _process(_delta):
	if is_controlling_character():
		if OS.has_feature("mobile"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if holding:
		holding.global_transform = Transform3D()
		if Input.is_action_just_pressed("hold_interact"):
			drop()
	
	if mobile_ui and OS.has_feature("mobile") and is_controlling_character():
		var camera_input = mobile_ui.camera_direction
		if camera_input != Vector2.ZERO:
			# Apply camera movement
			rotate_y(-camera_input.x * 0.02)
			rotateCameraX(0.02, camera_input.y)


func _ready():
	current = self
	ProximityPrompt.camera.queue_free()
	ProximityPrompt.camera = $Camera

var elapsed = 0
func _physics_process(delta):
	velocity += gravity * delta
	if position.y < -10 and len(safe_positions) > 0:
		position = safe_positions[0]
		safe_positions.remove_at(0)
	get_input(delta)
	set_velocity(velocity)
	set_up_direction(Vector3.UP)
	move_and_slide()

	elapsed += delta
