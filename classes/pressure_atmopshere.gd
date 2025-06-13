class_name PressureAtmosphere extends Node3D

@export var atmosphere: PressureAtmosphere = GlobalAtmosphere
@export var pressure: float = 1.0
@export var temperature: float = 273.15
@export var volume: float = 1.0
@export var gases: Dictionary[Gas, float] = {}

var vdw_pressure := Cached.new(0.0, 0.5)
func _calculate_vdw_pressure():
	# Get system values once to avoid repeated calculations
	
	# Gas constant R (adjust units based on your system)
	# R = 8.314 J/(mol·K) = 0.08314 L·bar/(mol·K)
	const R = 0.08314  # L·bar/(mol·K)
	
	var total_pressure = 0.0
	var total_moles = 0.0
	var mixed_a = 0.0  # For gas mixture van der Waals 'a' parameter
	var mixed_b = 0.0  # For gas mixture van der Waals 'b' parameter
	
	# Calculate total moles first
	for gas_moles in gases.values():
		total_moles += gas_moles
	
	if total_moles == 0.0:
		vdw_pressure.set_value(0.0)
	
	# For gas mixtures, calculate effective a and b parameters
	# Using mixing rules: a_mix = Σ Σ x_i * x_j * sqrt(a_i * a_j)
	# b_mix = Σ x_i * b_i
	
	var mole_fractions = {}
	for gas in gases.keys():
		mole_fractions[gas] = gases[gas] / total_moles
	
	# Calculate mixed b parameter (linear mixing rule)
	for gas in gases.keys():
		mixed_b += mole_fractions[gas] * gas.vdw_b
	
	# Calculate mixed a parameter (geometric mixing rule)
	for gas_i in gases.keys():
		for gas_j in gases.keys():
			mixed_a += mole_fractions[gas_i] * mole_fractions[gas_j] * sqrt(gas_i.vdw_a * gas_j.vdw_a)
	
	# Calculate van der Waals pressure
	# P = nRT/(V - nb) - an²/V²
	var ideal_term = (total_moles * R * temperature) / (volume - total_moles * mixed_b)
	var correction_term = (mixed_a * total_moles * total_moles) / (volume * volume)
	
	total_pressure = ideal_term - correction_term
	
	vdw_pressure.set_value(total_pressure)

func _ready() -> void:
	vdw_pressure.add_calculate_callback(_calculate_vdw_pressure)
	add_to_group("presusre_atmosphere")
	
	vdw_pressure.changed.connect(func(pressure: float):
		print(pressure)
	)

func _process(delta: float) -> void:
	_update_pressure()

func get_pressure() -> float:
	return pressure

func get_temperature() -> float:
	return temperature

func get_volume() -> float:
	return volume

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
