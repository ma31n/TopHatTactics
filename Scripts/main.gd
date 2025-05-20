extends Node2D

var wave = 1
var enemies = []
var spawnspeed = 1
var win = 0;
@export var level = 0
var paths = []
func _ready() -> void:
	
	Global.ogMP=Global.levelMP[self.name];
	Global.MP=Global.levelMP[self.name];
	Global.gamestate=-1;
	for child in self.get_children():
		if "Path" in child.name:
			paths.append(child)

func _physics_process(delta: float) -> void:
	
	if($ColorRect.size==Vector2(300,150)):
		$ColorRect/RichTextLabel.visible=true;
		if(win==-1):
			$ColorRect/retry.visible=true;
			$ColorRect/back.visible=true;
		elif(win==1):
			$ColorRect/win.visible=true
	
	$Label.text=str(wave)
	$Currency.text = str(Global.MP)
	match Global.gamestate:
		-1: $Button.text = "START"
		0: $Button.text = "RESUME"
		1: $Button.text = "2X SPEED"
		2: $Button.text = "PAUSE"
		
	
	
	if(get_tree().get_nodes_in_group("alive").size()==0 and enemies.size()==0 and Global.gamestate>0):
		Global.gamestate=-1
		wave+=1
		if(wave>15):
			youwon()
		

func _on_button_pressed() -> void:
	$MenuSFX.play()
	if(Global.gamestate==-1):
		Global.gamestate=1;
		match level:
			1:
				match wave:
					1: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["NecessaryEvil"]]
					2: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["NecessaryEvil"]]
					3: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.5],["EnemyHardHat",0,1],["NecessaryEvil"]]
					4: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyTopHat",0,0.5],["NecessaryEvil"]]
					5: enemies=[["EnemyHardHat",0,1],["EnemyTopHat",0,0.5],["EnemyHardHat",0,1],["EnemyTopHat",0,0.5],["EnemyHardHat",0,1],["EnemyTopHat",0,0.5],["EnemyHardHat",0,1],["EnemyHardHat",0,0.7],["NecessaryEvil"]]
					6: enemies=[["EnemyHardHat",0,1],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["NecessaryEvil"]]
					7: enemies=[["EnemyHardHat",0,1],["EnemyTopHat",0,0.8],["EnemyHardHat",0,0.8],["EnemyTopHat",0,0.8],["EnemyHardHat",0,0.8],["EnemyTopHat",0,0.8],["EnemyHardHat",0,0.8],["EnemyPropellerHat",0,1],["NecessaryEvil"]]
					8: enemies=[["EnemyPropellerHat",0,1],["EnemyTopHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,1],["EnemyTopHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,1],["NecessaryEvil"]]
					9: enemies=[["EnemyPropellerHat",0,1],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["NecessaryEvil"]]
					10: enemies=[["EnemyPropellerHat",0,1],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,1],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,1],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,1],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,0.5],["NecessaryEvil"]]
					11: enemies=[["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["NecessaryEvil"]]
					12: enemies=[["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",0,0.7],["EnemyTopHatSpeedy",0,0.7],["EnemyHardHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyPropellerHat",0,0.7],["EnemyTopHatSpeedy",0,1.5],["EnemyTopHatSpeedy",0,0.7],["EnemyTopHatSpeedy",0,0.7],["EnemyHardHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyPropellerHat",0,1.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["NecessaryEvil"]]
					13: enemies=[["EnemyPropellerHat",0,1],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["NecessaryEvil"]]
					14: enemies=[["EnemyHardHat",0,1],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyHardHat",0,1],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["NecessaryEvil"]]
					15: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",0,0.3],["EnemyTopHat",0,0.3],["EnemyTopHat",0,0.3],["EnemyTopHat",0,0.3],["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyHardHat",0,1],["EnemyHardHat",0,0.3],["EnemyHardHat",0,0.3],["EnemyHardHat",0,0.3],["EnemyHardHat",0,0.3],["EnemyHardHat",0,0.3],["EnemyHardHat",0,0.3],["EnemyPropellerHat",0,1],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyTopHat",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,0.5],["NecessaryEvil"]]

			2:
				match wave:
					1: enemies=[["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyHardHat",0], ["EnemyHardHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], "NecessaryEvil"]
					2: enemies=[["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyHardHat",1], ["EnemyHardHat",0], ["EnemyHardHat",1], ["EnemyHardHat",0], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyPropellerHat",0], ["EnemyTopHat",1], ["EnemyPropellerHat",1], ["NecessaryEvil"]]
					3: enemies=[["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyPropellerHat",1], ["EnemyPropellerHat",0], ["EnemyHardHat",1], ["EnemyHardHat",0], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyPropellerHat",0], ["EnemyHardHat",1], ["EnemyPropellerHat",1], ["NecessaryEvil"]]
					4: enemies=[["EnemyHardHat",0], ["EnemyHardHat",1], ["EnemyJesterHat",0], ["EnemyHardHat",1], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyHardHat",1], ["EnemyHardHat",0], ["EnemyPropellerHat",0], ["EnemyPropellerHat",1], ["EnemyJesterHat",1], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyPropellerHat",0], ["EnemyPropellerHat",1], ["NecessaryEvil"]]
					5: enemies=[["EnemyHardHat",0], ["EnemyHardHat",1], ["EnemyPropellerHat",0], ["EnemyPropellerHat",1], ["EnemyHardHat",1], ["EnemyHardHat",0], ["EnemyJesterHat",1], ["EnemyJesterHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["NecessaryEvil"]]
					6: youwon()
			3:
				match wave:
					1: enemies=[["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyHardHat",0], ["EnemyHardHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyJesterHat",1], "NecessaryEvil"]
					2: enemies=[["EnemyPilotHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyHardHat",0], ["EnemyHardHat",1], ["EnemyHardHat",0], ["EnemyHardHat",0], ["EnemyPilotHat",1], ["EnemyPilotHat",0], ["EnemyPropellerHat",1], ["EnemyPropellerHat",0], ["NecessaryEvil"]]
					3: enemies=[["EnemyPilotHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyHardHat",0], ["EnemyHardHat",1], ["EnemyHardHat",0], ["EnemyHardHat",0], ["EnemyPilotHat",1], ["EnemyPilotHat",0], ["EnemyPropellerHat",1], ["EnemyPropellerHat",0], ["NecessaryEvil"]]
					4: enemies=[["EnemyFootballHat",0], ["EnemyHardHat",0], ["EnemyJesterHat",0], ["EnemyHardHat",0], ["EnemyTopHat",0], ["EnemyTopHat",0], ["EnemyTopHat",0], ["EnemyTopHat",0], ["EnemyHardHat",0], ["EnemyPilotHat",0], ["EnemyHardHat",0], ["EnemyPropellerHat",0], ["EnemyPropellerHat",0], ["EnemyJesterHat",0], ["EnemyTopHat",0], ["EnemyTopHat",0], ["EnemyPropellerHat",0], ["EnemyPropellerHat",0], ["EnemyPilotHat",0], ["NecessaryEvil"]]
					5: enemies=[["EnemyHardHat",0], ["EnemyHardHat",1], ["EnemyPilotHat",0], ["EnemyPilotHat",1], ["EnemyPilotHat",0], ["EnemyPilotHat",1], ["EnemyFootballHat",1], ["EnemyFootballHat",0], ["EnemyJesterHat",1], ["EnemyJesterHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyTopHat",0], ["EnemyTopHat",1], ["EnemyTopHat",0], ["EnemyPropellerHat",1], ["EnemyPropellerHat",0], ["EnemyFootballHat",1], ["EnemyFootballHat",0], ["EnemyHardHat",0], ["EnemyHardHat",1], ["EnemyPilotHat",0], ["EnemyPilotHat",1], ["EnemyFootballHat",0], ["EnemyTopHat",0], ["EnemyTopHat",1],  ["NecessaryEvil"]]
					6: enemies=[["EnemyCrownHat",0],["NecessaryEvil"]]
					7: youwon()
	else:
		Global.gamestate+=1
		
	if(Global.gamestate>2):
		Global.gamestate=0
	
	if(Global.gamestate>0):
		$Timer.start(spawnspeed/Global.gamestate)


func _on_timer_timeout() -> void:
	if Global.gamestate>0:
		var enemyname = enemies.pop_front()
		if(enemies.size()!=0):
			var enemy = ResourceLoader.load("res://Scenes/"+enemyname[0]+".tscn").instantiate()
			enemy.add_to_group("alive")
			var path = PathFollow2D.new()
			path.set_script(load("res://Scripts/path_follow_2d.gd"))
			path.speed = enemy.enemies[enemyname[0]][1]
			path.add_child(enemy)
			path.rotate(deg_to_rad(0))
			path.rotates=false
			path.loop=true;
			paths[enemyname[1]].add_child(path)
			$Timer.start(float(enemyname[2])/Global.gamestate)
		


func _on_finish_area_entered(area: Area2D) -> void:
	if area.name=="Objective":
		win=-1
		$Button.visible=false;
		
		var tween = create_tween()
		$ColorRect.visible=true
		tween.set_parallel(true)
		tween.tween_property($ColorRect,"position",Vector2(138,87),0.1)
		tween.tween_property($ColorRect,"size",Vector2(300,150),0.1)
		$AudioStreamPlayer2D.stream=load("res://SFX/death.ogg")
		$AudioStreamPlayer2D.play()

func youwon():
	win=1
	$ColorRect.z_index=10000;
	var tween = create_tween()
	$ColorRect.visible=true
	$ColorRect/RichTextLabel.text="[center]YOU WON![center]";
	tween.set_parallel(true)
	tween.tween_property($ColorRect,"position",Vector2(138,87),0.1)
	tween.tween_property($ColorRect,"size",Vector2(300,150),0.1)
	$AudioStreamPlayer2D.stream=load("res://SFX/Win.ogg")
	$AudioStreamPlayer2D.play()

func _on_retry_pressed() -> void:
	$MenuSFX.play()
	get_tree().reload_current_scene()
	Global.MP=Global.ogMP
	Global.gamestate=Global.oggamestate


func _on_win_pressed() -> void:
	$MenuSFX.play()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	Global.MP=Global.ogMP
	Global.gamestate=Global.oggamestate

	Global.levelscompleted+=1


func _on_finish_2_area_entered(area: Area2D) -> void:
	if area.name=="Objective":
		win=-1
		var tween = create_tween()
		$ColorRect.visible=true
		tween.set_parallel(true)
		tween.tween_property($ColorRect,"position",Vector2(138,87),0.1)
		tween.tween_property($ColorRect,"size",Vector2(300,150),0.1)
		$AudioStreamPlayer2D.stream=load("res://SFX/death.ogg")
		$AudioStreamPlayer2D.play()


func _on_back_pressed() -> void:
	$MenuSFX.play()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	Global.MP=Global.ogMP
	Global.gamestate=Global.oggamestate
