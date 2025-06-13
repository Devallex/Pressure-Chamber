class_name Cached extends Resource

## Behavior for caching resource intensive values and recalculating at larger time intervals to save preformance.

static var instances: Array[Cached] = []

signal calculate ## A request for set_value(...) to be called
signal updated(value: Variant) ## When the value has changed

## The time until a new calculation must happen.
## If interval is -1, process being called will not do anything.
## process(delta) must be called by a node for this to work.
@export var interval: float = -1.0

## Multiplied by all intervals to increase or decrease all preformance globally.
static var global_interval_scalar: float = 1.0

@export var emit_update_when_identical: bool = false

var value: Variant

var time_since_last_update: float = 0.0

## Calculate emitted immediatley after starting, even with the default value passed
func _init(_value: float, _interval: float = interval) -> void:
	value = _value
	interval = _interval
	calculate.emit()
	instances.append(self)

func add_calculate_callback(callback: Callable) -> void:
	calculate.connect(callback)
	calculate.emit()

## Called automatically by CachedManager
func _process(delta: float) -> void:
	if interval == -1.0:
		return
	
	time_since_last_update += delta
	
	if time_since_last_update >= interval * global_interval_scalar:
		get_value_forced()
		time_since_last_update = 0.0

## Changes the value by an external source.
## The connection to the calculate signal should call this.
func set_value(_value: Variant) -> void:
	value = _value
	if emit_update_when_identical or value != _value:
		updated.emit(value)

## Returns the value, which may be eiwther cached or recalculated.
func get_value() -> Variant:
	if interval == -1.0 or time_since_last_update >= interval * global_interval_scalar:
		return get_value_forced()
	return value

## Returns the value, without recalculating it, even if it's outdated
func get_value_cached() -> Variant:
	return value

## Returns thee value, always recalculating it, even if it's just been changed
func get_value_forced() -> Variant:
	calculate.emit()
	return value
