extends Node2D

var wave = 1
var enemies = []
var spawnspeed = 1
var win = 0;
@export var level = 0
var paths = []

var buytween:Tween = null;
var buyshow = 1;

func _ready() -> void:
	
	Global.ogMP=Global.levelMP[self.name];
	Global.MP=Global.levelMP[self.name];
	Global.gamestate=-1;
	for child in self.get_children():
		if "Path" in child.name:
			paths.append(child)

func _physics_process(delta: float) -> void:
	
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().reload_current_scene()

	if($ColorRect.size==Vector2(300,150)):
		$ColorRect/RichTextLabel.visible=true;
		if(win==-1):
			$ColorRect/retry.visible=true;
			$ColorRect/back.visible=true;
			$ColorRect/win.visible=false;
		elif(win==1):
			$ColorRect/win.visible=true
			$ColorRect/retry.visible=false;
			$ColorRect/back.visible=false;
	
	$Label.text=str(wave)
	$Currency.text = str(Global.MP)
	match Global.gamestate:
		-1: $Button.text = "START"
		0: $Button.text = "RESUME"
		1: $Button.text = "PAUSE"
		
	
	
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
					1: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",0,5], ["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["NecessaryEvil"]]
					2: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["EnemyTopHat",0,1],["NecessaryEvil"]]
					3: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.5],["EnemyHardHat",0,1],["NecessaryEvil"]]
					4: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyTopHat",0,0.5],["NecessaryEvil"]]
					5: enemies=[["EnemyHardHat",0,1],["EnemyTopHat",0,0.5],["EnemyHardHat",0,1],["EnemyTopHat",0,0.5],["EnemyHardHat",0,1],["EnemyTopHat",0,0.5],["EnemyHardHat",0,1],["EnemyHardHat",0,0.7],["NecessaryEvil"]]
					6: enemies=[["EnemyHardHat",0,1],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["NecessaryEvil"]]
					7: enemies=[["EnemyHardHat",0,1],["EnemyTopHat",0,0.8],["EnemyHardHat",0,0.8],["EnemyTopHat",0,0.8],["EnemyHardHat",0,0.8],["EnemyTopHat",0,0.8],["EnemyHardHat",0,0.8],["EnemyPropellerHat",0,1],["NecessaryEvil"]]
					8: enemies=[["EnemyPropellerHat",0,1],["EnemyTopHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,1],["EnemyTopHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,1],["NecessaryEvil"]]
					9: enemies=[["EnemyPropellerHat",0,1],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["NecessaryEvil"]]
					10: enemies=[["EnemyPropellerHat",0,1],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,1],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,1],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,1],["EnemyHardHat",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,0.5],["NecessaryEvil"]]
					11: enemies=[["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["NecessaryEvil"]]
					12: enemies=[["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",0,0.7],["EnemyTopHatSpeedy",0,0.7],["EnemyHardHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyPropellerHat",0,0.7],["EnemyTopHatSpeedy",0,1.5],["EnemyTopHatSpeedy",0,0.7],["EnemyTopHatSpeedy",0,0.7],["EnemyHardHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyPropellerHat",0,1.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["NecessaryEvil"]]
					13: enemies=[["EnemyPropellerHat",0,1],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["NecessaryEvil"]]
					14: enemies=[["EnemyHardHat",0,1],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyHardHat",0,1],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyHardHat",0,0.2],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",0,0.5],["NecessaryEvil"]]
					15: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",0,0.3],["EnemyTopHat",0,0.3],["EnemyTopHat",0,0.3],["EnemyTopHat",0,0.3],["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyHardHat",0,1],["EnemyHardHat",0,0.3],["EnemyHardHat",0,0.3],["EnemyHardHat",0,0.3],["EnemyHardHat",0,0.3],["EnemyHardHat",0,0.3],["EnemyHardHat",0,0.3],["EnemyPropellerHat",0,1],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",0,0.3],["EnemyTopHat",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyHardHat",0,0.5],["EnemyPropellerHat",0,0.5],["NecessaryEvil"]]

			2:
				match wave:
					1: enemies=[["EnemyTopHat",1,0.05],["EnemyTopHat",0,1],["EnemyTopHat",1,0.05],["EnemyTopHat",0,1],["EnemyTopHat",1,0.05],["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",1,0.05],["NecessaryEvil"]]
					2: enemies=[["EnemyTopHat",0,1],["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHat",0,0.7],["EnemyTopHat",1,0.05],["EnemyTopHat",0,0.7],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",1,0.7],["NecessaryEvil"]]
					3: enemies=[["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",1,0.05],["EnemyHardHat",0,0.5],["EnemyHardHat",1,0.05],["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",1,0.05],["EnemyHardHat",0,0.5],["EnemyHardHat",1,0.05],["NecessaryEvil"]]
					4: enemies=[["EnemyHardHat",0,1],["EnemyHardHat",1,0.05],["EnemyHardHat",0,1],["EnemyHardHat",1,0.05],["EnemyTopHat",0,1],["EnemyTopHat",1,0.05],["EnemyTopHat",0,0.5],["EnemyTopHat",1,0.05],["EnemyTopHat",0,0.5],["EnemyTopHat",1,0.05],["NecessaryEvil"]]
					5: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",1,0.05],["EnemyTopHat",0,0.5],["EnemyTopHat",1,0.05],["EnemyHardHat",0,1],["EnemyHardHat",1,0.05],["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.05],["EnemyTopHatSpeedy",1,0.05], ["EnemyHardHat",0,0.5],["EnemyHardHat",1,0.05],["NecessaryEvil"]]
					6: enemies=[["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyJesterHat",0,1],["NecessaryEvil"]]
					7: enemies=[["EnemyJesterHat",0,1],["EnemyHardHat",1,0.05],["EnemyHardHat",0,0.5],["EnemyHardHat",1,0.05],["EnemyTopHat",0,0.5],["EnemyTopHat",1,0.05],["EnemyHardHat",0,0.5],["EnemyHardHat",1,0.05],["EnemyJesterHat",0,1],["EnemyJesterHat",1,0.05],["NecessaryEvil"]]
					8: enemies=[["EnemyPropellerHat",0,1],["EnemyPropellerHat",1,0.05],["EnemyPropellerHat",0,0.7],["EnemyPropellerHat",1,0.05],["EnemyHardHat",0,1],["EnemyHardHat",1,0.05],["EnemyJesterHat",0,1],["EnemyJesterHat",1,0.05],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",1,0.05],["NecessaryEvil"]]
					9: enemies=[["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",1,0.3],["EnemyTopHatSpeedy",1,0.3],["EnemyJesterHat",0,0.1],["EnemyTopHatSpeedy",1,0.2],["EnemyTopHatSpeedy",1,0.3],["EnemyTopHatSpeedy",1,0.3],["EnemyTopHatSpeedy",1,0.3],["EnemyTopHatSpeedy",1,0.3],["EnemyJesterHat",0,0.1],["EnemyPropellerHat",0,0.5],["NecessaryEvil"]]
					10: enemies=[["EnemyPilotHat",0,1],["EnemyPilotHat",1,1],["EnemyPilotHat",0,1],["EnemyPilotHat",1,1],["EnemyPilotHat",0,1],["NecessaryEvil"]]
					11: enemies=[["EnemyHardHat",0,1],["EnemyHardHat",1,0.05],["EnemyHardHat",0,1],["EnemyHardHat",1,0.05],["EnemyHardHat",0,1],["EnemyHardHat",1,0.05],["EnemyHardHat",0,1],["EnemyHardHat",1,0.05],["EnemyPilotHat",0,1],["EnemyPilotHat",1,0.3],["EnemyPilotHat",0,0.7],["EnemyPilotHat",1,0.3],["EnemyPilotHat",0,0.7],["EnemyPilotHat",1,0.3],["EnemyPropellerHat",0,1],["EnemyPropellerHat",1,0.05],["EnemyPropellerHat",0,1],["EnemyPropellerHat",1,0.05],["NecessaryEvil"]]
					12: enemies=[["EnemyJesterHat",0,1],["EnemyJesterHat",1,0.05],["EnemyPilotHat",0,1],["EnemyPilotHat",1,0.5],["EnemyPilotHat",0,1],["EnemyHardHat",0,0.3],["EnemyHardHat",1,0.05],["EnemyHardHat",0,0.3],["EnemyHardHat",1,0.05],["EnemyHardHat",0,0.3],["EnemyHardHat",1,0.05],["EnemyPilotHat",0,1],["EnemyPilotHat",1,0.5],["EnemyJesterHat",0,0.7],["EnemyJesterHat",1,0.05],["EnemyHardHat",0,1],["EnemyHardHat",1,0.05],["EnemyPilotHat",0,1],["EnemyPilotHat",1,0.3],["EnemyPilotHat",1,0.3],["EnemyPilotHat",1,0.3],["NecessaryEvil"]]
					13: enemies=[["EnemyTopHat",0,1],["EnemyTopHat",1,0.05],["EnemyTopHat",0,0.3],["EnemyTopHat",1,0.05],["EnemyTopHat",0,0.3],["EnemyTopHat",1,0.05],["EnemyHardHat",0,0.5],["EnemyHardHat",1,0.05],["EnemyHardHat",0,0.5],["EnemyHardHat",1,0.05],["EnemyPropellerHat",0,1],["EnemyPropellerHat",1,0.05],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",1,0.05],["EnemyPropellerHat",0,0.3],["EnemyPropellerHat",1,0.05],["EnemyJesterHat",0,1],["EnemyJesterHat",1,0.05],["EnemyTopHat",0,0.7],["EnemyTopHat",1,0.05],["EnemyTopHat",0,0.7],["EnemyTopHat",1,0.05],["EnemyTopHat",0,0.7],["EnemyTopHat",1,0.05],["EnemyTopHat",0,0.7],["EnemyJesterHat",0,0.7],["NecessaryEvil"]]
					14: enemies=[["EnemyPropellerHat",0,1],["EnemyPropellerHat",1,0.05],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",1,0.05],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",1,0.05],["EnemyPropellerHat",0,0.5],["EnemyPilotHat",0,1],["EnemyPilotHat",1,0.3],["EnemyPilotHat",0,0.3],["EnemyPilotHat",1,0.3],["EnemyPilotHat",0,0.3],["EnemyPilotHat",1,0.3],["EnemyPropellerHat",0,1],["EnemyPropellerHat",1,0.5],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",1,0.05],["EnemyPropellerHat",0,0.5],["EnemyPropellerHat",1,0.05],["EnemyPropellerHat",0,0.5],["EnemyPilotHat",0,0.7],["EnemyPilotHat",1,0.05],["EnemyPilotHat",0,0.2],["EnemyPilotHat",1,0.1],["EnemyPilotHat",0,0.2],["EnemyPilotHat",1,0.1],["NecessaryEvil"]]
					15: enemies=[["EnemyJesterHat",0,1],["EnemyJesterHat",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyPilotHat",1,0.5],["EnemyPilotHat",0,0.5],["EnemyPilotHat",1,0.5],["EnemyPilotHat",0,0.5],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyHardHat",0,0.3],["EnemyHardHat",1,0.05],["EnemyHardHat",0,0.3],["EnemyHardHat",1,0.05],["EnemyHardHat",0,0.3],["EnemyHardHat",1,0.05],["EnemyHardHat",0,0.3],["EnemyHardHat",1,0.05],["EnemyJesterHat",0,0.5],["EnemyJesterHat",1,0.5],["NecessaryEvil"]] 

			3:
				match wave:
					1: enemies=[["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHat",0,1],["EnemyTopHat",1,0.05],["EnemyTopHat",0,1],["EnemyTopHat",1,0.05],["EnemyTopHat",0,1],["EnemyTopHat",1,0.05],["EnemyTopHatSpeedy",0,2],["EnemyTopHatSpeedy",1,0.05],["NecessaryEvil"]]
					2: enemies=[["EnemyHardHat",0,1],["EnemyHardHat",1,0.05],["EnemyHardHat",0,1],["EnemyHardHat",1,0.05],["EnemyTopHat",0,0.3],["EnemyTopHat",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHat",0,0.3],["EnemyTopHat",0,0.3],["EnemyTopHatSpeedy",1,0.05],["NecessaryEvil"]]
					3: enemies=[["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",0,0.8],["EnemyTopHatSpeedy",0,0.8],["EnemyJesterHat",1,0.05],["EnemyHardHat",0,0.7],["EnemyHardHat",0,0.7],["EnemyJesterHat",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHat",0,0.5],["EnemyTopHat",0,0.5],["NecessaryEvil"]]
					4: enemies=[["EnemyPilotHat",0,1],["EnemyPilotHat",1,0.4],["EnemyPilotHat",0,0.4],["EnemyPilotHat",1,0.4],["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",0,0.5],["EnemyJesterHat",0,1],["EnemyPilotHat",1,0.5],["EnemyPilotHat",1,0.5],["NecessaryEvil"]]
					5: enemies=[["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyHardHatBlue",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyHardHat",1,0.05],["EnemyHardHat",0,1],["NecessaryEvil"]]
					6: enemies=[["EnemyPilotHat",0,1],["EnemyHardHatBlue",0,1],["EnemyHardHatBlue",0,1],["EnemyJesterHat",0,1],["EnemyPilotHat",1,1],["EnemyPilotHat",1,0.7],["EnemyPilotHat",1,0.7],["EnemyJesterHat",0,1],["EnemyHardHatBlue",0,1],["EnemyHardHat",0,1],["NecessaryEvil"]]
					7: enemies=[["EnemyHardHatBlue",1,1],["EnemyHardHatBlue",1,1],["EnemyJesterHat",1,1],["EnemyHardHatBlue",1,1],["EnemyHardHatBlue",1,1],["EnemyPropellerHat",0,0.05],["EnemyPropellerHat",0,0.7],["EnemyTopHatSpeedy",0,0.3],["EnemyPropellerHat",1,0.7], ["EnemyTopHatSpeedy",0,0.3], ["EnemyTopHatSpeedy",1,0.3], ["EnemyPropellerHat",0,1], ["NecessaryEvil"]]
					8: enemies=[["EnemyJesterHat",0,1],["EnemyJesterHat",1,0.05],["EnemyPilotHat",0,0.3],["EnemyPilotHat",1,0.3],["EnemyPilotHat",1,0.3],["EnemyPilotHat",0,0.3],["EnemyHardHatBlue",0,1],["EnemyHardHatBlue",1,0.05],["EnemyTopHatSpeedy",0,0.5],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",1,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,1],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["NecessaryEvil"]]
					9: enemies=[["EnemyFootballHat",0,1],["EnemyFootballHat",1,0.05],["EnemyFootballHat",0,1],["EnemyFootballHat",1,0.05],["EnemyFootballHat",0,1],["EnemyFootballHat",1,0.05],["NecessaryEvil"]]
					10: enemies=[["EnemyHardHatBlue",0,1],["EnemyHardHatBlue",1,0.05],["EnemyHardHatBlue",0,1],["EnemyHardHatBlue",1,0.05],["EnemyJesterHat",0,1],["EnemyJesterHat",1,0.05],["EnemyFootballHat",0,1],["EnemyFootballHat",1,0.05],["EnemyPilotHat",0,0.5],["EnemyPilotHat",1,0.2],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",1,0.05],["NecessaryEvil"]]
					11: enemies=[["EnemyHardHat",0,1],["EnemyHardHatBlue",0,0.5],["EnemyHardHat",0,0.5],["EnemyJesterHat",0,1],["EnemyPropellerHat",0,1],["EnemyPropellerHat",0,0.4],["EnemyPropellerHat",0,0.4],["EnemyPropellerHat",0,0.4],["EnemyPropellerHat",0,0.4],["EnemyPropellerHat",0,0.4],["EnemyFootballHat",0,1],["EnemyHardHatBlue",1,0.5],["NecessaryEvil"]]
					12: enemies=[["EnemyFootballHat",0,1],["EnemyHardHatBlue",0,0.5],["EnemyFootballHat",1,0.5],["EnemyHardHatBlue",1,0.5],["EnemyFootballHat",0,1],["EnemyHardHatBlue",0,0.5],["EnemyFootballHat",1,0.5],["EnemyHardHatBlue",1,0.5],["EnemyFootballHat",0,1],["EnemyHardHatBlue",0,0.5],["EnemyFootballHat",1,0.5],["EnemyHardHatBlue",1,0.5],["EnemyPilotHat",0,0.2],["EnemyPilotHat",1,0.2],["EnemyPilotHat",0,0.2],["EnemyPilotHat",1,0.2],["EnemyPilotHat",0,0.2],["EnemyPilotHat",1,0.2],["NecessaryEvil"]]
					13: enemies=[["EnemyPropellerHat",1,0.1],["EnemyPropellerHat",1,0.1],["EnemyPropellerHat",1,0.1],["EnemyPropellerHat",1,0.1],["EnemyHardHatBlue",0,0.05],["EnemyPropellerHat",1,0.1],["EnemyPropellerHat",1,0.1],["EnemyPropellerHat",1,0.1],["EnemyJesterHat",0,0.2],["EnemyFootballHat",1,0.5],["EnemyFootballHat",1,0.5],["EnemyHardHatBlue",0,0.5],["EnemyHardHatBlue",0,0.5],["EnemyPilotHat",0,0.2],["EnemyPilotHat",1,0.2],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["EnemyTopHatSpeedy",0,0.3],["NecessaryEvil"]]
					14: enemies=[["EnemyHardHatBlue",0,1],["EnemyFootballHat",0,1],["EnemyPropellerHat",0,0.7],["EnemyFootballHat",0,0.5],["EnemyPropellerHat",0,0.7],["EnemyFootballHat",0,0.5],["EnemyPropellerHat",0,0.7],["EnemyFootballHat",0,0.5],["EnemyPropellerHat",0,0.7],["EnemyPilotHat",1,0.2],["EnemyPilotHat",1,0.2],["EnemyFootballHat",0,0.1],["EnemyPilotHat",1,0.2],["EnemyPilotHat",1,0.2],["EnemyPilotHat",1,0.2],["EnemyFootballHat",0,0.1],["EnemyPilotHat",1,0.2],["EnemyPilotHat",1,0.2],["EnemyPropellerHat",0,0.1],["EnemyHardHatBlue",1,0.5],["EnemyJesterHat",1,0.7],["EnemyHardHatBlue",1,0.2],["EnemyTopHatSpeedy",1,0.2],["EnemyTopHatSpeedy",1,0.2],["EnemyTopHatSpeedy",1,0.2],["EnemyTopHatSpeedy",1,0.2],["EnemyFootballHat",1,1],["EnemyJesterHat",1,0.5],["EnemyFootballHat",1,1],["EnemyTopHat",0,1],["NecessaryEvil"]]
					15: enemies=[["EnemyCrownHat",0,1],["NecessaryEvil"]]
	else:
		Global.gamestate+=1
		
	if(Global.gamestate>1):
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
			
			paths[enemyname[1]].add_child(path)
			$Timer.start(float(enemyname[2])/Global.gamestate)
		


func _on_finish_area_entered(area: Area2D) -> void:
	if area.name=="Objective":
		Global.openedUpgrade=null;
		win=-1
		$Button.visible=false;
		Global.gamestate=0;
		var tween = create_tween()
		$ColorRect.visible=true
		tween.set_parallel(true)
		tween.tween_property($ColorRect,"position",Vector2(138,87),0.1)
		tween.tween_property($ColorRect,"size",Vector2(300,150),0.1)
		$AudioStreamPlayer2D.stream=load("res://SFX/death.ogg")
		$AudioStreamPlayer2D.play()

func youwon():
	Global.openedUpgrade=null;
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
	
func pausemenu():
	Global.openedUpgrade=null;
	if(Global.gamestate==1):
		Global.gamestate=0;
	else:
		Global.gamestate=1;
	$ColorRect.z_index=10000;
	var tween = create_tween()
	if($ColorRect.visible==false):
		$ColorRect.visible=true
		$ColorRect/RichTextLabel.text="[center]PAUSED[center]";
		tween.set_parallel(true)
		tween.tween_property($ColorRect,"position",Vector2(138,87),0.1)
		tween.tween_property($ColorRect,"size",Vector2(300,150),0.1)
		$ColorRect/retry.visible=true;
		$ColorRect/back.visible=true;
	else:
		$ColorRect.visible=false;
		tween.set_parallel(true)
		tween.tween_property($ColorRect,"position",Vector2(288,162),0.1)
		tween.tween_property($ColorRect,"size",Vector2(0,0),0.1)
		$ColorRect/retry.visible=true;
		$ColorRect/back.visible=true;
		

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
		Global.openedUpgrade=null;
		win=-1
		Global.gamestate=0;
		$Button.visible=false;
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


func _on_buy_button_pressed() -> void:
	if(buyshow==1):
		buytween = create_tween()
		buytween.tween_property($ICONS, "position", Vector2($ICONS.position.x+$ICONS.size.x,$ICONS.position.y),0.3)
		buytween.play()
		buyshow=0;
	elif(buyshow==0):
		buytween = create_tween()
		buytween.tween_property($ICONS, "position", Vector2($ICONS.position.x-$ICONS.size.x,$ICONS.position.y),0.3)
		buytween.play()
		buyshow=1;
	$MenuSFX.play();
