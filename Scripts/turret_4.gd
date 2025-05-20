extends CharacterBody2D

var cooldown = 1.5;
var rdy = true;
@export var dropped = false;
var turret_level = 0
var basedamage = 3
var damage = 3

var airvis = 0;
var pierce = false;

var upgrade = false;

var tween;
var placeable=false;
var upgrade3 = false;
var tab;
var upgrades = [
	[
		{"price":20,"desc":"Speed 1","state":0,"new":1.25},
		{"price":50,"desc":"Speed 2", "state":0, "new": 1},
		{"price":100,"desc":"Attacks multiple enemies, cuts speed."}
	],
	[
		{"price":20, "desc":"Damage 1","new":4},
		{"price":50, "desc": "Damage 2","new":5},
		{"price":80, "desc": "Insta kill every 10sec."}
	]
]
func _ready() -> void:
	$AudioStreamPlayer2D.stream=load("res://SFX/HatPlace.ogg")
	$AudioStreamPlayer2D.play()
	
	$Area2D/CollisionShape2D.shape = $Area2D/CollisionShape2D.shape.duplicate()
	
	_on_tab_container_tab_changed(0);

func _physics_process(delta: float) -> void:
	print($Instakill.time_left)
	if(dropped==false):
		placement_check()

	tab = $Control/TabContainer.current_tab
	if(!$AnimatedSprite2D.is_playing()):
		$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.offset.y=0

	queue_redraw()

	stunning()

	if(Global.gamestate>0 and dropped==true and $StunTimer.is_stopped()):
		var in_range: Array = $Area2D.get_overlapping_bodies()
		if(rdy == true and in_range.size()>0):
			if(upgrade==true):
				for enemy in in_range:
					if(airvis>=enemy.enemies[enemy.name][2]):
						attack(enemy)
						cooldown=3
						
						$AudioStreamPlayer2D.stream=load("res://SFX/Sword Slashing.ogg")
						$AudioStreamPlayer2D.play()
						tweening()
						rdy=false
						$Timer.start(cooldown/Global.gamestate)
						damage=basedamage
			else:
				if(airvis>=in_range[0].enemies[in_range[0].name][2]):
					attack(in_range[0])
					$AudioStreamPlayer2D.stream=load("res://SFX/Sword Slashing.ogg")
					$AudioStreamPlayer2D.play()
					tweening()
					rdy=false
					$Timer.start(cooldown/Global.gamestate)
					damage=basedamage
					
	elif(dropped==false):
		position=get_global_mouse_position()

func _on_timer_timeout() -> void:
	rdy = true;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if((event is InputEventMouseButton and event.is_action_pressed("leftClick", false)) and placeable==true and dropped==false):
		$MenuSFX.play()
		dropped=true;
		Global.global_selected=!dropped;
		Global.MP=Global.MP-50;
		Global.cancel=false;

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if((event is InputEventMouseButton and event.is_action_pressed("leftClick", false)) and dropped==true):
		$MenuSFX.play()
		Global.openedUpgrade=$Control;
		$Control.visible=!$Control.visible

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
			0: cooldown=upgrades[tab][lvl]["new"]
			1: basedamage=upgrades[tab][lvl]["new"]
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
			0: upgrade = true;
			1: $Instakill.start()
		
		if(path=="PATH1"):
			get_node("Control/TabContainer/PATH2/Buttons/LVL3").text="❌";
			get_node("Control/TabContainer/PATH2/Buttons/LVL3").disabled=true;
		else:
			get_node("Control/TabContainer/PATH1/Buttons/LVL3").text="❌";
			get_node("Control/TabContainer/PATH1/Buttons/LVL3").disabled=true;
		
		var n = get_node("Control/TabContainer/"+path+"/Buttons/LVL3"); 
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

func tweening():
	tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(self, "rotation_degrees", -5, 0.3);
	tween.tween_property(self, "rotation_degrees", 15, 0.1);
	tween.tween_property(self, "rotation_degrees", 0, 0.2);


func _on_instakill_timeout() -> void:
	damage=1000000;
	print("INSTAKILL")

func attack(enemy):
	$AnimatedSprite2D.play("attack")
	$AnimatedSprite2D.offset.y=16
	var projectile = load("res://Scenes/projectile_4.tscn").instantiate()
	projectile.position=enemy.get_parent().global_position;
	projectile.damage = damage;
	$"../".add_child(projectile)

func placement_check():
	var bodies = $Turret.get_overlapping_areas();
	for body in bodies:
		
		if(body.name=="Cancel"):
			Global.cancel=false;
			Global.global_selected=false;
			queue_free()
			
		if(body.name=="Unplaceable" or body.name=="Turret"):
			placeable=false;

		else:
			placeable=true;


func _on_sell_button_pressed() -> void:
		$MenuSFX.play()
		Global.MP+=50;
		queue_free();


func _on_tab_container_tab_changed(tab: int) -> void:
	get_node("Control/TabContainer/PATH"+str(tab+1)+"/INFO").text=upgrades[tab][0]["desc"]+"\n"+"COST: "+str(upgrades[tab][0]["price"])
