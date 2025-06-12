extends Node3D

func _process(delta: float) -> void:
	var bodies = %PlaceSlot.get_overlapping_bodies()
	var selected_body = null
	for body: Node3D in bodies:
		if body.get("atmosphere"):
			selected_body = body
			break
	
	if selected_body:
		if %Iigs.found:
			selected_body.atmosphere.gases = %Iigs.gases
		else:
			%Iigs.gases = selected_body.atmosphere.gases
	elif %Iigs.found:
		#%Iigs.gases = {}
		pass
	
	%Iigs.found = selected_body != null
