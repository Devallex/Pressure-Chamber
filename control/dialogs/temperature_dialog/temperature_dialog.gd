extends VBoxContainer

@export var set_temperature: float = 573
@export var min_temperature: float = 573
@export var max_temperature: float = 1773

@onready var slider := %Slider
@onready var label := %Label

func _ready() -> void:
	slider.min_value = min_temperature
	slider.max_value = max_temperature
	slider.value = set_temperature

func _process(delta: float) -> void:
	slider.min_value = min_temperature
	slider.max_value = max_temperature
	
	set_temperature = slider.value
	
	label.text = """— [Temperature Select] —
	Set Temperature: %.2f Kelvins
	
	— INFO —
	Min Temperature: %.2f Kelvins
	Max Temperature: %.2f Kelvins
	""" % [set_temperature, min_temperature, max_temperature]
