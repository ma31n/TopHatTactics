extends CharacterBody2D

var cooldown = 2;
var rdy = true;
@export var dropped = false;
var turret_level = 0
var damage = 4


var projscale = 1
var airvis = 1;
var pierce = false;
var tab;
var placeable = false;
var upgrades = [
	[
		{"price":10,"desc":"Speed 1","state":0,"new":1.5},
		{"price":20,"desc":"Speed 2", "state":0, "new": 1},
		{"price":50,"desc":"Splash damage."}
	],
	[
		{"price":10, "desc":"Range 1","new":120},
		{"price":20, "desc": "Range 2","new":150},
		{"price":50, "desc": "Infinite range"}
	]
]
func _ready() -> void:
	$AudioStreamPlayer2D.stream=load("res://SFX/baseball-cavalry-sting-short-sustain-80564.ogg")
	$AudioStreamPlayer2D.play()

func _physics_process(delta: float) -> void:
	tab = $TabContainer.current_tab
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
					break
			if(rdy == true and airvis>=target.enemies[target.name][2]):
				$AnimatedSprite2D.play("attack")
				var projectile = load("res://Scenes/projectile_3.tscn").instantiate()
				var dirtoenemy = position.direction_to(target.get_parent().global_position)
				projectile.enemyposition(dirtoenemy)
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
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and placeable==true and dropped==false):
		dropped=true
		Global.MP=Global.MP-50;
		Global.cancel=false;

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and dropped==true):
		$TabContainer.visible=!$TabContainer.visible

func _draw() -> void:
	if(dropped==false or $TabContainer.visible):
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
	var tab = $TabContainer.current_tab
	get_node("TabContainer/PATH"+str(tab+1)+"/VBoxContainer/INFO").text=upgrades[tab][lvl]["desc"]+"\n"+"COST: "+str(upgrades[tab][0]["price"])
	
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
		get_node("TabContainer/"+path+"/VBoxContainer/Buttons/LVL1").disabled=true;
		get_node("TabContainer/"+path+"/VBoxContainer/Buttons/LVL2").disabled=false;
	
func _on_lvl_2_pressed(path) -> void:
	var bought = buy_upgrade(1)
	if(bought==true):
		get_node("TabContainer/"+path+"/VBoxContainer/Buttons/LVL2").disabled=true;
		get_node("TabContainer/"+path+"/VBoxContainer/Buttons/LVL3").disabled=false;

func _on_lvl_3_pressed(path) -> void:
	if(Global.MP>=upgrades[tab][2]["price"]):
		match tab:
			0: projscale=1.5;
			1: $Area2D/CollisionShape2D.shape.radius=1000;
		get_node("TabContainer/"+path+"/VBoxContainer/Buttons/LVL3").disabled=true;

func stunning():
	var areas = $Turret.get_overlapping_areas()
	for area in areas:
		if area.name=="AOE" and $StunTimer.is_stopped():
			$StunTimer.start()

func placement_check():
	var bodies = $Turret.get_overlapping_areas();
	for body in bodies:
		
		if(body.name=="Cancel"):
			Global.cancel=false;
			queue_free()
		
		if(body.name=="Unplaceable" or body.name=="Turret"):
			placeable=false;
			break;
		else:
			placeable=true;
