extends Control

func _ready():

	var scroll_container = ScrollContainer.new()
	var label = RichTextLabel.new()

	add_child(scroll_container)
	scroll_container.add_child(label)

	scroll_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	label.bbcode_enabled = true
	label.text = """
[center][b]Manual[/b][/center]
"""

func dialog_shown():
	print("Manual opened")

func dialog_hidden():
	print("Manual closed")

func _input(event):
	if event.is_action_pressed("manual"):
		Dialog.show_dialog(self)
		
