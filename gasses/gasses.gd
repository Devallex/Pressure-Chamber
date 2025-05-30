extends Node

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

#func get_by_symbol(symbol: String)
	#for gas in gasses:
		#gas
