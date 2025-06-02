extends Control

func _process(delta: float) -> void:
	%FPS.text="FPS %s" % (Engine.get_frames_per_second())
