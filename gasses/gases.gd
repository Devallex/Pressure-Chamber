extends Node

func get_by_symbol(symbol: String): 
	for gas in gasses:
		if gas.symbol == symbol:
			return gas
	return null

func get_by_name(name: String): 
	for gas in gasses:
		if gas.name == name:
			return gas
	return null


var gasses: Array[Gas] = [
	Gas.new({
		"name" = "Helium",
		"symbol" = "He",
		"atomic_mass" = 4.0026,
		"vdw_radius" = 140,
		"vdw_a" = 0.0346,
		"vdw_b" = 0.0238,
		"color" = Color.ORANGE
	}),
	Gas.new({
		"name" = "Neon",
		"symbol" = "Ne",
		"atomic_mass" = 20.179701,
		"vdw_radius" = 154,
		"vdw_a" = 0.2135,
		"vdw_b" = 0.01709,
		"color" = Color.ORANGE_RED
	}),
	Gas.new({
		"name" = "Argon",
		"symbol" = "Ar",
		"atomic_mass" = 39.948002,
		"vdw_radius" = 188,
		"vdw_a" = 1.355,
		"vdw_b" = 0.03201,
		"color" = Color.LAVENDER
	}),
	Gas.new({
		"name" = "Krypton",
		"symbol" = "Kr",
		"atomic_mass" = 83.797997,
		"vdw_radius" = 202,
		"vdw_a" = 2.349,
		"vdw_b" = 0.03978,
		"color" = Color.LIGHT_STEEL_BLUE
	}),
	Gas.new({
		"name" = "Xenon",
		"symbol" = "Xe",
		"atomic_mass" = 131.292999,
		"vdw_radius" = 216,
		"vdw_a" = 4.250,
		"vdw_b" = 0.05105,
		"color" = Color.BLUE
	}),
	Gas.new({
		"name" = "Radon",
		"symbol" = "Rn",
		"atomic_mass" = 222.000000,
		"vdw_radius" = 220,
		"vdw_a" = 6.601,
		"vdw_b" = 0.06239,
		"color" = Color.RED
	})
]
