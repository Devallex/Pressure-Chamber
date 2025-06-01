extends Panel

@export var chamber: PressureChamber

var format_string: String = """— [ Pressure Chamber Overview ] —

— Status —
Hermetically sealed: %s
Object count: %d

— Actual Atmosphere —
In sync with external atmosphere: %s
Temperature: %.2f

— Target Atmosphere —
Temperature: %.2f
"""

func _process(delta: float) -> void:
	%Label.text = format_string % [
		not chamber.door_open,
		len(chamber.bodies),
		"<TODO>",
		chamber.atmosphere.temperature,
		chamber.target_atmosphere.temperature
	]
