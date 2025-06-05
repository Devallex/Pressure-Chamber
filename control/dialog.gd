extends Panel

var in_dialog: bool = false
var current_dialog: Control

var dialog_parent: Control

func hide_dialog():
	if current_dialog:
		current_dialog.hide()
		if current_dialog.has_method("dialog_hidden"):
			current_dialog.call_deferred("dialog_hidden")
		current_dialog = null
		in_dialog = false
		hide()

func show_dialog(dialog: Control):
	hide_dialog()
	current_dialog = dialog
	current_dialog.show()
	if dialog.has_method("dialog_shown"):
		dialog.call_deferred("dialog_shown")
	var parent: Node = dialog.get_parent()
	if parent != self:
		parent.remove_child(dialog)
		dialog_parent.add_child(dialog)
	in_dialog = true
	show()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit_dialog") and in_dialog:
		hide_dialog()

func bind_dialog(prompt: ProximityPrompt, dialog: Control):
	dialog.hide()
	if dialog.has_method("dialog_hidden"):
		dialog.call_deferred("dialog_hidden")
	prompt.triggered.connect(func():
		if current_dialog == dialog:
			hide_dialog()
		else:
			show_dialog(dialog)
	)

func toggle_dialog(dialog: Control):
	if current_dialog == dialog:
		hide_dialog()
	else:
		show_dialog(dialog)

func _ready() -> void:
	theme = load("res://control/theme.tres")
	dialog_parent = MarginContainer.new()
	dialog_parent.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(dialog_parent)
	mouse_filter = Control.MOUSE_FILTER_PASS
	hide()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	set_anchor_and_offset(SIDE_LEFT, 0.2, 0)
	set_anchor_and_offset(SIDE_TOP, 0.2, 0)
	set_anchor_and_offset(SIDE_RIGHT, 0.8, 0)
	set_anchor_and_offset(SIDE_BOTTOM, 0.8, 0)
