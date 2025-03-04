extends PathFollow2D

var speed = 0.001
var stun = 1
var slow = 1;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loop=false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	progress_ratio += speed*Global.gamestate*stun*slow;
	
