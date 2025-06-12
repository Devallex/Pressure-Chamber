extends Node3D

func _ready() -> void:
	var place_slot: Area3D = %PlaceSlot
	place_slot.body_entered.connect(func(body):
		var parent = body.get_parent_node_3d()
		if parent is PressureBody:
			parent.disabled_pickup = true
			
			var tween = body.create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(body, "global_position", body.global_position - Vector3(0, 2.0 ,0), 0.5)
			tween.finished.connect(func():
				body.get_parent_node_3d().queue_free()
			)
			tween.play()
		elif body is Character:
			body.global_transform = %Out.global_transform
	)
