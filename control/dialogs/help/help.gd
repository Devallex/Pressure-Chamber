extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("help_menu"):
		Dialog.toggle_dialog(self)
