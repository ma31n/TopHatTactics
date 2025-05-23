extends CharacterBody2D

var enemies = {
	"EnemyTopHat": [5, 0.001, 0, 10], #HEALTH, SPEED, AIRVIS, MONEY
	"EnemyTopHatSpeedy": [6, 0.00125, 0, 10],
	"EnemyHardHat": [12, 0.0008, 0, 10],
	"EnemyHardHatBlue": [32, 0.0007, 0, 20],
	"EnemyPropellerHat": [6, 0.0014, 1, 10],
	"EnemyJesterHat": [7, 0.0008, 0, 10],
	"EnemyFootballHat": [20, 0.0013, 0, 20],
	"EnemyCrownHat": [200, 0.0009, 0],
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
			$Stun.start(stun_length/Global.gamestate)
			get_parent().stun=0

	var areas = $Area2D.get_overlapping_areas()
	#if(self.name=="EnemyJesterHat"):
		#areas = $AOE.get_overlapping_areas()
	for area in areas:
		if area.name == "Projectile":
			if(area.get_parent().name=="projectile_4"):
				if(area.get_parent().target==null):
					area.get_parent().target=self
				elif(area.get_parent().target!=self):
					continue
				
			if(area.get_parent()!=lastproj):
				
				$AudioStreamPlayer2D.stream=load("res://SFX/EnemyHurt1.ogg")
				$AudioStreamPlayer2D.play()
				health=health-area.get_parent().damage
				lastproj=area.get_parent()
				if(health<=0):
					Global.MP+=enemies[name][3]
					get_parent().queue_free()
					

		
		if area.name == "Objective":
			if(area.get_parent().carrying==null or area.get_parent().carrying==self):
				area.get_parent().position = global_position
				self.get_parent().speed=0.0007;
				
				var path: PathFollow2D = self.get_parent()
				if(path.progress_ratio<0.5):
					path.direction(-1)
				


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
	pass
	#var areas = $Area2D.get_overlapping_areas()
	#for area in areas:
		#if area.name=="death":
			#Global.MP=Global.MP-50
			#get_parent().queue_free()

func _draw() -> void:
	if(self.name=="EnemyJesterHat"):
		draw_circle(Vector2(0,0),$AOE/CollisionShape2D.shape.radius,Color(255,255,0,0.1));
