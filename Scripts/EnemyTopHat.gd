extends CharacterBody2D

var enemies = {
	"EnemyTopHat": [5, 0.001, 0],
	"EnemyHardHat": [10, 0.0005, 0],
	"EnemyPropellerHat": [6, 0.0015, 1],
	"EnemyJesterHat": [7, 0.0011, 0],
	"EnemyFootballHat": [12, 0.0013, 0] ,
	"EnemyCrownHat": [100, 0.0005, 0]
}
var health;
var speed;
var lastproj=null;

var stun = false;
var stun_length;
var slowdown = false;
var slow_length=0.8;

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	for name in enemies.keys():
		if name==self.name:
			health = enemies[name][0]
			speed = enemies[name][1]

func _physics_process(delta: float) -> void:
	death()
	
	if stun==true and $Stun.is_stopped() and enemies[self.name][2]!=1:
		if(self.name!="EnemyJesterHat"):
			$Stun.start(stun_length)
			get_parent().stun=0

	var areas = $Area2D.get_overlapping_areas()
	for area in areas:
		if area.name == "Projectile":
			if(area.get_parent()!=lastproj):
				$AudioStreamPlayer2D.stream=load("res://SFX/EnemyHurt1.ogg")
				$AudioStreamPlayer2D.play()
				health=health-area.get_parent().damage
				lastproj=area.get_parent()
				if(health<=0):
					Global.MP+=20
					get_parent().queue_free()

		
		if area.name == "Objective":
			area.get_parent().position = global_position


func _on_stun_timeout() -> void:
	stun=false;
	if slowdown==true:
		$Slow.start()
		get_parent().slow=0.5
	get_parent().stun=1;

func _on_slow_timeout() -> void:
	slowdown=false;
	get_parent().slow=1

func death():
	var areas = $Area2D.get_overlapping_areas()
	for area in areas:
		if area.name=="death":
			#Global.MP=Global.MP-50
			get_parent().queue_free()
