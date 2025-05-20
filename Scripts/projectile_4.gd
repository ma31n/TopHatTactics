extends CharacterBody2D
var damage;
var pierce = false;
var target = null;
var en=null;
func _ready():
	pass
func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("default")
	
	if($Projectile.monitorable==true):
		var enemies = $Projectile.get_overlapping_bodies()
		for enemy in enemies:
			en = enemy
			break;
		
	if(en!=null):
		self.position = en.get_parent().global_position
		target = en;

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	$Projectile.monitoring=false;
	$Projectile.monitorable=false;
