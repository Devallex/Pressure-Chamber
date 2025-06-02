extends Control

signal changed(amount: float)

@export var mol_range: NumberRange = NumberRange.new(0.0, 10000.0)
@export var step: float = 0.1
@export var gas: Gas

func _ready() -> void:
	if not gas:
		return
	%Label.text = "%s (%s)" % [gas.name, gas.symbol]
	%Amount.value_changed.connect(changed.emit)

func _process(delta: float) -> void:
	%Amount.min_value = mol_range.min
	%Amount.max_value = mol_range.max
	%Amount.step = step
	%Moles.text = "%.2f Moles" % %Amount.value
