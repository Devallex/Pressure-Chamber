extends Node

func _process(delta: float) -> void:
	for cached: Cached in Cached.instances:
		cached._process(delta)
