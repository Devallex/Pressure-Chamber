extends Node

@onready var camera = get_viewport().get_camera_3d()

var is_mouse_down: bool = false
var focused_node: Node3D

#func _process(delta: float) -> void:
	#var new_focused_node
	#
	#if new_focused_node

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var ray = RayCast3D.new()
				if focused_node and focused_node.has_method("click_down"):
					focused_node.call_deferred("click_down")
			else:
				if focused_node and focused_node.has_method("click_up"):
					focused_node.call_deferred("click_up")
