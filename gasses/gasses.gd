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
		"name" = "Hydrogen",
		"symbol" = "H",
		"atomic_mass" = 1.00794
	}),
	Gas.new({
		"name" = "Helium",
		"symbol" = "H",
		"atomic_mass" = 4.0026
	})
]
