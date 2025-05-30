extends Node2D

@export var gases: Dictionary[Gas, float] = {
	Gasses.get_by_name("Hydrogen"): 0.1,
	Gasses.get_by_name("Helium"): 0.2
}
func _ready():
	var boundary: Area2D = %Boundary
	boundary.body_exited.connect(func(particle):
		print("it left")
	)
