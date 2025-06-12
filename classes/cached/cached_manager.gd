extends Node

func _process(delta: float) -> void:
	for cached: Cached in all_cached:
		cached._process(delta)

var all_cached: Array[Cached]
func register(cached: Cached) -> void:
	all_cached.append(cached)
