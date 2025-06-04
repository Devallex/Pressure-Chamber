extends Control

func dialog_shown():
	print("Manual opened")

func dialog_hidden():
	print("Manual closed")

func _input(event):
	if event.is_action_pressed("manual"):
		Dialog.toggle_dialog(self)
		
