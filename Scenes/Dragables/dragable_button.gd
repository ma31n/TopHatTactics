extends TextureButton

func _ready() -> void:
	pass


func _on_pressed() -> void:
	if(Global.MP>=50):
		Global.MP-=50
		var turret = ResourceLoader.load("res://Scenes/Turrets/"+self.name+".tscn").instantiate()
		turret.position=get_global_mouse_position()
		$"../".add_child(turret)
