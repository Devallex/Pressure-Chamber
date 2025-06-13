extends Node3D

@export_multiline var text: String = ""
@export var color: Color = Color("ffffff")

func _ready() -> void:
	%Text.text = text
	%Sprite3D.modulate = color
