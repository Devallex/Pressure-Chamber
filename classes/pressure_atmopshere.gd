class_name PressureAtmosphere extends Node3D

@export var atmosphere: PressureAtmosphere = GlobalAtmosphere
@export var pressure: float = 1.0
@export var temperature: float = 273.15
@export var volume: float = 1.0

@export var gases: Dictionary[Gas, float] = {}

func _ready() -> void:
	add_to_group("presusre_atmosphere")

func _process(_delta: float) -> void:
	_update_pressure()

func _update_pressure() -> void:
	var mol_sum = 0.0
	for gas: Gas in gases.keys():
		var moles = gases[gas]
		mol_sum += moles
	
	# P = nRT/V
	#if mol_sum < 0.001:
		#pressure = 1e-10
	#else:
	if mol_sum == 0.0:
			
		pass
	pressure = mol_sum  * 0.0821 * temperature / volume
