extends CharacterBody2D

var cooldown = 2;
var rdy = true;
@export var dropped = false;
var turret_level = 0
var damage = 1

var airvis = 0;
var pierce = false;
var stunl = 0.3;

var slowdown = false;

var tween;
var tween_stun=null;
var placeable = false;
var upgrade3 = false;
var tab;
var upgrades = [
	[
		{"price":20,"desc":"Range 1","state":0,"new":45},
		{"price":40,"desc":"Range 2", "state":0, "new": 50},
		{"price":60,"desc":"Added temporary slowdown."}
	],
	[
		{"price":20, "desc":"Speed 1","new":1.8},
		{"price":40, "desc": "Speed 2","new":1.6},
		{"price":60, "desc": "1.5x Stun Length."}
	]
]
func _ready() -> void:
	$AudioStreamPlayer2D.stream=load("res://SFX/HatPlace.ogg")
	$AudioStreamPlayer2D.play()
	
	$Area2D/CollisionShape2D.shape = $Area2D/CollisionShape2D.shape.duplicate()
	
	_on_tab_container_tab_changed(0);

func _physics_process(delta: float) -> void:
	if(dropped==false):
		placement_check()
		
	tab = $Control/TabContainer.current_tab
	if(!$AnimatedSprite2D.is_playing()):
		$AnimatedSprite2D.play("idle")

	queue_redraw()

	stunning()

	if(Global.gamestate>0 and dropped==true and $StunTimer.is_stopped()):
		var in_range: Array = $Area2D.get_overlapping_bodies()
		if(rdy == true and in_range.size()>0):
			for enemy in in_range:
				enemy.stun=true
				enemy.stun_length=stunl;
				enemy.slowdown=true;
				$AnimatedSprite2D.play("attack")
				var projectile = load("res://Scenes/projectile_2.tscn").instantiate()
				projectile.position=self.position;
				projectile.pos(Vector2(-1,-1))
				var projectile2 = load("res://Scenes/projectile_2.tscn").instantiate()
				projectile2.pos(Vector2(1,-1))
				projectile2.position=self.position;
				var projectile3 = load("res://Scenes/projectile_2.tscn").instantiate()
				projectile3.pos(Vector2(1,1))
				projectile3.position=self.position;
				var projectile4 = load("res://Scenes/projectile_2.tscn").instantiate()
				projectile4.pos(Vector2(-1,1))
				projectile4.position=self.position;
				$AudioStreamPlayer2D.stream=load("res://SFX/Fedora_Wink.ogg")
				$AudioStreamPlayer2D.play()
				$"../".add_child(projectile)
				$"../".add_child(projectile2)
				$"../".add_child(projectile3)
				$"../".add_child(projectile4)
				
				tweening()
			rdy=false
			$Timer.start(cooldown/Global.gamestate)
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
			0: $Area2D/CollisionShape2D.shape.radius=upgrades[tab][lvl]["new"]
			1: cooldown=upgrades[tab][lvl]["new"]
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
			0: slowdown=true
			1: stunl=stunl*1.5
		
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
		if(tween_stun==null):
			tween_stun = create_tween()
			tween_stun.set_loops()
			tween_stun.tween_property($AnimatedSprite2D,"modulate", Color.YELLOW, 0.3);
			tween_stun.tween_property($AnimatedSprite2D,"modulate", Color.WHITE, 0.3);
			tween_stun.play()
	elif($StunTimer.is_stopped()):
		if(tween_stun!=null):
			tween_stun.kill()
			$AnimatedSprite2D.modulate=Color.WHITE;

func tweening():
	tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(self, "rotation_degrees", -10, 0.2);
	tween.tween_property(self, "rotation_degrees", 15, 0.2);
	tween.tween_property(self, "rotation_degrees", 0, 0.2);

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
