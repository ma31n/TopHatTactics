extends CharacterBody2D

var speed = 100;
var op = 1.0
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	rotate(deg_to_rad(12));
	if(op>0):
		$Sprite2D.modulate=Color(Color.WHITE,op)
		op-=0.1;
	else:
		queue_free()
	
	move_and_slide()

func pos(p):
	velocity=p*speed;
