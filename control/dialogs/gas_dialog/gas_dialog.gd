extends Control

func _process(delta: float) -> void:
	%SubViewport.size_2d_override = %Particles.size
	
var gases: Dictionary[Gas, float]

func _ready() -> void:
	for gas in Gases.gasses:
		var entry = load("res://control/dialogs/gas_dialog/gas_entry.tscn").instantiate()
		entry.gas = gas
		entry.changed.connect(func(moles: float):
			gases[gas] = moles
			%ParticleRepresentation.gases = gases
			%ParticleRepresentation.create_and_remove_particles()
		)
		%Gases.add_child(entry)
	%ParticleRepresentation.create_and_remove_particles()
	
	%ParticleCount.value_changed.connect(func(new_particle_count: int):
		%ParticleRepresentation.particle_count = new_particle_count
		%ParticleRepresentation.create_and_remove_particles()
	)

func dialog_shown() -> void:
	#%ParticleRepresentation.set_frozen(false)
	%ParticleRepresentation.particle_count = %ParticleCount.value

func dialog_hidden() -> void:
	#%ParticleRepresentation.set_frozen(true)
	%ParticleRepresentation.particle_count = 0
