extends CharacterBody2D


@export var speed = 500;
var damage;
var pierce = false;
var lastobj = null;
var targeted = null;

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	var areas = $Projectile.get_overlapping_areas()
	for area in areas:
		if("Enemy" in area.get_parent().name and pierce==false):
			if(area.get_parent()!=lastobj and area.get_parent()==targeted):
				queue_free()
		elif("Enemy" in area.get_parent().name and pierce==true):
			if(area.get_parent()!=lastobj and area.get_parent()==targeted):
				var group = get_tree().get_nodes_in_group("alive")
				for i in range(0,len(group)-1):
					if(group[i]==area.get_parent() and area.get_parent().enemies[area.get_parent().name][2]==0):
						var dir = self.position.direction_to(group[i-1].get_parent().global_position)
						enemyposition(dir)
						pierce=false
						lastobj=group[i]
						break

func enemyposition(pos: Vector2):
	velocity = pos*speed*Global.gamestate

func target(t):
	targeted=t;
