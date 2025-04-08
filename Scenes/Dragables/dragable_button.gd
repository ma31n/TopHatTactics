extends TextureButton

func _ready() -> void:
	pass


func _on_pressed() -> void:
	if(Global.MP>=50):
		$MenuSFX.play()
		var turret = ResourceLoader.load("res://Scenes/Turrets/"+self.name+".tscn").instantiate()
		turret.position=get_global_mouse_position()
		turret.z_index=5;
		Global.cancel=true;
		$"../../".add_child(turret)
		
