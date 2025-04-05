extends Node2D

var enemies = ["EnemyTopHat","EnemyHardHat","EnemyPropellerHat","EnemyFootballHat","EnemyPilotHat","EnemyJesterHat"]
func _ready() -> void:
	$AudioStreamPlayer2D.stream=load("res://Top Hat Tactics Menu.ogg");
	$AudioStreamPlayer2D.play(Global.musictime)
	title()

func _physics_process(delta: float) -> void:

	if($Control/MusicVol.value>=$Control/MusicVol.step):
		Global.musiclevel = -$Control/MusicVol.max_value+$Control/MusicVol.value;
	else:
		Global.musiclevel = -100;
	
	if($Control/SFXVol.value>=$Control/SFXVol.step):
		Global.sfxlevel = -$Control/SFXVol.max_value+$Control/SFXVol.value;
	else:
		Global.sfxlevel = -100;
	
	if(Global.levelscompleted>=2):
		$Control/VBoxContainer/Level3.disabled=false;
		$Control/VBoxContainer/Level2.disabled=false;
	elif(Global.levelscompleted>=1):
		$Control/VBoxContainer/Level2.disabled=false;
		
	if(Global.levelscompleted==3):
		get_tree().change_scene_to_file("res://Scenes/intro.tscn")


func _on_timer_timeout() -> void:
	if(get_tree().get_node_count_in_group("alive")<10):
		Global.gamestate=1
		var rand = randi_range(0,len(enemies)-1)
		var enemy = ResourceLoader.load("res://Scenes/"+enemies[rand]+".tscn").instantiate()
		enemy.add_to_group("alive")
		var path = PathFollow2D.new()
		path.set_script(load("res://Scripts/path_follow_2d.gd"))
		path.speed = enemy.enemies[enemies[rand]][1]
		path.add_child(enemy)
		path.rotate(deg_to_rad(0))
		path.rotates=false
		$Path2D.add_child(path)


func _on_level_1_pressed() -> void:
	$MenuSFX.play()
	get_tree().change_scene_to_file("res://Scenes/main.tscn");


func _on_level_2_pressed() -> void:
	$MenuSFX.play()
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn");


func _on_level_3_pressed() -> void:
	$MenuSFX.play()
	get_tree().change_scene_to_file("res://Scenes/level_3.tscn");

func title():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property($Control/RichTextLabel, "rotation", deg_to_rad(3),0.8).set_ease(Tween.EASE_IN_OUT);
	tween.tween_property($Control/RichTextLabel, "rotation", deg_to_rad(-3),0.8).set_ease(Tween.EASE_IN_OUT);
	
	var tween2 = create_tween()
	tween2.set_loops()

	tween2.tween_property($Control/RichTextLabel, "scale", Vector2(0.9,0.9),1.5).set_ease(Tween.EASE_IN_OUT);
	tween2.chain().tween_property($Control/RichTextLabel, "scale", Vector2(1.1,1.1),1.5).set_ease(Tween.EASE_IN_OUT);
	
	
