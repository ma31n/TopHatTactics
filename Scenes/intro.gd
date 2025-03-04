extends Node2D

var lines = [
	["You are the world's most famous hatmaker and you make hella good hats.\n That's because you have \na powerful magic hat.", 1],
	["Your rival is The Madhatter, willing to do anything to gain your magic hat and its powers.", 2],
	["Please! Defend your hat legacy and defeat The Madhatter!",3]
]

var final = ["Great job! The Madhatter had to file for bankrupcy! Your hats will live on as the greatest in mankind!"]
var current = 0
func _ready() -> void:
	$RichTextLabel.text=lines[0][0]
	
func _physics_process(delta: float) -> void:
	if(Global.levelscompleted<=3):
		if (Input.is_action_just_pressed("ui_accept")):
			if(current<lines.size()-1):
				current+=1
				$RichTextLabel.text=lines[current][0]
				get_node(str(current+1)).visible=true;
			else:
				get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	elif(Global.levelscompleted>3):
		$RichTextLabel.text=final[0]
		$Sprite2D.visible=true
		
