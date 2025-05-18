extends CharacterBody2D

var enemies = {
	"EnemyPilotHat":[10, 0.001, 0, 20]
}
var health = 10;
var speed = 0.001;
var path;
var lastproj=null;

var stun = false;
var stun_length;
var slowdown = false;
var slow_length=0.8;

var tween=create_tween();
var fall=350

func _ready() -> void:
	$AnimatedSprite2D.play("flying")

	path = self.get_parent()
	path.progress_ratio=randf_range(0.3,0.6);
	path.speed=0
	path.position.y=path.position.y-fall
	sway()

func _physics_process(delta: float) -> void:
	falling()
	death()
	if(fall==0):
		tween.stop()
		self.rotation_degrees=0;
		path.speed=speed;
		$AnimatedSprite2D.offset.y=0
		$AnimatedSprite2D.play("walking")
		
	if stun==true and $Stun.is_stopped():
		$Stun.start(stun_length/Global.gamestate);
		get_parent().stun=0

	var areas = $Area2D.get_overlapping_areas()
	for area in areas:
		if area.name == "Projectile":
			if(area.get_parent()!=lastproj):
				$AudioStreamPlayer2D.stream=load("res://SFX/HatPlace.ogg")
				$AudioStreamPlayer2D.play()
				health=health-area.get_parent().damage
				lastproj=area.get_parent()
				if(health<=0):
					Global.MP+=enemies[name][3];
					get_parent().queue_free()

		
		if area.name == "Objective":
			area.get_parent().position = global_position

func sway():
	tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(self, "rotation_degrees", 15, 1);
	tween.tween_property(self, "rotation_degrees", -15, 1);
	tween.set_loops(100)
func falling():
	if(fall>0):
		path.position.y=path.position.y-fall
		fall-=1


func _on_stun_timeout() -> void:
	stun=false;
	if slowdown==true:
		$Slow.start(slow_length/Global.gamestate)
		get_parent().slow=0.5
	get_parent().stun=1;


func _on_slow_timeout() -> void:
	slowdown=false;
	get_parent().slow=1

func death():
	var areas = $Area2D.get_overlapping_areas()
	for area in areas:
		if area.name=="death":
			Global.MP=Global.MP-50
			get_parent().queue_free()
