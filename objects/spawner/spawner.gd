extends Node3D

func _calculate_disabled() -> void:
	%ProximityPrompt.disabled = len(%PlaceSlot.get_overlapping_bodies()) > 0

func spawn() -> void:
	%ProximityPrompt.disabled = true
	var ball = load("res://objects/ball/ball.tscn").instantiate()
	get_parent().add_child.call_deferred(ball)
	ball.global_transform = %Spawn.global_transform

func _ready() -> void:
	%ProximityPrompt.triggered.connect(spawn)
	
	#%PlaceSlot.body_entered.connect(_calculate_disabled)
	#%PlaceSlot.body_exited.connect(_calculate_disabled)
	
	spawn()

func _process(_delta: float) -> void:
	_calculate_disabled()
