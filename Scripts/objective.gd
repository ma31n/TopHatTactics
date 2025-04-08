extends CharacterBody2D

var carrying = null;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var areas = $Objective.get_overlapping_areas();
	if(len(areas)>0):
		for area in areas:
			if "Enemy" in area.get_parent().name:
				carrying=area.get_parent()
				break
	else:
		carrying = null;
