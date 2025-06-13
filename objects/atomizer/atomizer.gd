extends Node3D

func _ready() -> void:
	var place_slot: Area3D = %PlaceSlot
	place_slot.body_entered.connect(func(body):
		var parent = body.get_parent_node_3d()
		if parent is PressureBody:
			parent.disabled_pickup = true
			
			var tween: Tween = body.create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(body, "global_transform", %In.global_transform, 0.35)
			tween.chain().tween_property(body, "global_transform", %Death.global_transform, 0.75)
			tween.finished.connect(func():
				body.get_parent_node_3d().queue_free()
			)
			tween.play()
		elif body is Character:
			body.global_transform = %Player.global_transform
	)
