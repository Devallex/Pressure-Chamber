extends Panel

var in_dialog: bool = false
var current_dialog: Control

func hide_dialog():
	if current_dialog:
		current_dialog.hide()
		current_dialog = null
		in_dialog = false
		hide()

func show_dialog(dialog: Control):
	hide_dialog()
	current_dialog = dialog
	current_dialog.show()
	var parent: Node = dialog.get_parent()
	if parent != self:
		parent.remove_child(dialog)
		add_child(dialog)
	in_dialog = true
	show()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit_dialog") and in_dialog:
		hide_dialog()

func bind_dialog(prompt: ProximityPrompt, dialog: Control):
	dialog.hide()
	prompt.triggered.connect(func():
		if current_dialog == dialog:
			hide_dialog()
		else:
			show_dialog(dialog)
	)

func _ready() -> void:
	hide()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	set_anchor_and_offset(SIDE_LEFT, 0.2, 0)
	set_anchor_and_offset(SIDE_TOP, 0.2, 0)
	set_anchor_and_offset(SIDE_RIGHT, 0.8, 0)
	set_anchor_and_offset(SIDE_BOTTOM, 0.8, 0)
