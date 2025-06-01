extends Node3D

@export var set_temperature: float = 273
@export var min_temperature: float = 0.01
@export var max_temperature: float = 2000

@onready var prompt := %SetPrompt
@onready var dialog := %TemperatureDialog

func _ready() -> void:
	Dialog.bind_dialog(prompt, dialog)
	_update()

func _process(delta: float) -> void:
	_update()
	
func _update() -> void:
	dialog.min_temperature = min_temperature
	dialog.max_temperature = max_temperature
	set_temperature = dialog.set_temperature
