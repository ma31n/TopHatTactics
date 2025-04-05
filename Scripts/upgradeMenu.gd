extends Control

var vp; 
var points = [
	Vector2(-100,-180), Vector2(80,-180), Vector2(100, -80), Vector2(10, 40), Vector2(-100, 60), Vector2(-300, 20), Vector2(-300, -80), Vector2(-250, -180) 
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vp = get_tree().current_scene.get_viewport_rect().size;
	self.connect("visibility_changed",calcPos)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func calcPos():
	var pos = self.global_position;
	if(self.position==Vector2(0,0)):
		for point in points:
			var temp_pos = pos+point;
			if(
				(temp_pos.y<0 and 0<temp_pos.y+size.y) 
				or (temp_pos.y<vp.y and vp.y<temp_pos.y+size.y) 
				or (temp_pos.x<0 and 0<temp_pos.x+size.x) 
				or (temp_pos.x<vp.x and vp.x<temp_pos.x+size.x)
				or (temp_pos.y<0 and 0>temp_pos.y+size.y)
				or (temp_pos.y>vp.y and vp.y<temp_pos.y+size.y)
				or (temp_pos.x<0 and 0>temp_pos.x+size.x)
				or (temp_pos.x>vp.x and vp.x<temp_pos.x+size.x)
			):
				pass
			else:
				self.position=point;
				break
