extends Node2D

@export var gases: Dictionary[Gas, float] = {
	Gasses.get_by_name("Hydrogen"): 0.1,
	Gasses.get_by_name("Helium"): 0.2
}
