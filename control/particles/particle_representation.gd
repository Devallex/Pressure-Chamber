extends Node2D

@export var particle_count: int = 10
@export var radius_range: Vector2 = Vector2(10.0, 20.0)

@export var gases: Dictionary[Gas, float] = {}

var particles_by_gases: Dictionary[Gas, Array] = {}
var all_particles: Array[Particle] = []

var particle_scene: PackedScene = preload("res://control/particles/particle.tscn")

func create_and_remove_particles():
	var mol_sum: float = 0.0
	var max_radius: float = 0.0
	var min_radius: float = INF
	for gas: Gas in gases.keys():
		var moles = gases[gas]
		mol_sum += moles

		if gas.vdw_radius > max_radius:
			max_radius = gas.vdw_radius
		if gas.vdw_radius < min_radius:
			min_radius = gas.vdw_radius

	for gas: Gas in gases.keys():
		var moles = gases[gas]
		var mol_fraction = moles / mol_sum
		var gas_particle_count = floori(mol_fraction * particle_count)
		var particle_radius = lerp(radius_range.x, radius_range.y, inverse_lerp(min_radius, max_radius, gas.vdw_radius))
		if is_nan(particle_radius):
			particle_radius = radius_range.x
		
		if not gas in particles_by_gases:
			particles_by_gases[gas] = []
		var particles_by_gas: Array = particles_by_gases[gas]
		
		var particles_until_full = gas_particle_count - len(particles_by_gas)
		
		while particles_until_full != 0:
			if particles_until_full > 0:
				var particle: Particle = particle_scene.instantiate()
				particle.color = gas.color
				particle.label = gas.symbol
				
				particles_by_gas.append(particle)
				%Particles.add_child(particle)
				all_particles.append(particle)
				
				particles_until_full -= 1
			elif particles_until_full < 0:
				var particle: Particle = particles_by_gas.pick_random()
				particles_by_gas.remove_at(particles_by_gas.find(particle))
				all_particles.remove_at(all_particles.find(particle))
				particle.queue_free()
				
				particles_until_full += 1
		
		for particle: Particle in particles_by_gas:
			particle.radius = particle_radius

var base_positions: Dictionary[StaticBody2D, Vector2]
func _ready() -> void:
	create_and_remove_particles()
	
	for border: StaticBody2D in [%Top, %Left, %Bottom, %Right]:
		base_positions[border] = border.position
		border.position = base_positions[border] * get_viewport_rect().size
		
	get_viewport().size_changed.connect(func (): 
		for border: StaticBody2D in [%Top, %Left, %Bottom, %Right]:
			border.position = base_positions[border] * get_viewport_rect().size
		)


func set_frozen(frozen: bool):
	for particle: Particle in all_particles:
		particle.freeze = frozen
