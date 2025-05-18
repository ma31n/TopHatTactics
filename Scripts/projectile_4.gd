extends CharacterBody2D
var damage;
var pierce = false;
func _ready():
	pass
func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("default")
	
	var enemies = $Projectile.get_overlapping_bodies()
	var en=null;
	for enemy in enemies:
		en = enemy
	
	if(en!=null):
		self.position = en.get_parent().global_position

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	$Projectile.monitoring=false;
	$Projectile.monitorable=false;
