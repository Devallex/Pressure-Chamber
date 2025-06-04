extends Control

signal changed(amount: float)

@export var mol_range: NumberRange = NumberRange.new(0.0, 1000.0)
@export var step: float = 0.1
@export var gas: Gas

var current_amount: float = 0.0

func _ready() -> void:
	if not gas:
		return
	%Label.text = "%s (%s)" % [gas.name, gas.symbol]
	%Amount.value_changed.connect(func(amount: float):
		if amount == current_amount:
			return
		current_amount = amount
		%WrittenAmount.text = str(amount)
		changed.emit(amount)
	)
	%WrittenAmount.text_changed.connect(func(amount: String):
		if float(amount) == current_amount:
			return
		current_amount = float(amount)
		%Amount.value = current_amount
		changed.emit(current_amount)
	)

func _process(delta: float) -> void:
	%Amount.min_value = mol_range.min
	%Amount.max_value = mol_range.max
	%Amount.step = step
	#%Moles.text = "%.2f Moles" % %Amount.value
