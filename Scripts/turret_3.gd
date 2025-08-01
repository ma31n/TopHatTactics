extends CharacterBody2D

var cooldown = 2;
var rdy = true;
@export var dropped = false;
var turret_level = 0
var damage = 5;

var projscale = 1
var airvis = 1;
var pierce = false;
var tab;
var placeable = false;
var upgrade3 = false;
var upgrades = [
	[
		{"price":20,"desc":"Speed 1","state":0,"new":1.8},
		{"price":40,"desc":"Speed 2", "state":0, "new": 1.6},
		{"price":60,"desc":"Splash damage."}
	],
	[
		{"price":20, "desc":"Range 1","new":140},
		{"price":40, "desc": "Range 2","new":170},
		{"price":100, "desc": "Infinite range"}
	]
]

var tween = null;
func _ready() -> void:
	$AudioStreamPlayer2D.stream=load("res://SFX/baseball-cavalry-sting-short-sustain-80564.ogg")
	
	$Area2D/CollisionShape2D.shape = $Area2D/CollisionShape2D.shape.duplicate()
	
	_on_tab_container_tab_changed(0);

func _physics_process(delta: float) -> void:
	tab = $Control/TabContainer.current_tab
	if(!$AnimatedSprite2D.is_playing()):
		$AnimatedSprite2D.play("idle")
	
	if(dropped==false):
		placement_check()

	queue_redraw()

	stunning()

	if(Global.gamestate>0 and dropped==true and $StunTimer.is_stopped()):
		var in_range: Array = $Area2D.get_overlapping_bodies()
		
		if(in_range.size()>0):
			var target = in_range[0];
			for enemy in in_range:
				if(enemy.enemies[enemy.name][2]==1):
					target=enemy;
					break;
			if(rdy == true and airvis>=target.enemies[target.name][2]):
				$AnimatedSprite2D.play("attack")
				var projectile = load("res://Scenes/projectile_3.tscn").instantiate()
				var dirtoenemy = position.direction_to(target.get_parent().global_position)
				projectile.enemyposition(dirtoenemy)
				projectile.target(target);
				projectile.pierce=pierce
				projectile.position = self.position
				projectile.damage = damage;
				projectile.scale=Vector2(projscale,projscale);
				
				if($AnimatedSprite2D.frame==2):
					get_parent().add_child(projectile)
					rdy=false
					$Timer.start(cooldown/Global.gamestate)
					$AudioStreamPlayer2D.stream=load("res://SFX/Bonk.ogg")
					$AudioStreamPlayer2D.play()
	elif(dropped==false):
		position=get_global_mouse_position()

func _on_timer_timeout() -> void:
	rdy = true;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if((event is InputEventMouseButton and event.is_action_pressed("leftClick", false)) and placeable==true and dropped==false):
		$MenuSFX.play()
		dropped=true
		Global.global_selected=!dropped;
		Global.MP=Global.MP-50;
		Global.cancel=false;
		$AudioStreamPlayer2D.play()
		$"../"._on_buy_button_pressed()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if((event is InputEventMouseButton and event.is_action_pressed("leftClick", false)) and dropped==true and Global.gamestate!=0):
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
			0: cooldown=upgrades[tab][lvl]["new"]
			1: $Area2D/CollisionShape2D.shape.radius=upgrades[tab][lvl]["new"]
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
			0: projscale=1.5;
			1: $Area2D/CollisionShape2D.shape.radius=1000;
			
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
			tween=null
			$AnimatedSprite2D.modulate=Color.WHITE;

func placement_check():
	var bodies = $Turret.get_overlapping_areas();
	for body in bodies:
		
		if(body.name=="Cancel"):
			Global.cancel=false;
			Global.global_selected=false;
			$"../"._on_buy_button_pressed()
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
