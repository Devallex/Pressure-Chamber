extends Node3D

func _process(delta: float) -> void:
	var bodies = %Area3D.get_overlapping_bodies()
	var selected_body = null
	for body in bodies:
		if body is PressureAtmosphere:
			selected_body = body
			break
	
	if selected_body:
		if %Iigs.found:
			selected_body.gases = %Iigs.gases
		else:
			%Iigs.gases = selected_body.gases
	elif %Iigs.found:
		#%Iigs.gases = {}
		pass
	
	%Iigs.found = selected_body != null
