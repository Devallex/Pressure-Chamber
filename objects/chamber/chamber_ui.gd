extends Panel

@export var chamber: PressureChamber

var format_string: String = """— [ Pressure Chamber Overview ] —

— Status —
Hermetically sealed: %s
Object count: %d

Volume: %.2f Liters

— Actual Atmosphere —
In sync with external atmosphere: %s
Pressure: %.2f
Temperature: %.2f

— Target Atmosphere —
Pressure: %.2f
Temperature: %.2f
"""

func _process(delta: float) -> void:
	%Label.text = format_string % [
		not chamber.door_open,
		len(chamber.bodies),
		chamber.volume,
		"<TODO>",
		chamber.atmosphere.pressure,
		chamber.atmosphere.temperature,
		chamber.target_atmosphere.pressure,
		chamber.target_atmosphere.temperature
	]
