extends Node

var oggamestate = -1;
var levelMP = {
	"Main":10000,
	"Level2":150,
	"Level3":200
}
var ogMP = 100;
var oglevelscompleted = 0;

var gamestate = -1;
var MP = 100;
var levelscompleted = 2;

var musictime=0;

var cancel = false;

var musiclevel=0;

var sfxlevel=0;

var openedUpgrade: Control;

var global_selected = false;

func _physics_process(delta: float) -> void:
	var songs = get_tree().get_nodes_in_group("Music");
	for song in songs:
		song.volume_db=musiclevel;
	
	var sfx = get_tree().get_nodes_in_group("SFX");
	for sound in sfx:
		sound.volume_db=sfxlevel;
