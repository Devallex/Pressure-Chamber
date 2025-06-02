extends Node3D

@export var gases: Dictionary[Gas, float] = {}

@onready var prompt: ProximityPrompt = %ProximityPrompt
@onready var dialog: Control = %GasDialog

func _ready() -> void:
	Dialog.bind_dialog(prompt, dialog)

func _process(delta: float) -> void:
	gases = dialog.gases
