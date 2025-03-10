extends CharacterBody2D

var cooldown = 0.5;
var rdy = true;
@export var dropped = false;
var turret_level = 0
var damage = 1

var airvis = 0;
var pierce = false;
var tab;
var placeable = false;
var upgrades = [
	[
		{"price":10,"desc":"Range 1","state":0,"new":80},
		{"price":20,"desc":"Range 2", "state":0, "new": 90},
		{"price":50,"desc":"Ability to see air enemies."}
	],
	[
		{"price":10, "desc":"Damage 1","new":2},
		{"price":20, "desc": "Damage 2","new":3},
		{"price":50, "desc": "Piercing damage."}
	]
]
func _ready() -> void:
	$AudioStreamPlayer2D.stream=load("res://SFX/HatPlace.ogg")
	$AudioStreamPlayer2D.play()

func _physics_process(delta: float) -> void:
	
	if(dropped==false):
		placement_check();
	
	tab = $TabContainer.current_tab
	if(!$AnimatedSprite2D.is_playing()):
		$AnimatedSprite2D.play("idle")

	queue_redraw()

	stunning()

	if(Global.gamestate>0 and dropped==true and $StunTimer.is_stopped()):
		var in_range: Array = $Area2D.get_overlapping_bodies()
		
		if(in_range.size()>0):
			var target = in_range[0];
			if(rdy == true and airvis>=target.enemies[target.name][2]):
				$AnimatedSprite2D.play("attack")
				var projectile = load("res://Scenes/projectile.tscn").instantiate()
				var dirtoenemy = position.direction_to(target.get_parent().global_position)
				projectile.enemyposition(dirtoenemy)
				projectile.pierce=pierce
				projectile.position = self.position
				projectile.damage = damage;
				$AudioStreamPlayer2D.stream=load("res://SFX/WizardHatShoot.ogg")
				$AudioStreamPlayer2D.play()
				get_parent().add_child(projectile)
				rdy=false
				$Timer.start(cooldown/Global.gamestate)
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
			0: $Area2D/CollisionShape2D.shape.radius=upgrades[tab][lvl]["new"]
			1: damage=upgrades[tab][lvl]["new"]
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
			0: airvis=1;
			1: pierce=true;
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
