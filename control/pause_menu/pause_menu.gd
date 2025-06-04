extends Control

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Dialog.toggle_dialog(self)
