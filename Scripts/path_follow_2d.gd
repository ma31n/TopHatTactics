extends PathFollow2D

var speed = 0.001
var stun = 1
var slow = 1;
var dir = 1;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loop=false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	progress_ratio += dir*speed*Global.gamestate*stun*slow;
	
	if(progress_ratio>=1):
		dir=-1;
	

func direction(new_dir):
	dir=new_dir;
