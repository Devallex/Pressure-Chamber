extends VBoxContainer

@export_multiline var text: String = ""

@onready var button: CheckBox = %Button

func _ready() -> void:
	%Text.text = text
	button.toggled.connect(func(toggled_on: bool):
		if toggled_on:
			%Text.text = "[i][s][color=#888888]%s[/color][/s][/i]" % text
		else:
			%Text.text = text
	)
