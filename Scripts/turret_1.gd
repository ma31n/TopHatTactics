extends CharacterBody2D

var cooldown = 0.6;
var rdy = true;
@export var dropped = false;
var turret_level = 0
var damage = 1.5

var airvis = 0;
var pierce = false;
var tab;
var placeable = false;
var upgrade3 = false;

var tween: Tween=null;

var upgrades = [
	[
		{"price":20,"desc":"Longer range 1","state":0,"new":75},
		{"price":40,"desc":"Longer range 2", "state":0, "new": 85},
		{"price":60,"desc":"Ability to see air enemies."}
	],
	[
		{"price":20, "desc":"More damage 1","new":2},
		{"price":50, "desc": "More damage 2","new":2.5},
		{"price":100, "desc": "Piercing, half damage."}
	]
]
func _ready() -> void:
	$AudioStreamPlayer2D.stream=load("res://SFX/HatPlace.ogg")
	$AudioStreamPlayer2D.play()
	
	$Area2D/CollisionShape2D.shape = $Area2D/CollisionShape2D.shape.duplicate()
	
	_on_tab_container_tab_changed(0);

func _physics_process(delta: float) -> void:
	if(dropped==false):
		placement_check();
	
	tab = $Control/TabContainer.current_tab
	if(!$AnimatedSprite2D.is_playing()):
		$AnimatedSprite2D.play("idle")

	queue_redraw()

	stunning()

	if(Global.gamestate>0 and dropped==true and $StunTimer.is_stopped()):
		var in_range: Array = $Area2D.get_overlapping_bodies()
		
		if(in_range.size()>0):
			var target = in_range[0];
			if(airvis==1):
				for enemy in in_range:
					if(enemy.enemies[enemy.name][2]==1):
						target=enemy;
						break;
			
			if(rdy == true and airvis>=target.enemies[target.name][2]):
				$AnimatedSprite2D.play("attack")
				var projectile = load("res://Scenes/projectile.tscn").instantiate()
				var dirtoenemy = position.direction_to(target.get_parent().global_position)
				projectile.enemyposition(dirtoenemy)
				projectile.target(target);
				projectile.pierce=pierce
				projectile.position = self.position
				projectile.damage = damage;
				$AudioStreamPlayer2D.stream=load("res://SFX/WizardHatShoot.ogg")
				$AudioStreamPlayer2D.pitch_scale=randf_range(0.8, 1.2);
				$AudioStreamPlayer2D.play()
				get_parent().add_child(projectile)
				rdy=false
				$Timer.start(cooldown/Global.gamestate)
	elif(dropped==false):
		position=get_global_mouse_position()

func _on_timer_timeout() -> void:
	rdy = true;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:

	if((event is InputEventMouseButton and event.is_action_pressed("leftClick", false)) and placeable==true and dropped==false):
		dropped=true
		Global.global_selected=!dropped;
		Global.MP=Global.MP-50;
		Global.cancel=false;
		$MenuSFX.play()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if((event is InputEventMouseButton and event.is_action_pressed("leftClick", false)) and dropped==true):
		$Control.visible=!$Control.visible
		Global.openedUpgrade=$Control;
		$MenuSFX.play()

func _draw() -> void:
	if(dropped==false or $Control.visible):
		if(placeable==true):
			draw_circle(Vector2(0,0),$Area2D/CollisionShape2D.shape.radius,Color(0,0,0,0.5))
		else:
			draw_circle(Vector2(0,0),$Area2D/CollisionShape2D.shape.radius,Color(255,0,0,0.5))
	else:
		pass

func _on_lvl_1_mouse_entered() -> void:
	showbuttons(0)

func _on_lvl_2_mouse_entered() -> void:
	showbuttons(1)

func _on_lvl_3_mouse_entered() -> void:
	showbuttons(2)

func showbuttons(lvl):
	var tab = $Control/TabContainer.current_tab
	get_node("Control/TabContainer/PATH"+str(tab+1)+"/INFO").text=upgrades[tab][lvl]["desc"]+"\n"+"COST: "+str(upgrades[tab][lvl]["price"])
	
func buy_upgrade(lvl):
	var bought = false;
	if(Global.MP>=upgrades[tab][lvl]["price"]):
		match tab:
			0: $Area2D/CollisionShape2D.shape.radius=upgrades[tab][lvl]["new"]
			1: damage=upgrades[tab][lvl]["new"]
		Global.MP = Global.MP-upgrades[tab][lvl]["price"]
		bought = true;
	return bought

func _on_lvl_1_pressed(path) -> void:
	var bought = buy_upgrade(0)
	if(bought==true):
		$MenuSFX.play()
		var n = get_node("Control/TabContainer/"+path+"/Buttons/LVL1"); 
		n.disabled=true;
		n.text="✓";
		n.self_modulate=Color.GREEN;
		
		var n2 = get_node("Control/TabContainer/"+path+"/Buttons/LVL2");
		n2.disabled=false;
		n2.text=n2.name;
	
func _on_lvl_2_pressed(path) -> void:
	var bought = buy_upgrade(1)
	if(bought==true):
		$MenuSFX.play()
		var n = get_node("Control/TabContainer/"+path+"/Buttons/LVL2"); 
		n.disabled=true;
		n.text="✓";
		n.self_modulate=Color.GREEN;
		
		var n2 = get_node("Control/TabContainer/"+path+"/Buttons/LVL3");
		if(upgrade3==false):
			n2.disabled=false;
			n2.text=n2.name;

func _on_lvl_3_pressed(path) -> void:
	if(Global.MP>=upgrades[tab][2]["price"] and upgrade3!=true):
		$MenuSFX.play()
		match tab:
			0: airvis=1;
			1: pierce=true; damage=1;
		var n = get_node("Control/TabContainer/"+path+"/Buttons/LVL3");
		
		if(path=="PATH1"):
			get_node("Control/TabContainer/PATH2/Buttons/LVL3").text="❌";
			get_node("Control/TabContainer/PATH2/Buttons/LVL3").disabled=true;
		else:
			get_node("Control/TabContainer/PATH1/Buttons/LVL3").text="❌";
			get_node("Control/TabContainer/PATH1/Buttons/LVL3").disabled=true;

		n.disabled=true;
		n.text="✓";
		n.self_modulate=Color.GREEN;
		upgrade3=true;
		Global.MP = Global.MP-upgrades[tab][2]["price"]

func stunning():
	var areas = $Turret.get_overlapping_areas()
	for area in areas:
		if area.name=="AOE" and $StunTimer.is_stopped():
			$StunTimer.start()
	
	if(!$StunTimer.is_stopped()):
		if(tween==null):
			tween = create_tween()
			tween.set_loops()
			tween.tween_property($AnimatedSprite2D,"modulate", Color.YELLOW, 0.3);
			tween.tween_property($AnimatedSprite2D,"modulate", Color.WHITE, 0.3);
			tween.play()
	elif($StunTimer.is_stopped()):
		if(tween!=null):
			tween.kill()
			$AnimatedSprite2D.modulate=Color.WHITE;


func placement_check():
	var bodies = $Turret.get_overlapping_areas();
	for body in bodies:
		if(body.name=="Cancel"):
			Global.cancel=false;
			Global.global_selected=false;
			queue_free()

		if(body.name=="Unplaceable" or body.name=="Turret"):
			placeable=false;
			break;

		else:
			placeable=true;


func _on_sell_button_pressed() -> void:
	$MenuSFX.play()
	Global.MP+=50;
	queue_free();


func _on_tab_container_tab_changed(tab: int) -> void:
	get_node("Control/TabContainer/PATH"+str(tab+1)+"/INFO").text=upgrades[tab][0]["desc"]+"\n"+"COST: "+str(upgrades[tab][0]["price"])
