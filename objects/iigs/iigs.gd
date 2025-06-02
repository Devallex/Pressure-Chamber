extends Node3D

@export var gases: Dictionary[Gas, float] = {}
@export var found: bool = true

@onready var prompt: ProximityPrompt = %ProximityPrompt
@onready var dialog: Control = %GasDialog

func _ready() -> void:
	Dialog.bind_dialog(prompt, dialog)

func _process(delta: float) -> void:
	gases = dialog.gases
	
	dialog.found = found
